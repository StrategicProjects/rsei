# Publicacao

Represents the "Publicacao" structure in SEI (publication data).

## Usage

``` r
Publicacao(
  IdPublicacao = NULL,
  IdDocumento = NULL,
  StaMotivo = NULL,
  Resumo = NULL,
  IdVeiculoPublicacao = NULL,
  NomeVeiculo = NULL,
  StaTipoVeiculo = NULL,
  Numero = NULL,
  DataDisponibilizacao = NULL,
  DataPublicacao = NULL,
  Estado = NULL,
  ImprensaNacional = NULL
)
```

## Arguments

- IdPublicacao:

  Character. Internal ID of the publication.

- IdDocumento:

  Character. Internal ID of the associated document.

- StaMotivo:

  Character. "1"=Publication, "2"=Rectification, "3"=Republication,
  "4"=Apostilament.

- Resumo:

  Character. Summary text of the publication.

- IdVeiculoPublicacao:

  Character. Internal ID of the publication vehicle.

- NomeVeiculo:

  Character. Name of the publication vehicle.

- StaTipoVeiculo:

  Character. "I"=Internal, "E"=External, "M"=Module.

- Numero:

  Character. Publication number.

- DataDisponibilizacao:

  Character. Date of availability.

- DataPublicacao:

  Character. Date of publication.

- Estado:

  Character. "A"=Scheduled or "P"=Published.

- ImprensaNacional:

  A
  [`PublicacaoImprensaNacional`](https://strategicprojects.github.io/rsei/reference/PublicacaoImprensaNacional.md)
  object or NULL.

## Value

An S3 object of class "Publicacao".
