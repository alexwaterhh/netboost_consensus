# Quick Testing Commands

## Option 1: Run the Test Script (Recommended)
```r
# In R console, from package root directory:
source("test_consensus_local.R")
```

This will automatically:
- Document and load the package
- Run 6 comprehensive tests
- Show you if everything works

## Option 2: Manual Interactive Testing

### Step-by-step in R:

```r
# 1. Load devtools
library(devtools)

# 2. Document package (updates NAMESPACE and .Rd files)
document()

# 3. Load package without installing
load_all()

# 4. Test the function
data('tcga_aml_meth_rna_chr18', package='netboost')

# Create test datasets
set.seed(123)
n <- nrow(tcga_aml_meth_rna_chr18)
idx1 <- sample(1:n, floor(n/2))
idx2 <- setdiff(1:n, idx1)

datan_list <- list(
    tcga_aml_meth_rna_chr18[idx1,],
    tcga_aml_meth_rna_chr18[idx2,]
)

# Run the function
results <- netboost_consensus(
    datan_list = datan_list,
    stepno = 10L,
    soft_power = c(3L, 3L),
    consensus_method = "min",
    min_cluster_size = 10L,
    n_pc = 2,
    scale = TRUE,
    verbose = TRUE
)

# Check results
table(results$colors)
head(results$MEs)
```

## Option 3: Check Package Integrity

```r
# Run R CMD check
devtools::check()

# This will:
# - Check documentation
# - Run examples
# - Check for errors/warnings
# - Validate NAMESPACE
```

## Option 4: Quick Syntax Check

```r
# Just check if function loads without errors
devtools::load_all()
exists("netboost_consensus")  # Should return TRUE
```

## Command Line Testing (in Terminal)

```bash
# From package root directory:

# 1. Open R
R

# 2. Then in R:
library(devtools)
document()
load_all()
source("test_consensus_local.R")

# Or run directly:
Rscript test_consensus_local.R
```

## What to Look For

### ✅ Success indicators:
- No errors during `document()`
- `load_all()` completes without errors
- Function runs and returns results
- Module assignments make sense
- Output structure is correct

### ❌ Problems to watch for:
- Errors during documentation
- Missing dependencies
- Function not found
- Incorrect output structure
- Crashes or hangs

## Troubleshooting

### "Function not found"
```r
devtools::document()
devtools::load_all()
```

### "NAMESPACE error"
Check that NAMESPACE contains:
```
export(netboost_consensus)
```

### "Missing dependencies"
```r
# Install any missing packages
install.packages(c("WGCNA", "dynamicTreeCut", "Rcpp", "RcppParallel"))
```

### "Documentation warnings"
```r
# Rebuild docs
devtools::document()
```

## After Testing Successfully

```bash
# In terminal:

# 1. Commit your changes
git add .
git commit -m "Add netboost_consensus function"

# 2. Push to GitHub (if you have a remote)
git push origin master

# 3. Install locally
# Back in R:
devtools::install()
```

## Quick Validation Checklist

- [ ] `devtools::document()` runs without errors
- [ ] `devtools::load_all()` runs without errors  
- [ ] Function exists: `exists("netboost_consensus")`
- [ ] Help page works: `?netboost_consensus`
- [ ] Test script runs: `source("test_consensus_local.R")`
- [ ] Results look reasonable
- [ ] No warnings or errors

## Example Output (What Success Looks Like)

```
Step 1: Rebuilding package...
ℹ Loading netboost
Writing NAMESPACE
Writing netboost_consensus.Rd

Step 2: Loading package functions...
ℹ Loading netboost

Step 3: Loading example data...

Step 4: Preparing test datasets...
Total samples: 180
Cohort 1: 90 samples x 5283 features
Cohort 2: 90 samples x 5283 features

=== TEST 1: Basic functionality with 'min' method ===
Netboost Consensus: Scaling and centering data.
...
✓ Test 1 completed successfully!
Modules found: 7

✅ ALL TESTS PASSED!
```
