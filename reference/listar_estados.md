# listar_estados

Lista os estados (UF).

## Usage

``` r
listar_estados(
  config = sei_config(),
  id_pais = NULL,
  raw = FALSE,
  verbose = FALSE
)
```

## Arguments

- config:

  Um objeto
  [`sei_config()`](https://strategicprojects.github.io/rsei/reference/sei_config.md).

- id_pais:

  Filtro opcional.

- raw, verbose:

  Logical.

## Value

Um `tibble` de estados.
