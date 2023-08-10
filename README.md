# Survay Data Mapping Script- Orange County, Florida

This project aims to visualize the importance of clean water in Orange County, Florida, based on survey data collected at the Orlando Mayor Buddy Dyer's Neighborhood and Community Summit. The data was gathered as part of a traditional town planning class, and the goal is to create a map that displays the perceived importance of clean water across different zip codes in the region.

The script provided processes the survey data, combines it with spatial data from shapefiles, and generates a map using the Leaflet library in R. The map displays each zip code area with a color-coded representation of the survey responses, highlighting the importance of clean water as reported by the participants.

## Code Description

Load necessary libraries: The script begins by loading the required R libraries, which include ggplot2, dplyr, sf, leaflet, htmlwidgets, and webshot.

Read and preprocess data: The script reads the survey data from datas.csv and the US zip code data from uszips.csv. It removes any NA values from the survey data and prints the unique zip codes present in the dataset.

Merge data and create sf object: The script merges the survey data with the spatial zip code data, and then converts the merged data into an sf (simple features) object with proper coordinate reference system (CRS) settings.

Read and process shapefiles: The script reads the zip code boundaries (ZCTA) and county boundaries shapefiles. It then merges the zip code boundaries with the survey data and filters the zip codes based on the survey dataset.

Set colors and calculate centroids: The script sets the colors for each zip code area based on the survey responses and calculates the centroids for the zip code polygons.

Read and transform county boundaries: The script reads the Orange County boundary shapefile and transforms the CRS to WGS84 (EPSG:4326).

Create the map: The script creates an interactive map using the Leaflet library, adds polygons representing zip code areas, circle markers for zip code labels, a legend, and county boundaries.

Save the map: The script saves the map as an HTML file, converts it to a PNG file using the webshot library, and then removes the temporary HTML file. The final output is a PNG file named map_output.png.

## Getting Started

These instructions will help you run the project on your local machine.

### Prerequisites

- R (version 3.5.0 or higher)
- RStudio (optional, but recommended)

### Required Libraries

- ggplot2
- dplyr
- sf
- leaflet
- htmlwidgets
- webshot

### Required Files

1. `datas.csv`: Survey data collected at the Orlando Mayor Buddy Dyer's Neighborhood and Community Summit.
2. `uszips.csv`: US zip code data including latitude and longitude.
3. `tl_2020_us_zcta510.shp`: Zip code boundary shapefile (ZCTA).
4. `tl_2022_us_county.shp`: County boundary shapefile.

### Running the Script

1. Clone the repository or download the files to your local machine.
2. Open the R script `clean_water_map.R` in R or RStudio.
3. Ensure that the required libraries are installed. You can install them using the following command:
```R
install.packages(c("ggplot2", "dplyr", "sf", "leaflet", "htmlwidgets", "webshot"))
```
5. Set the working directory to the folder containing the script and required files. In RStudio, you can set the working directory by going to Session > Set Working Directory > Choose Directory....
6. Run the entire script to generate the map. The output file map_output.png will be saved in the current working directory.

### Output
The final output is a PNG file named map_output.png that visualizes the importance of clean water in Orange County, Florida, based on the survey data collected. This map can help local authorities, urban planners, and environmental organizations understand community perspectives on clean water and inform future decisions related to water management and infrastructure development.



