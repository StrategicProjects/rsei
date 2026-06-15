# listar_andamentos_completo

Conveniência sobre
[`listar_andamentos()`](https://strategicprojects.github.io/rsei/reference/listar_andamentos.md)
que recupera a **linha do tempo completa** de um processo e a ordena
cronologicamente. Como a operação `listarAndamentos` do SEI exige um
filtro de tarefas, esta função usa por padrão um intervalo amplo de
identificadores de tarefa (que cobre as tarefas internas do SEI:
geração, documentos, assinaturas, envio, recebimento, conclusão, blocos,
etc.).

## Usage

``` r
listar_andamentos_completo(
  protocolo_procedimento,
  config = sei_config(),
  tarefas = 1:200,
  sin_retornar_atributos = "N",
  ordenar = TRUE,
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

- tarefas:

  Vetor de identificadores de tarefa a recuperar (padrão `1:200`, que
  abrange as tarefas internas do SEI).

- sin_retornar_atributos:

  "S" ou "N".

- ordenar:

  Logical. Se `TRUE` (padrão), ordena por `DataHora` (mais antigo
  primeiro).

- raw, verbose:

  Logical.

## Value

Um `tibble` de andamentos ordenado por data/hora (ver
[parse_andamento_item](https://strategicprojects.github.io/rsei/reference/parse_andamento_item.md)).

## Examples

``` r
if (FALSE) { # \dontrun{
  linha <- listar_andamentos_completo("12.1.000000077-4", config = sei_config())
  linha[, c("DataHora", "Descricao", "SiglaUnidade", "NomeUsuario")]
} # }
```
