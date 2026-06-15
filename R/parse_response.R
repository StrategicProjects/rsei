# file: R/parse_response.R
#
# Parsers de respostas SOAP do SEI -> tibbles. Os helpers genéricos
# (`sei_node_child`, `get_text_child`, `parse_struct`, `parse_items`) evitam a
# repetição do padrão `map(...) %>% bind_rows()` e ancoram a extração na
# subárvore correta (filho direto), evitando o bug de pegar o primeiro
# descendente homônimo (ex.: `Sigla` de Unidade vs. de Usuario).

##############################################
# 1) recodify_access_level
##############################################

#' @title Recodify SEI Access Level
#'
#' @description
#' Converte os códigos numéricos de nível de acesso do SEI em texto:
#' "0" -> "público", "1" -> "restrito", "2" -> "sigiloso". Valores ausentes,
#' vazios ou fora de \code{c("0","1","2")} são devolvidos inalterados.
#'
#' @param val Character, geralmente "0", "1" ou "2".
#'
#' @return "público", "restrito", "sigiloso", ou o valor original.
#'
#' @examples
#' recodify_access_level("0")  # "público"
#' recodify_access_level("2")  # "sigiloso"
#'
#' @export
recodify_access_level <- function(val) {
  if (length(val) == 0 || is.na(val) || val == "") {
    return(val)
  }
  # "publico" construído via codepoints p/ evitar literal acentuado no fonte
  # (R sob locale "C" corromperia um literal UTF-8). 250 = U+00FA (u acentuado).
  publico <- intToUtf8(c(112L, 250L, 98L, 108L, 105L, 99L, 111L))
  switch(
    val,
    "0" = publico,
    "1" = "restrito",
    "2" = "sigiloso",
    val  # default
  )
}


##############################################
# 2) helpers de extração XML
##############################################

#' @title get_text: texto de um descendente por local-name
#'
#' @description
#' Encontra o primeiro descendente de \code{parent} com o \code{local-name}
#' informado (ignorando namespaces) e devolve seu texto, ou "" se ausente /
#' \code{xsi:nil="true"}. Mantido por compatibilidade; para extração ancorada
#' em filho direto use o helper interno \code{get_text_child}.
#'
#' @param parent Um nó \code{xml2}.
#' @param child_name Character. O local-name do elemento a extrair.
#'
#' @return Uma string (possivelmente vazia).
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

# Nó filho DIRETO por local-name; NULL se ausente ou xsi:nil.
sei_node_child <- function(parent, name) {
  if (is.null(parent)) return(NULL)
  nd <- xml2::xml_find_first(parent, sprintf("./*[local-name()='%s']", name))
  if (inherits(nd, "xml_missing") || is.na(nd)) return(NULL)
  if (xml2::xml_attr(nd, "nil", default = "") == "true") return(NULL)
  nd
}

# Texto de um filho DIRETO por local-name; NA_character_ se ausente / nil.
get_text_child <- function(parent, name) {
  if (is.null(parent)) return(NA_character_)
  nd <- xml2::xml_find_first(parent, sprintf("./*[local-name()='%s']", name))
  if (inherits(nd, "xml_missing") || is.na(nd)) return(NA_character_)
  if (xml2::xml_attr(nd, "nil", default = "") == "true") return(NA_character_)
  xml2::xml_text(nd)
}

# Constrói um tibble de 1 linha a partir de um nó e um mapa de campos.
# `fields` é um vetor nomeado: nomes = colunas do tibble; valores = local-names
# dos filhos diretos. Se `node` for NULL, devolve uma linha de NAs.
parse_struct <- function(node, fields) {
  vals <- lapply(unname(fields), function(f) get_text_child(node, f))
  names(vals) <- names(fields)
  tibble::as_tibble(vals)
}

# Itera sobre <array_name>/<item> de `parent`, aplicando `item_parser` a cada um.
# Devolve um tibble (vazio com 0 linhas se não houver itens).
parse_items <- function(parent, array_name, item_parser) {
  items <- xml2::xml_find_all(
    parent,
    sprintf(".//*[local-name()='%s']/*[local-name()='item']", array_name)
  )
  if (length(items) == 0) return(tibble::tibble())
  dplyr::bind_rows(purrr::map(items, item_parser))
}

# Versão VETORIZADA de parse_struct para um conjunto de nós (nodeset).
# Para cada campo faz UMA busca xml_find_first sobre todo o nodeset, em vez de
# um XPath por item — essencial p/ listas grandes (ex.: 18k unidades).
# `fields` é um vetor nomeado (coluna = local-name do filho direto).
parse_struct_nodeset <- function(items, fields) {
  if (length(items) == 0) {
    cols <- stats::setNames(replicate(length(fields), character(0), simplify = FALSE),
                            names(fields))
    return(tibble::as_tibble(cols))
  }
  cols <- lapply(unname(fields), function(f) {
    nd  <- xml2::xml_find_first(items, sprintf("./*[local-name()='%s']", f))
    txt <- xml2::xml_text(nd)               # NA para nós ausentes
    nil <- xml2::xml_attr(nd, "nil")
    txt[!is.na(nil) & nil == "true"] <- NA_character_
    txt
  })
  names(cols) <- names(fields)
  tibble::as_tibble(cols)
}


