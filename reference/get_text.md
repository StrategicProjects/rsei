# get_text: texto de um descendente por local-name

Encontra o primeiro descendente de `parent` com o `local-name` informado
(ignorando namespaces) e devolve seu texto, ou "" se ausente /
`xsi:nil="true"`. Mantido por compatibilidade; para extração ancorada em
filho direto use o helper interno `get_text_child`.

## Usage

``` r
get_text(parent, child_name)
```

## Arguments

- parent:

  Um nó `xml2`.

- child_name:

  Character. O local-name do elemento a extrair.

## Value

Uma string (possivelmente vazia).
