#' @title listar_unidades
#'
#' @description
#' Sends a SOAP request to SEI (via \code{listarUnidades}) to retrieve
#' the list of available units (Unidades). This function replicates the
#' cURL command provided, using \code{glue} to build the envelope and
#' \code{httr2} to perform the request.
#'
#' @param sei_url Character. The SEI Web Service endpoint, e.g. "https://sei.pe.gov.br/sei/ws/SeiWS.php".
#' @param sigla_sistema Character. The name/sigla of the system (e.g. "HORTENSIAS").
#' @param identificacao_servico Character. The service key in SEI (e.g. "publicacao").
#'
#' @return An \code{xml2::xml_document} containing the SOAP response.
#'   You can parse the relevant node (usually <parametros>) to get the array of units.
#'
#' @examples
#' \dontrun{
#'   doc <- listar_unidades(
#'     sei_url = "https://sei.pe.gov.br/sei/ws/SeiWS.php",
#'     sigla_sistema = "HORTENSIAS",
#'     identificacao_servico = "publicacao"
#'   )
#'
#'   # Inspect raw XML:
#'   print(doc)
#'
#'   # Then parse the result to extract <Unidade> elements or <parametros>.
#'   # For example:
#'   # nd_params <- xml_find_first(doc, "//*[local-name()='listarUnidadesResponse']/*[local-name()='parametros']")
#'   # unid_nodes <- xml_find_all(nd_params, ".//*[local-name()='Unidade']")
#'   # ... (extract with xml_text() or parse_unidade() function)
#' }
#'
#' @export
listar_unidades <- function(
    sei_url = "https://sei.pe.gov.br/sei/ws/SeiWS.php",
    sigla_sistema = "HORTENSIAS",
    identificacao_servico = "publicacao"
) {

  # 1) Build the SOAP envelope using glue
  envelope <- glue::glue(
    '<?xml version="1.0" encoding="utf-8"?>
    <soapenv:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
                      xmlns:xsd="http://www.w3.org/2001/XMLSchema"
                      xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/"
                      xmlns:sei="Sei">
      <soapenv:Header/>
      <soapenv:Body>
        <sei:listarUnidades soapenv:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
          <SiglaSistema xsi:type="xsd:string">{sigla_sistema}</SiglaSistema>
          <IdentificacaoServico xsi:type="xsd:string">{identificacao_servico}</IdentificacaoServico>
        </sei:listarUnidades>
      </soapenv:Body>
    </soapenv:Envelope>')

  # 2) Make the SOAP request via httr2
  resp <- request(sei_url) |>
    req_headers(
      "Content-Type" = "text/xml; charset=UTF-8",
      "SOAPAction"   = "SeiAction"  # Some servers require a non-empty SOAPAction
    ) |>
    req_body_raw(envelope, type = "text/xml") |>
    req_perform()

  # 3) Parse the response as an xml_document
  doc <- resp_body_xml(resp)

  # 4) Return the raw XML; you can parse <parametros> or <Unidade> elements later
  doc
}
