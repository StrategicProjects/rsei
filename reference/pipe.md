# Pipe operator

Veja `magrittr::%>%` para detalhes.

## Usage

``` r
lhs %>% rhs
```

## Arguments

- lhs:

  Um valor ou o objeto `magrittr` placeholder.

- rhs:

  Uma chamada de função usando a semântica do `magrittr`.

## Value

O resultado de chamar `rhs(lhs)`.
