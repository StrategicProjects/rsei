# Documento

Represents the "Documento" structure in SEI, for generated or external
documents.

## Usage

``` r
Documento(
  Tipo,
  IdProcedimento = NULL,
  ProtocoloProcedimento = NULL,
  IdSerie,
  Numero = NULL,
  NomeArvore = NULL,
  Data = NULL,
  Descricao = NULL,
  IdTipoConferencia = NULL,
  SinArquivamento = NULL,
  Remetente = NULL,
  Interessados = list(),
  Destinatarios = list(),
  Observacao = NULL,
  NomeArquivo = NULL,
  NivelAcesso = NULL,
  IdHipoteseLegal = NULL,
  Conteudo = NULL,
  ConteudoMTOM = NULL,
  IdArquivo = NULL,
  Campos = list(),
  SinBloqueado = NULL
)
```

## Arguments

- Tipo:

  Character. "G" (generated) or "R" (received).

- IdProcedimento:

  Character. SEI process ID (optional).

- ProtocoloProcedimento:

  Character. Visible process number (optional).

- IdSerie:

  Character. The document type in SEI.

- Numero:

  Character. Document number (optional).

- NomeArvore:

  Character. Display name in the process tree (optional).

- Data:

  Character. Document date (required for external docs).

- Descricao:

  Character. Document description (required for generated docs).

- IdTipoConferencia:

  Character. Conference type ID (for external docs).

- SinArquivamento:

  "S" or "N". Indicates if document should be archived.

- Remetente:

  A
  [`Remetente`](https://strategicprojects.github.io/rsei/reference/Remetente.md)
  object (null for generated docs).

- Interessados:

  A list of
  [`Interessado`](https://strategicprojects.github.io/rsei/reference/Interessado.md)
  objects.

- Destinatarios:

  A list of
  [`Destinatario`](https://strategicprojects.github.io/rsei/reference/Destinatario.md)
  objects.

- Observacao:

  Character. Unit observation, if any.

- NomeArquivo:

  Character. File name (required for external docs).

- NivelAcesso:

  Character. "0"=public, "1"=restricted, "2"=secret, or NULL.

- IdHipoteseLegal:

  Character. Hypothesis ID for restricted/secret docs, if any.

- Conteudo:

  Character. Base64-encoded file content (required for docs).

- ConteudoMTOM:

  Raw or base64 for large files (optional).

- IdArquivo:

  Character. If using `adicionarArquivo` approach, reference ID.

- Campos:

  A list of `Campo` structures (form fields), if any.

- SinBloqueado:

  "S" or "N". If blocked, the doc cannot be changed or removed.

## Value

An S3 object of class "Documento".
