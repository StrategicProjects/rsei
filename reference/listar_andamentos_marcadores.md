# listar_andamentos_marcadores

Lista os eventos de marcador de um processo
(`listarAndamentosMarcadores`): cada item traz o texto do marcador, a
data/hora, o usuário responsável e o marcador associado.

## Usage

``` r
listar_andamentos_marcadores(
  protocolo_procedimento,
  config = sei_config(),
  marcadores = NULL,
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

- marcadores:

  Vetor opcional de identificadores de marcador (filtro); se `NULL`,
  retorna todos.

- raw, verbose:

  Logical.

## Value

Um `tibble` com uma linha por evento de marcador.
