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
