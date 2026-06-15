# file: R/core.R
#
# Motor SOAP do rsei: monta o envelope no formato esperado pelo SEI e executa a
# requisição com httr2, tratando erros HTTP e SOAP Fault. Todas as operações
# (consultas, listas, escrita) são wrappers finos sobre `sei_call()`.

#' @title Escape de texto para XML
#'
#' @description
#' Escapa os cinco caracteres reservados de XML (\code{&}, \code{<}, \code{>},
#' as aspas duplas e o apóstrofo) em um valor escalar. Usado internamente ao
#' montar os parâmetros do envelope SOAP.
#'
#' @param x Vetor de tamanho 1 (será coagido para character).
#'
#' @return Uma string com os caracteres reservados escapados.
#'
#' @keywords internal
#' @export
sei_xml_escape <- function(x) {
  x <- as.character(x)
  x <- gsub("&", "&amp;", x, fixed = TRUE)
  x <- gsub("<", "&lt;", x, fixed = TRUE)
  x <- gsub(">", "&gt;", x, fixed = TRUE)
  x <- gsub("\"", "&quot;", x, fixed = TRUE)
  x <- gsub("'", "&apos;", x, fixed = TRUE)
  x
}

# Renderiza um único parâmetro <name>...</name> a partir de um valor R.
# Regras:
#   NULL                       -> omitido (string vazia)
#   NA                         -> <name xsi:nil="true"/>
#   escalar (chr/num/lgl len 1)-> <name xsi:type="xsd:string">valor</name>
#   lista nomeada (estrutura)  -> <name>...filhos recursivos...</name>
#   lista não nomeada (array)  -> <name><item>...</item>...</name>
.render_param <- function(name, value) {
  if (is.null(value)) return("")

  if (is.list(value)) {
    nm <- names(value)
    if (!is.null(nm) && all(nzchar(nm))) {
      # estrutura aninhada
      inner <- .render_params(value)
      return(sprintf("<%1$s>%2$s</%1$s>", name, inner))
    }
    # array: cada elemento vira um <item>
    items <- vapply(value, function(el) {
      if (is.list(el)) {
        sprintf("<item>%s</item>", .render_params(el))
      } else if (length(el) == 1 && is.na(el)) {
        "<item xsi:nil=\"true\"/>"
      } else {
        sprintf("<item xsi:type=\"xsd:string\">%s</item>", sei_xml_escape(el))
      }
    }, character(1))
    return(sprintf("<%1$s>%2$s</%1$s>", name, paste0(items, collapse = "")))
  }

  if (length(value) == 1 && is.na(value)) {
    return(sprintf("<%s xsi:nil=\"true\"/>", name))
  }

  sprintf("<%1$s xsi:type=\"xsd:string\">%2$s</%1$s>", name, sei_xml_escape(value))
}

# Renderiza uma lista nomeada de parâmetros em XML concatenado.
.render_params <- function(params) {
  if (length(params) == 0) return("")
  nm <- names(params)
  if (is.null(nm) || any(!nzchar(nm))) {
    stop("`params` deve ser uma lista totalmente nomeada.", call. = FALSE)
  }
  parts <- vapply(seq_along(params),
                  function(i) .render_param(nm[i], params[[i]]),
                  character(1))
  paste0(parts, collapse = "")
}

#' @title Monta o Envelope SOAP do SEI
#'
#' @description
#' Constrói o envelope SOAP 1.1 no formato esperado pelos Web Services do SEI,
#' com os namespaces \code{xsi}/\code{xsd}/\code{soapenv}/\code{sei} e o atributo
#' \code{soapenv:encodingStyle} na operação. Suporta parâmetros escalares,
#' estruturas aninhadas (listas nomeadas) e arrays (listas não nomeadas, cada
#' elemento renderizado como \code{<item>}).
#'
#' @param operation Character. Nome da operação SOAP (ex.: "consultarProcedimento").
#' @param params Lista nomeada de parâmetros do corpo da operação. Valores
#'   \code{NULL} são omitidos; \code{NA} vira \code{xsi:nil="true"}.
#' @param ns_prefix Character. Prefixo do namespace da operação (padrão "sei").
#' @param ns_uri Character. URI do namespace da operação (padrão "Sei"; para o
#'   SIP use "sipns").
#'
#' @return Uma string com o envelope SOAP completo.
#'
#' @examples
#' cat(sei_build_envelope("listarUnidades",
#'   list(SiglaSistema = "HORTENSIAS", IdentificacaoServico = "chave")))
#'
#' @export
sei_build_envelope <- function(operation, params = list(),
                               ns_prefix = "sei", ns_uri = "Sei") {
  body <- .render_params(params)
  sprintf(
'<?xml version="1.0" encoding="utf-8"?>
<soapenv:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:%3$s="%4$s">
  <soapenv:Header/>
  <soapenv:Body>
    <%3$s:%1$s soapenv:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">%2$s</%3$s:%1$s>
  </soapenv:Body>
</soapenv:Envelope>',
    operation, body, ns_prefix, ns_uri)
}

