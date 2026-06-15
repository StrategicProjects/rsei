# Build a SOAP Envelope (compatibilidade)

Cria um envelope SOAP 1.1 no formato do SEI com `method` como elemento
raiz dentro de `<soapenv:Body>`. `body_content` deve ser a string XML já
renderizada dos parâmetros (ver
[`build_parameters_xml`](https://strategicprojects.github.io/rsei/reference/build_parameters_xml.md)).

Para novo código, prefira
[`sei_build_envelope`](https://strategicprojects.github.io/rsei/reference/sei_build_envelope.md),
que monta os parâmetros a partir de uma lista R.

## Usage

``` r
build_soap_envelope(method, body_content)
```

## Arguments

- method:

  Character. Nome da operação SOAP (ex.: "gerarProcedimento").

- body_content:

  Character. XML dos parâmetros a inserir na operação.

## Value

Uma string com o envelope SOAP completo.

## See also

[`sei_build_envelope`](https://strategicprojects.github.io/rsei/reference/sei_build_envelope.md)

## Examples

``` r
build_soap_envelope("listarUnidades",
  build_parameters_xml(list(SiglaSistema = "X")))
#> [1] "<?xml version=\"1.0\" encoding=\"utf-8\"?>\n<soapenv:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soapenv=\"http://schemas.xmlsoap.org/soap/envelope/\" xmlns:sei=\"Sei\">\n  <soapenv:Header/>\n  <soapenv:Body>\n    <sei:listarUnidades soapenv:encodingStyle=\"http://schemas.xmlsoap.org/soap/encoding/\"><SiglaSistema xsi:type=\"xsd:string\">X</SiglaSistema></sei:listarUnidades>\n  </soapenv:Body>\n</soapenv:Envelope>"
```
