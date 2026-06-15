# listar_series

Lista os tipos de documento (séries) liberados ao serviço.

## Usage

``` r
listar_series(
  config = sei_config(),
  id_unidade = NULL,
  id_tipo_procedimento = NULL,
  raw = FALSE,
  verbose = FALSE
)
```

## Arguments

- config:

  Um objeto
  [`sei_config()`](https://strategicprojects.github.io/rsei/reference/sei_config.md).

- id_unidade, id_tipo_procedimento:

  Filtros opcionais.

- raw, verbose:

  Logical.

## Value

Um `tibble` de séries.
