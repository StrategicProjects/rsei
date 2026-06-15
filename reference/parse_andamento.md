# parse_andamento: Parse a `<Andamento>` Node

Parseia um nó `<Andamento>` (`Descricao`, `DataHora`, e as subestruturas
`Unidade` e `Usuario`) num tibble de 1 linha. Se o nó for ausente ou
`xsi:nil="true"`, devolve uma linha de `NA`.

## Usage

``` r
parse_andamento(node_and)
```

## Arguments

- node_and:

  Um nó `xml2` representando um `<Andamento>`.

## Value

Um tibble de 1 linha com `Descricao`, `DataHora`, `IdUnidade`,
`SiglaUnidade`, `DescricaoUnidade`, `IdUsuario`, `SiglaUsuario`,
`NomeUsuario`.
