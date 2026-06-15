# Cargo

Represents a "Cargo" (position) in SEI, with expressions for treatment
and vocative.

## Usage

``` r
Cargo(
  IdCargo = NULL,
  ExpressaoCargo = NULL,
  ExpressaoTratamento = NULL,
  ExpressaoVocativo = NULL
)
```

## Arguments

- IdCargo:

  Character. Internal ID of the cargo.

- ExpressaoCargo:

  Character. Cargo description (e.g., "Governor").

- ExpressaoTratamento:

  Character. Treatment (e.g., "A Sua Excelência o Senhor").

- ExpressaoVocativo:

  Character. Vocative (e.g., "Senhor Governador").

## Value

An S3 object of class "Cargo".
