# cancelar_documento

Cancela um documento (`cancelarDocumento`).

## Usage

``` r
cancelar_documento(
  protocolo_documento,
  motivo,
  config = sei_config(),
  verbose = FALSE
)
```

## Arguments

- protocolo_documento:

  Character. Número do documento.

- motivo:

  Character. Motivo do cancelamento.

- config:

  Um objeto
  [`sei_config()`](https://strategicprojects.github.io/rsei/reference/sei_config.md).

- verbose:

  Logical.

## Value

`TRUE` em caso de sucesso.
