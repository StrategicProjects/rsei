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

- config:

  Um objeto
  [`sei_config()`](https://strategicprojects.github.io/rsei/reference/sei_config.md).

- raw, verbose:

  Logical.

## Value

Um `tibble`
([parse_retorno_envio_email](https://strategicprojects.github.io/rsei/reference/parse_retorno_envio_email.md)).
