# parse_consultar_documento_response

Parseia a resposta de `consultarDocumento` (`RetornoConsultaDocumento`).

## Usage

``` r
parse_consultar_documento_response(doc)
```

## Arguments

- doc:

  Um `xml2::xml_document`.

## Value

Um tibble de 1 linha. `Serie`, `UnidadeElaboradora` e `AndamentoGeracao`
viram colunas com prefixo; `Publicacao`, `Assinaturas` e `Campos` ficam
como colunas-lista.
