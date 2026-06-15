# gerar_bloco

Gera um bloco (`gerarBloco`). Retorna o número do bloco.

## Usage

``` r
gerar_bloco(
  tipo,
  descricao,
  config = sei_config(),
  unidades_disponibilizacao = NULL,
  documentos = NULL,
  sin_disponibilizar = "N",
  verbose = FALSE
)
```

## Arguments

- tipo:

  Character. "A" (assinatura), "R" (reunião) ou "I" (interno).

- descricao:

  Character. Descrição do bloco.

- config:

  Um objeto
  [`sei_config()`](https://strategicprojects.github.io/rsei/reference/sei_config.md).

- unidades_disponibilizacao:

  Vetor de ids de unidades (ou `NULL`).

- documentos:

  Vetor de protocolos de documentos (ou `NULL`).

- sin_disponibilizar:

  "S"/"N".

- verbose:

  Logical.

## Value

Character com o `IdBloco` gerado.
