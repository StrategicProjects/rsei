# listar_publicacoes_processo

Lista as publicações de um processo. Como o Web Service do SEI não expõe
isso diretamente, a função descobre os documentos do processo com
[`listar_documentos_processo()`](https://strategicprojects.github.io/rsei/reference/listar_documentos_processo.md)
e consulta a publicação de cada um
([`consultar_publicacoes()`](https://strategicprojects.github.io/rsei/reference/consultar_publicacoes.md)),
mantendo apenas os documentos que de fato possuem publicação.

## Usage

``` r
listar_publicacoes_processo(
  protocolo_procedimento,
  config = sei_config(),
  verbose = FALSE
)
```

## Arguments

- protocolo_procedimento:

  Character. Número do processo.

- config:

  Um objeto
  [`sei_config()`](https://strategicprojects.github.io/rsei/reference/sei_config.md).

- verbose:

  Logical.

## Value

Um `tibble` com uma linha por publicação (coluna `id` = número do
documento, mais as colunas de
[`consultar_publicacao()`](https://strategicprojects.github.io/rsei/reference/consultar_publicacao.md)).
Vazio se o processo não tiver publicações.

## Examples

``` r
if (FALSE) { # \dontrun{
  listar_publicacoes_processo("12.1.000000077-4", config = sei_config())
} # }
```
