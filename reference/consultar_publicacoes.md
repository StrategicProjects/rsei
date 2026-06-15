# consultar_publicacoes

Consulta várias publicações de uma vez e empilha os resultados em um
único `tibble`. Cada item é consultado com
[`consultar_publicacao()`](https://strategicprojects.github.io/rsei/reference/consultar_publicacao.md)
usando o tipo de identificador indicado em `por`. O resultado recebe uma
coluna `id` (o valor consultado) e uma coluna `erro` (`NA` em sucesso).
Um item com erro não interrompe o lote (salvo `parar_em_erro = TRUE`).

## Usage

``` r
consultar_publicacoes(
  ids,
  config = sei_config(),
  por = c("id_documento", "protocolo_documento", "id_publicacao"),
  parar_em_erro = FALSE,
  verbose = FALSE
)
```

## Arguments

- ids:

  Vetor de identificadores.

- config:

  Um objeto
  [`sei_config()`](https://strategicprojects.github.io/rsei/reference/sei_config.md).

- por:

  Tipo do identificador em `ids`: `"id_documento"` (padrão),
  `"protocolo_documento"` ou `"id_publicacao"`.

- parar_em_erro:

  Logical. Se `TRUE`, interrompe na primeira falha.

- verbose:

  Logical.

## Value

Um `tibble` com uma linha por item (colunas `id` e `erro` além das de
[`consultar_publicacao()`](https://strategicprojects.github.io/rsei/reference/consultar_publicacao.md)).

## Examples

``` r
if (FALSE) { # \dontrun{
  consultar_publicacoes(c("20000002", "67640000"), por = "id_documento")
} # }
```
