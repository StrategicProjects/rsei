# listar_unidades

Lista as unidades acessíveis ao serviço (`listarUnidades`).

## Usage

``` r
listar_unidades(
  config = sei_config(),
  id_tipo_procedimento = NULL,
  id_serie = NULL,
  raw = FALSE,
  verbose = FALSE,
  sei_url = NULL,
  sigla_sistema = NULL,
  identificacao_servico = NULL
)
```

## Arguments

- config:

  Um objeto
  [`sei_config()`](https://strategicprojects.github.io/rsei/reference/sei_config.md).

- id_tipo_procedimento, id_serie:

  Filtros opcionais.

- raw:

  Logical. Se `TRUE`, devolve o `xml_document` bruto.

- verbose:

  Logical.

- sei_url, sigla_sistema, identificacao_servico:

  Compatibilidade: sobrescrevem `config`.

## Value

Um `tibble` de unidades (ou `xml_document` se `raw = TRUE`).
