# file: R/parse_consultas.R
#
# Parsers das demais consultas: documento, publicação, bloco e procedimento
# individual. Reaproveita os helpers de R/parse_response.R
# (`sei_node_child`, `get_text_child`, `parse_struct`, `parse_items`).

##############################################
# Parsers de estruturas reutilizáveis
##############################################

#' @title parse_unidade
#' @description Parseia uma estrutura `Unidade` (filho direto ou `<item>`).
#' @param node Nó `xml2` da `Unidade`.
#' @return Um tibble de 1 linha com os campos da unidade.
#' @export
parse_unidade <- function(node) parse_struct(node, .sei_fields$unidade)

#' @title parse_serie
#' @description Parseia uma estrutura `Serie`.
#' @param node Nó `xml2` da `Serie`.
#' @return Um tibble de 1 linha com `IdSerie`, `Nome`, `Aplicabilidade`.
#' @export
parse_serie <- function(node) parse_struct(node, .sei_fields$serie)

#' @title parse_assinatura
#' @description Parseia uma estrutura `Assinatura`.
#' @param node Nó `xml2` da `Assinatura` (filho direto ou `<item>`).
#' @return Um tibble de 1 linha com os campos da assinatura.
#' @export
parse_assinatura <- function(node) {
  parse_struct(node, c(
    Nome        = "Nome",
    CargoFuncao = "CargoFuncao",
    DataHora    = "DataHora",
    IdUsuario   = "IdUsuario",
    IdOrigem    = "IdOrigem",
    IdOrgao     = "IdOrgao",
    Sigla       = "Sigla"
  ))
}

#' @title parse_campo
#' @description Parseia uma estrutura `Campo` (formulário).
#' @param node Nó `xml2` do `Campo`.
#' @return Um tibble de 1 linha com `Nome` e `Valor`.
#' @export
parse_campo <- function(node) {
  parse_struct(node, c(Nome = "Nome", Valor = "Valor"))
}

#' @title parse_imprensa_nacional
#' @description Parseia uma estrutura `PublicacaoImprensaNacional`.
#' @param node Nó `xml2`.
#' @return Um tibble de 1 linha.
#' @export
parse_imprensa_nacional <- function(node) {
  parse_struct(node, c(
    IdVeiculo        = "IdVeiculo",
    SiglaVeiculo     = "SiglaVeiculo",
    DescricaoVeiculo = "DescricaoVeiculo",
    Pagina           = "Pagina",
    IdSecao          = "IdSecao",
    Secao            = "Secao",
    Data             = "Data"
  ))
}

#' @title parse_publicacao
#' @description Parseia uma estrutura `Publicacao`, com a `ImprensaNacional`
#'   aninhada como coluna-lista.
#' @param node Nó `xml2` da `Publicacao`.
#' @return Um tibble de 1 linha.
#' @export
parse_publicacao <- function(node) {
  base <- parse_struct(node, c(
    IdPublicacao         = "IdPublicacao",
    IdDocumento          = "IdDocumento",
    StaMotivo            = "StaMotivo",
    Resumo               = "Resumo",
    IdVeiculoPublicacao  = "IdVeiculoPublicacao",
    NomeVeiculo          = "NomeVeiculo",
    StaTipoVeiculo       = "StaTipoVeiculo",
    Numero               = "Numero",
    DataDisponibilizacao = "DataDisponibilizacao",
    DataPublicacao       = "DataPublicacao",
    Estado               = "Estado"
  ))
  nd_in <- sei_node_child(node, "ImprensaNacional")
  base$ImprensaNacional <- list(
    if (is.null(nd_in)) tibble::tibble() else parse_imprensa_nacional(nd_in)
  )
  base
}

#' @title parse_protocolo_bloco
#' @description Parseia uma estrutura `ProtocoloBloco`.
#' @param node Nó `xml2` (um `<item>` de `Protocolos`).
#' @return Um tibble de 1 linha com `ProtocoloFormatado`, `Identificacao` e
#'   `Assinaturas` (coluna-lista).
#' @export
parse_protocolo_bloco <- function(node) {
  base <- parse_struct(node, c(ProtocoloFormatado = "ProtocoloFormatado",
                               Identificacao = "Identificacao"))
  base$Assinaturas <- list(parse_items(node, "Assinaturas", parse_assinatura))
  base
}


