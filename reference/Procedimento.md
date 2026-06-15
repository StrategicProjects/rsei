# Procedimento

Represents the "Procedimento" structure in SEI (process definition).

## Usage

``` r
Procedimento(
  IdTipoProcedimento,
  NumeroProtocolo = NULL,
  DataAutuacao = NULL,
  Especificacao = NULL,
  Assuntos = list(),
  Interessados = list(),
  Observacao = NULL,
  NivelAcesso = NULL,
  IdHipoteseLegal = NULL
)
```

## Arguments

- IdTipoProcedimento:

  Character. ID of the process type.

- NumeroProtocolo:

  Character. Process number (optional).

- DataAutuacao:

  Character. Process creation date (optional).

- Especificacao:

  Character. Process specification (optional).

- Assuntos:

  A list of
  [`Assunto`](https://strategicprojects.github.io/rsei/reference/Assunto.md)
  objects.

- Interessados:

  A list of
  [`Interessado`](https://strategicprojects.github.io/rsei/reference/Interessado.md)
  objects.

- Observacao:

  Character. Unit observation (optional).

- NivelAcesso:

  "0"=public, "1"=restricted, "2"=secret, or NULL.

- IdHipoteseLegal:

  Character. If restricted/secret, link to a legal hypothesis.

## Value

An S3 object of class "Procedimento".
