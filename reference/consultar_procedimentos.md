# consultar_procedimentos

Consulta vários processos de uma vez e empilha os resultados em um único
`tibble`. Cada protocolo é consultado com
[`consultar_procedimento()`](https://strategicprojects.github.io/rsei/reference/consultar_procedimento.md)
e o resultado recebe uma coluna `protocolo` (o número consultado) e uma
coluna `erro` (`NA` em caso de sucesso; a mensagem do erro caso a
consulta falhe). Por padrão um protocolo com erro não interrompe o lote.

## Usage

``` r
consultar_procedimentos(
  protocolos,
  config = sei_config(),
  parar_em_erro = FALSE,
  verbose = FALSE,
  ...
)
```

## Arguments

- protocolos:

  Vetor de números de processo (ex.: `c("12.1.0001-1", ...)`).

- config:

  Um objeto
  [`sei_config()`](https://strategicprojects.github.io/rsei/reference/sei_config.md).

- parar_em_erro:

  Logical. Se `TRUE`, interrompe na primeira falha; se `FALSE` (padrão),
  registra o erro na coluna `erro` e segue.

- verbose:

  Logical. Repassado a
  [`consultar_procedimento()`](https://strategicprojects.github.io/rsei/reference/consultar_procedimento.md).

- ...:

  Demais argumentos repassados a
  [`consultar_procedimento()`](https://strategicprojects.github.io/rsei/reference/consultar_procedimento.md)
  (ex.: os sinalizadores `sin_retornar_*`). Não use `raw` aqui.

## Value

Um `tibble` com uma linha por processo (colunas `protocolo` e `erro`
além das de
[`consultar_procedimento()`](https://strategicprojects.github.io/rsei/reference/consultar_procedimento.md)).
Linhas com erro têm `NA` nas demais colunas.

## Examples

``` r
if (FALSE) { # \dontrun{
  protos <- c("0000000000.000001/2020-11", "0000000000.000003/2020-33")
  tudo <- consultar_procedimentos(protos, config = sei_config())
  tudo[, c("protocolo", "Especificacao", "NivelAcessoGlobal", "erro")]
} # }
```
