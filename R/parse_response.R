##############################################
# 1) recodify_access_level
##############################################

#' @title Recodify SEI Access Level
#'
#' @description
#' Converts SEI numeric access-level codes into human-readable strings:
#' \itemize{
#'   \item "0" -> "público"
#'   \item "1" -> "restrito"
#'   \item "2" -> "sigiloso"
#' }
#'
#' If the input is missing, empty, or not in \code{c("0", "1", "2")}, it returns
#' the original value.
#'
#' @param val A character string, usually "0", "1", or "2".
#'
#' @return A character string: "público", "restrito", "sigiloso", or the original value.
#'
#' @examples
#' recodify_access_level("0")  # "público"
#' recodify_access_level("1")  # "restrito"
#' recodify_access_level("2")  # "sigiloso"
#' recodify_access_level("X")  # "X"
#'
#' @export
recodify_access_level <- function(val) {
  if (is.na(val) || val == "") {
    return(val)
  }
  switch(
    val,
    "0" = "público",
    "1" = "restrito",
    "2" = "sigiloso",
    val  # default
  )
}


##############################################
# 2) get_text
##############################################

#' @title get_text: Extract Text from an XML Node
#'
#' @description
#' A helper function to find the first child node of \code{parent} with a given
#' local-name, ignoring namespaces. It returns the text content unless
#' \code{xsi:nil="true"}, in which case it returns an empty string.
#'
#' @param parent An \code{xml2} node.
#' @param child_name Character. The local-name of the child element to extract.
#'
#' @return A character string (possibly empty).
#'
#' @examples
#' \dontrun{
#'   doc <- xml2::read_xml("<root><Foo xsi:nil='true'/></root>")
#'   get_text(doc, "Foo")  # => ""
#' }
#'
#' @export
get_text <- function(parent, child_name) {
  nd <- xml2::xml_find_first(
    parent,
    paste0(".//*[local-name() = '", child_name, "']")
  )
  if (inherits(nd, "xml_missing") || is.na(nd)) return("")
  if (xml2::xml_attr(nd, "nil", default = "") == "true") return("")
  xml2::xml_text(nd)
}


##############################################
# 3) parse_andamento
##############################################

#' @title parse_andamento: Parse an <Andamento> Node
#'
#' @description
#' Parses an \code{<Andamento>} node (including \code{<Descricao>}, \code{<DataHora>},
#' \code{<Unidade>}, \code{<Usuario>}) and returns a named list. If the node
#' is missing or \code{xsi:nil="true"}, returns \code{NULL}.
#'
#' @param node_and An \code{xml2} node that may represent an <Andamento>.
#'
#' @return A named list with elements \code{$Descricao}, \code{$DataHora}, \code{$Unidade}, \code{$Usuario},
#'   or \code{NULL} if not found.
#'
#' @examples
#' \dontrun{
#'   # Suppose you have <Andamento><Descricao>... etc ...
#'   parse_andamento(xml_andamento)
#' }
#'
#' @export
parse_andamento <- function(node_and) {
  if (inherits(node_and, "xml_missing") || is.na(node_and)) {
    return(tibble(
      Descricao = NA_character_,
      DataHora = NA_character_,
      IdUnidade = NA_character_,
      SiglaUnidade =  NA_character_,
      DescricaoUnidade = NA_character_,
      IdUsuario = NA_character_,
      SiglaUsuario = NA_character_,
      NomeUsuario =  NA_character_
    ))
  }
  if (xml2::xml_attr(node_and, "nil", default = "") == "true") {
    return(tibble(
      Descricao = NA_character_,
      DataHora = NA_character_,
      IdUnidade = NA_character_,
      SiglaUnidade =  NA_character_,
      DescricaoUnidade = NA_character_,
      IdUsuario = NA_character_,
      SiglaUsuario = NA_character_,
      NomeUsuario =  NA_character_
    ))
  }
  list(
    Descricao = get_text(node_and, "Descricao"),
    DataHora  = get_text(node_and, "DataHora"),
    Unidade   = list(
      IdUnidade = get_text(node_and, "IdUnidade"),
      SiglaUnidade     = get_text(node_and, "Sigla"),
      DescricaoUnidade = get_text(node_and, "Descricao")
    ) %>% bind_rows(),
    Usuario   = list(
      IdUsuario = get_text(node_and, "IdUsuario"),
      SiglaUsuario     = get_text(node_and, "Sigla"),
      NomeUsuario      = get_text(node_and, "Nome")
    ) %>% bind_rows()
  ) %>%
    bind_rows() %>%
    unnest(c(Unidade, Usuario))
}


