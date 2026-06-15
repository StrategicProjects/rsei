# parse_procedimento_resumido

Parseia um `<item>` de `<ProcedimentosRelacionados>` ou
`<ProcedimentosAnexados>`.

## Usage

``` r
parse_procedimento_resumido(nd_pr)
```

## Arguments

- nd_pr:

  Um nó `xml2` de `<item>`.

## Value

Um tibble de 1 linha com `IdProcedimento` e `ProcedimentoFormatado`.
