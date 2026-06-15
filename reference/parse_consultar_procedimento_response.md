# parse_consultar_procedimento_response

Parser principal de `consultarProcedimento`: localiza o nó
`<parametros>`, extrai os campos escalares, recodifica
`NivelAcessoLocal`/`NivelAcessoGlobal` e parseia as subestruturas
(`TipoProcedimento`, andamentos, e os arrays `Assuntos`, `Interessados`,
etc.).

## Usage

``` r
parse_consultar_procedimento_response(doc)
```

## Arguments

- doc:

  Um `xml2::xml_document` com a resposta de "consultarProcedimento".

## Value

Um tibble de 1 linha. Campos escalares e subestruturas 1:1
(TipoProcedimento e andamentos) viram colunas com prefixo; arrays
(`Assuntos`, `Interessados`, `Observacoes`,
`UnidadesProcedimentoAberto`, `ProcedimentosRelacionados`,
`ProcedimentosAnexados`) ficam como colunas-lista de tibbles.

## Examples

``` r
if (FALSE) { # \dontrun{
  doc <- consultar_procedimento("0000000000.000001/2020-11", raw = TRUE)
  parse_consultar_procedimento_response(doc)
} # }
```
