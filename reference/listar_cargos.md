# listar_cargos

Lista os cargos.

## Usage

``` r
listar_cargos(
  config = sei_config(),
  id_cargo = NULL,
  raw = FALSE,
  verbose = FALSE
)
```

## Arguments

- config:

  Um objeto
  [`sei_config()`](https://strategicprojects.github.io/rsei/reference/sei_config.md).

- id_cargo:

  Filtro opcional.

- raw, verbose:

  Logical.

## Value

Um `tibble` de cargos.
