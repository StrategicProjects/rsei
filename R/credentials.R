# file: R/credentials.R

#' @title Store SEI Credentials in Keyring
#'
#' @description
#' Stores (or updates) credentials for the SEI web service in the `keyring`.
#' If the keyring package is not installed or if the store operation fails,
#' it simply displays a message instead of throwing an error.
#'
#' @param service_name Character string. The name of the service that identifies
#'   this set of credentials (e.g., "SEI_WS").
#' @param username Optional. The username or system alias used for SEI, if applicable.
#'   Defaults to "default_user" if not provided.
#' @param password The SEI access key or password to be stored.
#' @param ... Other parameters you wish to store in the keyring (e.g., URL,
#'   unit ID, etc.). These will be serialized as JSON under a separate username ("EXTRAS").
#'
#' @return Invisibly returns a logical value: `TRUE` if credentials were stored successfully,
#'   or `FALSE` otherwise.
#'
#' @export
#'
#' @examples
#' \dontrun{
#' store_sei_credentials(
#'   service_name = "SEI_WS",
#'   username = "MySystemSigla",
#'   password = "MySEIAccessKey",
#'   url = "https://myserver/sei/controlador_ws.php?servico=sei",
#'   unit_id = "100000969"
#' )
#' }
#'
store_sei_credentials <- function(service_name,
                                  username = NULL,
                                  password,
                                  ...) {
  if (!requireNamespace("keyring", quietly = TRUE)) {
    message("Package 'keyring' is not installed. Cannot store credentials securely.")
    return(invisible(FALSE))
  }

  tryCatch(
    {
      # If no username is provided, use 'default_user'
      keyring::key_set_with_value(
        service  = service_name,
        username = if (is.null(username)) "default_user" else username,
        password = password
      )

      # Store additional parameters (if any) in a separate entry ("EXTRAS")
      extras <- list(...)
      if (length(extras) > 0) {
        extras_json <- jsonlite::toJSON(extras, auto_unbox = TRUE)
        keyring::key_set_with_value(
          service  = service_name,
          username = "EXTRAS",
          password = extras_json
        )
      }

      message("Credentials stored/updated successfully in '", service_name, "'.")
      invisible(TRUE)
    },
    error = function(e) {
      message("Could not store credentials: ", e$message)
      invisible(FALSE)
    }
  )
}


#' @title Retrieve SEI Credentials from Keyring
#'
#' @description
#' Retrieves the stored SEI credentials for a given `service_name` from the `keyring`.
#' If the `keyring` package is missing or if retrieval fails, the function displays a
#' message instead of throwing an error, and returns `NULL`.
#'
#' @param service_name Character string. The name of the service that identifies
#'   the SEI credentials in the keyring.
#'
#' @return A list containing:
#' \itemize{
#'   \item \code{username}: The stored username (if any).
#'   \item \code{password}: The stored password or SEI access key (if any).
#'   \item \code{extras}: A list of additional parameters (if any).
#' }
#' Returns `NULL` if no credentials are found or if an error occurred.
#'
#' @export
#'
#' @examples
#' \dontrun{
#' creds <- get_sei_credentials("SEI_WS")
#' if (!is.null(creds)) {
#'   cat("Username:", creds$username, "\n")
#'   cat("Password:", creds$password, "\n")
#'   cat("Extras:", "\n")
#'   print(creds$extras)
#' }
#' }
#'
get_sei_credentials <- function(service_name) {
  if (!requireNamespace("keyring", quietly = TRUE)) {
    message("Package 'keyring' is not installed. Cannot retrieve credentials.")
    return(NULL)
  }

  cred_list <- tryCatch(
    keyring::key_list(service = service_name),
    error = function(e) {
      message("Could not list credentials for '", service_name, "': ", e$message)
      NULL
    }
  )

  if (is.null(cred_list) || nrow(cred_list) == 0) {
    message("No credentials found for service '", service_name, "'.")
    return(NULL)
  }

  # Check if "EXTRAS" entry exists
  has_extras <- "EXTRAS" %in% cred_list$username
  extras_list <- NULL
  if (has_extras) {
    extras_pass <- tryCatch(
      keyring::key_get(service = service_name, username = "EXTRAS"),
      error = function(e) {
        message("Could not retrieve EXTRAS: ", e$message)
        NULL
      }
    )
    if (!is.null(extras_pass)) {
      extras_list <- jsonlite::fromJSON(extras_pass, simplifyVector = FALSE)
    }
  }

  # Retrieve the first "normal" username (if any)
  normal_users <- cred_list$username[cred_list$username != "EXTRAS"]
  if (length(normal_users) == 0) {
    # Only EXTRAS were stored, no actual username/password
    return(list(
      username = NA_character_,
      password = NA_character_,
      extras   = extras_list
    ))
  }

  username_chosen <- normal_users[1]
  password_chosen <- tryCatch(
    keyring::key_get(service = service_name, username = username_chosen),
    error = function(e) {
      message("Could not retrieve the password for '", username_chosen, "': ", e$message)
      NA_character_
    }
  )

  list(
    username = username_chosen,
    password = password_chosen,
    extras   = extras_list
  )
}
