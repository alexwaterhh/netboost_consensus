# Testing Checklist for netboost_consensus

## Pre-Testing Setup
- [ ] Package compiles without errors: `devtools::check()`
- [ ] Documentation builds: `devtools::document()`
- [ ] Package loads: `library(netboost)`
- [ ] Help page accessible: `?netboost_consensus`

## Basic Functionality Tests

### Input Validation
- [ ] Error on NULL datan_list
- [ ] Error on non-list datan_list
- [ ] Error on single dataset (< 2 datasets)
- [ ] Error on non-data.frame elements
- [ ] Error on mismatched feature counts
- [ ] Error on mismatched feature names
- [ ] Error on invalid stepno
- [ ] Error on invalid min_cluster_size
- [ ] Error on invalid ME_diss_thres
- [ ] Error on wrong soft_power length
- [ ] Error on invalid consensus_method
- [ ] Error on invalid quantile value

### Core Functionality
- [ ] Runs with 2 datasets
- [ ] Runs with 3+ datasets
- [ ] Runs with scaling (scale=TRUE)
- [ ] Runs without scaling (scale=FALSE)
- [ ] Runs with automatic soft_power (soft_power=NULL)
- [ ] Runs with manual soft_power vector
- [ ] Returns expected output structure
- [ ] All output fields present

### Consensus Methods
- [ ] "min" method works
- [ ] "max" method works
- [ ] "quantile.0.25" works
- [ ] "quantile.0.5" works (median)
- [ ] "quantile.0.75" works
- [ ] "quantile.0.1" works
- [ ] "quantile.0.9" works
- [ ] Results differ across methods (as expected)

### Reference Dataset
- [ ] reference_data=1 works
- [ ] reference_data=2 works
- [ ] reference_data=last dataset works
- [ ] reference_data=NULL defaults to 1
- [ ] Error on invalid reference_data

### Parallelization
- [ ] cores=1 (sequential) works
- [ ] cores=2 works
- [ ] cores=4+ works
- [ ] Results consistent across core counts

## Integration Tests

### Example Data
- [ ] Runs on tcga_aml_meth_rna_chr18 (split)
- [ ] Produces reasonable number of modules
- [ ] Module sizes are reasonable
- [ ] Module eigengenes calculated correctly
- [ ] Colors assigned correctly

### Output Validation
- [ ] dendros is list of dendrograms
- [ ] names matches feature names
- [ ] colors is vector with correct length
- [ ] MEs dimensions correct
- [ ] var_explained present
- [ ] rotation present
- [ ] consensus_filter is matrix
- [ ] consensus_TOM is vector
- [ ] individual_filters is list
- [ ] n_datasets matches input
- [ ] soft_power vector correct

### Compatibility
- [ ] Output works with nb_plot_dendro()
- [ ] Output works with nb_transfer()
- [ ] Output works with nb_summary() (if applicable)
- [ ] Standard netboost visualizations work

## Performance Tests

### Small Data (< 1000 features)
- [ ] Completes in reasonable time
- [ ] Memory usage acceptable
- [ ] No warnings or errors

### Medium Data (1000-10000 features)
- [ ] Completes successfully
- [ ] Progress messages appear
- [ ] Memory usage acceptable

### Large Data (10000+ features)
- [ ] Completes or fails gracefully
- [ ] Memory usage monitored
- [ ] Consider skip if too large

## Edge Cases

### Data Characteristics
- [ ] All identical samples across datasets
- [ ] Completely different samples
- [ ] Overlapping samples (if possible)
- [ ] Single feature (edge case)
- [ ] Very few features (< 10)
- [ ] Very few samples (< 10)

### Module Detection
- [ ] Single module result
- [ ] Many modules result
- [ ] All features in one module
- [ ] Most features unassigned (module 0)

### Special Values
- [ ] Missing values in data (NAs)
- [ ] Constant features
- [ ] Highly correlated features
- [ ] Completely independent features

## Comparison Tests

### Method Comparison
- [ ] min < median < max (generally)
- [ ] Module counts differ appropriately
- [ ] Edge counts in filters make sense

### vs Standard netboost
- [ ] With single dataset = similar to netboost()
- [ ] Consensus more robust than single dataset
- [ ] Results interpretable and sensible

## Documentation Tests

### Help System
- [ ] `?netboost_consensus` displays correctly
- [ ] All parameters documented
- [ ] Examples are executable
- [ ] Examples run without error

### Examples
- [ ] examples/netboost_consensus_example.R runs
- [ ] All 10 examples execute successfully
- [ ] Output makes sense

### Vignette
- [ ] Vignette builds: `devtools::build_vignettes()`
- [ ] Code chunks execute
- [ ] Plots generate
- [ ] No errors in vignette

## Stress Tests

### Extreme Parameters
- [ ] stepno = 1L (minimal filtering)
- [ ] stepno = 100L (heavy filtering)
- [ ] min_cluster_size = 1L
- [ ] min_cluster_size = 100L
- [ ] ME_diss_thres = 0 (no merging)
- [ ] ME_diss_thres = 0.9 (heavy merging)

### Multiple Datasets
- [ ] 2 datasets
- [ ] 3 datasets
- [ ] 5 datasets
- [ ] 10 datasets
- [ ] Check memory scaling

## Real-World Use Cases

### Multi-Tissue
- [ ] Create tissue-split data
- [ ] Run consensus
- [ ] Results biologically sensible

### Batch Effects
- [ ] Create batch-split data
- [ ] Run consensus
- [ ] Robust to batch effects

### Multi-Omics
- [ ] Use different data types
- [ ] Different soft powers
- [ ] Results integrate well

## Regression Tests

If updating in future:
- [ ] Old results reproducible
- [ ] No unexpected changes
- [ ] Backward compatibility maintained

## Code Quality

### Style
- [ ] Code follows package style
- [ ] Proper indentation
- [ ] Clear variable names
- [ ] Comments where needed

### Error Handling
- [ ] Clear error messages
- [ ] Helpful warnings
- [ ] Informative verbose output

### Performance
- [ ] No obvious inefficiencies
- [ ] Proper use of vectorization
- [ ] Minimal copying of large objects

## Final Checks

### Before Release
- [ ] All tests pass
- [ ] No errors in R CMD check
- [ ] Version number updated
- [ ] NEWS file updated
- [ ] README updated if needed
- [ ] Examples work on clean install

### Documentation Complete
- [ ] Function documentation complete
- [ ] Vignette reviewed
- [ ] Examples reviewed
- [ ] README reviewed

## Test Results Summary

| Test Category | Pass | Fail | Notes |
|--------------|------|------|-------|
| Input Validation | | | |
| Core Functionality | | | |
| Consensus Methods | | | |
| Integration Tests | | | |
| Performance | | | |
| Edge Cases | | | |
| Documentation | | | |

## Notes
```
[Add any notes here during testing]
```

## Issues Found
```
[List any issues discovered during testing]
```

## Recommended Fixes
```
[List recommended fixes for issues found]
```
