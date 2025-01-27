# file: R/soap_helpers.R

#' @title Build a SOAP Envelope
#'
#' @description
#' Creates a basic SOAP envelope (SOAP 1.1) with the given `method` as the root
#' element in the `<soapenv:Body>`. The `body_content` should be a string containing
#' any child XML to be inserted.
#'
#' @param method Character string. The name of the SOAP method (e.g., "gerarProcedimento").
#' @param body_content Character string. The XML content to be placed inside the method tag.
#'
#' @return A character string containing the complete SOAP envelope XML.
#'
#' @examples
#' build_soap_envelope("myMethod", "<param>value</param>")
#'
#' @export
build_soap_envelope <- function(method, body_content) {
  sprintf('
    <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/">
      <soapenv:Header/>
      <soapenv:Body>
        <%1$s xmlns="urn:sei">%2$s</%1$s>
      </soapenv:Body>
    </soapenv:Envelope>',
          method,
          body_content
  )
}

#' @title Build Simple XML for SOAP Parameters
#'
#' @description
#' Converts a named list (key-value pairs) to a simple XML string for inclusion
#' as parameters in the SOAP body.
#'
#' @param params_list A named list of parameters, e.g. \code{list(SiglaSistema = "X", IdUnidade = "123")} .
#'
#' @return A character string of XML that looks like:
#'   \code{<SiglaSistema>X</SiglaSistema><IdUnidade>123</IdUnidade>}.
#'
#' @examples
#' build_parameters_xml(list(SiglaSistema = "X", IdUnidade = "123"))
#'
#' @export
build_parameters_xml <- function(params_list) {
  # If a parameter is NULL, it is represented as an xsi:nil field.
  parts <- lapply(
    names(params_list),
    function(name) {
      val <- params_list[[name]]
      if (is.null(val)) {
        sprintf('<%1$s xsi:nil="true" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" />', name)
      } else {
        sprintf('<%1$s>%2$s</%1$s>', name, val)
      }
    }
  )
  paste0(parts, collapse = "")
}
