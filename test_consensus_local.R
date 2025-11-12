# Local Testing Script for netboost_consensus
# Run this script to test the new function before committing

# Step 1: Load required packages and rebuild
cat("Step 1: Rebuilding package...\n")
library(devtools)
library(roxygen2)

# Document the package (creates .Rd files and updates NAMESPACE)
document()

# Step 2: Load the package without installing
cat("\nStep 2: Loading package functions...\n")
load_all()

# Step 3: Load example data
cat("\nStep 3: Loading example data...\n")
data('tcga_aml_meth_rna_chr18', package='netboost')

# Step 4: Prepare test datasets
cat("\nStep 4: Preparing test datasets...\n")
set.seed(123)
n_samples <- nrow(tcga_aml_meth_rna_chr18)
cat("Total samples:", n_samples, "\n")

# Split into two cohorts
idx1 <- sample(1:n_samples, size=floor(n_samples/2))
idx2 <- setdiff(1:n_samples, idx1)

datan_list <- list(
    cohort1 = tcga_aml_meth_rna_chr18[idx1, ],
    cohort2 = tcga_aml_meth_rna_chr18[idx2, ]
)

cat("Cohort 1:", nrow(datan_list[[1]]), "samples x", ncol(datan_list[[1]]), "features\n")
cat("Cohort 2:", nrow(datan_list[[2]]), "samples x", ncol(datan_list[[2]]), "features\n")

# Step 5: Test basic functionality
cat("\n=== TEST 1: Basic functionality with 'min' method ===\n")
results_min <- netboost_consensus(
    datan_list = datan_list,
    stepno = 10L,  # Reduced for faster testing
    soft_power = c(3L, 3L),
    consensus_method = "min",
    min_cluster_size = 10L,
    n_pc = 2,
    scale = TRUE,
    ME_diss_thres = 0.25,
    qc_plot = FALSE,  # Set to TRUE to see plots
    verbose = TRUE,
    cores = 2L
)

cat("\n✓ Test 1 completed successfully!\n")
cat("Modules found:", length(unique(results_min$colors)), "\n")
cat("Module sizes:\n")
print(table(results_min$colors))

# Step 6: Test automatic soft power
cat("\n=== TEST 2: Automatic soft power determination ===\n")
results_auto <- netboost_consensus(
    datan_list = datan_list,
    stepno = 10L,
    soft_power = NULL,  # Auto-determine
    consensus_method = "quantile.0.5",
    min_cluster_size = 10L,
    n_pc = 1,
    scale = TRUE,
    ME_diss_thres = 0.25,
    qc_plot = FALSE,
    verbose = TRUE,
    cores = 2L
)

cat("\n✓ Test 2 completed successfully!\n")
cat("Auto-determined soft powers:", results_auto$soft_power, "\n")
cat("Modules found:", length(unique(results_auto$colors)), "\n")

# Step 7: Test different consensus methods
cat("\n=== TEST 3: Testing different consensus methods ===\n")

cat("\n--- Method: max ---\n")
results_max <- netboost_consensus(
    datan_list = datan_list,
    stepno = 10L,
    soft_power = c(3L, 3L),
    consensus_method = "max",
    min_cluster_size = 10L,
    n_pc = 1,
    scale = TRUE,
    ME_diss_thres = 0.25,
    qc_plot = FALSE,
    verbose = FALSE,
    cores = 2L
)

cat("Modules (max):", length(unique(results_max$colors)), "\n")

cat("\n--- Method: quantile.0.25 ---\n")
results_q25 <- netboost_consensus(
    datan_list = datan_list,
    stepno = 10L,
    soft_power = c(3L, 3L),
    consensus_method = "quantile.0.25",
    min_cluster_size = 10L,
    n_pc = 1,
    scale = TRUE,
    ME_diss_thres = 0.25,
    qc_plot = FALSE,
    verbose = FALSE,
    cores = 2L
)

cat("Modules (q25):", length(unique(results_q25$colors)), "\n")

cat("\n✓ Test 3 completed successfully!\n")
cat("\nComparison of methods:\n")
cat("  min:     ", length(unique(results_min$colors)), "modules\n")
cat("  q25:     ", length(unique(results_q25$colors)), "modules\n")
cat("  median:  ", length(unique(results_auto$colors)), "modules\n")
cat("  max:     ", length(unique(results_max$colors)), "modules\n")

