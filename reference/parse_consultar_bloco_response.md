# parse_consultar_bloco_response

Parseia a resposta de `consultarBloco` (`RetornoConsultaBloco`).

## Usage

``` r
parse_consultar_bloco_response(doc)
```

## Arguments

- doc:

  Um `xml2::xml_document`.

## Value

Um tibble de 1 linha. `Unidade`, `Usuario` e `UsuarioAtribuicao` viram
colunas com prefixo; `UnidadesDisponibilizacao` e `Protocolos` ficam
como colunas-lista.
