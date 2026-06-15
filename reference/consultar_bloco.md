# consultar_bloco

Chama a operação `consultarBloco` do SEI. O bloco deve ser da unidade
(`config$id_unidade`) ou estar disponibilizado para ela.

## Usage

``` r
consultar_bloco(
  id_bloco,
  config = sei_config(),
  sin_retornar_protocolos = "N",
  raw = FALSE,
  verbose = FALSE
)
```

## Arguments

- id_bloco:

  Character. Número do bloco.

- config:

  Um objeto
  [`sei_config()`](https://strategicprojects.github.io/rsei/reference/sei_config.md).

- sin_retornar_protocolos:

  "S" ou "N" (padrão "N"; "S" implica processamento adicional no
  servidor).

- raw:

  Logical. Se `TRUE`, devolve o `xml_document` bruto.

- verbose:

  Logical. Se `TRUE`, imprime envelope e resposta.

## Value

Um `tibble` (ou `xml_document` se `raw = TRUE`).
