# excluir_processo

Exclui um processo (`excluirProcesso`). Irreversível.

## Usage

``` r
excluir_processo(
  protocolo_procedimento,
  config = sei_config(),
  verbose = FALSE
)
```

## Arguments

- protocolo_procedimento:

  Character. Número do processo.

- config:

  Um objeto
  [`sei_config()`](https://strategicprojects.github.io/rsei/reference/sei_config.md).

- verbose:

  Logical.

## Value

`TRUE` em caso de sucesso.
