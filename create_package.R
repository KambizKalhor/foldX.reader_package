# create_package("path")
 
# Install devtools if not installed
if (!requireNamespace("devtools", quietly = TRUE)) {
  install.packages("devtools")
}

# Install roxygen2 if not installed
if (!requireNamespace("roxygen2", quietly = TRUE)) {
  install.packages("roxygen2")
}

# Load the installed packages
library(devtools)
library(roxygen2)

#use_git()

# add a function
use_r("read_multiple_fxout_function.R")
use_r("read_fxout_function.R")

# load all functions
load_all()

# test if functions are loaded
#path <- "/Users/kami/my_GitHub_Repository/my_R_packages/foldX.reader/foldx_output_example"
#multiple_output_dataframe = read_multiple_fxout(path, visualize = TRUE)

check()

use_mit_license()

# trigger documentation creation
document()

# load all functions again
load_all()
?read_fxout
?read_multiple_fxout


# usage
# whenever we want to use or package use the command below
#devtools::install_git("path_to_package_directory")
#devtools::install_git("/Users/kami/my_GitHub_Repository/my_R_packages/foldX.reader/")



# making vinnet video 8_nov 47:00
