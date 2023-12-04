# Load the installed packages
library(devtools)
library(roxygen2)
devtools::install_github("KambizKalhor/foldX.reader_package")

library(foldX.reader)
data <- read_fxout("/home/kkalhor/my_R_packages_on_github/foldX.reader/foldX.reader_package/foldx_output_example/0_unrelaxed_alphafold2_ptm_model_1_seed_000_0_ST.fxout")
glimpse(data)
 
multiple_data <- read_multiple_fxout("/home/kkalhor/my_R_packages_on_github/foldX.reader/foldX.reader_package/foldx_output_example/")
glimpse(multiple_data)
