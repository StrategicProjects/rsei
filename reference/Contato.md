# Contato

Represents the "Contato" structure in SEI, storing personal or
organizational contact data.

## Usage

``` r
Contato(
  StaOperacao = NULL,
  IdContato,
  IdTipoContato = NULL,
  Nome = NULL,
  NomeSocial = NULL,
  StaNatureza = NULL,
  Endereco = NULL,
  Bairro = NULL,
  Cep = NULL,
  Cpf = NULL,
  Cnpj = NULL,
  Rg = NULL,
  OrgaoExpedidor = NULL,
  TelefoneFixo = NULL,
  TelefoneCelular = NULL,
  Email = NULL,
  ...
)
```

## Arguments

- StaOperacao:

  Character. Operation code: "A", "E", "D", "R", or NULL.

- IdContato:

  Character. Internal ID of the contact.

- IdTipoContato:

  Character. Internal ID for the type of contact.

- Nome:

  Character. Name of the contact.

- NomeSocial:

  Character. Social name of the contact.

- StaNatureza:

  Character. "F" (individual) or "J" (company).

- Endereco:

  Character. Address of the contact.

- Bairro:

  Character. Neighborhood.

- Cep:

  Character. Postal code.

- Cpf:

  Character. Contact's CPF.

- Cnpj:

  Character. Contact's CNPJ.

- Rg:

  Character. Contact's RG.

- OrgaoExpedidor:

  Character. RG Issuing authority.

- TelefoneFixo:

  Character. Landline phone.

- TelefoneCelular:

  Character. Mobile phone.

- Email:

  Character. Email of the contact.

- ...:

  Additional fields (e.g., city, cargo, passaporte).

## Value

An S3 object of class "Contato".
