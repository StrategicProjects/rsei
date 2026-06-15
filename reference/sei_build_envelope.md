# Monta o Envelope SOAP do SEI

Constrói o envelope SOAP 1.1 no formato esperado pelos Web Services do
SEI, com os namespaces `xsi`/`xsd`/`soapenv`/`sei` e o atributo
`soapenv:encodingStyle` na operação. Suporta parâmetros escalares,
estruturas aninhadas (listas nomeadas) e arrays (listas não nomeadas,
cada elemento renderizado como `<item>`).

## Usage

``` r
sei_build_envelope(
  operation,
  params = list(),
  ns_prefix = "sei",
  ns_uri = "Sei"
)
```

## Arguments

- operation:

  Character. Nome da operação SOAP (ex.: "consultarProcedimento").

- params:

  Lista nomeada de parâmetros do corpo da operação. Valores `NULL` são
  omitidos; `NA` vira `xsi:nil="true"`.

- ns_prefix:

  Character. Prefixo do namespace da operação (padrão "sei").

- ns_uri:

  Character. URI do namespace da operação (padrão "Sei"; para o SIP use
  "sipns").

## Value

Uma string com o envelope SOAP completo.

## Examples

``` r
cat(sei_build_envelope("listarUnidades",
  list(SiglaSistema = "HORTENSIAS", IdentificacaoServico = "chave")))
#> <?xml version="1.0" encoding="utf-8"?>
#> <soapenv:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:sei="Sei">
#>   <soapenv:Header/>
#>   <soapenv:Body>
#>     <sei:listarUnidades soapenv:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/"><SiglaSistema xsi:type="xsd:string">HORTENSIAS</SiglaSistema><IdentificacaoServico xsi:type="xsd:string">chave</IdentificacaoServico></sei:listarUnidades>
#>   </soapenv:Body>
#> </soapenv:Envelope>
```
