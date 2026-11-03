# alterar_bloco

Altera a descrição e as unidades de disponibilização de um bloco
existente (`alterarBloco`; operação disponível a partir do SEI 5).

## Usage

``` r
alterar_bloco(
  id_bloco,
  descricao,
  unidades_disponibilizacao = NULL,
  config = sei_config(),
  verbose = FALSE
)
```

## Arguments

- id_bloco:

  Character. Número do bloco.

- descricao:

  Character. Nova descrição do bloco.

- unidades_disponibilizacao:

  Vetor de ids de unidades (ou `NULL`).

- config:

  Um objeto
  [`sei_config()`](https://strategicprojects.github.io/rsei/reference/sei_config.md).

- verbose:

  Logical.

## Value

`TRUE` em caso de sucesso.
