# consultar_documento

Chama a operação `consultarDocumento` do SEI. Por padrão devolve o
resultado parseado como `tibble` (use `raw = TRUE` para o
`xml_document`).

## Usage

``` r
consultar_documento(
  protocolo_documento,
  config = sei_config(),
  sin_retornar_andamento_geracao = "S",
  sin_retornar_assinaturas = "S",
  sin_retornar_publicacao = "S",
  sin_retornar_campos = "S",
  raw = FALSE,
  verbose = FALSE
)
```

## Arguments

- protocolo_documento:

  Character. Número do documento visível ao usuário (ex.: "0003934").

- config:

  Um objeto
  [`sei_config()`](https://strategicprojects.github.io/rsei/reference/sei_config.md).

- sin_retornar_andamento_geracao, sin_retornar_assinaturas,
  sin_retornar_publicacao, sin_retornar_campos:

  "S" ou "N", indicando se cada bloco deve ser retornado.

- raw:

  Logical. Se `TRUE`, devolve o `xml_document` bruto.

- verbose:

  Logical. Se `TRUE`, imprime envelope e resposta.

## Value

Um `tibble` (ou `xml_document` se `raw = TRUE`).