##############################################
# Parsers de resposta
##############################################

#' @title parse_consultar_documento_response
#' @description Parseia a resposta de `consultarDocumento`
#'   (`RetornoConsultaDocumento`).
#' @param doc Um `xml2::xml_document`.
#' @return Um tibble de 1 linha. `Serie`, `UnidadeElaboradora` e
#'   `AndamentoGeracao` viram colunas com prefixo; `Publicacao`, `Assinaturas`
#'   e `Campos` ficam como colunas-lista.
#' @export
parse_consultar_documento_response <- function(doc) {
  np <- sei_find_parametros(doc, "consultarDocumentoResponse")
  if (is.null(np)) {
    warning("Resposta sem elemento <parametros> paraconsultarDocumento.")
    return(tibble::tibble(IdDocumento = NA_character_))
  }

  Serie              <- parse_serie(sei_node_child(np, "Serie"))
  UnidadeElaboradora <- parse_unidade(sei_node_child(np, "UnidadeElaboradora"))
  AndamentoGeracao   <- parse_andamento(sei_node_child(np, "AndamentoGeracao"))

  nd_pub    <- sei_node_child(np, "Publicacao")
  Publicacao <- if (is.null(nd_pub)) tibble::tibble() else parse_publicacao(nd_pub)
  Assinaturas <- parse_items(np, "Assinaturas", parse_assinatura)
  Campos      <- parse_items(np, "Campos", parse_campo)

  tibble::tibble(
    IdProcedimento        = get_text_child(np, "IdProcedimento"),
    ProcedimentoFormatado = get_text_child(np, "ProcedimentoFormatado"),
    IdDocumento           = get_text_child(np, "IdDocumento"),
    DocumentoFormatado    = get_text_child(np, "DocumentoFormatado"),
    NivelAcessoLocal      = recodify_access_level(get_text_child(np, "NivelAcessoLocal")),
    NivelAcessoGlobal     = recodify_access_level(get_text_child(np, "NivelAcessoGlobal")),
    LinkAcesso            = get_text_child(np, "LinkAcesso"),
    Numero                = get_text_child(np, "Numero"),
    Descricao             = get_text_child(np, "Descricao"),
    Data                  = get_text_child(np, "Data"),
    Serie                 = Serie,
    UnidadeElaboradora    = UnidadeElaboradora,
    AndamentoGeracao      = AndamentoGeracao,
    Publicacao            = list(Publicacao),
    Assinaturas           = list(Assinaturas),
    Campos                = list(Campos)
  ) %>%
    tidyr::unnest(c("Serie", "UnidadeElaboradora", "AndamentoGeracao"),
                  names_sep = "_")
}

#' @title parse_consultar_publicacao_response
#' @description Parseia a resposta de `consultarPublicacao`
#'   (`RetornoConsultaPublicacao`).
#' @param doc Um `xml2::xml_document`.
#' @return Um tibble de 1 linha. `Publicacao` e `Andamento` viram colunas com
#'   prefixo; `Assinaturas` fica como coluna-lista.
#' @export
parse_consultar_publicacao_response <- function(doc) {
  np <- sei_find_parametros(doc, "consultarPublicacaoResponse")
  if (is.null(np)) {
    warning("Resposta sem elemento <parametros> paraconsultarPublicacao.")
    return(tibble::tibble(IdPublicacao = NA_character_))
  }

  nd_pub <- sei_node_child(np, "Publicacao")
  Publicacao <- if (is.null(nd_pub)) {
    tibble::tibble(IdPublicacao = NA_character_, ImprensaNacional = list(tibble::tibble()))
  } else parse_publicacao(nd_pub)

  Andamento   <- parse_andamento(sei_node_child(np, "Andamento"))
  Assinaturas <- parse_items(np, "Assinaturas", parse_assinatura)

  tibble::tibble(
    Publicacao  = Publicacao,
    Andamento   = Andamento,
    Assinaturas = list(Assinaturas)
  ) %>%
    tidyr::unnest(c("Publicacao", "Andamento"), names_sep = "_")
}

