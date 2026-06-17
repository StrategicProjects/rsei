# file: R/parse_listas.R
#
# Parser genérico das operações `listar*` e os parsers/mapas de campo de cada
# estrutura. Os mapas em `.sei_fields` são a única fonte de verdade: usados tanto
# pelos parsers de nó único (`parse_X`) quanto pelo caminho vetorizado das listas
# (`parse_struct_nodeset`), evitando duplicação.

# Mapa de campos por estrutura (coluna = local-name do filho direto).
.sei_fields <- list(
  unidade = c(IdUnidade = "IdUnidade", Sigla = "Sigla", Descricao = "Descricao",
              SinProtocolo = "SinProtocolo", SinArquivamento = "SinArquivamento",
              SinOuvidoria = "SinOuvidoria"),
  serie = c(IdSerie = "IdSerie", Nome = "Nome", Aplicabilidade = "Aplicabilidade"),
  tipo_procedimento = c(IdTipoProcedimento = "IdTipoProcedimento", Nome = "Nome"),
  usuario = c(IdUsuario = "IdUsuario", Sigla = "Sigla", Nome = "Nome"),
  hipotese_legal = c(IdHipoteseLegal = "IdHipoteseLegal", Nome = "Nome",
                     BaseLegal = "BaseLegal", NivelAcesso = "NivelAcesso"),
  cidade = c(IdCidade = "IdCidade", IdEstado = "IdEstado", IdPais = "IdPais",
             Nome = "Nome", CodigoIbge = "CodigoIbge", SinCapital = "SinCapital",
             Latitude = "Latitude", Longitude = "Longitude"),
  estado = c(IdEstado = "IdEstado", IdPais = "IdPais", Sigla = "Sigla",
             Nome = "Nome", CodigoIbge = "CodigoIbge"),
  pais = c(IdPais = "IdPais", Nome = "Nome"),
  cargo = c(IdCargo = "IdCargo", ExpressaoCargo = "ExpressaoCargo",
            ExpressaoTratamento = "ExpressaoTratamento",
            ExpressaoVocativo = "ExpressaoVocativo"),
  feriado = c(Data = "Data", Descricao = "Descricao"),
  arquivo_extensao = c(IdArquivoExtensao = "IdArquivoExtensao",
                       Extensao = "Extensao", Descricao = "Descricao"),
  marcador = c(IdMarcador = "IdMarcador", Nome = "Nome", SinAtivo = "SinAtivo"),
  tipo_conferencia = c(IdTipoConferencia = "IdTipoConferencia", Descricao = "Descricao"),
  contato = c(IdContato = "IdContato", StaNatureza = "StaNatureza", Sigla = "Sigla",
              Nome = "Nome", NomeSocial = "NomeSocial", Cpf = "Cpf", Cnpj = "Cnpj",
              Email = "Email", TelefoneFixo = "TelefoneFixo",
              TelefoneCelular = "TelefoneCelular", Endereco = "Endereco",
              Bairro = "Bairro", Cep = "Cep", NomeCidade = "NomeCidade",
              SiglaEstado = "SiglaEstado", NomePais = "NomePais",
              ExpressaoCargo = "ExpressaoCargo", DataNascimento = "DataNascimento",
              SinAtivo = "SinAtivo")
)

#' @title parse_list_response
#' @description Parser genérico para respostas `listar*`: encontra `<parametros>`
#'   (que é um array) e aplica `item_parser` a cada `<item>` filho direto. Para
#'   estruturas planas prefira o caminho vetorizado interno (via mapas de campo),
#'   bem mais rápido em listas grandes.
#' @param doc Um `xml2::xml_document`.
#' @param response_name Character. Nome do elemento de resposta.
#' @param item_parser Função que parseia um nó `<item>` num tibble de 1 linha.
#' @return Um tibble com uma linha por item (vazio se não houver itens).
#' @export
parse_list_response <- function(doc, response_name, item_parser) {
  np <- sei_find_parametros(doc, response_name)
  if (is.null(np)) return(tibble::tibble())
  items <- xml2::xml_find_all(np, "./*[local-name()='item']")
  if (length(items) == 0) return(tibble::tibble())
  dplyr::bind_rows(purrr::map(items, item_parser))
}

