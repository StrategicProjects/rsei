# consultar_documentos

Consulta vários documentos de uma vez e empilha os resultados em um
único `tibble`. Cada documento é consultado com
[`consultar_documento()`](https://strategicprojects.github.io/rsei/reference/consultar_documento.md)
e o resultado recebe uma coluna `protocolo` (o número consultado) e uma
coluna `erro` (`NA` em sucesso; a mensagem caso a consulta falhe). Por
padrão um documento com erro não interrompe o lote.

## Usage

``` r
consultar_documentos(
  protocolos,
  config = sei_config(),
  parar_em_erro = FALSE,
  verbose = FALSE,
  ...
)
```

## Arguments

- protocolos:

  Vetor de números de documento.

- config:

  Um objeto
  [`sei_config()`](https://strategicprojects.github.io/rsei/reference/sei_config.md).

- parar_em_erro:

  Logical. Se `TRUE`, interrompe na primeira falha; se `FALSE` (padrão),
  registra o erro na coluna `erro` e segue.

- verbose:

  Logical. Repassado a
  [`consultar_documento()`](https://strategicprojects.github.io/rsei/reference/consultar_documento.md).

- ...:

  Demais argumentos repassados a
  [`consultar_documento()`](https://strategicprojects.github.io/rsei/reference/consultar_documento.md)
  (ex.: os sinalizadores `sin_retornar_*`). Não use `raw` aqui.

## Value

Um `tibble` com uma linha por documento (colunas `protocolo` e `erro`
além das de
[`consultar_documento()`](https://strategicprojects.github.io/rsei/reference/consultar_documento.md)).

## Examples

``` r
if (FALSE) { # \dontrun{
  consultar_documentos(c("58769333", "0003934"), config = sei_config())
} # }
```
