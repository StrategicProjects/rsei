# Cidade

Represents the "Cidade" structure in SEI.

## Usage

``` r
Cidade(
  IdCidade,
  IdEstado,
  IdPais,
  Nome,
  CodigoIbge = NULL,
  SinCapital = NULL,
  Latitude = NULL,
  Longitude = NULL
)
```

## Arguments

- IdCidade:

  Character. Identifier of the city.

- IdEstado:

  Character. Identifier of the state.

- IdPais:

  Character. Identifier of the country.

- Nome:

  Character. Name of the city.

- CodigoIbge:

  Character. IBGE code of the city.

- SinCapital:

  "S" or "N", indicates if the city is a state capital.

- Latitude:

  Character. Latitude of the city.

- Longitude:

  Character. Longitude of the city.

## Value

An S3 object of class "Cidade".
