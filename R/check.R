#' Generate a Data Quality Report
#'
#' @description
#' This function performs a series of checks on a data frame or tibble and
#' prints a summary report to the console. The checks include verifying if the
#' input is a tibble, checking the object's memory size, identifying
#' duplicated rows, locating NA values, and for `sf` objects, ensuring
#' geometry type consistency.
#'
#' @param data The input data frame, tibble, or sf object to be checked.
#'
#' @return The function does not return a value. It prints a formatted report
#'   directly to the console.
#'
#' @autoglobal
#' @importFrom scales label_bytes
#' @export
#'
#' @examples
#' \dontrun{
#' humanicheck(penguins)
#' }
humanicheck <- function(data) {
  cli::cli_h1("Data Quality Report")

  cli::cli_h2("1. Tibble Check")
  if (!tibble::is_tibble(data)) {
    cli::cli_alert_danger(
      "Input is not a tibble. Consider using `tibble::as_tibble()`."
    )
  } else {
    cli::cli_alert_success("Data is a tibble.")
  }

  cli::cli_h2("2. Object Size Check")
  obj_s_numeric <- lobstr::obj_size(data) |>
    as.numeric()

  if (obj_s_numeric > 5e7) {
    cli::cli_alert_danger(
      "Object size ({scales::label_bytes()(obj_s_numeric)}) exceeds GitHub's 50MB warning limit."
    )
  } else {
    cli::cli_alert_success(
      "Object size ({scales::label_bytes()(obj_s_numeric)}) is within a reasonable limit."
    )
  }

  cli::cli_h2("3. Duplicated Rows Check")
  if (any(duplicated(data))) {
    cli::cli_alert_danger("Found duplicated rows:")
    data |>
      dplyr::mutate(
        .row_number = dplyr::row_number()
      ) |>
      dplyr::filter(duplicated(data) | duplicated(data, fromLast = TRUE)) |>
      print()
  } else {
    cli::cli_alert_success("No duplicate rows found.")
  }

  cli::cli_h2("4. NA Value Check")
  na_locations <- which(is.na(data), arr.ind = TRUE) |>
    tibble::as_tibble() |>
    dplyr::mutate(column = names(data)[col]) |>
    dplyr::select(row, column)

  if (nrow(na_locations) > 0) {
    cli::cli_alert_danger("Found NA values at these locations:")
    print(na_locations)
  } else {
    cli::cli_alert_success("No NA values found.")
  }

  cli::cli_h2("5. SF Geometry Check")
  if (!inherits(data, "sf")) {
    cli::cli_alert_info("Skipping SF checks (not an sf object).")
  } else {
    geom_types <- sf::st_geometry_type(data) |>
      unique()

    if (length(geom_types) > 1) {
      cli::cli_alert_danger(
        "Multiple geometry types found: {paste(geom_types, collapse = ', ')}."
      )
    } else if (length(geom_types) == 0) {
      cli::cli_alert_success("Data contains no geometries.")
    } else {
      cli::cli_alert_success(
        "All features share a single geometry type: {geom_types}."
      )
    }
  }
  cli::cli_h1("End of Report")
}
