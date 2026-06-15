# Generate a New Procedure (gerarProcedimento)

Wrapper de exemplo para a operação `gerarProcedimento` do SEI. Monta a
lista de parâmetros e chama
[`sei_call`](https://strategicprojects.github.io/rsei/reference/sei_call.md).
Operação de escrita: use preferencialmente em servidor de
homologação/treino.

## Usage

``` r
sei_generate_procedure(
  sei_url,
  sigla_sistema,
  identificacao_servico,
  id_unidade,
  procedimento = list(),
  verbose = FALSE
)
```

## Arguments

- sei_url:

  Character. URL do Web Service do SEI.

- sigla_sistema:

  Character. Sigla do sistema registrada no SEI.

- identificacao_servico:

  Character. Chave de acesso / id do serviço.

- id_unidade:

  Character. Id da unidade.

- procedimento:

  Lista nomeada com a estrutura `Procedimento`, ex.:
  `list(IdTipoProcedimento = "100000368", Especificacao = "Teste")`.

- verbose:

  Logical. Se `TRUE`, imprime envelope e resposta.

## Value

Um `xml_document` com a resposta SOAP (a ser parseada).

## Examples

``` r
if (FALSE) { # \dontrun{
  resp <- sei_generate_procedure(
    sei_url = "https://sei.exemplo.gov.br/sei/controlador_ws.php?servico=sei",
    sigla_sistema = "HORTENSIAS",
    identificacao_servico = "chave",
    id_unidade = "100000969",
    procedimento = list(IdTipoProcedimento = "100000368",
                        Especificacao = "Teste")
  )
} # }
```
