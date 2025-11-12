# Quick Start Guide: netboost_consensus

## 5-Minute Tutorial

### 1. Load Package and Data
```r
library(netboost)
data('tcga_aml_meth_rna_chr18', package='netboost')
```

### 2. Prepare Multiple Datasets
```r
# Split into two cohorts
set.seed(123)
n <- nrow(tcga_aml_meth_rna_chr18)
idx1 <- sample(1:n, size=floor(n/2))
idx2 <- setdiff(1:n, idx1)

datan_list <- list(
    tcga_aml_meth_rna_chr18[idx1, ],
    tcga_aml_meth_rna_chr18[idx2, ]
)
```

### 3. Run Consensus Clustering
```r
results <- netboost_consensus(
    datan_list = datan_list,
    stepno = 20L,
    soft_power = c(3L, 3L),
    consensus_method = "min",
    min_cluster_size = 10L,
    n_pc = 2,
    scale = TRUE,
    ME_diss_thres = 0.25
)
```

### 4. Examine Results
```r
# How many modules?
table(results$colors)

# Module eigengenes
head(results$MEs)

# Consensus info
results$consensus_method
results$n_datasets
```

## That's it! 🎉

For more details, see:
- `?netboost_consensus` for function documentation
- `examples/NETBOOST_CONSENSUS_README.md` for comprehensive guide
- `examples/netboost_consensus_example.R` for more examples
- `vignettes/netboost_consensus.Rmd` for full vignette

## Key Points to Remember

✓ All datasets must have **same features** (columns)  
✓ Datasets can have **different samples** (rows)  
✓ Specify one **soft_power** per dataset (or use NULL for auto)  
✓ Choose **consensus_method**: "min", "max", or "quantile.X"  
✓ All standard netboost parameters work the same way  

## Common Use Cases

| Scenario | Recommended Method |
|----------|-------------------|
| Conservative modules | `"min"` |
| Balanced approach | `"quantile.0.5"` (median) |
| Include dataset-specific | `"max"` |
| Multi-tissue conserved | `"min"` |
| Batch effect robust | `"quantile.0.75"` |

## Integration Methods Explained

- **"min"**: Takes minimum TOM → Most conservative, only keeps relationships strong in ALL datasets
- **"max"**: Takes maximum TOM → Most liberal, keeps relationships strong in ANY dataset  
- **"quantile.0.5"**: Takes median → Balanced middle ground (recommended default)
- **"quantile.0.25"**: 25th percentile → Moderately conservative
- **"quantile.0.75"**: 75th percentile → Moderately liberal

## Troubleshooting

**Error: "All datasets must have the same features"**
→ Make sure all data frames have identical column names

**Error: "soft_power must have length equal to length(datan_list)"**
→ Provide one power value per dataset, or use `soft_power = NULL`

**Slow performance?**
→ Use `cores = 4` (or more) for parallel processing
→ Reduce `stepno` for faster exploration (try 10L)

**Want automatic soft power?**
→ Set `soft_power = NULL` and it will be determined automatically

## Next Steps

Once you have results, you can:

1. **Visualize modules**
```r
nb_plot_dendro(results, labels = FALSE, colorsrandom = TRUE)
```

2. **Transfer to new data**
```r
new_MEs <- nb_transfer(results, new_data = new_samples)
```

3. **Export module assignments**
```r
module_assignments <- data.frame(
    feature = names(results$colors),
    module = results$colors
)
write.csv(module_assignments, "modules.csv")
```

4. **Get module features**
```r
# Features in module 3
module_3 <- names(results$colors[results$colors == 3])
```

## Example Output

```r
> table(results$colors)
  0   1   2   3   4   5   6 
123  45  67  89  34  28  19

> results$n_datasets
[1] 2

> results$consensus_method
[1] "min"

> dim(results$MEs)
[1] 90  6
```

## Help & Resources

- Function help: `?netboost_consensus`
- Package vignette: `vignette("netboost_consensus")`
- Examples: `system.file("examples", package="netboost")`
- GitHub issues: [your-repo-url]

Happy clustering! 🚀
