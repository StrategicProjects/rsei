# Unidade

Represents the "Unidade" structure in SEI (organizational unit).

## Usage

``` r
Unidade(
  IdUnidade,
  Sigla,
  Descricao,
  SinProtocolo = NULL,
  SinArquivamento = NULL,
  SinOuvidoria = NULL
)
```

## Arguments

- IdUnidade:

  Character. Identifier of the unit.

- Sigla:

  Character. Unit sigla.

- Descricao:

  Character. Unit description.

- SinProtocolo:

  "S" or "N" if it's a protocol unit.

- SinArquivamento:

  "S" or "N" if it's an archive unit.

- SinOuvidoria:

  "S" or "N" if it's an ombudsman unit.

## Value

An S3 object of class "Unidade".
