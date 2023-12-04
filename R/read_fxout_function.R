#' FoldX Reader Package
#' @name read_fxout
#' @description
#' The foldX.reader package provides a toolkit for seamlessly importing data from files with a .fxout extension into R, facilitating the creation of database for efficient data management and analysis. for multiple inputs, this package streamlines the process of parsing, organizing, and storing .fxout files into a structured database format and visualize the input. this package has been tested for foldx version 5.
#' @author Kambiz Kalhor
#'
#'
#' @usage read_fxout(path)
#' # read a fxout file
#' @usage data <- read_fxout(path)
#' # save as dataframe object
#' @usage data.Backbone_Hbond
#' # access to values in dataframe
#'
#'
#' @param path path to file with .fxout extension.
#' @return dataframe
#'
#'
#' @details
#'| **Title**                                                                      | **energy_description**                                                     | **access**|
#'|---------------------------|---------------------------|------------------|
#'| [Total Energy](https://foldxsuite.crg.eu/energy/TotalEnergy)                   | This is the predicted overall stability of your protein                    |`data.Total_Energy`|
#'| [Backbone Hbond](https://foldxsuite.crg.eu/energy/BackboneHbond)               | This the contribution of backbone Hbonds                                   |`data.Backbone_Hbond`|
#'| [Sidechain Hbond](https://foldxsuite.crg.eu/energy/SidechainHbond)             | This the contribution of sidechain-sidechain and sidechain-backbone Hbonds |`code block`|
#'| [Van der Waals](https://foldxsuite.crg.eu/energy/VanderWaals)                  | Contribution of the VanderWaals                                            |`code block`|
#'| [Electrostatics](https://foldxsuite.crg.eu/energy/Electrostatics)              | Electrostatic interactions                                                 |`code block`|
#'| [Solvation Polar](https://foldxsuite.crg.eu/energy/SolvationPolar)             | Penalization for burying polar groups                                      |`code block`|
#'| [Solvation Hydrophobic](https://foldxsuite.crg.eu/energy/SolvationHydrophobic) | Contribution of hydrophobic groups                                         |`code block`|
#'| [Van der Waals clashes](https://foldxsuite.crg.eu/energy/VanderWaalsclashes)   | Energy penalization due to VanderWaals' clashes (interresidue)             |`code block`|
#'| [Entropy Side Chain](https://foldxsuite.crg.eu/energy/EntropySideChain)        | Entropy cost of fixing the side chain                                      |`code block`|
#'| [Entropy Main Chain](https://foldxsuite.crg.eu/energy/EntropyMainChain)        | Entropy cost of fixing the main chain                                      |`code block`|
#'| [Sloop Entropy](https://foldxsuite.crg.eu/energy/SloopEntropy)                 | ONLY FOR ADVANCED USERS                                                    |`code block`|
#'| [Mloop Entropy](https://foldxsuite.crg.eu/energy/MloopEntropy)                 | ONLY FOR ADVANCED USERS                                                    |`code block`|
#'| [Cis Bond](https://foldxsuite.crg.eu/energy/CisBond)                           | Cost of having a cis peptide bond                                          |`code block`|
#'| [Torsional Clash](https://foldxsuite.crg.eu/energy/TorsionalClash)             | VanderWaals' torsional clashes (intraresidue)                              |`code block`|
#'| [Backbone Clash](https://foldxsuite.crg.eu/energy/BackboneClash)               | Backbone-backbone VanderWaals. These are not considered in the total       |`code block`|
#'| [Helix Dipole](https://foldxsuite.crg.eu/energy/HelixDipole)                   | Electrostatic contribution of the helix dipole                             |`code block`|
#'| [Water Bridge](https://foldxsuite.crg.eu/energy/WaterBridge)                   | Contribution of water bridges                                              |`code block`|
#'| [Disulfide](https://foldxsuite.crg.eu/energy/Disulfide)                        | Contribution of disulfide bonds                                            |`code block`|
#'| [Electrostatic Kon](https://foldxsuite.crg.eu/energy/ElectrostaticKon)         | Electrostatic interaction between molecules in the precomplex              |`code block`|
#'| [Partial Covalent Bonds](https://foldxsuite.crg.eu/energyPartialCovalentBonds) | Interactions with bound metals                                             |`code block`|
#'| [Energy Ionisation](https://foldxsuite.crg.eu/energy/EnergyIonisation)         | Contribution of ionisation energy                                          |`code block`|
#'| [Entropy Complex](https://foldxsuite.crg.eu/energy/EntropyComplex)             | Entropy cost of forming a complex                                          |`code block`|
#'| [Residue Number](https://foldxsuite.crg.eu/energy/ResidueNumber)               | Number of residues                                                         |`code block`|
#'
#'
#'
#' @seealso [read_multiple_fxout()]
#'
#' @references FoldX is a molecular modeling software primarily used for protein structure prediction, protein design, and protein engineering studies. It's specifically focused on studying the structure-function relationship of proteins. The software employs empirical force fields and algorithms to predict the stability changes in proteins caused by mutations, analyze protein-protein interactions, and perform protein design experiments. The FoldX Suite builds on the strong fundament of advanced protein design features, already implemented in the successful FoldX3, and exploits the power of fragment libraries, by integrating in silico digested backbone protein fragments of different lengths. Such fragment-based strategy allows for new powerful capabilities: loop reconstruction, implemented in LoopX and peptide docking, implemented in PepX. The Suite also features an improved usability, thanks to a new boost Command Line Interface.
#' @references [FoldX website](https://foldxsuite.crg.eu/)
#'
#' @export


