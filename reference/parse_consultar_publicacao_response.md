# parse_consultar_publicacao_response

Parseia a resposta de `consultarPublicacao`
(`RetornoConsultaPublicacao`).

## Usage

``` r
parse_consultar_publicacao_response(doc)
```

## Arguments

- doc:

  Um `xml2::xml_document`.

## Value

Um tibble de 1 linha. `Publicacao` e `Andamento` viram colunas com
prefixo; `Assinaturas` fica como coluna-lista.
