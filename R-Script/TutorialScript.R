##############################################
#    Data Science in EES, Tutorial R-Script  #
##############################################
# Data Visualization: Part 3  (Advanced Data Visualization- Creating BBC-Style Plots in R with ggplot2)

# Created by: Zeynep Deniz Yuksel 
# Contact information: s232049@ed.ac.uk
# Date: November 2024

## Make sure that you have covered part 1 and 2 of coding club tutorials to make the most of this one :)
## This tutorial uses publicly available data from OurWorldInData  to efficiently target the learning outcomes:
  #1: Utilize advanced ggplot2 techniques, including annotations, custom themes, and secondary axes.
  #2: Combine multiple plots seamlessly using the patchwork package.
  #3: Apply color palettes from the scico package to ensure accessibility and visual appeal.
  #4: Replicate BBC-style design principles, such as clarity, simplicity, and impactful storytelling.


#Step 1: Import necessary libraries making sure they are installed prior:----
install.packages(c("ggplot2", "patchwork", "scico", "extrafont", "colorblindcheck"))
library(dplyr)
library(tidyverse)
library(ggplot2)
library(patchwork)
library(scico)
library(extrafont)
library (colorblindcheck)

#Step 2: Load dataset: ----
global_waste <- read.csv("Datasets/share-of-global-plastic-waste-emitted-to-the-ocean.csv")
waste_items <- read.csv("Datasets/waste-items-ocean-region.csv")

#Step 3: Inspecting dataset and wrangle (check tutorials on data manipulation if this isn't clear) : ----
# Filtering out all countries and keeping only continent data from first dataset
global_waste_continent <- global_waste %>%
  filter(Entity %in% c('Africa', 
                       'Asia', 
                       'Europe', 
                       'Micronesia', 
                       'North America', 
                       'Oceania', 
                       'South America'))
# Identifying top 5 entities in Waste Items Dataset
top_items <- waste_items %>%
  group_by(Entity) %>%  # Grouping  data by variable 'Entity'.Subsequent operations are performed separately within each Entity group.
  summarise(count = n()) %>%  # Counting the number of rows (observations) within each Entity group. n() returns the number of rows, and this count is stored in a new column called count.
  arrange(desc(count)) %>%  # Sorting resulting grouped data in descending order based on the count column, so the entities with the highest counts appear at the top.
  head(5)  # Taking first 5 rows from the sorted data, giving the top 5 entities with the highest counts.

# Only keeping rows where Entity is in the specified list of top 5 values
waste_items <- waste_items %>%
  filter(Entity %in% c('Bottle lids', 
                       'Cans (drink)', 
                       'Cans (food)', 
                       'Clothing', 
                       'Fishing net'))
# Inspecting cleaned waste items data
head(waste_items)
str(waste_items_long)

# Converting first dataset (waste_items) to long format
waste_items_long <- gather(waste_items, Region, Amount,  # Gather function takes the dataset waste_items and reshapes it by:
                             c(High.income, 
                               East.Asia.and.Pacific, 
                               South.Asia,  
                               Latin.America.and.the.Carribean,
                               Sub.Saharan.Africa,
                               North.Africa.and.Middle.East))  # Creating a new column called Region, storing the names of the original columns as values.
waste_items_long <- mutate(waste_items_long, 
                           Region = gsub("\\.", " ", Region))  # Replace dots with spaces for better and advanced visual appearance



#Step 4: Data visualization: ----

## Visualization 1: Line Plot with Advanced ggplot2 Features
# Show global waste trends for each continent
(ggplot(global_waste_continent, aes(x = Year, y = Share.of.global.plastics.emitted.to.ocean, color = Entity)) +
  geom_line(size = 1.2) +
  scale_color_scico_d(palette = "roma") +
  labs(title = "Global Plastic Waste Trends by Continent",
       subtitle = "Percentage of global plastic waste emitted to the ocean",
       x = "Year",
       y = "Plastic Waste (%)",
       color = "Continent") +
  theme_minimal(base_family = "Arial") +
  theme(plot.title = element_text(size = 18, face = "bold"),
        plot.subtitle = element_text(size = 14),
        legend.position = "bottom") +
  scale_y_continuous(sec.axis = sec_axis(~.*1, name = "Secondary Axis Example")))

## Visualization 2: Stacked Bar Plot with Custom Theme
# Display top waste items by region
ggplot(waste_items_long, aes(x = Region, y = Amount, fill = Entity)) +
  geom_bar(stat = "identity", position = "stack") +
  scale_fill_scico_d(palette = "batlow") +
  labs(title = "Top Waste Items in Different Regions",
       x = "Region",
       y = "Amount of Waste",
       fill = "Waste Item") +
  theme_classic() +
  theme(text = element_text(family = "Arial"),
        axis.text.x = element_text(angle = 45, hjust = 1),
        plot.title = element_text(size = 18, face = "bold"))

## Visualization 3: Combining Plots with patchwork
# Combine the two plots
plot1 <- ggplot(global_waste_continent, aes(x = Year, y = Share.of.global.plastics.emitted.to.ocean, color = Entity)) +
  geom_line(size = 1.2) +
  labs(title = "Global Plastic Waste Trends by Continent") +
  theme_minimal()

plot2 <- ggplot(waste_items_long, aes(x = Region, y = Amount, fill = Entity)) +
  geom_bar(stat = "identity") +
  labs(title = "Top Waste Items by Region") +
  theme_classic()

combined_plot <- plot1 + plot2 + 
  plot_annotation(title = "BBC-Style Data Visualizations",
                  theme = theme(plot.title = element_text(size = 20, face = "bold")))
print(combined_plot)

## Visualization 4: Accessibility Check
# Check for colorblind accessibility
colorblindcheck::palette_check(scico(5, palette = "roma"))

# Final Steps: Save the plots
ggsave("global_waste_plot.png", plot = plot1, dpi = 300, width = 10, height = 6)
ggsave("combined_plot.png", plot = combined_plot, dpi = 300, width = 12, height = 8)

##############################################
# End of Tutorial
##############################################