##############################################
# 3) parse_andamento (corrigido: ancorado em subárvore)
##############################################

#' @title parse_andamento: Parse a \code{<Andamento>} Node
#'
#' @description
#' Parseia um nó \code{<Andamento>} (\code{Descricao}, \code{DataHora}, e as
#' subestruturas \code{Unidade} e \code{Usuario}) num tibble de 1 linha. Se o nó
#' for ausente ou \code{xsi:nil="true"}, devolve uma linha de \code{NA}.
#'
#' @param node_and Um nó \code{xml2} representando um \code{<Andamento>}.
#'
#' @return Um tibble de 1 linha com \code{Descricao}, \code{DataHora},
#'   \code{IdUnidade}, \code{SiglaUnidade}, \code{DescricaoUnidade},
#'   \code{IdUsuario}, \code{SiglaUsuario}, \code{NomeUsuario}.
#'
#' @export
parse_andamento <- function(node_and) {
  empty <- tibble::tibble(
    Descricao = NA_character_, DataHora = NA_character_,
    IdUnidade = NA_character_, SiglaUnidade = NA_character_,
    DescricaoUnidade = NA_character_,
    IdUsuario = NA_character_, SiglaUsuario = NA_character_,
    NomeUsuario = NA_character_
  )
  if (is.null(node_and) || inherits(node_and, "xml_missing") || is.na(node_and)) {
    return(empty)
  }
  if (xml2::xml_attr(node_and, "nil", default = "") == "true") {
    return(empty)
  }

  unid <- sei_node_child(node_and, "Unidade")
  usr  <- sei_node_child(node_and, "Usuario")

  tibble::tibble(
    Descricao        = get_text_child(node_and, "Descricao"),
    DataHora         = get_text_child(node_and, "DataHora"),
    IdUnidade        = get_text_child(unid, "IdUnidade"),
    SiglaUnidade     = get_text_child(unid, "Sigla"),
    DescricaoUnidade = get_text_child(unid, "Descricao"),
    IdUsuario        = get_text_child(usr, "IdUsuario"),
    SiglaUsuario     = get_text_child(usr, "Sigla"),
    NomeUsuario      = get_text_child(usr, "Nome")
  )
}


##############################################
# 4) parse_unidade_procedimento_aberto (corrigido)
##############################################

#' @title parse_unidade_procedimento_aberto
#'
#' @description
#' Parseia um \code{<item>} de \code{<UnidadesProcedimentoAberto>}, extraindo as
#' subestruturas \code{Unidade} e \code{UsuarioAtribuicao}.
#'
#' @param node_upa Um nó \code{xml2} de um \code{<item>}.
#'
#' @return Um tibble de 1 linha com os campos da unidade e do usuário de atribuição.
#'
#' @export
parse_unidade_procedimento_aberto <- function(node_upa) {
  unid <- sei_node_child(node_upa, "Unidade")
  usr  <- sei_node_child(node_upa, "UsuarioAtribuicao")

  tibble::tibble(
    IdUnidade        = get_text_child(unid, "IdUnidade"),
    SiglaUnidade     = get_text_child(unid, "Sigla"),
    DescricaoUnidade = get_text_child(unid, "Descricao"),
    IdUsuario        = get_text_child(usr, "IdUsuario"),
    SiglaUsuario     = get_text_child(usr, "Sigla"),
    NomeUsuario      = get_text_child(usr, "Nome")
  )
}


##############################################
# 5) parsers de itens simples
##############################################

#' @title parse_assunto
#' @description Parseia um \code{<item>} de \code{<Assuntos>}.
#' @param node_ass Um nó \code{xml2} de \code{<item>}.
#' @return Um tibble de 1 linha com \code{CodigoEstruturado} e \code{Descricao}.
#' @export
parse_assunto <- function(node_ass) {
  parse_struct(node_ass, c(CodigoEstruturado = "CodigoEstruturado",
                           Descricao = "Descricao"))
}

#' @title parse_interessado
#' @description Parseia um \code{<item>} de \code{<Interessados>}.
#' @param nd_int Um nó \code{xml2} de \code{<item>}.
#' @return Um tibble de 1 linha com \code{Sigla} e \code{Nome}.
#' @export
parse_interessado <- function(nd_int) {
  parse_struct(nd_int, c(Sigla = "Sigla", Nome = "Nome"))
}

