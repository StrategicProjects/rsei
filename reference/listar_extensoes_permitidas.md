# listar_extensoes_permitidas

Lista as extensões de arquivo permitidas.

## Usage

``` r
listar_extensoes_permitidas(
  config = sei_config(),
  id_arquivo_extensao = NULL,
  raw = FALSE,
  verbose = FALSE
)
```

## Arguments

- config:

  Um objeto
  [`sei_config()`](https://strategicprojects.github.io/rsei/reference/sei_config.md).

- id_arquivo_extensao:

  Filtro opcional.

- raw, verbose:

  Logical.

## Value

Um `tibble` de extensões.
