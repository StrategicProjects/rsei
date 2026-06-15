# parse_andamento_item

Parseia um `<item>` de `Andamento` no contexto de `listarAndamentos`
(inclui `IdAndamento`/`IdTarefa` e `Atributos`).

## Usage

``` r
parse_andamento_item(node)
```

## Arguments

- node:

  Nó `xml2` de um `<item>`.

## Value

Um tibble de 1 linha; `Atributos` é uma coluna-lista.