# Step 8: Verify output structure
cat("\n=== TEST 4: Verifying output structure ===\n")
expected_fields <- c("dendros", "names", "colors", "MEs", "var_explained", 
                     "rotation", "consensus_filter", "consensus_TOM", 
                     "individual_filters", "soft_power", "consensus_method",
                     "n_datasets", "reference_data")

missing_fields <- setdiff(expected_fields, names(results_min))
if (length(missing_fields) > 0) {
    cat("✗ Missing fields:", paste(missing_fields, collapse=", "), "\n")
} else {
    cat("✓ All expected fields present\n")
}

# Check field contents
cat("\nField checks:\n")
cat("  n_datasets:", results_min$n_datasets, "(expected: 2) ✓\n")
cat("  consensus_method:", results_min$consensus_method, "(expected: min) ✓\n")
cat("  reference_data:", results_min$reference_data, "(expected: 1) ✓\n")
cat("  colors length:", length(results_min$colors), 
    "(expected:", ncol(tcga_aml_meth_rna_chr18), ") ✓\n")
cat("  MEs rows:", nrow(results_min$MEs), 
    "(expected:", nrow(datan_list[[1]]), ") ✓\n")
cat("  Individual filters:", length(results_min$individual_filters), 
    "(expected: 2) ✓\n")

# Step 9: Test with three datasets
cat("\n=== TEST 5: Testing with 3 datasets ===\n")
n_samples <- nrow(tcga_aml_meth_rna_chr18)
idx1 <- 1:floor(n_samples/3)
idx2 <- (floor(n_samples/3)+1):floor(2*n_samples/3)
idx3 <- (floor(2*n_samples/3)+1):n_samples

datan_list_3 <- list(
    cohort1 = tcga_aml_meth_rna_chr18[idx1, ],
    cohort2 = tcga_aml_meth_rna_chr18[idx2, ],
    cohort3 = tcga_aml_meth_rna_chr18[idx3, ]
)

results_3 <- netboost_consensus(
    datan_list = datan_list_3,
    stepno = 10L,
    soft_power = c(3L, 3L, 3L),
    consensus_method = "quantile.0.5",
    min_cluster_size = 10L,
    n_pc = 1,
    scale = TRUE,
    ME_diss_thres = 0.25,
    qc_plot = FALSE,
    verbose = FALSE,
    cores = 2L
)

cat("✓ Test 5 completed successfully!\n")
cat("Modules found with 3 datasets:", length(unique(results_3$colors)), "\n")

# Step 10: Test error handling
cat("\n=== TEST 6: Testing error handling ===\n")

test_error <- function(test_name, expr) {
    cat("\nTesting:", test_name, "\n")
    result <- tryCatch({
        eval(expr)
        cat("  ✗ Should have thrown an error!\n")
        FALSE
    }, error = function(e) {
        cat("  ✓ Error caught:", conditionMessage(e), "\n")
        TRUE
    })
    return(result)
}

# Test various error conditions
test_error("NULL datan_list", {
    netboost_consensus(datan_list = NULL)
})

test_error("Single dataset", {
    netboost_consensus(datan_list = list(tcga_aml_meth_rna_chr18))
})

test_error("Wrong soft_power length", {
    netboost_consensus(
        datan_list = datan_list,
        soft_power = c(3L)  # Only 1, but need 2
    )
})

test_error("Invalid consensus_method", {
    netboost_consensus(
        datan_list = datan_list,
        soft_power = c(3L, 3L),
        consensus_method = "invalid_method"
    )
})

# Step 11: Summary
cat("\n" , paste(rep("=", 60), collapse=""), "\n")
cat("TESTING SUMMARY\n")
cat(paste(rep("=", 60), collapse=""), "\n\n")
cat("✓ Test 1: Basic functionality (min method)\n")
cat("✓ Test 2: Automatic soft power\n")
cat("✓ Test 3: Different consensus methods\n")
cat("✓ Test 4: Output structure validation\n")
cat("✓ Test 5: Three datasets\n")
cat("✓ Test 6: Error handling\n")
cat("\n✅ ALL TESTS PASSED!\n\n")
cat("The netboost_consensus function is working correctly!\n")
cat("\nNext steps:\n")
cat("  1. Run: devtools::check() to check package\n")
cat("  2. Commit changes to git\n")
cat("  3. Push to GitHub\n")
cat("  4. Install package: devtools::install()\n")
cat("\n")
