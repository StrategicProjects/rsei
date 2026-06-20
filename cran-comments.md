## Resubmission

This is a resubmission. In response to the review by Konstanze Lauseker we have
made the following changes:

* Added a reference to the web services in the `Description` field of
  `DESCRIPTION`, using angle brackets for auto-linking and no space after
  `https:`
  (`<https://www.gov.br/gestao/pt-br/assuntos/processo-eletronico-nacional>`).
* Removed the examples for unexported functions. The two functions that had
  examples while being unexported (`get_sei_credentials()` and
  `store_sei_credentials()`) are user-facing credential helpers (they are
  referenced in the package vignette), so we have exported them instead of
  omitting their examples. There are no longer any examples for unexported
  functions.

## R CMD check results

0 errors | 0 warnings | 1 note

* This is a new submission.

## Network access

The package is a client for the SOAP web services of the SEI/SIP systems.
Access to these services is restricted by the server to previously authorized
network addresses and requires an access key, so the services cannot be reached
from the CRAN check machines. Accordingly:

* No example, test or vignette code contacts the network. Network-dependent
  examples are wrapped in `\dontrun{}`; the vignette chunks use `eval = FALSE`;
  the test suite runs entirely offline against stored XML fixtures and mocked
  request functions.
* Requests use a default timeout and fail gracefully with an informative
  message when the service is unreachable.

## Test environments

* Ubuntu 22.04, R 4.x (R CMD check --as-cran)

## URLs
The attribution link to https://monitoramento.sepe.pe.gov.br (the maintainers'
institution) is valid; it may occasionally be flagged if the checking host
cannot reach the Brazilian government server.
