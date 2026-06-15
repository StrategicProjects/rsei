# consultar_procedimento

Chama a operação `consultarProcedimento` do SEI para recuperar os dados
de um processo. Internamente usa
[`sei_call`](https://strategicprojects.github.io/rsei/reference/sei_call.md)
e, por padrão, devolve o resultado já parseado como `tibble`.

## Usage

``` r
consultar_procedimento(
  protocolo_procedimento,
  config = sei_config(),
  sin_retornar_assuntos = "S",
  sin_retornar_interessados = "S",
  sin_retornar_observacoes = "S",
  sin_retornar_andamento_geracao = "S",
  sin_retornar_andamento_conclusao = "S",
  sin_retornar_ultimo_andamento = "S",
  sin_retornar_unidades_procedimento_aberto = "S",
  sin_retornar_procedimentos_relacionados = "S",
  sin_retornar_procedimentos_anexados = "S",
  raw = FALSE,
  sei_url = NULL,
  sigla_sistema = NULL,
  identificacao_servico = NULL,
  id_unidade = NULL,
  verbose = FALSE
)
```

## Arguments

- protocolo_procedimento:

  Character. Número do processo visível ao usuário, ex.:
  "0030600043.002462/2024-05".

- config:

  Um objeto
  [`sei_config`](https://strategicprojects.github.io/rsei/reference/sei_config.md).

- sin_retornar_assuntos, sin_retornar_interessados,
  sin_retornar_observacoes, sin_retornar_andamento_geracao,
  sin_retornar_andamento_conclusao, sin_retornar_ultimo_andamento,
  sin_retornar_unidades_procedimento_aberto,
  sin_retornar_procedimentos_relacionados,
  sin_retornar_procedimentos_anexados:

  "S" ou "N", indicando se cada bloco de informação deve ser retornado.

- raw:

  Logical. Se `TRUE`, devolve o `xml_document` bruto em vez do `tibble`
  parseado.

- sei_url, sigla_sistema, identificacao_servico, id_unidade:

  Compatibilidade: se informados, sobrescrevem os valores de `config`.

- verbose:

  Logical. Se `TRUE`, imprime envelope e resposta.

## Value

Um `tibble` com os dados do processo (ou um `xml_document` se
`raw = TRUE`).

## Examples

``` r
if (FALSE) { # \dontrun{
  consultar_procedimento(
    "0011108545.000056/2022-49",
    config = sei_config(sigla_sistema = "HORTENSIAS",
                        identificacao_servico = "chave")
  )
} # }
```
