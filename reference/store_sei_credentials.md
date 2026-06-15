# Store SEI Credentials in Keyring

Stores (or updates) credentials for the SEI web service in the
`keyring`. If the keyring package is not installed or if the store
operation fails, it simply displays a message instead of throwing an
error.

## Usage

``` r
store_sei_credentials(service_name, username = NULL, password, ...)
```

## Arguments

- service_name:

  Character string. The name of the service that identifies this set of
  credentials (e.g., "SEI_WS").

- username:

  Optional. The username or system alias used for SEI, if applicable.
  Defaults to "default_user" if not provided.

- password:

  The SEI access key or password to be stored.

- ...:

  Other parameters you wish to store in the keyring (e.g., URL, unit ID,
  etc.). These will be serialized as JSON under a separate username
  ("EXTRAS").

## Value

Invisibly returns a logical value: `TRUE` if credentials were stored
successfully, or `FALSE` otherwise.

## Examples

``` r
if (FALSE) { # \dontrun{
store_sei_credentials(
  service_name = "SEI_WS",
  username = "MySystemSigla",
  password = "MySEIAccessKey",
  url = "https://myserver/sei/controlador_ws.php?servico=sei",
  unit_id = "100000969"
)
} # }
```
