# parse_retorno_geracao_procedimento

Parseia o retorno de `gerarProcedimento` (`RetornoGeracaoProcedimento`).

## Usage

``` r
parse_retorno_geracao_procedimento(doc)
```

## Arguments

- doc:

  Um `xml2::xml_document`.

## Value

Um tibble de 1 linha com `IdProcedimento`, `ProcedimentoFormatado`,
`LinkAcesso` e `RetornoInclusaoDocumentos` (coluna-lista).
