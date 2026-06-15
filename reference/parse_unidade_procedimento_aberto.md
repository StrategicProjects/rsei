# parse_unidade_procedimento_aberto

Parseia um `<item>` de `<UnidadesProcedimentoAberto>`, extraindo as
subestruturas `Unidade` e `UsuarioAtribuicao`.

## Usage

``` r
parse_unidade_procedimento_aberto(node_upa)
```

## Arguments

- node_upa:

  Um nó `xml2` de um `<item>`.

## Value

Um tibble de 1 linha com os campos da unidade e do usuário de
atribuição.
