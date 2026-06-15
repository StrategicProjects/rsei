# atribuir_processo

Atribui um processo a um usuário na unidade (`atribuirProcesso`).

## Usage

``` r
atribuir_processo(
  protocolo_procedimento,
  id_usuario,
  config = sei_config(),
  sin_reabrir = "N",
  verbose = FALSE
)
```

## Arguments

- protocolo_procedimento:

  Character. Número do processo.

- id_usuario:

  Character. Id do usuário no SIP.

- config:

  Um objeto
  [`sei_config()`](https://strategicprojects.github.io/rsei/reference/sei_config.md).

- sin_reabrir:

  "S"/"N".

- verbose:

  Logical.

## Value

`TRUE` em caso de sucesso.