# Caminho vetorizado: localiza os <item> de uma resposta listar* e extrai os
# campos de uma vez. Usado pelos wrappers de estruturas planas.
parse_list_struct <- function(doc, response_name, fields) {
  np <- sei_find_parametros(doc, response_name)
  if (is.null(np)) return(parse_struct_nodeset(list(), fields))
  items <- xml2::xml_find_all(np, "./*[local-name()='item']")
  parse_struct_nodeset(items, fields)
}

##############################################
# Parsers de item de nó único (p/ uso em estruturas aninhadas)
##############################################

#' @title parse_tipo_procedimento
#' @description Parseia uma estrutura `TipoProcedimento`.
#' @param node Nó `xml2`.
#' @return Um tibble de 1 linha.
#' @export
parse_tipo_procedimento <- function(node) parse_struct(node, .sei_fields$tipo_procedimento)

#' @title parse_usuario
#' @description Parseia uma estrutura `Usuario`.
#' @param node Nó `xml2`.
#' @return Um tibble de 1 linha.
#' @export
parse_usuario <- function(node) parse_struct(node, .sei_fields$usuario)

#' @title parse_hipotese_legal
#' @description Parseia uma estrutura `HipoteseLegal`.
#' @param node Nó `xml2`.
#' @return Um tibble de 1 linha.
#' @export
parse_hipotese_legal <- function(node) parse_struct(node, .sei_fields$hipotese_legal)

#' @title parse_cidade
#' @description Parseia uma estrutura `Cidade`.
#' @param node Nó `xml2`.
#' @return Um tibble de 1 linha.
#' @export
parse_cidade <- function(node) parse_struct(node, .sei_fields$cidade)

#' @title parse_estado
#' @description Parseia uma estrutura `Estado`.
#' @param node Nó `xml2`.
#' @return Um tibble de 1 linha.
#' @export
parse_estado <- function(node) parse_struct(node, .sei_fields$estado)

#' @title parse_pais
#' @description Parseia uma estrutura `Pais`.
#' @param node Nó `xml2`.
#' @return Um tibble de 1 linha.
#' @export
parse_pais <- function(node) parse_struct(node, .sei_fields$pais)

#' @title parse_cargo
#' @description Parseia uma estrutura `Cargo`.
#' @param node Nó `xml2`.
#' @return Um tibble de 1 linha.
#' @export
parse_cargo <- function(node) parse_struct(node, .sei_fields$cargo)

#' @title parse_feriado
#' @description Parseia uma estrutura `Feriado`.
#' @param node Nó `xml2`.
#' @return Um tibble de 1 linha.
#' @export
parse_feriado <- function(node) parse_struct(node, .sei_fields$feriado)

#' @title parse_arquivo_extensao
#' @description Parseia uma estrutura `ArquivoExtensao`.
#' @param node Nó `xml2`.
#' @return Um tibble de 1 linha.
#' @export
parse_arquivo_extensao <- function(node) parse_struct(node, .sei_fields$arquivo_extensao)

#' @title parse_marcador
#' @description Parseia uma estrutura `Marcador` (sem `Icone`, que é Base64).
#' @param node Nó `xml2`.
#' @return Um tibble de 1 linha.
#' @export
parse_marcador <- function(node) parse_struct(node, .sei_fields$marcador)

#' @title parse_tipo_conferencia
#' @description Parseia uma estrutura `TipoConferencia`.
#' @param node Nó `xml2`.
#' @return Um tibble de 1 linha.
#' @export
parse_tipo_conferencia <- function(node) parse_struct(node, .sei_fields$tipo_conferencia)

