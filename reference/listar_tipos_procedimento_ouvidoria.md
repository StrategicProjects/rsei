# listar_tipos_procedimento_ouvidoria

Lista os tipos de processo sinalizados como de Ouvidoria.

## Usage

``` r
listar_tipos_procedimento_ouvidoria(
  config = sei_config(),
  raw = FALSE,
  verbose = FALSE
)
```

## Arguments

- config:

  Um objeto
  [`sei_config()`](https://strategicprojects.github.io/rsei/reference/sei_config.md).

- raw, verbose:

  Logical.

## Value

Um `tibble` de tipos de processo.
