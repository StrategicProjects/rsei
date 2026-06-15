# sobrestar_processo

Sobresta um processo (`sobrestarProcesso`).

## Usage

``` r
sobrestar_processo(
  protocolo_procedimento,
  motivo,
  protocolo_vinculado = NULL,
  config = sei_config(),
  verbose = FALSE
)
```

## Arguments

- protocolo_procedimento:

  Character. Número do processo.

- motivo:

  Character. Motivo do sobrestamento.

- protocolo_vinculado:

  Character opcional. Processo vinculado.

- config:

  Um objeto
  [`sei_config()`](https://strategicprojects.github.io/rsei/reference/sei_config.md).

- verbose:

  Logical.

## Value

`TRUE` em caso de sucesso.
