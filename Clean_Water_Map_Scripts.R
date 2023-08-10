# Load necessary libraries
library(ggplot2)
library(dplyr)
library(sf)
library(leaflet)
library(htmlwidgets)
library(webshot)

# Read the CSV files
data <- read.csv("datas.csv", header = TRUE)
us_zip_data <- read.csv("uszips.csv", header = TRUE)

# Remove NA values from data
data <- data[!is.na(data$Q1),]

# Print unique zip codes
print(unique(data$Q1))

# Merge data with spatial data
data_merged <- inner_join(us_zip_data, data, by = c("zip" = "Q1"))

# Create an sf object
data_sf <- st_as_sf(data_merged, coords = c("lng", "lat"), crs = 4326)

# Read zip code boundary shapefile (ZCTA)
zip_boundaries_sf <- st_read("tl_2020_us_zcta510.shp")

# Convert Q1 column to character type
data$Q1 <- as.character(data$Q1)

# Merge the zip code boundaries with the data
zip_boundaries_merged <- left_join(zip_boundaries_sf, data, by = c("ZCTA5CE10" = "Q1"))

# Filter only the zip codes in datas.csv
zip_boundaries_merged <- zip_boundaries_merged %>% filter(ZCTA5CE10 %in% data$Q1)

# Set colors for zip codes based on Q15 values
zip_boundaries_merged <- zip_boundaries_merged %>%
  mutate(color = case_when(
    Q15 == "Extremely important" ~ "blue",
    Q15 == "Somewhat important" ~ "green",
    Q15 == "Slightly important" ~ "yellow",
    Q15 == "Not at all important" ~ "red",
    Q15 == "I don't know" ~ "gray",
    TRUE ~ "gray"
  ))

# Calculate the centroid of Orange County zip codes
centroid <- st_centroid(st_union(data_sf))

# Extract the coordinates of the centroid
centroid_coords <- st_coordinates(centroid)

# Define the legend categories and colors
legend_categories <- c("Extremely important", "Somewhat important", "Slightly important", "Not at all important", "I don't know")
legend_colors <- c("blue", "green", "yellow", "red", "gray")

# Calculate centroids for the zip code polygons
zip_boundaries_merged$centroid <- st_centroid(zip_boundaries_merged$geometry)
# Calculate the total percentage of people who said "Extremely important"
extremely_important_percentage <- sum(data$percentage[data$Q15 == "Extremely important"])

# Update the legend category for "Extremely important" to include the total percentage
extremely_important_category <- paste0("Extremely important (", round(extremely_important_percentage, 2), "%)")
updated_legend_categories <- c(extremely_important_category, "Somewhat important", "Slightly important", "Not at all important", "I don't know")

# Read Orange County boundary shapefile
orange_county_sf <- st_read("tl_2022_us_county.shp")

# Read county boundary shapefile
county_boundaries_sf <- st_read("tl_2022_us_county.shp")

# Transform CRS to WGS84 (EPSG:4326)
county_boundaries_sf <- st_transform(county_boundaries_sf, 4326)

# Create the map
map <- leaflet() %>%
  addProviderTiles(providers$OpenStreetMap) %>%
  setView(lng = centroid_coords[1], lat = centroid_coords[2], zoom = 10) %>%
  addPolygons(data = zip_boundaries_merged,
              fillColor = ~color,
              color = "black",
              weight = 1,
              fillOpacity = 0.8,
              highlightOptions = highlightOptions(color = "white", weight = 2, bringToFront = TRUE)) %>%
  addCircleMarkers(data = st_set_geometry(zip_boundaries_merged, zip_boundaries_merged$centroid),
                   radius = 0,
                   label = ~paste0(ZCTA5CE10),
                   labelOptions = labelOptions(noHide = TRUE, direction = "center", textOnly = TRUE, opacity = 1, offset = c(0, 0), style = list("font-weight" = "bold", "font-size" = "10px", "color" = "black"))) %>%
  addLegend("bottomright",
            title = "How Important Is Clean Water",
            colors = legend_colors,
            labels = updated_legend_categories,
            opacity = 0.8) %>%
  addPolygons(data = orange_county_sf,
              fillColor = "transparent",
              color = "orange",
              weight = 3)

# Save the map as a temporary HTML file
tmp_file <- tempfile(fileext = ".html")
saveWidget(map, file = tmp_file, selfcontained = FALSE)

# Convert the HTML file to a PNG file
webshot(tmp_file, file = "map_output.png", delay = 5, vwidth = 1024, vheight = 768)

# Remove the temporary HTML file
unlink(tmp_file)
