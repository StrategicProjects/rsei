# file: R/sip.R
#
# Serviços SIP (Sistema de Permissões). Endpoint e autenticação distintos do SEI:
# namespace "sipns", SOAPAction "sipnsAction", autenticação por `ChaveAcesso` +
# `IdSistema`. Os nomes de parâmetros vêm do WSDL
# (.../sip/controlador_ws.php?servico=sip&wsdl).
#
# NOTA: requer uma Chave de Acesso do SIP e que o sistema cliente tenha os
# serviços liberados em "Serviços Liberados para Acesso no SIP". Validação live
# pendente (depende dessas credenciais).

#' @title Configuração de conexão SIP
#' @description Objeto com os dados das chamadas SIP: URL do Web Service,
#'   Chave de Acesso e `IdSistema`. Valores resolvem de argumentos,
#'   `options(rsei.sip_*)` e variáveis `RSEI_SIP_*`. Sem URL embutida — serve a
#'   qualquer instalação do SIP.
#' @param sip_url Character. Endpoint do SIP (ex.:
#'   `"https://sei.<seu-orgao>.gov.br/sip/controlador_ws.php?servico=sip"`).
#' @param chave_acesso Character. Chave de Acesso do SIP.
#' @param id_sistema Character. Id do sistema no SIP.
#' @return Um objeto de classe `sip_config`.
#' @export
sip_config <- function(sip_url = NULL, chave_acesso = NULL, id_sistema = NULL) {
  resolve <- function(arg, option, env, fallback) {
    if (!is.null(arg) && !identical(arg, "")) return(arg)
    opt <- getOption(option, default = NULL)
    if (!is.null(opt) && !identical(opt, "")) return(opt)
    e <- Sys.getenv(env, unset = "")
    if (!identical(e, "")) return(e)
    fallback
  }
  structure(
    list(
      sip_url = resolve(sip_url, "rsei.sip_url", "RSEI_SIP_URL", ""),
      chave_acesso = resolve(chave_acesso, "rsei.sip_chave_acesso",
                             "RSEI_SIP_CHAVE_ACESSO", ""),
      id_sistema = resolve(id_sistema, "rsei.sip_id_sistema", "RSEI_SIP_ID_SISTEMA", "")
    ),
    class = "sip_config"
  )
}

#' @export
print.sip_config <- function(x, ...) {
  cat("<sip_config>\n")
  cat("  sip_url      :", x$sip_url, "\n")
  cat("  chave_acesso :", if (nzchar(x$chave_acesso)) "<set>" else "<empty>", "\n")
  cat("  id_sistema   :", if (nzchar(x$id_sistema)) x$id_sistema else "<empty>", "\n")
  invisible(x)
}

#' @title Chamada genérica a um Web Service do SIP
#' @description Envia uma operação SIP usando o namespace "sipns" e a SOAPAction
#'   "sipnsAction". Delega para [sei_call()].
#' @param operation Character. Nome da operação SIP.
#' @param params Lista nomeada de parâmetros (ver [sei_build_envelope()]).
#' @param config Um objeto [sip_config()].
#' @param verbose Logical.
#' @return Um `xml2::xml_document`.
#' @export
sip_call <- function(operation, params = list(), config = sip_config(), verbose = FALSE) {
  tmp <- sei_config(sei_url = config$sip_url)
  sei_call(operation, params = params, config = tmp,
           soap_action = "sipnsAction", ns_prefix = "sip", ns_uri = "sipns",
           verbose = verbose)
}

# Parser de itens de uma resposta SIP (que usa um elemento "returnX" em vez de
# <parametros>): localiza a resposta e mapeia os <item>.
parse_sip_list <- function(doc, response_name, fields) {
  resp <- xml2::xml_find_first(doc, sprintf("//*[local-name()='%s']", response_name))
  if (inherits(resp, "xml_missing") || is.na(resp)) return(parse_struct_nodeset(list(), fields))
  items <- xml2::xml_find_all(resp, ".//*[local-name()='item']")
  parse_struct_nodeset(items, fields)
}

