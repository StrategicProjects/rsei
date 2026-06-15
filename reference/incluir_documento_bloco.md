# incluir_documento_bloco

Inclui um documento em um bloco (`incluirDocumentoBloco`).

## Usage

``` r
incluir_documento_bloco(
  id_bloco,
  protocolo_documento,
  anotacao = NULL,
  config = sei_config(),
  verbose = FALSE
)
```

## Arguments

- id_bloco:

  Character. Número do bloco.

- protocolo_documento:

  Character. Número do documento.

- anotacao:

  Character opcional.

- config:

  Um objeto
  [`sei_config()`](https://strategicprojects.github.io/rsei/reference/sei_config.md).

- verbose:

  Logical.

## Value

`TRUE` em caso de sucesso.
