# Generic SEI SOAP Call (compatibilidade)

Envia uma requisição SOAP para um Web Service do SEI. Mantida por
compatibilidade; internamente delega para
[`sei_call`](https://strategicprojects.github.io/rsei/reference/sei_call.md),
que monta o envelope no formato correto e trata erros HTTP e
`SOAP Fault`.

## Usage

``` r
call_sei_api(sei_url, method, params = list(), verbose = FALSE)
```

## Arguments

- sei_url:

  Character. URL do Web Service do SEI.

- method:

  Character. Nome da operação SOAP (ex.: "gerarProcedimento").

- params:

  Lista nomeada de parâmetros do corpo da operação.

- verbose:

  Logical. Se `TRUE`, imprime envelope e resposta.

## Value

Um `xml_document` (de xml2) com a resposta SOAP.

## See also

[`sei_call`](https://strategicprojects.github.io/rsei/reference/sei_call.md)

## Examples

``` r
if (FALSE) { # \dontrun{
  resp_xml <- call_sei_api(
    sei_url = "https://sei.pe.gov.br/sei/ws/SeiWS.php",
    method  = "listarUnidades",
    params  = list(SiglaSistema = "HORTENSIAS", IdentificacaoServico = "chave")
  )
} # }
```
