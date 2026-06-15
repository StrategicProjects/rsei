# file: R/parse_escrita.R
#
# Parsers dos retornos das operações de escrita.

# Muitas operações retornam apenas "true". Interpreta <parametros> como lógico.
sei_parse_bool <- function(doc) {
  np <- sei_find_parametros(doc)
  if (is.null(np)) return(NA)
  val <- tolower(trimws(xml2::xml_text(np)))
  if (val %in% c("true", "1", "s")) return(TRUE)
  if (val %in% c("false", "0", "n")) return(FALSE)
  # alguns servidores devolvem o valor em um filho
  ch <- get_text_child(np, "Status")
  if (!is.na(ch)) return(tolower(trimws(ch)) %in% c("true", "1"))
  NA
}

#' @title parse_retorno_geracao_procedimento
#' @description Parseia o retorno de `gerarProcedimento`
#'   (`RetornoGeracaoProcedimento`).
#' @param doc Um `xml2::xml_document`.
#' @return Um tibble de 1 linha com `IdProcedimento`, `ProcedimentoFormatado`,
#'   `LinkAcesso` e `RetornoInclusaoDocumentos` (coluna-lista).
#' @export
parse_retorno_geracao_procedimento <- function(doc) {
  np <- sei_find_parametros(doc, "gerarProcedimentoResponse")
  if (is.null(np)) {
    warning("Resposta sem elemento <parametros> paragerarProcedimento.")
    return(tibble::tibble(IdProcedimento = NA_character_))
  }
  docs <- parse_items(np, "RetornoInclusaoDocumentos", function(it) {
    parse_struct(it, c(IdDocumento = "IdDocumento",
                       DocumentoFormatado = "DocumentoFormatado",
                       LinkAcesso = "LinkAcesso"))
  })
  tibble::tibble(
    IdProcedimento             = get_text_child(np, "IdProcedimento"),
    ProcedimentoFormatado      = get_text_child(np, "ProcedimentoFormatado"),
    LinkAcesso                 = get_text_child(np, "LinkAcesso"),
    RetornoInclusaoDocumentos  = list(docs)
  )
}

#' @title parse_retorno_inclusao_documento
#' @description Parseia o retorno de `incluirDocumento`
#'   (`RetornoInclusaoDocumento`).
#' @param doc Um `xml2::xml_document`.
#' @return Um tibble de 1 linha com `IdDocumento`, `DocumentoFormatado`, `LinkAcesso`.
#' @export
parse_retorno_inclusao_documento <- function(doc) {
  np <- sei_find_parametros(doc, "incluirDocumentoResponse")
  if (is.null(np)) {
    warning("Resposta sem elemento <parametros> paraincluirDocumento.")
    return(tibble::tibble(IdDocumento = NA_character_))
  }
  parse_struct(np, c(IdDocumento = "IdDocumento",
                     DocumentoFormatado = "DocumentoFormatado",
                     LinkAcesso = "LinkAcesso"))
}

#' @title parse_retorno_envio_email
#' @description Parseia o retorno de `enviarEmail` (`RetornoEnvioEmail`).
#' @param doc Um `xml2::xml_document`.
#' @return Um tibble de 1 linha com `IdDocumento`, `DocumentoFormatado`, `LinkAcesso`.
#' @export
parse_retorno_envio_email <- function(doc) {
  np <- sei_find_parametros(doc, "enviarEmailResponse")
  if (is.null(np)) return(tibble::tibble(IdDocumento = NA_character_))
  parse_struct(np, c(IdDocumento = "IdDocumento",
                     DocumentoFormatado = "DocumentoFormatado",
                     LinkAcesso = "LinkAcesso"))
}

#' @title parse_andamento_response
#' @description Parseia o retorno de `lancarAndamento` (um `Andamento`).
#' @param doc Um `xml2::xml_document`.
#' @return Um tibble de 1 linha (ver [parse_andamento_item]).
#' @export
parse_andamento_response <- function(doc) {
  np <- sei_find_parametros(doc, "lancarAndamentoResponse")
  if (is.null(np)) return(parse_andamento_item(NULL))
  parse_andamento_item(np)
}
