# desanexar_processo

Desanexa um processo (`desanexarProcesso`).

## Usage

``` r
desanexar_processo(
  protocolo_principal,
  protocolo_anexado,
  motivo,
  config = sei_config(),
  verbose = FALSE
)
```

## Arguments

- protocolo_principal, protocolo_anexado:

  Números dos processos.

- motivo:

  Character. Motivo da desanexação.

- config:

  Um objeto
  [`sei_config()`](https://strategicprojects.github.io/rsei/reference/sei_config.md).

- verbose:

  Logical.

## Value

`TRUE` em caso de sucesso.
