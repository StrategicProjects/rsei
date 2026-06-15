# file: R/consultas.R
#
# Wrappers das operações de consulta (read-only) do SEI, sobre `sei_call()`.
# `consultar_procedimento` vive em R/consultaProcedimento.R.

#' @title consultar_documento
#'
#' @description
#' Chama a operação `consultarDocumento` do SEI. Por padrão devolve o resultado
#' parseado como `tibble` (use `raw = TRUE` para o `xml_document`).
#'
#' @param protocolo_documento Character. Número do documento visível ao usuário
#'   (ex.: "0003934").
#' @param config Um objeto [sei_config()].
#' @param sin_retornar_andamento_geracao,sin_retornar_assinaturas,sin_retornar_publicacao,sin_retornar_campos
#'   "S" ou "N", indicando se cada bloco deve ser retornado.
#' @param raw Logical. Se `TRUE`, devolve o `xml_document` bruto.
#' @param verbose Logical. Se `TRUE`, imprime envelope e resposta.
#'
#' @return Um `tibble` (ou `xml_document` se `raw = TRUE`).
#' @export
consultar_documento <- function(
    protocolo_documento,
    config = sei_config(),
    sin_retornar_andamento_geracao = "S",
    sin_retornar_assinaturas       = "S",
    sin_retornar_publicacao        = "S",
    sin_retornar_campos            = "S",
    raw = FALSE,
    verbose = FALSE) {

  params <- list(
    SiglaSistema                = config$sigla_sistema,
    IdentificacaoServico        = config$identificacao_servico,
    IdUnidade                   = config$id_unidade,
    ProtocoloDocumento          = protocolo_documento,
    SinRetornarAndamentoGeracao = sin_retornar_andamento_geracao,
    SinRetornarAssinaturas      = sin_retornar_assinaturas,
    SinRetornarPublicacao       = sin_retornar_publicacao,
    SinRetornarCampos           = sin_retornar_campos
  )

  doc <- sei_call("consultarDocumento", params = params, config = config, verbose = verbose)
  if (isTRUE(raw)) return(doc)
  parse_consultar_documento_response(doc)
}

#' @title consultar_documentos
#'
#' @description
#' Consulta vários documentos de uma vez e empilha os resultados em um único
#' `tibble`. Cada documento é consultado com [consultar_documento()] e o
#' resultado recebe uma coluna `protocolo` (o número consultado) e uma coluna
#' `erro` (`NA` em sucesso; a mensagem caso a consulta falhe). Por padrão um
#' documento com erro não interrompe o lote.
#'
#' @param protocolos Vetor de números de documento.
#' @param config Um objeto [sei_config()].
#' @param parar_em_erro Logical. Se `TRUE`, interrompe na primeira falha; se
#'   `FALSE` (padrão), registra o erro na coluna `erro` e segue.
#' @param verbose Logical. Repassado a [consultar_documento()].
#' @param ... Demais argumentos repassados a [consultar_documento()] (ex.: os
#'   sinalizadores `sin_retornar_*`). Não use `raw` aqui.
#'
#' @return Um `tibble` com uma linha por documento (colunas `protocolo` e `erro`
#'   além das de [consultar_documento()]).
#'
#' @examples
#' \dontrun{
#'   consultar_documentos(c("58769333", "0003934"), config = sei_config())
#' }
#'
#' @export
consultar_documentos <- function(protocolos, config = sei_config(),
                                 parar_em_erro = FALSE, verbose = FALSE, ...) {
  protocolos <- as.character(protocolos)
  linhas <- lapply(protocolos, function(p) {
    res <- tryCatch(
      do.call(consultar_documento,
              c(list(p, config = config, verbose = verbose), list(...))),
      error = function(e) {
        if (isTRUE(parar_em_erro)) stop(e)
        tibble::tibble(erro = conditionMessage(e))
      }
    )
    if (!"erro" %in% names(res)) res$erro <- NA_character_
    dplyr::bind_cols(tibble::tibble(protocolo = p), res)
  })
  dplyr::bind_rows(linhas)
}