.sip_fields_permissao <- c(
  StaOperacao = "StaOperacao", IdSistema = "IdSistema",
  IdOrgaoUsuario = "IdOrgaoUsuario", IdUsuario = "IdUsuario",
  IdOrigemUsuario = "IdOrigemUsuario", IdOrgaoUnidade = "IdOrgaoUnidade",
  IdUnidade = "IdUnidade", IdOrigemUnidade = "IdOrigemUnidade",
  IdPerfil = "IdPerfil", DataInicial = "DataInicial", DataFinal = "DataFinal",
  SinSubunidades = "SinSubunidades"
)

#' @title parse_permissao
#' @description Parseia uma estrutura `Permissao` do SIP.
#' @param node Nó `xml2`.
#' @return Um tibble de 1 linha.
#' @export
parse_permissao <- function(node) parse_struct(node, .sip_fields_permissao)

#' @title listar_permissao
#' @description Lista permissões no SIP (`listarPermissao`).
#' @param config Um objeto [sip_config()].
#' @param id_orgao_usuario,id_usuario,id_origem_usuario,id_orgao_unidade,id_unidade,id_origem_unidade,id_perfil
#'   Filtros opcionais.
#' @param raw,verbose Logical.
#' @return Um `tibble` de permissões (ou `xml_document` se `raw = TRUE`).
#' @export
listar_permissao <- function(config = sip_config(),
                             id_orgao_usuario = NULL, id_usuario = NULL,
                             id_origem_usuario = NULL, id_orgao_unidade = NULL,
                             id_unidade = NULL, id_origem_unidade = NULL,
                             id_perfil = NULL, raw = FALSE, verbose = FALSE) {
  params <- list(
    ChaveAcesso     = config$chave_acesso,
    IdSistema       = config$id_sistema,
    IdOrgaoUsuario  = id_orgao_usuario,
    IdUsuario       = id_usuario,
    IdOrigemUsuario = id_origem_usuario,
    IdOrgaoUnidade  = id_orgao_unidade,
    IdUnidade       = id_unidade,
    IdOrigemUnidade = id_origem_unidade,
    IdPerfil        = id_perfil
  )
  doc <- sip_call("listarPermissao", params, config, verbose = verbose)
  if (isTRUE(raw)) return(doc)
  parse_sip_list(doc, "listarPermissaoResponse", .sip_fields_permissao)
}

#' @title replicar_permissao
#' @description Replica (cadastra/altera/exclui) permissões no SIP (`replicarPermissao`).
#' @param permissoes Lista de permissões; cada uma uma lista nomeada com campos
#'   da estrutura `Permissao` (ao menos `StaOperacao`, `IdSistema`, `IdPerfil`).
#' @param config Um objeto [sip_config()].
#' @param verbose Logical.
#' @return `TRUE` em caso de sucesso.
#' @export
replicar_permissao <- function(permissoes, config = sip_config(), verbose = FALSE) {
  params <- list(ChaveAcesso = config$chave_acesso, Permissoes = unname(permissoes))
  sei_parse_bool(sip_call("replicarPermissao", params, config, verbose = verbose))
}

#' @title replicar_usuario
#' @description Replica (cadastra/altera/desativa/reativa) usuários no SIP
#'   (`replicarUsuario`).
#' @param usuarios Lista de usuários; cada um uma lista nomeada (ao menos
#'   `StaOperacao` e `IdOrigem`).
#' @param config Um objeto [sip_config()].
#' @param sin_considerar_orgao "S"/"N".
#' @param verbose Logical.
#' @return `TRUE` em caso de sucesso.
#' @export
replicar_usuario <- function(usuarios, config = sip_config(),
                             sin_considerar_orgao = "N", verbose = FALSE) {
  params <- list(ChaveAcesso = config$chave_acesso, Usuarios = unname(usuarios),
                 SinConsiderarOrgao = sin_considerar_orgao)
  sei_parse_bool(sip_call("replicarUsuario", params, config, verbose = verbose))
}
