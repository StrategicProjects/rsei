# listar_cidades

Lista as cidades.

## Usage

``` r
listar_cidades(
  config = sei_config(),
  id_pais = NULL,
  id_estado = NULL,
  raw = FALSE,
  verbose = FALSE
)
```

## Arguments

- config:

  Um objeto
  [`sei_config()`](https://strategicprojects.github.io/rsei/reference/sei_config.md).

- id_pais, id_estado:

  Filtros opcionais.

- raw, verbose:

  Logical.

## Value

Um `tibble` de cidades.