#' @title Chamada Genérica a um Web Service do SEI
#'
#' @description
#' Monta o envelope SOAP para \code{operation} com \code{params}, envia via
#' \code{httr2} e devolve a resposta como \code{xml_document}. Trata erros HTTP
#' e \code{SOAP Fault} (o SEI retorna falhas em HTTP 500 com \code{faultstring}).
#'
#' @param operation Character. Nome da operação SOAP.
#' @param params Lista nomeada de parâmetros (ver \code{\link{sei_build_envelope}}).
#' @param config Um objeto \code{\link{sei_config}}.
#' @param soap_action Character. Valor do cabeçalho \code{SOAPAction}.
#' @param ns_prefix,ns_uri Namespace da operação (ver \code{\link{sei_build_envelope}}).
#' @param timeout Numérico. Tempo máximo da requisição em segundos (padrão 60).
#'   Se esgotado (ou em falha de conexão), a função para com mensagem clara.
#' @param verbose Logical. Se \code{TRUE}, imprime o envelope enviado e a resposta.
#'
#' @return Um \code{xml2::xml_document} com a resposta SOAP.
#'
#' @examples
#' \dontrun{
#'   doc <- sei_call("listarUnidades",
#'     params = list(SiglaSistema = "HORTENSIAS",
#'                   IdentificacaoServico = "chave"),
#'     config = sei_config())
#' }
#'
#' @export
sei_call <- function(operation,
                     params = list(),
                     config = sei_config(),
                     soap_action = "SeiAction",
                     ns_prefix = "sei",
                     ns_uri = "Sei",
                     timeout = 60,
                     verbose = FALSE) {

  if (is.null(config$sei_url) || !nzchar(config$sei_url)) {
    stop(paste0("URL do Web Service do SEI nao definida. Informe `sei_url` em ",
                "sei_config() (ex.: 'https://sei.<seu-orgao>.gov.br/sei/ws/SeiWS.php'), ",
                "ou defina options(rsei.sei_url=) / a variavel de ambiente RSEI_URL."),
         call. = FALSE)
  }

  envelope <- sei_build_envelope(operation, params, ns_prefix = ns_prefix, ns_uri = ns_uri)

  req <- httr2::request(config$sei_url) |>
    httr2::req_headers(
      "Content-Type" = "text/xml; charset=UTF-8",
      "SOAPAction"   = soap_action
    ) |>
    httr2::req_body_raw(enc2utf8(envelope), type = "text/xml; charset=UTF-8") |>
    httr2::req_timeout(timeout) |>
    httr2::req_error(is_error = function(resp) FALSE)

  # Falha graciosa: erros de conexão/timeout viram uma mensagem clara em vez de
  # travar ou propagar o erro bruto do httr2 (o acesso ao SEI é restrito por IP).
  resp <- tryCatch(
    httr2::req_perform(req),
    error = function(e) {
      stop(sprintf(
        paste0("Nao foi possivel acessar o servico SEI em '%s' (operacao '%s'): %s. ",
               "Verifique a conectividade e se o IP de origem esta autorizado no SEI."),
        config$sei_url, operation, conditionMessage(e)), call. = FALSE)
    }
  )

  status   <- httr2::resp_status(resp)
  body_txt <- httr2::resp_body_string(resp)

  if (verbose) {
    message("== SOAP Envelope enviado ==\n", envelope)
    message("== HTTP ", status, " ==\n", body_txt)
  }

  # Tenta detectar SOAP Fault (presente mesmo em HTTP 500)
  fault <- .extract_soap_fault(body_txt)
  if (!is.null(fault)) {
    stop(sprintf("SOAP Fault em '%s' [%s]: %s",
                 operation, fault$code, fault$string), call. = FALSE)
  }

  if (status >= 300) {
    stop(sprintf("Erro HTTP %d ao chamar '%s'. Resposta:\n%s",
                 status, operation, body_txt), call. = FALSE)
  }

  xml2::read_xml(body_txt)
}

# Extrai faultcode/faultstring de um corpo SOAP, ignorando namespace.
# Retorna NULL se não houver Fault.
.extract_soap_fault <- function(body_txt) {
  doc <- tryCatch(xml2::read_xml(body_txt), error = function(e) NULL)
  if (is.null(doc)) return(NULL)
  fault <- xml2::xml_find_first(doc, "//*[local-name()='Fault']")
  if (inherits(fault, "xml_missing") || is.na(fault)) return(NULL)
  code   <- xml2::xml_text(xml2::xml_find_first(fault, ".//*[local-name()='faultcode']"))
  string <- xml2::xml_text(xml2::xml_find_first(fault, ".//*[local-name()='faultstring']"))
  list(code = code, string = string)
}

#' @title Localiza o nó \code{<parametros>} da Resposta
#'
#' @description
#' Helper interno que encontra o nó \code{parametros} dentro de uma resposta
#' \code{<...Response>}, ignorando namespaces. Base para os parsers.
#'
#' @param doc Um \code{xml2::xml_document} (resposta SOAP).
#' @param response Character opcional. Nome do elemento de resposta
#'   (ex.: "consultarProcedimentoResponse") para ancorar a busca.
#'
#' @return O nó \code{parametros}, ou \code{NULL} se não encontrado.
#'
#' @keywords internal
#' @export
sei_find_parametros <- function(doc, response = NULL) {
  node <- NULL
  if (!is.null(response)) {
    node <- xml2::xml_find_first(
      doc,
      sprintf("//*[local-name()='%s']/*[local-name()='parametros']", response))
  }
  if (is.null(node) || inherits(node, "xml_missing") || is.na(node)) {
    node <- xml2::xml_find_first(doc, "//*[local-name()='parametros']")
  }
  if (inherits(node, "xml_missing") || is.na(node)) return(NULL)
  node
}
