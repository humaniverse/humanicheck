# humanicheck
Helper package to check data being outputted by humaniverse packages meets expectations

## Overview

This package exports a single function, `humanicheck()` which generates a quick and human-readable data quality report directly in your R console.


## Installation

You can install the development version of `humanicheck` from [GitHub](https://github.com/) with:

```r
# install.packages("pak")
pak::pak("humaniverse/humanicheck")
```

## Example Usage

Using the function is straightforward. Simply pass your data frame or tibble to `humanicheck()`.

```r
humanicheck::humanicheck(penguins)
```

### Report Output

The command above will produce the following report in your console:

```r
── Data Quality Report ─────────────────────────────────────────────────────────

── 1. Tibble Check ──

✖ Input is not a tibble. Consider using `tibble::as_tibble()`.

── 2. Object Size Check ──

✔ Object size (17 kB) is within a reasonable limit.

── 3. Duplicated Rows Check ──

✔ No duplicate rows found.

── 4. NA Value Check ──

✖ Found NA values at these locations:
# A tibble: 19 × 2
     row column     
   <int> <chr>      
 1     4 bill_len   
 2   272 bill_len   
 3     4 bill_dep   
 4   272 bill_dep   
 5     4 flipper_len
 6   272 flipper_len
 7     4 body_mass  
 8   272 body_mass  
 9     4 sex        
10     9 sex        
11    10 sex        
12    11 sex        
13    12 sex        
14    48 sex        
15   179 sex        
16   219 sex        
17   257 sex        
18   269 sex        
19   272 sex        

── 5. SF Geometry Check ──

ℹ Skipping SF checks (not an sf object).

── End of Report ───────────────────────────────────────────────────────────────
```

## Checks Performed

The `humanicheck()` function runs the following diagnostic checks:

* **Tibble Check**: Verifies that the input data is a `tibble`.
* **Object Size**: Checks if the in-memory size of the object exceeds 50MB.
* **Duplicated Rows**: Identifies and displays any fully duplicated rows.
* **NA Values**: Locates and reports the positions of any `NA` values.
* **SF Geometry**: For `sf` objects, checks if all geometries are of a single, consistent type.

## License

This package is licensed under the MIT License.