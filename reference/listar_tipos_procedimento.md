# listar_tipos_procedimento

Lista os tipos de processo liberados ao serviço.

## Usage

``` r
listar_tipos_procedimento(
  config = sei_config(),
  id_unidade = NULL,
  id_serie = NULL,
  raw = FALSE,
  verbose = FALSE
)
```

## Arguments

- config:

  Um objeto
  [`sei_config()`](https://strategicprojects.github.io/rsei/reference/sei_config.md).

- id_unidade, id_serie:

  Filtros opcionais.

- raw, verbose:

  Logical.

## Value

Um `tibble` de tipos de processo.
