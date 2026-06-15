# ProcedimentoResumido

Represents a "ProcedimentoResumido" structure (summary of a process).

## Usage

``` r
ProcedimentoResumido(
  IdTipoProcedimento,
  ProcedimentoFormatado,
  TipoProcedimento = NULL
)
```

## Arguments

- IdTipoProcedimento:

  Character. ID of the process type.

- ProcedimentoFormatado:

  Character. Visible process number.

- TipoProcedimento:

  A
  [`TipoProcedimento`](https://strategicprojects.github.io/rsei/reference/TipoProcedimento.md)
  object with details about the process type.

## Value

An S3 object of class "ProcedimentoResumido".
