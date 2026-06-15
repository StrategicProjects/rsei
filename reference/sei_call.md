# Chamada Genérica a um Web Service do SEI

Monta o envelope SOAP para `operation` com `params`, envia via `httr2` e
devolve a resposta como `xml_document`. Trata erros HTTP e `SOAP Fault`
(o SEI retorna falhas em HTTP 500 com `faultstring`).

## Usage

``` r
sei_call(
  operation,
  params = list(),
  config = sei_config(),
  soap_action = "SeiAction",
  ns_prefix = "sei",
  ns_uri = "Sei",
  timeout = 60,
  verbose = FALSE
)
```

## Arguments

- operation:

  Character. Nome da operação SOAP.

- params:

  Lista nomeada de parâmetros (ver
  [`sei_build_envelope`](https://strategicprojects.github.io/rsei/reference/sei_build_envelope.md)).

- config:

  Um objeto
  [`sei_config`](https://strategicprojects.github.io/rsei/reference/sei_config.md).

- soap_action:

  Character. Valor do cabeçalho `SOAPAction`.

- ns_prefix, ns_uri:

  Namespace da operação (ver
  [`sei_build_envelope`](https://strategicprojects.github.io/rsei/reference/sei_build_envelope.md)).

- timeout:

  Numérico. Tempo máximo da requisição em segundos (padrão 60). Se
  esgotado (ou em falha de conexão), a função para com mensagem clara.

- verbose:

  Logical. Se `TRUE`, imprime o envelope enviado e a resposta.

## Value

Um `xml2::xml_document` com a resposta SOAP.

## Examples

``` r
if (FALSE) { # \dontrun{
  doc <- sei_call("listarUnidades",
    params = list(SiglaSistema = "HORTENSIAS",
                  IdentificacaoServico = "chave"),
    config = sei_config())
} # }
```
