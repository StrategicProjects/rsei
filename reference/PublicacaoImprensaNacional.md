# PublicacaoImprensaNacional

Represents the "PublicacaoImprensaNacional" structure in SEI.

## Usage

``` r
PublicacaoImprensaNacional(
  IdVeiculo = NULL,
  SiglaVeiculo = NULL,
  DescricaoVeiculo = NULL,
  Pagina = NULL,
  IdSecao = NULL,
  Secao = NULL,
  Data = NULL
)
```

## Arguments

- IdVeiculo:

  Character. ID of the vehicle.

- SiglaVeiculo:

  Character. e.g., "DOU".

- DescricaoVeiculo:

  Character. e.g., "Diário Oficial da União".

- Pagina:

  Character. Page number of the publication.

- IdSecao:

  Character. ID of the section.

- Secao:

  Character. Section name.

- Data:

  Character. Publication date.

## Value

An S3 object of class "PublicacaoImprensaNacional".