#' @title parse_contato
#' @description Parseia uma estrutura `Contato` (subconjunto dos campos úteis).
#' @param node Nó `xml2`.
#' @return Um tibble de 1 linha.
#' @export
parse_contato <- function(node) parse_struct(node, .sei_fields$contato)

#' @title parse_andamento_item
#' @description Parseia um `<item>` de `Andamento` no contexto de
#'   `listarAndamentos` (inclui `IdAndamento`/`IdTarefa` e `Atributos`).
#' @param node Nó `xml2` de um `<item>`.
#' @return Um tibble de 1 linha; `Atributos` é uma coluna-lista.
#' @export
parse_andamento_item <- function(node) {
  if (is.null(node) || inherits(node, "xml_missing") || is.na(node)) {
    return(tibble::tibble(
      IdAndamento = NA_character_, IdTarefa = NA_character_,
      IdTarefaModulo = NA_character_, Descricao = NA_character_,
      DataHora = NA_character_, IdUnidade = NA_character_,
      SiglaUnidade = NA_character_, DescricaoUnidade = NA_character_,
      IdUsuario = NA_character_, SiglaUsuario = NA_character_,
      NomeUsuario = NA_character_, Atributos = list(tibble::tibble())
    ))
  }
  unid <- sei_node_child(node, "Unidade")
  usr  <- sei_node_child(node, "Usuario")
  atributos <- parse_items(node, "Atributos", function(a) {
    parse_struct(a, c(Nome = "Nome", Valor = "Valor", IdOrigem = "IdOrigem"))
  })
  tibble::tibble(
    IdAndamento      = get_text_child(node, "IdAndamento"),
    IdTarefa         = get_text_child(node, "IdTarefa"),
    IdTarefaModulo   = get_text_child(node, "IdTarefaModulo"),
    Descricao        = get_text_child(node, "Descricao"),
    DataHora         = get_text_child(node, "DataHora"),
    IdUnidade        = get_text_child(unid, "IdUnidade"),
    SiglaUnidade     = get_text_child(unid, "Sigla"),
    DescricaoUnidade = get_text_child(unid, "Descricao"),
    IdUsuario        = get_text_child(usr, "IdUsuario"),
    SiglaUsuario     = get_text_child(usr, "Sigla"),
    NomeUsuario      = get_text_child(usr, "Nome"),
    Atributos        = list(atributos)
  )
}

#' @title parse_andamento_marcador_item
#' @description Parseia um `<item>` de `AndamentoMarcador` no contexto de
#'   `listarAndamentosMarcadores` (texto do marcador, data/hora, usuário e
#'   marcador associado).
#' @param node Nó `xml2` de um `<item>`.
#' @return Um tibble de 1 linha.
#' @export
parse_andamento_marcador_item <- function(node) {
  if (is.null(node) || inherits(node, "xml_missing") || is.na(node)) {
    return(tibble::tibble(
      IdAndamentoMarcador = NA_character_, Texto = NA_character_,
      DataHora = NA_character_, IdUsuario = NA_character_,
      SiglaUsuario = NA_character_, NomeUsuario = NA_character_,
      IdMarcador = NA_character_, NomeMarcador = NA_character_
    ))
  }
  usr <- sei_node_child(node, "Usuario")
  mrc <- sei_node_child(node, "Marcador")
  tibble::tibble(
    IdAndamentoMarcador = get_text_child(node, "IdAndamentoMarcador"),
    Texto               = get_text_child(node, "Texto"),
    DataHora            = get_text_child(node, "DataHora"),
    IdUsuario           = get_text_child(usr, "IdUsuario"),
    SiglaUsuario        = get_text_child(usr, "Sigla"),
    NomeUsuario         = get_text_child(usr, "Nome"),
    IdMarcador          = get_text_child(mrc, "IdMarcador"),
    NomeMarcador        = get_text_child(mrc, "Nome")
  )
}
