#' @title consultar_procedimento
#'
#' @description
#' Chama a operação \code{consultarProcedimento} do SEI para recuperar os dados
#' de um processo. Internamente usa \code{\link{sei_call}} e, por padrão,
#' devolve o resultado já parseado como \code{tibble}.
#'
#' @param protocolo_procedimento Character. Número do processo visível ao
#'   usuário, ex.: "0000000000.000003/2020-33".
#' @param config Um objeto \code{\link{sei_config}}.
#' @param sin_retornar_assuntos,sin_retornar_interessados,sin_retornar_observacoes,sin_retornar_andamento_geracao,sin_retornar_andamento_conclusao,sin_retornar_ultimo_andamento,sin_retornar_unidades_procedimento_aberto,sin_retornar_procedimentos_relacionados,sin_retornar_procedimentos_anexados
#'   "S" ou "N", indicando se cada bloco de informação deve ser retornado.
#' @param raw Logical. Se \code{TRUE}, devolve o \code{xml_document} bruto em vez
#'   do \code{tibble} parseado.
#' @param sei_url,sigla_sistema,identificacao_servico,id_unidade Compatibilidade:
#'   se informados, sobrescrevem os valores de \code{config}.
#' @param verbose Logical. Se \code{TRUE}, imprime envelope e resposta.
#'
#' @return Um \code{tibble} com os dados do processo (ou um \code{xml_document}
#'   se \code{raw = TRUE}).
#'
#' @examples
#' \dontrun{
#'   consultar_procedimento(
#'     "0000000000.000001/2020-11",
#'     config = sei_config(sigla_sistema = "HORTENSIAS",
#'                         identificacao_servico = "chave")
#'   )
#' }
#'
#' @export
consultar_procedimento <- function(
    protocolo_procedimento,
    config                = sei_config(),
    sin_retornar_assuntos                     = "S",
    sin_retornar_interessados                 = "S",
    sin_retornar_observacoes                  = "S",
    sin_retornar_andamento_geracao            = "S",
    sin_retornar_andamento_conclusao          = "S",
    sin_retornar_ultimo_andamento             = "S",
    sin_retornar_unidades_procedimento_aberto = "S",
    sin_retornar_procedimentos_relacionados   = "S",
    sin_retornar_procedimentos_anexados       = "S",
    raw                   = FALSE,
    sei_url               = NULL,
    sigla_sistema         = NULL,
    identificacao_servico = NULL,
    id_unidade            = NULL,
    verbose               = FALSE) {

  config <- .merge_config(config, sei_url, sigla_sistema, identificacao_servico, id_unidade)

  params <- list(
    SiglaSistema                          = config$sigla_sistema,
    IdentificacaoServico                  = config$identificacao_servico,
    IdUnidade                             = config$id_unidade,
    ProtocoloProcedimento                 = protocolo_procedimento,
    SinRetornarAssuntos                   = sin_retornar_assuntos,
    SinRetornarInteressados               = sin_retornar_interessados,
    SinRetornarObservacoes                = sin_retornar_observacoes,
    SinRetornarAndamentoGeracao           = sin_retornar_andamento_geracao,
    SinRetornarAndamentoConclusao         = sin_retornar_andamento_conclusao,
    SinRetornarUltimoAndamento            = sin_retornar_ultimo_andamento,
    SinRetornarUnidadesProcedimentoAberto = sin_retornar_unidades_procedimento_aberto,
    SinRetornarProcedimentosRelacionados  = sin_retornar_procedimentos_relacionados,
    SinRetornarProcedimentosAnexados      = sin_retornar_procedimentos_anexados
  )

  doc <- sei_call("consultarProcedimento", params = params, config = config,
                  verbose = verbose)

  if (isTRUE(raw)) return(doc)
  parse_consultar_procedimento_response(doc)
}


#' @title consultar_procedimentos
#'
#' @description
#' Consulta vários processos de uma vez e empilha os resultados em um único
#' `tibble`. Cada protocolo é consultado com [consultar_procedimento()] e o
#' resultado recebe uma coluna `protocolo` (o número consultado) e uma coluna
#' `erro` (`NA` em caso de sucesso; a mensagem do erro caso a consulta falhe).
#' Por padrão um protocolo com erro não interrompe o lote.
#'
#' @param protocolos Vetor de números de processo (ex.: `c("12.1.0001-1", ...)`).
#' @param config Um objeto [sei_config()].
#' @param parar_em_erro Logical. Se `TRUE`, interrompe na primeira falha; se
#'   `FALSE` (padrão), registra o erro na coluna `erro` e segue.
#' @param verbose Logical. Repassado a [consultar_procedimento()].
#' @param ... Demais argumentos repassados a [consultar_procedimento()] (ex.:
#'   os sinalizadores `sin_retornar_*`). Não use `raw` aqui.
#'
#' @return Um `tibble` com uma linha por processo (colunas `protocolo` e `erro`
#'   além das de [consultar_procedimento()]). Linhas com erro têm `NA` nas
#'   demais colunas.
#'
#' @examples
#' \dontrun{
#'   protos <- c("0000000000.000001/2020-11", "0000000000.000003/2020-33")
#'   tudo <- consultar_procedimentos(protos, config = sei_config())
#'   tudo[, c("protocolo", "Especificacao", "NivelAcessoGlobal", "erro")]
#' }
#'
#' @export
consultar_procedimentos <- function(protocolos, config = sei_config(),
                                    parar_em_erro = FALSE, verbose = FALSE, ...) {
  protocolos <- as.character(protocolos)
  linhas <- lapply(protocolos, function(p) {
    res <- tryCatch(
      do.call(consultar_procedimento,
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
