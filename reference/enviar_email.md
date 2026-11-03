# enviar_email

Envia um e-mail vinculado a um processo (`enviarEmail`).

## Usage

``` r
enviar_email(
  protocolo_procedimento,
  de,
  para,
  assunto,
  mensagem,
  cco = NULL,
  id_documentos = NULL,
  nivel_acesso = NULL,
  id_hipotese_legal = NULL,
  config = sei_config(),
  raw = FALSE,
  verbose = FALSE
)
```

## Arguments

- protocolo_procedimento:

  Character. Número do processo.

- de:

  Character. Endereço do remetente.

- para:

  Vetor de destinatários (serão unidos por ";").

- assunto, mensagem:

  Character.

- cco:

  Vetor de destinatários em cópia oculta (opcional).

- id_documentos:

  Vetor de ids de documentos a anexar (opcional).

- nivel_acesso:

  Character opcional (SEI \>= 5): "0" (público), "1" (restrito) ou "2"
  (sigiloso).

- id_hipotese_legal:

  Character opcional (SEI \>= 5): id da hipótese legal, obrigatório
  quando `nivel_acesso` é restrito/sigiloso.

- config:

  Um objeto
  [`sei_config()`](https://strategicprojects.github.io/rsei/reference/sei_config.md).

- raw, verbose:

  Logical.

## Value

Um `tibble`
([parse_retorno_envio_email](https://strategicprojects.github.io/rsei/reference/parse_retorno_envio_email.md)).
