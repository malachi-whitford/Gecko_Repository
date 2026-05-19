# Define required packages
pkgs <- c("geodata", "terra")

# Function to check, install, and load packages
install_and_load <- function(packages) {
  for (pkg in packages) {
    if (!require(pkg, character.only = TRUE)) {
      install.packages(pkg, dependencies = TRUE)
      library(pkg, character.only = TRUE)
    }
  }
} 
####

# Run the function
install_and_load(pkgs)

# Define a working directory
working_dir <- "C:/Users/malac/Desktop/maxent/worldclim_data"
if (!dir.exists(working_dir)) dir.create(working_dir, recursive = TRUE)

# Download the 19 bioclimatic variables at 0.5 minutes resolution
bioclim_data <- worldclim_global(var = "bio", res = 0.5, path = working_dir)

# Download boundary data for the United States to isolate California
us_boundary <- gadm(country = "USA", level = 1, path = working_dir)
california <- us_boundary[us_boundary$NAME_1 == "California", ]

# Crop and mask the global bioclimatic data to the California boundary
bioclim_california_cropped <- crop(bioclim_data, california)
bioclim_california_masked <- mask(bioclim_california_cropped, california)

# Export each layer as an ascii file for Maxent with a numeric NA flag
output_folder <- "C:/Users/malac/Desktop/maxent/layers"
if (!dir.exists(output_folder)) dir.create(output_folder, recursive = TRUE)

# Loop through each layer to save individually
for (i in 1:nlyr(bioclim_california_masked)) {
  layer <- bioclim_california_masked[[i]]
  layer_name <- names(layer)
  output_file <- paste0(output_folder, "/", layer_name, ".asc")
  
  # The NAflag = -9999 argument forces R to use a number for missing data
  writeRaster(layer, filename = output_file, filetype = "AAIGrid", NAflag = -9999, overwrite = TRUE)
}

print("Files re-processed with numeric NoData values.")