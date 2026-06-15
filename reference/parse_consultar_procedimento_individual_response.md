# parse_consultar_procedimento_individual_response

Parseia a resposta de `consultarProcedimentoIndividual`
(`ProcedimentoResumido`). Retorna linha de `NA` se nenhum processo for
encontrado (`parametros` nulo).

## Usage

``` r
parse_consultar_procedimento_individual_response(doc)
```

## Arguments

- doc:

  Um `xml2::xml_document`.

## Value

Um tibble de 1 linha.
