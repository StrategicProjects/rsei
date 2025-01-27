# file: R/api.R

library(httr2)
library(xml2)

#' @title Generic SEI SOAP Call
#'
#' @description
#' Sends an XML SOAP request to the SEI web service. Builds the SOAP
#' envelope with the given method and parameter list, then performs
#' a POST request with `httr2`.
#'
#' @param sei_url Character string. The SEI web service URL, e.g.
#'   \code{"http://server/sei/controlador_ws.php?servico=sei"}.
#' @param method Character string. The SOAP method name (e.g. "gerarProcedimento").
#' @param params A named list of parameters for the method body.
#'   If you need more complex structures, you can build them manually.
#' @param verbose Logical. If \code{TRUE}, prints the final envelope and response.
#'
#' @return An \code{xml_document} (from \pkg{xml2}) representing the SOAP response.
#'
#' @examples
#' \dontrun{
#'   resp_xml <- call_sei_api(
#'     sei_url = "http://server/sei/controlador_ws.php?servico=sei",
#'     method = "gerarProcedimento",
#'     params = list(SiglaSistema="MySys", IdUnidade="100")
#'   )
#' }
#'
#' @export
call_sei_api <- function(sei_url, method, params = list(), verbose = FALSE) {
  # 1) Build the inner XML for the method
  body_xml <- build_parameters_xml(params)

  # 2) Build the full SOAP envelope
  envelope <- build_soap_envelope(method, body_xml)

  # 3) Prepare and perform the request
  resp <- request(sei_url) |>
    req_headers(
      "Content-Type" = "text/xml; charset=utf-8",
      "SOAPAction"   = method  # can vary depending on server config
    ) |>
    req_body_raw(envelope, type = "text/xml") |>
    req_perform()

  # Check for HTTP error
  if (resp$status_code >= 300) {
    stop(
      sprintf("HTTP error %d while calling '%s'. Response:\n%s",
              resp$status_code, method, resp_body_string(resp))
    )
  }

  # Parse the XML response
  response_xml <- resp_body_xml(resp)

  if (verbose) {
    message("SOAP Envelope Sent:\n", envelope)
    message("\nSOAP Response:\n", as.character(response_xml))
  }

  response_xml
}


#' @title Generate a New Procedure (gerarProcedimento)
#'
#' @description
#' Example function that wraps a call to the SEI \code{gerarProcedimento} method.
#' It builds a parameters list and calls \code{\link{call_sei_api}} under the hood.
#'
#' @param sei_url Character string. The SEI web service URL.
#' @param sigla_sistema Character string. The system name as registered in SEI.
#' @param identificacao_servico Character string. The key/access code or service ID in SEI.
#' @param id_unidade Character string. The unit ID for the request.
#' @param procedimento A named list with the structure required by SEI, e.g.:
#'   \code{list(
#'     IdTipoProcedimento = "100000368",
#'     Especificacao      = "Test procedure",
#'     Observacao         = "Sample note"
#'   )}
#' @param verbose Logical. If \code{TRUE}, prints envelope and response.
#'
#' @return An \code{xml_document} object with the SOAP response (to be parsed).
#'
#' @examples
#' \dontrun{
#'   proc <- list(
#'     IdTipoProcedimento = "100000368",
#'     Especificacao = "Test procedure",
#'     Observacao = "Sample note"
#'   )
#'   resp <- sei_generate_procedure(
#'     sei_url = "http://server/sei/controlador_ws.php?servico=sei",
#'     sigla_sistema = "MySystem",
#'     identificacao_servico = "MyAccessKey",
#'     id_unidade = "100000969",
#'     procedimento = proc
#'   )
#' }
#'
sei_generate_procedure <- function(sei_url,
                                   sigla_sistema,
                                   identificacao_servico,
                                   id_unidade,
                                   procedimento = list(),
                                   verbose = FALSE) {
  # Minimal set of params required by SEI (from documentation)
  params <- list(
    SiglaSistema         = sigla_sistema,
    IdentificacaoServico = identificacao_servico,
    IdUnidade            = id_unidade
  )

  # The SEI expects a <Procedimento> tag containing the fields, so
  # we can either embed them directly or create a sub-XML.
  # For simplicity, let's just flatten it for now:
  # e.g., "Procedimento" = <IdTipoProcedimento>...</IdTipoProcedimento>...

  procedure_xml <- build_parameters_xml(procedimento)
  # We wrap that procedure XML inside <Procedimento>...</Procedimento>
  params[["Procedimento"]] <- sprintf("<Procedimento>%s</Procedimento>", procedure_xml)

  # Call the generic SOAP function
  resp_xml <- call_sei_api(
    sei_url = sei_url,
    method  = "gerarProcedimento",
    params  = params,
    verbose = verbose
  )

  resp_xml
}

