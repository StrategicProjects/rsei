# consultar_procedimento_individual

Chama a operação `consultarProcedimentoIndividual` do SEI, que retorna o
processo individual mais recente do tipo informado onde o usuário é
interessado (ou `NA` se nenhum for encontrado).

## Usage

``` r
consultar_procedimento_individual(
  id_orgao_procedimento,
  id_tipo_procedimento,
  id_orgao_usuario,
  sigla_usuario,
  config = sei_config(),
  raw = FALSE,
  verbose = FALSE
)
```

## Arguments

- id_orgao_procedimento, id_tipo_procedimento, id_orgao_usuario,
  sigla_usuario:

  Identificadores exigidos pela operação.

- config:

  Um objeto
  [`sei_config()`](https://strategicprojects.github.io/rsei/reference/sei_config.md).

- raw:

  Logical. Se `TRUE`, devolve o `xml_document` bruto.

- verbose:

  Logical. Se `TRUE`, imprime envelope e resposta.

## Value

Um `tibble` (ou `xml_document` se `raw = TRUE`).
