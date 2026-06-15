# listar_andamentos

Lista andamentos de um processo (`listarAndamentos`). É preciso informar
ao menos um filtro: `andamentos`, `tarefas` ou `tarefas_modulos`.

## Usage

``` r
listar_andamentos(
  protocolo_procedimento,
  config = sei_config(),
  sin_retornar_atributos = "N",
  andamentos = NULL,
  tarefas = NULL,
  tarefas_modulos = NULL,
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

- sin_retornar_atributos:

  "S" ou "N".

- andamentos, tarefas, tarefas_modulos:

  Vetores de identificadores (filtro).

- raw, verbose:

  Logical.

## Value

Um `tibble` de andamentos (`Atributos` como coluna-lista).
