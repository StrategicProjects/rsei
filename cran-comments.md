## rsei 0.1.1

This is a minor update of a package already on CRAN (rsei 0.1.0).

Main changes (see NEWS.md):

* Compatibility coverage for version 5 of the SEI system, whose SOAP API adds
  one operation and a few parameters/fields on top of version 4: new function
  `alterar_bloco()`; new optional arguments `nivel_acesso` and
  `id_hipotese_legal` in `enviar_email()`; new `SinOuvidoriaAnonimo` column
  parsed in the "tipos de procedimento" listings. All changes are additive and
  backward compatible.
* Updated author metadata (name spellings and ORCID identifiers).

## R CMD check results

0 errors | 0 warnings | 0 notes

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

* Local macOS, R 4.x (R CMD check --as-cran)
* Ubuntu 22.04, R 4.x (R CMD check --as-cran)
* GitHub Actions (R-CMD-check workflow)