#' @title parse_observacao
#' @description Parseia um \code{<item>} de \code{<Observacoes>}.
#' @param nd_obs Um nó \code{xml2} de \code{<item>}.
#' @return Um tibble de 1 linha com \code{Descricao}.
#' @export
parse_observacao <- function(nd_obs) {
  parse_struct(nd_obs, c(Descricao = "Descricao"))
}

#' @title parse_procedimento_resumido
#' @description Parseia um \code{<item>} de \code{<ProcedimentosRelacionados>}
#'   ou \code{<ProcedimentosAnexados>}.
#' @param nd_pr Um nó \code{xml2} de \code{<item>}.
#' @return Um tibble de 1 linha com \code{IdProcedimento} e \code{ProcedimentoFormatado}.
#' @export
parse_procedimento_resumido <- function(nd_pr) {
  parse_struct(nd_pr, c(IdProcedimento = "IdProcedimento",
                        ProcedimentoFormatado = "ProcedimentoFormatado"))
}


##############################################
# 6) parse_consultar_procedimento_response
##############################################

#' @title parse_consultar_procedimento_response
#'
#' @description
#' Parser principal de \code{consultarProcedimento}: localiza o nó
#' \code{<parametros>}, extrai os campos escalares, recodifica
#' \code{NivelAcessoLocal}/\code{NivelAcessoGlobal} e parseia as subestruturas
#' (\code{TipoProcedimento}, andamentos, e os arrays \code{Assuntos},
#' \code{Interessados}, etc.).
#'
#' @param doc Um \code{xml2::xml_document} com a resposta de "consultarProcedimento".
#'
#' @return Um tibble de 1 linha. Campos escalares e subestruturas 1:1
#'   (TipoProcedimento e andamentos) viram colunas com prefixo; arrays
#'   (\code{Assuntos}, \code{Interessados}, \code{Observacoes},
#'   \code{UnidadesProcedimentoAberto}, \code{ProcedimentosRelacionados},
#'   \code{ProcedimentosAnexados}) ficam como colunas-lista de tibbles.
#'
#' @examples
#' \dontrun{
#'   doc <- consultar_procedimento("0011108545.000056/2022-49", raw = TRUE)
#'   parse_consultar_procedimento_response(doc)
#' }
#'
#' @export
parse_consultar_procedimento_response <- function(doc) {

  node_params <- sei_find_parametros(doc, "consultarProcedimentoResponse")
  if (is.null(node_params)) {
    warning("Resposta sem elemento <parametros> paraconsultarProcedimento.")
    return(tibble::tibble(IdProcedimento = NA_character_))
  }

  # Campos escalares
  IdProcedimento        <- get_text_child(node_params, "IdProcedimento")
  ProcedimentoFormatado <- get_text_child(node_params, "ProcedimentoFormatado")
  Especificacao         <- get_text_child(node_params, "Especificacao")
  DataAutuacao          <- get_text_child(node_params, "DataAutuacao")
  LinkAcesso            <- get_text_child(node_params, "LinkAcesso")
  NivelAcessoLocal      <- recodify_access_level(get_text_child(node_params, "NivelAcessoLocal"))
  NivelAcessoGlobal     <- recodify_access_level(get_text_child(node_params, "NivelAcessoGlobal"))

  # TipoProcedimento (1:1)
  nd_tp <- sei_node_child(node_params, "TipoProcedimento")
  TipoProcedimento <- parse_struct(nd_tp, c(IdTipoProcedimento = "IdTipoProcedimento",
                                            Nome = "Nome"))

  # Andamentos (1:1)
  AndamentoGeracao   <- parse_andamento(sei_node_child(node_params, "AndamentoGeracao"))
  AndamentoConclusao <- parse_andamento(sei_node_child(node_params, "AndamentoConclusao"))
  UltimoAndamento    <- parse_andamento(sei_node_child(node_params, "UltimoAndamento"))

  # Arrays
  UnidadesProcedimentoAberto <- parse_items(node_params, "UnidadesProcedimentoAberto",
                                            parse_unidade_procedimento_aberto)
  Assuntos                  <- parse_items(node_params, "Assuntos", parse_assunto)
  Interessados              <- parse_items(node_params, "Interessados", parse_interessado)
  Observacoes               <- parse_items(node_params, "Observacoes", parse_observacao)
  ProcedimentosRelacionados <- parse_items(node_params, "ProcedimentosRelacionados",
                                           parse_procedimento_resumido)
  ProcedimentosAnexados     <- parse_items(node_params, "ProcedimentosAnexados",
                                           parse_procedimento_resumido)

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
    tidyr::unnest(c("TipoProcedimento", "AndamentoGeracao",
                    "AndamentoConclusao", "UltimoAndamento"),
                  names_sep = "_")
}
