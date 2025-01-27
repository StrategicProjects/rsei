#' @title consultar_procedimento
#'
#' @description
#' Sends a SOAP request to SEI (via \code{consultarProcedimento}) to retrieve
#' process data. Uses \code{glue::glue} to build the envelope, then performs
#' the request with \code{httr2}.
#'
#' @param sei_url Character. The SEI Web Service endpoint, typically something like
#'   "https://sei.pe.gov.br/sei/ws/SeiWS.php".
#' @param sigla_sistema Character. The system sigla, e.g. "HORTENSIAS".
#' @param identificacao_servico Character. The key/service ID in SEI, e.g. "publicacao".
#' @param id_unidade Character. The SEI unit ID. If not needed, pass an empty string.
#' @param protocolo_procedimento Character. The visible process number, e.g. "0030600043.002462/2024-05".
#' @param sin_retornar_assuntos,sin_retornar_interessados,sin_retornar_observacoes,
#'   sin_retornar_andamento_geracao,sin_retornar_andamento_conclusao,sin_retornar_ultimo_andamento,
#'   sin_retornar_unidades_procedimento_aberto,sin_retornar_procedimentos_relacionados,
#'   sin_retornar_procedimentos_anexados
#'   "S" or "N" to indicate whether you want those fields returned in the response.
#'
#' @return An xml2::xml_document (SOAP response) which you can parse further.
#'
#' @examples
#' \dontrun{
#'   doc <- consultar_procedimento(
#'     sei_url = "https://sei.pe.gov.br/sei/ws/SeiWS.php",
#'     sigla_sistema = "HORTENSIAS",
#'     identificacao_servico = "publicacao",
#'     id_unidade = "",
#'     protocolo_procedimento = "0030600043.002462/2024-05",
#'     sin_retornar_assuntos = "S",
#'     sin_retornar_interessados = "S",
#'     sin_retornar_observacoes = "S",
#'     sin_retornar_andamento_geracao = "S",
#'     sin_retornar_andamento_conclusao = "S",
#'     sin_retornar_ultimo_andamento = "S",
#'     sin_retornar_unidades_procedimento_aberto = "S",
#'     sin_retornar_procedimentos_relacionados = "S",
#'     sin_retornar_procedimentos_anexados = "S"
#'   )
#'   print(doc)
#'   # Then parse doc using your parser functions.
#' }
#'
#' @export
consultar_procedimento <- function(
    sei_url = "https://sei.pe.gov.br/sei/ws/SeiWS.php",
    sigla_sistema = "HORTENSIAS",
    identificacao_servico = "publicacao",
    id_unidade = "",
    protocolo_procedimento,
    sin_retornar_assuntos                   = "S",
    sin_retornar_interessados               = "S",
    sin_retornar_observacoes                = "S",
    sin_retornar_andamento_geracao          = "S",
    sin_retornar_andamento_conclusao        = "S",
    sin_retornar_ultimo_andamento           = "S",
    sin_retornar_unidades_procedimento_aberto = "S",
    sin_retornar_procedimentos_relacionados   = "S",
    sin_retornar_procedimentos_anexados       = "S"
) {

  # 1) Construct the SOAP envelope using `glue`
  envelope <- glue::glue('
  <?xml version="1.0" encoding="utf-8"?>
    <soapenv:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
                      xmlns:xsd="http://www.w3.org/2001/XMLSchema"
                      xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/"
                      xmlns:sei="Sei">
       <soapenv:Header/>
       <soapenv:Body>
          <sei:consultarProcedimento soapenv:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
             <SiglaSistema xsi:type="xsd:string">{sigla_sistema}</SiglaSistema>
             <IdentificacaoServico xsi:type="xsd:string">{identificacao_servico}</IdentificacaoServico>
             <IdUnidade xsi:type="xsd:string">{id_unidade}</IdUnidade>
             <ProtocoloProcedimento xsi:type="xsd:string">{protocolo_procedimento}</ProtocoloProcedimento>
             <SinRetornarAssuntos xsi:type="xsd:string">{sin_retornar_assuntos}</SinRetornarAssuntos>
             <SinRetornarInteressados xsi:type="xsd:string">{sin_retornar_interessados}</SinRetornarInteressados>
             <SinRetornarObservacoes xsi:type="xsd:string">{sin_retornar_observacoes}</SinRetornarObservacoes>
             <SinRetornarAndamentoGeracao xsi:type="xsd:string">{sin_retornar_andamento_geracao}</SinRetornarAndamentoGeracao>
             <SinRetornarAndamentoConclusao xsi:type="xsd:string">{sin_retornar_andamento_conclusao}</SinRetornarAndamentoConclusao>
             <SinRetornarUltimoAndamento xsi:type="xsd:string">{sin_retornar_ultimo_andamento}</SinRetornarUltimoAndamento>
             <SinRetornarUnidadesProcedimentoAberto xsi:type="xsd:string">{sin_retornar_unidades_procedimento_aberto}</SinRetornarUnidadesProcedimentoAberto>
             <SinRetornarProcedimentosRelacionados xsi:type="xsd:string">{sin_retornar_procedimentos_relacionados}</SinRetornarProcedimentosRelacionados>
             <SinRetornarProcedimentosAnexados xsi:type="xsd:string">{sin_retornar_procedimentos_anexados}</SinRetornarProcedimentosAnexados>
          </sei:consultarProcedimento>
       </soapenv:Body>
    </soapenv:Envelope>
  ')

  # 2) Perform the SOAP request
  resp <- request(sei_url) |>
    req_headers(
      "Content-Type" = "text/xml; charset=UTF-8",
      "SOAPAction"   = "SeiAction"  # Some SEI servers require a non-empty SOAPAction
    ) |>
    req_body_raw(envelope) |>
    req_perform()

  # 3) Parse the response as XML
  doc <- resp_body_xml(resp)

  # 4) Return the xml_document
  parse_consultar_procedimento_response(doc)
}
