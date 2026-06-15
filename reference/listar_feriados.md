# listar_feriados

Lista os feriados.

## Usage

``` r
listar_feriados(
  config = sei_config(),
  id_orgao = NULL,
  data_inicial = NULL,
  data_final = NULL,
  raw = FALSE,
  verbose = FALSE
)
```

## Arguments

- config:

  Um objeto
  [`sei_config()`](https://strategicprojects.github.io/rsei/reference/sei_config.md).

- id_orgao, data_inicial, data_final:

  Filtros opcionais.

- raw, verbose:

  Logical.

## Value

Um `tibble` de feriados.
