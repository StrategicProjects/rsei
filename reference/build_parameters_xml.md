# Build XML for SOAP Parameters (compatibilidade)

Converte uma lista nomeada em XML dos parâmetros para o corpo SOAP, no
formato do SEI (com `xsi:type="xsd:string"` em escalares, estruturas
aninhadas e arrays `<item>`). Delega para o renderizador canônico do
pacote.

## Usage

``` r
build_parameters_xml(params_list)
```

## Arguments

- params_list:

  Lista nomeada de parâmetros, ex.:
  `list(SiglaSistema = "X", IdUnidade = "123")`.

## Value

Uma string XML dos parâmetros.

## See also

[`sei_build_envelope`](https://strategicprojects.github.io/rsei/reference/sei_build_envelope.md)

## Examples

``` r
build_parameters_xml(list(SiglaSistema = "X", IdUnidade = "123"))
#> [1] "<SiglaSistema xsi:type=\"xsd:string\">X</SiglaSistema><IdUnidade xsi:type=\"xsd:string\">123</IdUnidade>"
```
