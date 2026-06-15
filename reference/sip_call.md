# Chamada genérica a um Web Service do SIP

Envia uma operação SIP usando o namespace "sipns" e a SOAPAction
"sipnsAction". Delega para
[`sei_call()`](https://strategicprojects.github.io/rsei/reference/sei_call.md).

## Usage

``` r
sip_call(operation, params = list(), config = sip_config(), verbose = FALSE)
```

## Arguments

- operation:

  Character. Nome da operação SIP.

- params:

  Lista nomeada de parâmetros (ver
  [`sei_build_envelope()`](https://strategicprojects.github.io/rsei/reference/sei_build_envelope.md)).

- config:

  Um objeto
  [`sip_config()`](https://strategicprojects.github.io/rsei/reference/sip_config.md).

- verbose:

  Logical.

## Value

Um `xml2::xml_document`.
