# Subsample numeric vector1 to match the mean of numeric vector2
set.seed(1234)

library(tidyverse)

# Example vectors # vector 1 will be e.g. eur
# vector 2 will be e.g. afr
vector1 = round(rnorm(8000, mean = 30, sd = 10))
names(vector1) = paste0("id.", 1:8000) # Names can be e.g. trio IDs
vector2 = round(rnorm(200, mean = 33, sd = 10))
names(vector2) = paste0("id.", 1:200)

# Calculate the means
mean1 = mean(vector1)
mean2 = mean(vector2)

# Function to find a subsample of vector to approximate target mean
find_subsample = function(vector, target_mean, tolerance = 0.01, 
                           max_iter = 1000, p=0.8) {
  # Random sample "sample_size" elements from the original vector
  sample_size = length(vector)*p  # Initial sample size, adjust as needed
  current_sample = sample(vector, sample_size)
  
  best_sample = current_sample
  # Check the difference between means: random subsample vs target mean
  best_diff = abs(mean(current_sample) - target_mean) 
  
  # Perform n iterations
  for (i in 1:max_iter) {
    # iteratively replace elements in the random sample with elements from the 
    # original vector
    for (j in 1:sample_size) {
      # Replace element j with another random element from the original vector
      new_sample = current_sample
      new_sample[j] = sample(vector, 1) 
      # check differences between mean and target mean
      new_diff = abs(mean(new_sample) - target_mean)
      
      if (new_diff < best_diff) {
        best_diff = new_diff
        best_sample = new_sample
        current_sample = new_sample
      }
    }
    
    if (best_diff < tolerance) {
      break
    }
  }
  
  return(best_sample)
}

# Subsample vector2 to approximate the mean of vector1
subsample_vector2 = find_subsample(vector2, mean1)
subsample_vector2 = find_subsample(vector2, mean1)

# The other way around
subsample_vector1 = find_subsample(vector1, mean2)
