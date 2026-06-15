# Andamento

Represents the "Andamento" structure in SEI, which tracks process
events.

## Usage

``` r
Andamento(
  IdAndamento = NULL,
  IdTarefa = NULL,
  IdTarefaModulo = NULL,
  Descricao = NULL,
  DataHora = NULL,
  Unidade = NULL,
  Usuario = NULL,
  Atributos = list()
)
```

## Arguments

- IdAndamento:

  Character. Internal identifier of the andamento.

- IdTarefa:

  Character. Identifier of the associated task.

- IdTarefaModulo:

  Character. Identifier of the module task.

- Descricao:

  Character. Text describing the andamento.

- DataHora:

  Character. Date/time when the andamento was generated.

- Unidade:

  A
  [`Unidade`](https://strategicprojects.github.io/rsei/reference/Unidade.md)
  object describing the unit that created the andamento.

- Usuario:

  A
  [`Usuario`](https://strategicprojects.github.io/rsei/reference/Usuario.md)
  object describing the user who created the andamento.

- Atributos:

  A list of
  [`AtributoAndamento`](https://strategicprojects.github.io/rsei/reference/AtributoAndamento.md)
  objects (can be empty).

## Value

An S3 object of class "Andamento".
