# file: R/soap_helpers.R
#
# Mantidos por compatibilidade. A montagem canônica do envelope agora vive em
# R/core.R (`sei_build_envelope` / `.render_params`), no formato realmente
# aceito pelo SEI (namespace sei="Sei" + encodingStyle + xsi:type).

#' @title Build a SOAP Envelope (compatibilidade)
#'
#' @description
#' Cria um envelope SOAP 1.1 no formato do SEI com \code{method} como elemento
#' raiz dentro de \code{<soapenv:Body>}. \code{body_content} deve ser a string
#' XML já renderizada dos parâmetros (ver \code{\link{build_parameters_xml}}).
#'
#' Para novo código, prefira \code{\link{sei_build_envelope}}, que monta os
#' parâmetros a partir de uma lista R.
#'
#' @param method Character. Nome da operação SOAP (ex.: "gerarProcedimento").
#' @param body_content Character. XML dos parâmetros a inserir na operação.
#'
#' @return Uma string com o envelope SOAP completo.
#'
#' @examples
#' build_soap_envelope("listarUnidades",
#'   build_parameters_xml(list(SiglaSistema = "X")))
#'
#' @seealso \code{\link{sei_build_envelope}}
#' @export
build_soap_envelope <- function(method, body_content) {
  sprintf(
'<?xml version="1.0" encoding="utf-8"?>
<soapenv:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:sei="Sei">
  <soapenv:Header/>
  <soapenv:Body>
    <sei:%1$s soapenv:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">%2$s</sei:%1$s>
  </soapenv:Body>
</soapenv:Envelope>',
    method, body_content)
}

#' @title Build XML for SOAP Parameters (compatibilidade)
#'
#' @description
#' Converte uma lista nomeada em XML dos parâmetros para o corpo SOAP, no formato
#' do SEI (com \code{xsi:type="xsd:string"} em escalares, estruturas aninhadas e
#' arrays \code{<item>}). Delega para o renderizador canônico do pacote.
#'
#' @param params_list Lista nomeada de parâmetros, ex.:
#'   \code{list(SiglaSistema = "X", IdUnidade = "123")}.
#'
#' @return Uma string XML dos parâmetros.
#'
#' @examples
#' build_parameters_xml(list(SiglaSistema = "X", IdUnidade = "123"))
#'
#' @seealso \code{\link{sei_build_envelope}}
#' @export
build_parameters_xml <- function(params_list) {
  .render_params(params_list)
}
