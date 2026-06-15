# incluir_documento

Inclui um documento em um processo (`incluirDocumento`). Escrita.

## Usage

``` r
incluir_documento(
  documento,
  config = sei_config(),
  raw = FALSE,
  verbose = FALSE
)
```

## Arguments

- documento:

  Lista nomeada / objeto
  [`Documento()`](https://strategicprojects.github.io/rsei/reference/Documento.md).

- config:

  Um objeto
  [`sei_config()`](https://strategicprojects.github.io/rsei/reference/sei_config.md).

- raw, verbose:

  Logical.

## Value

Um `tibble`
([parse_retorno_inclusao_documento](https://strategicprojects.github.io/rsei/reference/parse_retorno_inclusao_documento.md))
ou `xml_document`.
