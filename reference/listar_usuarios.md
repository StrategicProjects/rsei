# listar_usuarios

Lista os usuários com perfil "Básico" na unidade.

## Usage

``` r
listar_usuarios(
  config = sei_config(),
  id_usuario = NULL,
  raw = FALSE,
  verbose = FALSE
)
```

## Arguments

- config:

  Um objeto
  [`sei_config()`](https://strategicprojects.github.io/rsei/reference/sei_config.md).

- id_usuario:

  Filtro opcional.

- raw, verbose:

  Logical.

## Value

Um `tibble` de usuários.
