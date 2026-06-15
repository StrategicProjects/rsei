# consultar_publicacao

Chama a operação `consultarPublicacao` do SEI. Informe ao menos um
filtro: `id_publicacao`, `id_documento` ou `protocolo_documento`.

## Usage

``` r
consultar_publicacao(
  id_publicacao = NULL,
  id_documento = NULL,
  protocolo_documento = NULL,
  config = sei_config(),
  sin_retornar_andamento = "S",
  sin_retornar_assinaturas = "S",
  raw = FALSE,
  verbose = FALSE
)
```

## Arguments

- id_publicacao, id_documento, protocolo_documento:

  Filtros (informe um).

- config:

  Um objeto
  [`sei_config()`](https://strategicprojects.github.io/rsei/reference/sei_config.md).

- sin_retornar_andamento, sin_retornar_assinaturas:

  "S" ou "N".

- raw:

  Logical. Se `TRUE`, devolve o `xml_document` bruto.

- verbose:

  Logical. Se `TRUE`, imprime envelope e resposta.

## Value

Um `tibble` (ou `xml_document` se `raw = TRUE`).
