# Example usage of netboost_consensus function
# This script demonstrates how to use the new consensus clustering function

# Load the package (assuming it's installed)
# library(netboost)

# Load example data
data('tcga_aml_meth_rna_chr18', package='netboost')

# Example 1: Split data by samples to create multiple datasets
# This simulates having the same features measured in different conditions/cohorts
set.seed(123)
n_samples <- nrow(tcga_aml_meth_rna_chr18)
idx1 <- sample(1:n_samples, size=floor(n_samples/2))
idx2 <- setdiff(1:n_samples, idx1)

# Create a list of datasets
datan_list <- list(
    dataset1 = tcga_aml_meth_rna_chr18[idx1, ],
    dataset2 = tcga_aml_meth_rna_chr18[idx2, ]
)

cat("Dataset 1 dimensions:", dim(datan_list[[1]]), "\n")
cat("Dataset 2 dimensions:", dim(datan_list[[2]]), "\n")

# Example 2: Run consensus clustering with minimum integration
# This takes the minimum TOM value across datasets (most conservative)
cat("\n=== Running netboost_consensus with 'min' method ===\n")
results_min <- netboost_consensus(
    datan_list = datan_list,
    stepno = 20L,
    soft_power = c(3L, 3L),  # One soft power for each dataset
    consensus_method = "min",
    min_cluster_size = 10L,
    n_pc = 2,
    scale = TRUE,
    ME_diss_thres = 0.25,
    qc_plot = FALSE,  # Set to TRUE to see plots
    verbose = TRUE
)

cat("\nNumber of modules found:", length(unique(results_min$colors)), "\n")
cat("Module sizes:\n")
print(table(results_min$colors))

# Example 3: Run consensus clustering with median integration
# This takes the median TOM value across datasets
cat("\n=== Running netboost_consensus with 'quantile.0.5' (median) method ===\n")
results_median <- netboost_consensus(
    datan_list = datan_list,
    stepno = 20L,
    soft_power = c(3L, 3L),
    consensus_method = "quantile.0.5",  # Median
    min_cluster_size = 10L,
    n_pc = 2,
    scale = TRUE,
    ME_diss_thres = 0.25,
    qc_plot = FALSE,
    verbose = TRUE
)

cat("\nNumber of modules found:", length(unique(results_median$colors)), "\n")
cat("Module sizes:\n")
print(table(results_median$colors))

# Example 4: Run consensus clustering with maximum integration
# This takes the maximum TOM value across datasets (most liberal)
cat("\n=== Running netboost_consensus with 'max' method ===\n")
results_max <- netboost_consensus(
    datan_list = datan_list,
    stepno = 20L,
    soft_power = c(3L, 3L),
    consensus_method = "max",
    min_cluster_size = 10L,
    n_pc = 2,
    scale = TRUE,
    ME_diss_thres = 0.25,
    qc_plot = FALSE,
    verbose = TRUE
)

cat("\nNumber of modules found:", length(unique(results_max$colors)), "\n")
cat("Module sizes:\n")
print(table(results_max$colors))

# Example 5: Compare results across methods
cat("\n=== Comparison of Methods ===\n")
cat("Min method - Modules:", length(unique(results_min$colors)), "\n")
cat("Median method - Modules:", length(unique(results_median$colors)), "\n")
cat("Max method - Modules:", length(unique(results_max$colors)), "\n")

# Example 6: Access consensus-specific results
cat("\n=== Consensus-specific information ===\n")
cat("Number of datasets:", results_min$n_datasets, "\n")
cat("Consensus method:", results_min$consensus_method, "\n")
cat("Soft power values:", results_min$soft_power, "\n")
cat("Reference dataset:", results_min$reference_data, "\n")
cat("Consensus filter edges:", nrow(results_min$consensus_filter), "\n")
cat("Individual filter edges:", 
    sapply(results_min$individual_filters, nrow), "\n")

# Example 7: Using automatic soft power determination
cat("\n=== Running with automatic soft power determination ===\n")
results_auto <- netboost_consensus(
    datan_list = datan_list,
    stepno = 20L,
    soft_power = NULL,  # Will be determined automatically
    consensus_method = "min",
    min_cluster_size = 10L,
    n_pc = 2,
    scale = TRUE,
    ME_diss_thres = 0.25,
    qc_plot = FALSE,
    verbose = TRUE
)

cat("Automatically determined soft powers:", results_auto$soft_power, "\n")

# Example 8: Using a different quantile (75th percentile)
cat("\n=== Running with 75th percentile ===\n")
results_q75 <- netboost_consensus(
    datan_list = datan_list,
    stepno = 20L,
    soft_power = c(3L, 3L),
    consensus_method = "quantile.0.75",
    min_cluster_size = 10L,
    n_pc = 2,
    scale = TRUE,
    ME_diss_thres = 0.25,
    qc_plot = FALSE,
    verbose = TRUE
)

cat("Number of modules found:", length(unique(results_q75$colors)), "\n")

# Example 9: Accessing module eigengenes
cat("\n=== Module Eigengenes ===\n")
cat("Module eigengene dimensions:", dim(results_min$MEs), "\n")
cat("Module eigengene names:", colnames(results_min$MEs), "\n")

# Example 10: Plotting results (if qc_plot was enabled)
# If you want to see plots, rerun with qc_plot=TRUE:
# pdf("netboost_consensus_plots.pdf", width=30)
# results_with_plots <- netboost_consensus(
#     datan_list = datan_list,
#     stepno = 20L,
#     soft_power = c(3L, 3L),
#     consensus_method = "min",
#     min_cluster_size = 10L,
#     n_pc = 2,
#     scale = TRUE,
#     ME_diss_thres = 0.25,
#     qc_plot = TRUE,
#     verbose = TRUE
# )
# dev.off()

cat("\n=== Example completed successfully! ===\n")
