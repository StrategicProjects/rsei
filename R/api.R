# file: R/api.R

#' @title Generic SEI SOAP Call (compatibilidade)
#'
#' @description
#' Envia uma requisição SOAP para um Web Service do SEI. Mantida por
#' compatibilidade; internamente delega para \code{\link{sei_call}}, que monta o
#' envelope no formato correto e trata erros HTTP e \code{SOAP Fault}.
#'
#' @param sei_url Character. URL do Web Service do SEI.
#' @param method Character. Nome da operação SOAP (ex.: "gerarProcedimento").
#' @param params Lista nomeada de parâmetros do corpo da operação.
#' @param verbose Logical. Se \code{TRUE}, imprime envelope e resposta.
#'
#' @return Um \code{xml_document} (de \pkg{xml2}) com a resposta SOAP.
#'
#' @examples
#' \dontrun{
#'   resp_xml <- call_sei_api(
#'     sei_url = "https://sei.pe.gov.br/sei/ws/SeiWS.php",
#'     method  = "listarUnidades",
#'     params  = list(SiglaSistema = "HORTENSIAS", IdentificacaoServico = "chave")
#'   )
#' }
#'
#' @seealso \code{\link{sei_call}}
#' @export
call_sei_api <- function(sei_url, method, params = list(), verbose = FALSE) {
  cfg <- sei_config(sei_url = sei_url)
  sei_call(method, params = params, config = cfg, verbose = verbose)
}


#' @title Generate a New Procedure (gerarProcedimento)
#'
#' @description
#' Wrapper de exemplo para a operação \code{gerarProcedimento} do SEI. Monta a
#' lista de parâmetros e chama \code{\link{sei_call}}. Operação de escrita: use
#' preferencialmente em servidor de homologação/treino.
#'
#' @param sei_url Character. URL do Web Service do SEI.
#' @param sigla_sistema Character. Sigla do sistema registrada no SEI.
#' @param identificacao_servico Character. Chave de acesso / id do serviço.
#' @param id_unidade Character. Id da unidade.
#' @param procedimento Lista nomeada com a estrutura \code{Procedimento}, ex.:
#'   \code{list(IdTipoProcedimento = "100000368", Especificacao = "Teste")}.
#' @param verbose Logical. Se \code{TRUE}, imprime envelope e resposta.
#'
#' @return Um \code{xml_document} com a resposta SOAP (a ser parseada).
#'
#' @examples
#' \dontrun{
#'   resp <- sei_generate_procedure(
#'     sei_url = "https://sei4treina.pe.gov.br/sei/controlador_ws.php?servico=sei",
#'     sigla_sistema = "HORTENSIAS",
#'     identificacao_servico = "chave",
#'     id_unidade = "100000969",
#'     procedimento = list(IdTipoProcedimento = "100000368",
#'                         Especificacao = "Teste")
#'   )
#' }
#'
#' @export
sei_generate_procedure <- function(sei_url,
                                   sigla_sistema,
                                   identificacao_servico,
                                   id_unidade,
                                   procedimento = list(),
                                   verbose = FALSE) {
  cfg <- sei_config(
    sei_url               = sei_url,
    sigla_sistema         = sigla_sistema,
    identificacao_servico = identificacao_servico,
    id_unidade            = id_unidade
  )

  params <- list(
    SiglaSistema         = cfg$sigla_sistema,
    IdentificacaoServico = cfg$identificacao_servico,
    IdUnidade            = cfg$id_unidade,
    Procedimento         = procedimento
  )

  sei_call("gerarProcedimento", params = params, config = cfg, verbose = verbose)
}
