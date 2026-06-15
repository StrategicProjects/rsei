# parse_andamento_response

Parseia o retorno de `lancarAndamento` (um `Andamento`).

## Usage

``` r
parse_andamento_response(doc)
```

## Arguments

- doc:

  Um `xml2::xml_document`.

## Value

Um tibble de 1 linha (ver
[parse_andamento_item](https://strategicprojects.github.io/rsei/reference/parse_andamento_item.md)).
