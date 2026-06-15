# listar_contatos

Lista contatos (paginado).

## Usage

``` r
listar_contatos(
  config = sei_config(),
  id_tipo_contato = NULL,
  pagina_registros = NULL,
  pagina_atual = NULL,
  sigla = NULL,
  nome = NULL,
  cpf = NULL,
  cnpj = NULL,
  matricula = NULL,
  raw = FALSE,
  verbose = FALSE
)
```

## Arguments

- config:

  Um objeto
  [`sei_config()`](https://strategicprojects.github.io/rsei/reference/sei_config.md).

- id_tipo_contato, sigla, nome, cpf, cnpj, matricula:

  Filtros opcionais.

- pagina_registros, pagina_atual:

  Paginação (1-1000; padrão 1).

- raw, verbose:

  Logical.

## Value

Um `tibble` de contatos.
