# listar_hipoteses_legais

Lista as hipóteses legais.

## Usage

``` r
listar_hipoteses_legais(
  config = sei_config(),
  nivel_acesso = NULL,
  raw = FALSE,
  verbose = FALSE
)
```

## Arguments

- config:

  Um objeto
  [`sei_config()`](https://strategicprojects.github.io/rsei/reference/sei_config.md).

- nivel_acesso:

  Filtro opcional (1 - restrito, 2 - sigiloso).

- raw, verbose:

  Logical.

## Value

Um `tibble` de hipóteses legais.
