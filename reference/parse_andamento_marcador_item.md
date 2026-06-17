# parse_andamento_marcador_item

Parseia um `<item>` de `AndamentoMarcador` no contexto de
`listarAndamentosMarcadores` (texto do marcador, data/hora, usuário e
marcador associado).

## Usage

``` r
parse_andamento_marcador_item(node)
```

## Arguments

- node:

  Nó `xml2` de um `<item>`.

## Value

Um tibble de 1 linha.
