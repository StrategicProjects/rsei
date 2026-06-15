# lancar_andamento

Lança um andamento em um processo (`lancarAndamento`). Escrita.

## Usage

``` r
lancar_andamento(
  protocolo_procedimento,
  config = sei_config(),
  id_tarefa = NULL,
  id_tarefa_modulo = NULL,
  atributos = list(),
  raw = FALSE,
  verbose = FALSE
)
```

## Arguments

- protocolo_procedimento:

  Character. Número do processo.

- config:

  Um objeto
  [`sei_config()`](https://strategicprojects.github.io/rsei/reference/sei_config.md).

- id_tarefa, id_tarefa_modulo:

  Identificador da tarefa (informe um). `id_tarefa` deve ser \>= 1000,
  ou 65 (atualização de andamento, com atributo DESCRICAO).

- atributos:

  Lista de atributos (cada um `list(Nome=, Valor=, IdOrigem=)`).

- raw, verbose:

  Logical.

## Value

Um `tibble` do andamento gerado
([parse_andamento_response](https://strategicprojects.github.io/rsei/reference/parse_andamento_response.md)).
