# parse_assunto

Parseia um `<item>` de `<Assuntos>`.

## Usage

``` r
parse_assunto(node_ass)
```

## Arguments

- node_ass:

  Um nó `xml2` de `<item>`.

## Value

Um tibble de 1 linha com `CodigoEstruturado` e `Descricao`.
