# listar_permissao

Lista permissões no SIP (`listarPermissao`).

## Usage

``` r
listar_permissao(
  config = sip_config(),
  id_orgao_usuario = NULL,
  id_usuario = NULL,
  id_origem_usuario = NULL,
  id_orgao_unidade = NULL,
  id_unidade = NULL,
  id_origem_unidade = NULL,
  id_perfil = NULL,
  raw = FALSE,
  verbose = FALSE
)
```

## Arguments

- config:

  Um objeto
  [`sip_config()`](https://strategicprojects.github.io/rsei/reference/sip_config.md).

- id_orgao_usuario, id_usuario, id_origem_usuario, id_orgao_unidade,
  id_unidade, id_origem_unidade, id_perfil:

  Filtros opcionais.

- raw, verbose:

  Logical.

## Value

Um `tibble` de permissões (ou `xml_document` se `raw = TRUE`).
