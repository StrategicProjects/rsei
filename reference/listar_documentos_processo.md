# listar_documentos_processo

Reconstrói a lista de documentos de um processo a partir dos seus
andamentos.

O Web Service do SEI **não possui** uma operação nativa para listar os
documentos de um processo; portanto esta função recupera a linha do
tempo com
[`listar_andamentos_completo()`](https://strategicprojects.github.io/rsei/reference/listar_andamentos_completo.md)
e extrai os números de documento mencionados nas descrições (ex.:
"Gerado documento ... 84230597"). É uma heurística: o resultado depende
do texto dos andamentos e pode não captar 100% dos casos.

## Usage

``` r
listar_documentos_processo(
  protocolo_procedimento,
  config = sei_config(),
  consultar = FALSE,
  verbose = FALSE
)
```

## Arguments

- protocolo_procedimento:

  Character. Número do processo.

- config:

  Um objeto
  [`sei_config()`](https://strategicprojects.github.io/rsei/reference/sei_config.md).

- consultar:

  Logical. Se `TRUE`, consulta cada documento encontrado com
  [`consultar_documentos()`](https://strategicprojects.github.io/rsei/reference/consultar_documentos.md)
  e anexa os detalhes (série, data, unidade elaboradora, etc.). Faz uma
  chamada por documento.

- verbose:

  Logical.

## Value

Um `tibble` com uma linha por documento: `documento` (número),
`DataHora`/`SiglaUnidade`/`SiglaUsuario`/`NomeUsuario`/`Andamento` da
primeira menção (a geração). Com `consultar = TRUE`, inclui também as
colunas de
[`consultar_documento()`](https://strategicprojects.github.io/rsei/reference/consultar_documento.md).

## Examples

``` r
if (FALSE) { # \dontrun{
  docs <- listar_documentos_processo("12.1.000000077-4", config = sei_config())
  docs[, c("documento", "DataHora", "SiglaUnidade", "NomeUsuario")]

  # com detalhes (série, data, etc.)
  listar_documentos_processo("12.1.000000077-4", consultar = TRUE)
} # }
```
