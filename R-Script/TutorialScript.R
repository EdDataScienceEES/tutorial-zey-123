##############################################
#    Data Science in EES, Tutorial R-Script  #
##############################################
# Data Visualization: Part 3  (Advanced Data Visualization- Creating BBC-Style Plots in R with ggplot2)

# Created by: Zeynep Deniz Yuksel 
# Contact information: s232049@ed.ac.uk
# Date: November 2024

## Make sure that you have covered part 1 and 2 of coding club tutorials to make the most of this one :)
## This tutorial uses the palmerpenguins dataset to efficiently target the learning outcomes:
  #1: Utilize advanced ggplot2 techniques, including annotations, custom themes, and secondary axes.
  #2: Combine multiple plots seamlessly using the patchwork package.
  #3: Apply color palettes from the scico package to ensure accessibility and visual appeal.
  #4: Replicate BBC-style design principles, such as clarity, simplicity, and impactful storytelling.


#Step 1: Import necessary libraries making sure they are installed prior:----
install.packages(c("ggplot2", "patchwork", "scico", "extrafont", "colorblindcheck"))
install.packages(c("dplyr", "tidyr", "gapminder", "ggalt", "forcats", "R.utils", "png","grid","ggpubr","scales","bbplot"))

library(dplyr)
library(tidyverse)
library(tidyr)
library(ggplot2)
library(patchwork)
library(scico)
library(extrafont)
library (colorblindcheck)
library(ggalt)
library(forcats)
library (R.utils)
library(png)
library(grid)
library(ggpubr)
library(scales)
library(bbplot)


#Step 2: Load dataset: ----
install.packages("palmerpenguins")
library(palmerpenguins)
head(penguins)
summary(penguins)
view(penguins)

# Prepare the data by grouping by year and calculating the average body mass
line_df <- penguins %>%
  group_by(year) %>%
  summarise(avg_body_mass = mean(body_mass_g, na.rm = TRUE))  # #Aggregates the data into meaningful metrics (average body mass) to simplify visualization

# Create a basic line plot 
(line_plot <- ggplot(line_df, aes(x = year, y = avg_body_mass)) +
  geom_line(colour = "#1380A1", size = 1) +  # Line plot with custom color and size
  geom_hline(yintercept = 0, size = 1, colour = "#333333") +  # Add a horizontal line at y = 0
  bbc_style() +
    theme(panel.grid.major.x = element_line(color="#cbcbcb"),  ## Additional customizations (gridlines) added following bbc_style() command...
          panel.grid.major.y=element_blank())+ 
  labs(title = "Penguin Body Mass Over Time", 
       subtitle = "Average body mass of penguins per year")+ # Add title and subtitle
    scale_x_continuous(breaks = seq(min(line_df$year), max(line_df$year), by = 1)))  # Display years as integers


# Finalize the plot with finalise_plot() and save out finished chart once all modifications have been completed

final_plot<- finalise_plot(plot_name = line_plot,
              source = "Source: Data from Palmer Penguins Dataset",
              save_filepath = "Tutorial/Figure1-LineChart.png",
              width_pixels = 640,
              height_pixels = 450)


# Part 2a- Annotations (Highlighting a key year in the penguins dataset)  
(annotated_plot <- ggplot(penguins, aes(x = flipper_length_mm, y = body_mass_g)) +  #Mapping the x-axis to flipper_length_mm and the y-axis to body_mass_g.
    geom_point(aes(color = species), size = 3) +  #Plotting individual penguins as points on the chart, and coloring these points based on the species of penguin, setting size to 3. 
    annotate("text", x = 205, y = 4100, label = "Note this cluster!", size = 7, color = "black", family="Helvetica") +  #Placing a text annotation at the specified coordinates. Sets the annotation's text to "Note this cluster!" with a font size of 7 and color black.
    bbc_style() +  #Applying BBC-style formatting
    labs(title = "Penguin Body Mass vs. Flipper Length", subtitle = "Annotated clusters of penguins")) #Setting plot title and subtitles.


# Part 2a - adding line breaks
(annotated_plot <- ggplot(penguins, aes(x = flipper_length_mm, y = body_mass_g)) +  
    geom_point(aes(color = species), size = 3) +
    annotate("text", x = 205, y = 4100, label = "Note\n this\n cluster!", size = 7, color = "black", family="Helvetica", lineheight = 0.8) +
    bbc_style() +  
    labs(title = "Penguin Body Mass vs. Flipper Length", subtitle = "Annotated clusters of penguins")) #Setting plot title and subtitles.




# Adding labels based on data

(labelled_clusters <- ggplot(penguins, aes(x = flipper_length_mm, y = body_mass_g)) +
  geom_point(aes(color = species), size = 3) +
  geom_label(aes(label = round(body_mass_g, 0)),   # Add labels with rounded body mass values
             hjust = 0.5, # Horizontal justification (centered)
             vjust = -0.5,  # Vertical adjustment (move labels slightly above points)
             colour = "black",  # Border color of the label box
             fill ="white",  # Background color of the label box
             label.size = 0.1,  # # Thickness of the label's border - making it easier to read
             family = "Helvetica",  # Font family for the label text
             size = 2) +  # Adjust label size
  bbc_style() +  # Apply BBC-style aesthetics
  labs(title = "Penguin Body Mass vs. Flipper Length", 
       subtitle = "Labels based on penguin body mass"))


# Adding arrows (LEFT OFF HERE)

labelled_clusters+ geom_curve(aes(x = 1979, y = 45, xend = 1965, yend = 43), 
                              colour = "#555555", 
                              size=0.5, 
                              curvature = -0.2,
                              arrow = arrow(length = unit(0.03, "npc")))

annotated_plot +
  geom_curve(aes(x = flipper_length_mm[1], y = body_mass_g[1], 
                 xend = flipper_length_mm[2], yend = body_mass_g[2]),  # Set the start and end points of the arrow
             colour = "#555555", 
             size = 0.5, 
             curvature = -0.2, 
             arrow = arrow(length = unit(0.03, "npc")))  # Add arrow between two points










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