##############################################
# 4) parse_unidade_procedimento_aberto
##############################################

#' @title parse_unidade_procedimento_aberto
#'
#' @description
#' Parses a node presumably within \code{<UnidadesProcedimentoAberto><item>...</item></UnidadesProcedimentoAberto>},
#' extracting \code{<Unidade>} and \code{<UsuarioAtribuicao>}.
#'
#' @param node_upa An \code{xml2} node for one <item> in <UnidadesProcedimentoAberto>.
#'
#' @return A named list with \code{$Unidade} and \code{$UsuarioAtribuicao}, each a sub-list
#'   containing fields like \code{IdUnidade}, \code{Sigla}, \code{Descricao}.
#'
#' @examples
#' \dontrun{
#'   parse_unidade_procedimento_aberto(xml_item)
#' }
#'
#' @export
parse_unidade_procedimento_aberto <- function(node_upa) {
  unid_node <- xml2::xml_find_first(node_upa, ".//*[local-name()='Unidade']")
  usr_node  <- xml2::xml_find_first(node_upa, ".//*[local-name()='UsuarioAtribuicao']")

  bind_cols(
    Unidade = list(
      IdUnidade = get_text(unid_node, "IdUnidade"),
      SiglaUnidade = get_text(unid_node, "Sigla"),
      DescricaoUnidade = get_text(unid_node, "Descricao")
    )  %>% bind_rows(),
    UsuarioAtribuicao = list(
      IdUsuario = get_text(usr_node, "IdUsuario"),
      SiglaUsuario = get_text(usr_node, "Sigla"),
      NomeUsuario = get_text(usr_node, "Nome")
    )
  )
}


##############################################
# 5) parse_assunto
##############################################

#' @title parse_assunto
#'
#' @description
#' Parses one <Assunto> item, extracting \code{CodigoEstruturado} and \code{Descricao}.
#'
#' @param node_ass An \code{xml2} node for <item> in <Assuntos>.
#'
#' @return A named list with \code{$CodigoEstruturado} and \code{$Descricao}.
#'
#' @examples
#' \dontrun{
#'   parse_assunto(xml_item)
#' }
#'
#' @export
parse_assunto <- function(node_ass) {
  list(
    CodigoEstruturado = get_text(node_ass, "CodigoEstruturado"),
    Descricao         = get_text(node_ass, "Descricao")
  ) %>%
    bind_rows()
}


##############################################
# 6) parse_interessado
##############################################

#' @title parse_interessado
#'
#' @description
#' Parses one <Interessado> item, extracting \code{Sigla} and \code{Nome}.
#'
#' @param nd_int An \code{xml2} node for <item> in <Interessados>.
#'
#' @return A named list with \code{$Sigla} and \code{$Nome}.
#'
#' @examples
#' \dontrun{
#'   parse_interessado(xml_item)
#' }
#'
#' @export
parse_interessado <- function(nd_int) {
  list(
    Sigla = get_text(nd_int, "Sigla"),
    Nome  = get_text(nd_int, "Nome")
  ) %>%
    bind_rows()
}


##############################################
# 7) parse_observacao
##############################################

#' @title parse_observacao
#'
#' @description
#' Parses one <Observacao> item, extracting \code{Descricao} (and ignoring <Unidade> if present).
#'
#' @param nd_obs An \code{xml2} node for <item> in <Observacoes>.
#'
#' @return A named list with \code{$Descricao}.
#'
#' @examples
#' \dontrun{
#'   parse_observacao(xml_item)
#' }
#'
#' @export
parse_observacao <- function(nd_obs) {
  list(
    Descricao = get_text(nd_obs, "Descricao")
  ) %>%
    bind_rows()
}


