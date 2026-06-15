# DefinicaoControlePrazo

Represents the "DefinicaoControlePrazo" structure for deadline control.

## Usage

``` r
DefinicaoControlePrazo(
  ProtocoloProcedimento,
  DataPrazo = NULL,
  Dias = NULL,
  SinDiasUteis = NULL
)
```

## Arguments

- ProtocoloProcedimento:

  Character. Visible process number, e.g. "12.1.000000077-4".

- DataPrazo:

  Character. The date for defining the deadline.

- Dias:

  Character. Number of days for the deadline.

- SinDiasUteis:

  "S" or "N", indicating if the days are business days.

## Value

An S3 object of class "DefinicaoControlePrazo".
