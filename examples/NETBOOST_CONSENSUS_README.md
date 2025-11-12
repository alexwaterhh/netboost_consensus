# Netboost Consensus Clustering

## Overview

The `netboost_consensus` function extends the original `netboost` clustering approach to perform consensus network analysis across multiple datasets. This is similar to WGCNA's `blockwiseConsensusModules` function but uses the netboost filtering and sparse clustering approach.

## Key Features

- **Multiple Dataset Integration**: Analyze multiple datasets with the same features but different samples
- **TOM Calculation**: Computes Topological Overlap Matrix (TOM) for each dataset
- **Flexible Integration Methods**: Integrate TOMs using:
  - `"min"`: Minimum value (most conservative)
  - `"max"`: Maximum value (most liberal)
  - `"quantile.X"`: Any quantile (e.g., `"quantile.0.5"` for median)
- **Dynamic Tree Cutting**: Uses the same robust clustering approach as original netboost
- **Soft Power Control**: Specify different soft thresholds for each dataset

## Installation

This function is part of the netboost package. Install and load as usual:

```r
# Install if needed
# devtools::install()

library(netboost)
```

## Basic Usage

```r
# Load example data
data('tcga_aml_meth_rna_chr18', package='netboost')

# Create multiple datasets (e.g., split by samples)
set.seed(123)
n_samples <- nrow(tcga_aml_meth_rna_chr18)
idx1 <- sample(1:n_samples, size=floor(n_samples/2))
idx2 <- setdiff(1:n_samples, idx1)

datan_list <- list(
    tcga_aml_meth_rna_chr18[idx1, ],
    tcga_aml_meth_rna_chr18[idx2, ]
)

# Run consensus clustering
results <- netboost_consensus(
    datan_list = datan_list,
    stepno = 20L,
    soft_power = c(3L, 3L),  # One for each dataset
    consensus_method = "min",
    min_cluster_size = 10L,
    n_pc = 2,
    scale = TRUE,
    ME_diss_thres = 0.25,
    qc_plot = TRUE
)
```

## Parameters

### Required Parameters

- **`datan_list`**: List of data frames with same features (columns) but can have different samples (rows)

### Key Parameters

- **`soft_power`**: Vector of soft threshold powers, one for each dataset
  - If `NULL`, automatically determined for each dataset
  - Length must equal `length(datan_list)`

- **`consensus_method`**: How to integrate TOMs across datasets
  - `"min"`: Most conservative, requires agreement across datasets
  - `"max"`: Most liberal, accepts relationships from any dataset
  - `"quantile.0.25"`: 25th percentile
  - `"quantile.0.5"`: Median (balanced approach)
  - `"quantile.0.75"`: 75th percentile

- **`reference_data`**: Which dataset to use for calculating module eigengenes (default: 1)

### Other Parameters

All other parameters work the same as in the original `netboost` function:
- `stepno`: Boosting steps (default: 20L)
- `min_cluster_size`: Minimum module size (default: 2L)
- `ME_diss_thres`: Module eigengene dissimilarity threshold (default: 0.25)
- `n_pc`: Number of principal components (default: 1)
- `scale`: Scale and center data (default: TRUE)
- `cores`: Number of CPU cores (default: 2)

## Output

The function returns all the standard netboost outputs plus:

- **`consensus_filter`**: The union of all edges across datasets
- **`consensus_TOM`**: The integrated TOM distance matrix
- **`individual_filters`**: List of filter matrices for each dataset
- **`soft_power`**: Vector of soft powers used for each dataset
- **`consensus_method`**: The integration method used
- **`n_datasets`**: Number of datasets analyzed
- **`reference_data`**: Which dataset was used for module eigengenes

Standard outputs include:
- **`colors`**: Module assignments for each feature
- **`MEs`**: Module eigengenes
- **`var_explained`**: Variance explained by each module
- **`dendros`**: Dendrograms for visualization

## Choosing Integration Methods

### When to use "min" (Conservative)
- When you want modules that are consistently present across all datasets
- Reduces false positives
- May miss dataset-specific relationships

### When to use "max" (Liberal)
- When relationships in any dataset are meaningful
- Captures dataset-specific modules
- May include more false positives

### When to use quantiles (Balanced)
- `"quantile.0.5"` (median): Balanced approach
- `"quantile.0.25"`: More conservative than median
- `"quantile.0.75"`: More liberal than median

## Example Workflows

### Example 1: Multi-Tissue Study
```r
# Analyze same genes in different tissues
tissue_list <- list(
    brain = brain_expression_data,
    liver = liver_expression_data,
    heart = heart_expression_data
)

results <- netboost_consensus(
    datan_list = tissue_list,
    consensus_method = "quantile.0.5",  # Median
    min_cluster_size = 20L,
    qc_plot = TRUE
)
```

### Example 2: Multi-Omics Integration
```r
# Integrate methylation and expression data
omics_list <- list(
    methylation = meth_data,
    expression = expr_data
)

results <- netboost_consensus(
    datan_list = omics_list,
    soft_power = c(6L, 3L),  # Different powers for different data types
    consensus_method = "min",  # Conservative
    reference_data = 2  # Use expression for eigengenes
)
```

### Example 3: Batch Effect Analysis
```r
# Compare modules across batches
batch_list <- list(
    batch1 = data_batch1,
    batch2 = data_batch2,
    batch3 = data_batch3
)

results <- netboost_consensus(
    datan_list = batch_list,
    consensus_method = "quantile.0.75",
    min_cluster_size = 15L
)
```

## Comparison with WGCNA

| Feature | netboost_consensus | WGCNA blockwiseConsensusModules |
|---------|-------------------|--------------------------------|
| Filtering | Boosting-based edge filtering | All pairwise correlations |
| Scalability | Handles millions of features | Limited by memory |
| Clustering | Sparse UPGMA | Standard hierarchical |
| Integration | min/max/quantile on TOM | min/max/quantile on adjacency |
| Module Detection | Dynamic tree cut | Dynamic tree cut |

## Performance Tips

1. **Use filtering**: The boosting filter reduces computation time dramatically
2. **Adjust `stepno`**: Lower values (10-20) for exploration, higher (50+) for final analysis
3. **Parallel processing**: Set `cores` to use multiple CPUs
4. **Memory**: Consensus filtering uses less memory than full correlation matrices

## Troubleshooting

### Error: "All datasets must have the same features"
- Ensure all data frames in `datan_list` have identical column names
- Check that features are in the same order

### Error: "soft_power must have length equal to length(datan_list)"
- Provide one soft power value for each dataset
- Or set `soft_power = NULL` for automatic determination

### Warning: "A bug in sparse UPGMA currently prevents analyses with more than 5 million features"
- Reduce the number of features through pre-filtering
- Focus on most variable features

## Citation

If you use netboost_consensus, please cite:

[Original netboost citation] + this extension

## See Also

- `netboost()`: Original single-dataset clustering
- `nb_filter()`: Feature filtering function
- `nb_dist()`: Distance calculation
- `nb_clust()`: Clustering step
