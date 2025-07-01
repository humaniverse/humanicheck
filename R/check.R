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
#' @export
#'
#' @examples
#' \dontrun{
#' humanicheck(penguins)
#' }
humanicheck <- function(data) {
  cat("--- Data Quality Report ---\n")

  cat("1. Tibble Check\n")
  if (!tibble::is_tibble(data)) {
    cat("❗️Input is not a tibble. Consider using `tibble::as_tibble()`.\n")
  } else {
    cat("✅ Data is a tibble.\n")
  }

  cat("---\n")

  cat("2. Object Size Check\n")
  obj_s_numeric <- lobstr::obj_size(data) |>
    as.numeric()

  if (obj_s_numeric > 5e7) {
    cat(
      stringr::str_glue(
        "❗️Object size ({scales::label_bytes()(obj_s_numeric)}) exceeds GitHub's 50MB warning limit.\n"
      )
    )
  } else {
    cat(
      stringr::str_glue(
        "✅ Object size ({scales::label_bytes()(obj_s_numeric)}) is within a reasonable limit.\n"
      )
    )
  }

  cat("\n---\n")

  cat("3. Duplicated Rows Check\n")
  if (any(duplicated(data))) {
    cat("❗️Found duplicated rows:\n")
    data |>
      dplyr::mutate(
        .row_number = dplyr::row_number()
      ) |>
      dplyr::filter(duplicated(data) | duplicated(data, fromLast = TRUE)) |>
      print()
    cat("\n")
  } else {
    cat("✅ No duplicate rows found.\n")
  }

  cat("---\n")

  cat("4. NA Value Check\n")
  na_locations <- which(is.na(data), arr.ind = TRUE) |>
    tibble::as_tibble() |>
    dplyr::mutate(
      column = names(data)[col]
    ) |>
    dplyr::select(
      row,
      column
    )

  if (nrow(na_locations) > 0) {
    cat("❗️Found NA values at these locations:\n")
    print(na_locations, n = Inf)
    cat("\n")
  } else {
    cat("✅ No NA values found.\n")
  }

  cat("---\n")

  cat("5. SF Geometry Check\n")
  if (!inherits(data, "sf")) {
    cat("✅ Skipping SF checks (not an sf object).\n")
  } else {
    geom_types <- sf::st_geometry_type(data) |>
      unique()

    if (length(geom_types) > 1) {
      cat(
        stringr::str_glue(
          "❗️Multiple geometry types found: {paste(geom_types, collapse = ', ')}.\n"
        )
      )
    } else if (length(geom_types) == 0) {
      cat("✅ Data contains no geometries.\n")
    } else {
      cat(
        stringr::str_glue(
          "✅ All features share a single geometry type: {geom_types}.\n"
        )
      )
    }
  }

  cat("\n--- End of Report ---\n")
}
