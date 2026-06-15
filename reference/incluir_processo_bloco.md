# incluir_processo_bloco

Inclui um processo em um bloco (`incluirProcessoBloco`).

## Usage

``` r
incluir_processo_bloco(
  id_bloco,
  protocolo_procedimento,
  anotacao = NULL,
  config = sei_config(),
  verbose = FALSE
)
```

## Arguments

- id_bloco:

  Character. Número do bloco.

- protocolo_procedimento:

  Character. Número do processo.

- anotacao:

  Character opcional.

- config:

  Um objeto
  [`sei_config()`](https://strategicprojects.github.io/rsei/reference/sei_config.md).

- verbose:

  Logical.

## Value

`TRUE` em caso de sucesso.
