# Retrieve SEI Credentials from Keyring

Retrieves the stored SEI credentials for a given `service_name` from the
`keyring`. If the `keyring` package is missing or if retrieval fails,
the function displays a message instead of throwing an error, and
returns `NULL`.

## Usage

``` r
get_sei_credentials(service_name)
```

## Arguments

- service_name:

  Character string. The name of the service that identifies the SEI
  credentials in the keyring.

## Value

A list containing:

- `username`: The stored username (if any).

- `password`: The stored password or SEI access key (if any).

- `extras`: A list of additional parameters (if any).

Returns `NULL` if no credentials are found or if an error occurred.

## Examples

``` r
if (FALSE) { # \dontrun{
creds <- get_sei_credentials("SEI_WS")
if (!is.null(creds)) {
  cat("Username:", creds$username, "\n")
  cat("Password:", creds$password, "\n")
  cat("Extras:", "\n")
  print(creds$extras)
}
} # }
```