##############################################
# 8) parse_procedimento_resumido
##############################################

#' @title parse_procedimento_resumido
#'
#' @description
#' Parses one <ProcedimentoResumido> item, extracting \code{IdProcedimento} and
#' \code{ProcedimentoFormatado}.
#'
#' @param nd_pr An \code{xml2} node for <item> in <ProcedimentosRelacionados> or <ProcedimentosAnexados>.
#'
#' @return A named list with \code{$IdProcedimento} and \code{$ProcedimentoFormatado}.
#'
#' @examples
#' \dontrun{
#'   parse_procedimento_resumido(xml_item)
#' }
#'
#' @export
parse_procedimento_resumido <- function(nd_pr) {
  list(
    IdProcedimento       = get_text(nd_pr, "IdProcedimento"),
    ProcedimentoFormatado= get_text(nd_pr, "ProcedimentoFormatado")
    # If <TipoProcedimento> is nested, parse similarly
  ) %>%
    bind_rows()
}


##############################################
# 9) parse_consultar_procedimento_response
##############################################

#' @title parse_consultar_procedimento_response
#'
#' @description
#' The main parser that finds the <parametros> node under
#' <consultarProcedimentoResponse>, extracts top-level fields
#' (e.g., \code{IdProcedimento}, \code{Especificacao}, \code{NivelAcessoLocal}, etc.),
#' recodes \code{NivelAcessoLocal} and \code{NivelAcessoGlobal} using
#' \code{\link{recodify_access_level}}, and parses substructures like
#' \code{AndamentoGeracao}, \code{Assuntos}, \code{Interessados}, etc.
#'
#' @param doc An \code{xml2::xml_document} containing the SOAP response
#' for the operation "consultarProcedimento".
#'
#' @return A named list with elements:
#' \itemize{
#'   \item \code{IdProcedimento}, \code{ProcedimentoFormatado}, \code{Especificacao}, \code{DataAutuacao},
#'         \code{LinkAcesso}, \code{NivelAcessoLocal}, \code{NivelAcessoGlobal}
#'   \item \code{TipoProcedimento} (list)
#'   \item \code{AndamentoGeracao}, \code{AndamentoConclusao}, \code{UltimoAndamento}
#'   \item \code{UnidadesProcedimentoAberto} (list of sub-lists)
#'   \item \code{Assuntos}, \code{Interessados}, \code{Observacoes},
#'         \code{ProcedimentosRelacionados}, \code{ProcedimentosAnexados}
#' }
#'
#' @examples
#' \dontrun{
#'   resp_xml <- call_sei_api(..., method="consultarProcedimento")
#'   result <- parse_consultar_procedimento_response(resp_xml)
#'   str(result)
#' }
#'
#' @export
parse_consultar_procedimento_response <- function(doc) {

  # 1) Locate <consultarProcedimentoResponse><parametros> ignoring namespaces
  node_params <- xml2::xml_find_first(
    doc,
    "//*[local-name()='consultarProcedimentoResponse']/*[local-name()='parametros']"
  )
  # if not found, try <parametros> anywhere
  if (inherits(node_params, "xml_missing") || is.na(node_params)) {
    node_params <- xml2::xml_find_first(doc, "//*[local-name()='parametros']")
  }
  if (inherits(node_params, "xml_missing") || is.na(node_params)) {
    warning("No <parametros> node found in this XML for consultarProcedimento.")
    return(tibble(IdTipoProcedimento = NA_character_,  Nome  = NA_character_))
  }

  # 2) Extract scalar fields
  IdProcedimento        <- get_text(node_params, "IdProcedimento")
  ProcedimentoFormatado <- get_text(node_params, "ProcedimentoFormatado")
  Especificacao         <- get_text(node_params, "Especificacao")
  DataAutuacao          <- get_text(node_params, "DataAutuacao")
  LinkAcesso            <- get_text(node_params, "LinkAcesso")

  # 3) Access levels, recoding numeric -> text
  raw_local  <- get_text(node_params, "NivelAcessoLocal")
  raw_global <- get_text(node_params, "NivelAcessoGlobal")
  NivelAcessoLocal  <- recodify_access_level(raw_local)
  NivelAcessoGlobal <- recodify_access_level(raw_global)

  # 4) Parse <TipoProcedimento>
  nd_tp <- xml2::xml_find_first(node_params, ".//*[local-name()='TipoProcedimento']")
  TipoProcedimento <- tibble::tibble(IdTipoProcedimento = NA_character_,  Nome  = NA_character_)
  if (!inherits(nd_tp, "xml_missing") && !is.na(nd_tp)) {
    TipoProcedimento <- tibble::tibble(
      IdTipoProcedimento = get_text(nd_tp, "IdTipoProcedimento"),
      Nome               = get_text(nd_tp, "Nome")
    )
  }

  # 5) Parse Andamentos
  nd_ag <- xml2::xml_find_first(node_params, ".//*[local-name()='AndamentoGeracao']")
  AndamentoGeracao <- parse_andamento(nd_ag)

  nd_ac <- xml2::xml_find_first(node_params, ".//*[local-name()='AndamentoConclusao']")
  AndamentoConclusao <- parse_andamento(nd_ac)

  nd_ua <- xml2::xml_find_first(node_params, ".//*[local-name()='UltimoAndamento']")
  UltimoAndamento <- parse_andamento(nd_ua)

  # 6) Arrays with <item>: UnidadesProcedimentoAberto, Assuntos, etc.
  nd_upa_items <- xml2::xml_find_all(
    node_params,
    ".//*[local-name()='UnidadesProcedimentoAberto']/*[local-name()='item']"
  )
  UnidadesProcedimentoAberto <- map(nd_upa_items, parse_unidade_procedimento_aberto) %>%
    bind_rows()

  nd_assuntos <- xml2::xml_find_all(
    node_params,
    ".//*[local-name()='Assuntos']/*[local-name()='item']"
  )
  Assuntos <- map(nd_assuntos, parse_assunto) %>%
    bind_rows()

  nd_interessados <- xml2::xml_find_all(
    node_params,
    ".//*[local-name()='Interessados']/*[local-name()='item']"
  )
  Interessados <- map(nd_interessados, parse_interessado) %>%
    bind_rows()

  nd_obs_items <- xml2::xml_find_all(
    node_params,
    ".//*[local-name()='Observacoes']/*[local-name()='item']"
  )
  Observacoes <- map(nd_obs_items, parse_observacao) %>%
    bind_rows()

  nd_pr_rel <- xml2::xml_find_all(
    node_params,
    ".//*[local-name()='ProcedimentosRelacionados']/*[local-name()='item']"
  )
  ProcedimentosRelacionados <- map(nd_pr_rel, parse_procedimento_resumido) %>%
    bind_rows()

  nd_pr_anx <- xml2::xml_find_all(
    node_params,
    ".//*[local-name()='ProcedimentosAnexados']/*[local-name()='item']"
  )
  ProcedimentosAnexados <- map(nd_pr_anx, parse_procedimento_resumido) %>%
    bind_rows()

  # 7) Return final named list
  tibble::tibble(
    IdProcedimento             = IdProcedimento,
    ProcedimentoFormatado      = ProcedimentoFormatado,
    Especificacao              = Especificacao,
    DataAutuacao               = DataAutuacao,
    LinkAcesso                 = LinkAcesso,
    NivelAcessoLocal           = NivelAcessoLocal,
    NivelAcessoGlobal          = NivelAcessoGlobal,
    TipoProcedimento           = TipoProcedimento,
    AndamentoGeracao           = AndamentoGeracao,
    AndamentoConclusao         = AndamentoConclusao,
    UltimoAndamento            = UltimoAndamento,
    UnidadesProcedimentoAberto = list(UnidadesProcedimentoAberto),
    Assuntos                   = list(Assuntos),
    Interessados               = list(Interessados),
    Observacoes                = list(Observacoes),
    ProcedimentosRelacionados  = list(ProcedimentosRelacionados),
    ProcedimentosAnexados      = list(ProcedimentosAnexados)
  ) %>%
    unnest(c(TipoProcedimento, AndamentoGeracao, AndamentoConclusao, UltimoAndamento),
           names_sep = "_")

}