#' @title parse_consultar_bloco_response
#' @description Parseia a resposta de `consultarBloco` (`RetornoConsultaBloco`).
#' @param doc Um `xml2::xml_document`.
#' @return Um tibble de 1 linha. `Unidade`, `Usuario` e `UsuarioAtribuicao`
#'   viram colunas com prefixo; `UnidadesDisponibilizacao` e `Protocolos`
#'   ficam como colunas-lista.
#' @export
parse_consultar_bloco_response <- function(doc) {
  np <- sei_find_parametros(doc, "consultarBlocoResponse")
  if (is.null(np)) {
    warning("Resposta sem elemento <parametros> paraconsultarBloco.")
    return(tibble::tibble(IdBloco = NA_character_))
  }

  Unidade           <- parse_unidade(sei_node_child(np, "Unidade"))
  Usuario           <- parse_struct(sei_node_child(np, "Usuario"),
                                    c(IdUsuario = "IdUsuario", Sigla = "Sigla", Nome = "Nome"))
  UsuarioAtribuicao <- parse_struct(sei_node_child(np, "UsuarioAtribuicao"),
                                    c(IdUsuario = "IdUsuario", Sigla = "Sigla", Nome = "Nome"))

  UnidadesDisponibilizacao <- parse_items(np, "UnidadesDisponibilizacao", parse_unidade)
  Protocolos               <- parse_items(np, "Protocolos", parse_protocolo_bloco)

  tibble::tibble(
    IdBloco                  = get_text_child(np, "IdBloco"),
    Descricao                = get_text_child(np, "Descricao"),
    Tipo                     = get_text_child(np, "Tipo"),
    Estado                   = get_text_child(np, "Estado"),
    SinPrioridade            = get_text_child(np, "SinPrioridade"),
    SinRevisao               = get_text_child(np, "SinRevisao"),
    Unidade                  = Unidade,
    Usuario                  = Usuario,
    UsuarioAtribuicao        = UsuarioAtribuicao,
    UnidadesDisponibilizacao = list(UnidadesDisponibilizacao),
    Protocolos               = list(Protocolos)
  ) %>%
    tidyr::unnest(c("Unidade", "Usuario", "UsuarioAtribuicao"), names_sep = "_")
}

#' @title parse_consultar_procedimento_individual_response
#' @description Parseia a resposta de `consultarProcedimentoIndividual`
#'   (`ProcedimentoResumido`). Retorna linha de `NA` se nenhum processo for
#'   encontrado (`parametros` nulo).
#' @param doc Um `xml2::xml_document`.
#' @return Um tibble de 1 linha.
#' @export
parse_consultar_procedimento_individual_response <- function(doc) {
  np <- sei_find_parametros(doc, "consultarProcedimentoIndividualResponse")
  empty <- tibble::tibble(
    IdProcedimento = NA_character_, IdTipoProcedimento = NA_character_,
    ProcedimentoFormatado = NA_character_,
    TipoProcedimento_IdTipoProcedimento = NA_character_,
    TipoProcedimento_Nome = NA_character_
  )
  if (is.null(np)) return(empty)

  TipoProcedimento <- parse_struct(sei_node_child(np, "TipoProcedimento"),
                                   c(IdTipoProcedimento = "IdTipoProcedimento",
                                     Nome = "Nome"))
  tibble::tibble(
    IdProcedimento        = get_text_child(np, "IdProcedimento"),
    IdTipoProcedimento    = get_text_child(np, "IdTipoProcedimento"),
    ProcedimentoFormatado = get_text_child(np, "ProcedimentoFormatado"),
    TipoProcedimento      = TipoProcedimento
  ) %>%
    tidyr::unnest(c("TipoProcedimento"), names_sep = "_")
}