#' @title consultar_publicacao
#'
#' @description
#' Chama a operação `consultarPublicacao` do SEI. Informe ao menos um filtro:
#' `id_publicacao`, `id_documento` ou `protocolo_documento`.
#'
#' @param id_publicacao,id_documento,protocolo_documento Filtros (informe um).
#' @param config Um objeto [sei_config()].
#' @param sin_retornar_andamento,sin_retornar_assinaturas "S" ou "N".
#' @param raw Logical. Se `TRUE`, devolve o `xml_document` bruto.
#' @param verbose Logical. Se `TRUE`, imprime envelope e resposta.
#'
#' @return Um `tibble` (ou `xml_document` se `raw = TRUE`).
#' @export
consultar_publicacao <- function(
    id_publicacao = NULL,
    id_documento = NULL,
    protocolo_documento = NULL,
    config = sei_config(),
    sin_retornar_andamento   = "S",
    sin_retornar_assinaturas = "S",
    raw = FALSE,
    verbose = FALSE) {

  if (is.null(id_publicacao) && is.null(id_documento) && is.null(protocolo_documento)) {
    stop("Informe ao menos um de: id_publicacao, id_documento ou protocolo_documento.",
         call. = FALSE)
  }

  params <- list(
    SiglaSistema           = config$sigla_sistema,
    IdentificacaoServico   = config$identificacao_servico,
    IdUnidade              = config$id_unidade,
    IdPublicacao           = id_publicacao,
    IdDocumento            = id_documento,
    ProtocoloDocumento     = protocolo_documento,
    SinRetornarAndamento   = sin_retornar_andamento,
    SinRetornarAssinaturas = sin_retornar_assinaturas
  )

  doc <- sei_call("consultarPublicacao", params = params, config = config, verbose = verbose)
  if (isTRUE(raw)) return(doc)
  parse_consultar_publicacao_response(doc)
}

#' @title consultar_bloco
#'
#' @description
#' Chama a operação `consultarBloco` do SEI. O bloco deve ser da unidade
#' (`config$id_unidade`) ou estar disponibilizado para ela.
#'
#' @param id_bloco Character. Número do bloco.
#' @param config Um objeto [sei_config()].
#' @param sin_retornar_protocolos "S" ou "N" (padrão "N"; "S" implica
#'   processamento adicional no servidor).
#' @param raw Logical. Se `TRUE`, devolve o `xml_document` bruto.
#' @param verbose Logical. Se `TRUE`, imprime envelope e resposta.
#'
#' @return Um `tibble` (ou `xml_document` se `raw = TRUE`).
#' @export
consultar_bloco <- function(
    id_bloco,
    config = sei_config(),
    sin_retornar_protocolos = "N",
    raw = FALSE,
    verbose = FALSE) {

  params <- list(
    SiglaSistema         = config$sigla_sistema,
    IdentificacaoServico = config$identificacao_servico,
    IdUnidade            = config$id_unidade,
    IdBloco              = id_bloco,
    SinRetornarProtocolos = sin_retornar_protocolos
  )

  doc <- sei_call("consultarBloco", params = params, config = config, verbose = verbose)
  if (isTRUE(raw)) return(doc)
  parse_consultar_bloco_response(doc)
}

#' @title consultar_procedimento_individual
#'
#' @description
#' Chama a operação `consultarProcedimentoIndividual` do SEI, que retorna o
#' processo individual mais recente do tipo informado onde o usuário é
#' interessado (ou `NA` se nenhum for encontrado).
#'
#' @param id_orgao_procedimento,id_tipo_procedimento,id_orgao_usuario,sigla_usuario
#'   Identificadores exigidos pela operação.
#' @param config Um objeto [sei_config()].
#' @param raw Logical. Se `TRUE`, devolve o `xml_document` bruto.
#' @param verbose Logical. Se `TRUE`, imprime envelope e resposta.
#'
#' @return Um `tibble` (ou `xml_document` se `raw = TRUE`).
#' @export
consultar_procedimento_individual <- function(
    id_orgao_procedimento,
    id_tipo_procedimento,
    id_orgao_usuario,
    sigla_usuario,
    config = sei_config(),
    raw = FALSE,
    verbose = FALSE) {

  params <- list(
    SiglaSistema         = config$sigla_sistema,
    IdentificacaoServico = config$identificacao_servico,
    IdUnidade            = config$id_unidade,
    IdOrgaoProcedimento  = id_orgao_procedimento,
    IdTipoProcedimento   = id_tipo_procedimento,
    IdOrgaoUsuario       = id_orgao_usuario,
    SiglaUsuario         = sigla_usuario
  )

  doc <- sei_call("consultarProcedimentoIndividual", params = params,
                  config = config, verbose = verbose)
  if (isTRUE(raw)) return(doc)
  parse_consultar_procedimento_individual_response(doc)
}