# install and call required packages

# Install tidyverse if not installed
if (!requireNamespace("tidyverse", quietly = TRUE)) {
  install.packages("tidyverse")
}

# Install fs if not installed
if (!requireNamespace("fs", quietly = TRUE)) {
  install.packages("fs")
}

# Install devtools if not installed
if (!requireNamespace("devtools", quietly = TRUE)) {
  install.packages("devtools")
}

# Load the installed packages
library(devtools)
library(tidyverse)
library(fs)


## important functions to save image
# function to save plots
save_plot <- function(fig, save_output_path, file_name_png) {
  path <- sub("file_name", file_name_png,
              save_output_path)
  ggsave(path,
         fig ,
         height = 15, width = 20,units = 'cm', dpi = 300 )
}


# read single fxout function
# Define a function that takes a single foldx output (.fxout) and gives a dataframe as output
read_fxout <- function(path) {

  # read the input
  input_string <- read_file(path)

  # make a vector from input
  data <- input_string |>
    str_replace('\n', '') |>
    str_split("\t") |>
    unlist()

  # headers for dataframe
  headers <-c(
    "input",
    "Total_Energy",
    "Backbone_Hbond",
    "Sidechain_Hbond",
    "Van_der_Waals",
    "Electrostatics",
    "Solvation_Polar",
    "Solvation_Hydrophobic",
    "Van_der_Waals_clashes",
    "Entropy_Side_Chain",
    "Entropy_Main_Chain",
    "Sloop_Entropy",
    "Mloop_Entropy",
    "Cis_Bond",
    "Torsional_Clash",
    "Backbone_Clash",
    "Helix_Dipole",
    "Water_Bridge",
    "Disulfide",
    "Electrostatic_Kon",
    'Partial_Covalent_Bonds',
    "Energy_Ionisation",
    "Entropy_Complex",
    'Residue_Number')




  foldx_data_frame = as.data.frame(t(data));
  #change the names of the dataframe to be the titles
  colnames(foldx_data_frame) <- headers


  # change class from character to numeric

  foldx_data_frame <- foldx_data_frame |>
    mutate_at(vars(-input), as.numeric)

  return(foldx_data_frame)
}




# visualization
# this is only useable when we have multiple foldx results


visualize_multiple_fxout <- function(my_variable, name_of_plot) {

  #save the png which will be created
  where_to_save = paste(name_of_plot,".png", sep = "")
  png(where_to_save, width = 800, height = 800)  # Adjust width and height as needed
  print(paste("png output saved as :", where_to_save))
  # Layout to split the screen
  layout(mat = matrix(c(1,2),2,1, byrow=TRUE),  height = c(1,8))

  # Draw the boxplot
  par(mar=c(0, 3.1, 1.1, 2.1))
  min_val <- min(my_variable)
  max_val <- max(my_variable)
  boxplot(my_variable , #This should be the variable or data frame column you want to visualize.
          horizontal=TRUE , #This specifies that you want a horizontal boxplot.
          ylim=c(min_val,max_val),
          xaxt="n" , #This removes the x-axis ticks.
          col=rgb(0.8,0.8,0,0.5) ,
          frame=F)

  # Draw the histogram
  par(mar=c(4, 3.1, 1.1, 2.1))

  hist(my_variable ,
       breaks=40 , #This sets the number of bins (or breaks) for the histogram to 40.
       col=rgb(0.2,0.8,0.5,0.5) ,
       border=F ,
       main="" ,
       xlab=name_of_plot,
       ylab = "frequency of variable",
       xlim=c(min_val,max_val))



  dev.off() # Close the graphics device

}



# Read multiple fxout function
# Define a function that takes a path to multiple foldx outputs (.fxout) and gives a dataframe as output
read_multiple_fxout <- function(multiple_path, visualize = TRUE) {



  # List all files with paths ending in .fxout in the directory and its subdirectories
  fxout_files <- dir_ls(path = multiple_path, recurse = TRUE, regexp = "\\.fxout$")

  # Display the paths to .fxout files
  #print(fxout_files)

  first <- TRUE
  for (i in fxout_files){
    if (first == TRUE) {
      total_foldx_data_frame <- read_fxout(i)
      first <- FALSE
    } else {
      new_row = read_fxout(i)
      total_foldx_data_frame <- rbind(total_foldx_data_frame, new_row)
    }
  }


  # visualization
  if (visualize == TRUE) {
    # Perform an visualization when visualize is TRUE
    visualize_multiple_fxout(total_foldx_data_frame$Total_Energy, "total_energy")
  }


  return(total_foldx_data_frame)
}

