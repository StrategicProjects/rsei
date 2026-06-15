# ProtocoloBloco

Represents a "ProtocoloBloco" structure (process/document in a block).

## Usage

``` r
ProtocoloBloco(ProtocoloFormatado, Identificacao, Assinaturas = list())
```

## Arguments

- ProtocoloFormatado:

  Character. Visible process or document number.

- Identificacao:

  Character. Type of the process or document.

- Assinaturas:

  A list of
  [`Assinatura`](https://strategicprojects.github.io/rsei/reference/Assinatura.md)
  objects (empty if none).

## Value

An S3 object of class "ProtocoloBloco".
