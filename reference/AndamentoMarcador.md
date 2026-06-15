# AndamentoMarcador

Represents the "AndamentoMarcador" structure in SEI (marker events).

## Usage

``` r
AndamentoMarcador(
  IdAndamentoMarcador = NULL,
  Texto = NULL,
  DataHora = NULL,
  Usuario = NULL,
  Marcador = NULL
)
```

## Arguments

- IdAndamentoMarcador:

  Character. Internal ID of the marker event.

- Texto:

  Character. Text associated with the andamento marker.

- DataHora:

  Character. Date/time the marker was generated.

- Usuario:

  A
  [`Usuario`](https://strategicprojects.github.io/rsei/reference/Usuario.md)
  object describing the user who generated the marker.

- Marcador:

  A
  [`Marcador`](https://strategicprojects.github.io/rsei/reference/Marcador.md)
  object used in the marker event (or `NULL` if removed).

## Value

An S3 object of class "AndamentoMarcador".
