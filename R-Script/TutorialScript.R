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


#Part 1a- Import necessary libraries making sure they are installed prior:----
install.packages(c("dplyr", "ggplot2","patchwork","scico", "extrafont", "colorblindcheck", 
                   "tidyr", "gapminder", "ggalt", "forcats", "R.utils", "png","grid",
                   "ggpubr","scales","bbplot")) 
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


#Part 1a- Load dataset: ----
install.packages("palmerpenguins")
library(palmerpenguins)
head(penguins)
summary(penguins)
view(penguins)

# Part 1b - Prepare the data by grouping by year and calculating the average body mass----
line_df <- penguins %>%
  group_by(year) %>%
  summarise(avg_body_mass = mean(body_mass_g, na.rm = TRUE))  # #Aggregates the data into meaningful metrics (average body mass) to simplify visualization

# Part 1b- Create a basic line plot ----
(line_plot <- ggplot(line_df, aes(x = year, y = avg_body_mass)) +
  geom_line(colour = "#1380A1", size = 1) +  # Line plot with custom color and size
  geom_hline(yintercept = 0, size = 1, colour = "#333333") +  # Add a horizontal line at y = 0
  bbc_style() +
    theme(panel.grid.major.x = element_line(color="#cbcbcb"),  ## Additional customizations (gridlines) added following bbc_style() command...
          panel.grid.major.y=element_blank())+ 
  labs(title = "Penguin Body Mass Over Time", 
       subtitle = "Average body mass of penguins per year")+ # Add title and subtitle
    scale_x_continuous(breaks = seq(min(line_df$year), max(line_df$year), by = 1)))  # Display years as integers


# Part 1b- Finalize the plot with finalise_plot() and save out finished chart once all modifications have been completed ----

final_plot<- finalise_plot(plot_name = line_plot,
              source = "Source: Data from Palmer Penguins Dataset",
              save_filepath = "Tutorial/Figure1-LineChart.png",
              width_pixels = 640,
              height_pixels = 450)


# Part 2a- Annotations (Highlighting a key year in the penguins dataset)  ----
(annotated_plot <- ggplot(penguins, aes(x = flipper_length_mm, y = body_mass_g)) +  #Mapping the x-axis to flipper_length_mm and the y-axis to body_mass_g.
    geom_point(aes(color = species), size = 3) +  #Plotting individual penguins as points on the chart, and coloring these points based on the species of penguin, setting size to 3. 
    annotate("text", x = 205, y = 4100, label = "Note this cluster!", size = 7, color = "black", family="Helvetica") +  #Placing a text annotation at the specified coordinates. Sets the annotation's text to "Note this cluster!" with a font size of 7 and color black.
    bbc_style() +  #Applying BBC-style formatting
    labs(title = "Penguin Body Mass vs. Flipper Length", subtitle = "Annotated clusters of penguins")) #Setting plot title and subtitles.


# Part 2a - adding line breaks ----
(annotated_plot <- ggplot(penguins, aes(x = flipper_length_mm, y = body_mass_g)) +  
    geom_point(aes(color = species), size = 3) +
    annotate("text", x = 205, y = 4100, label = "Note\n this\n cluster!", size = 7, color = "black", family="Helvetica", lineheight = 0.8) +
    bbc_style() +  
    labs(title = "Penguin Body Mass vs. Flipper Length", subtitle = "Annotated clusters of penguins")) #Setting plot title and subtitles.


# Part 2a- Adding labels based on data ----
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


# Part 2a- Adding arrows ----
annotated_plot + geom_curve(aes(x = 205, y = 3800, xend = 200, yend = 3700),  # Set the start and end points of the arrow. If x/yend> x/y then the curve downward curve (sad face), if otherwise than upward smile :)
             colour = "#555555", #Setting the color of the curve to a light gray shade for subtle visibility.
             size = 0.5, # Thickness of the curve
             curvature = -0.1, #Determines the degree and direction of the curve; negative values create downward curves, while positive values create upward curves.
             arrow = arrow(length = unit(0.03, "npc")))  #Adds an arrowhead to the end of the curve with a specified length of 0.03 normalized parent coordinates (npc).


# Part 2b- Using a secondary y-axis to show body mass in pounds  ----

(secondary_axis_plot <- ggplot(penguins, aes(x = bill_length_mm, y = body_mass_g)) +  
  geom_point(aes(color = species), size = 3) +  # Scatter plot with color-coded species  
  scale_y_continuous(  
    name = "Body Mass (g)",  # Primary axis label  
    sec.axis = sec_axis(~ . / 453.592, name = "Body Mass (lbs)")  # Secondary axis transformation and label  
  ) +  
  bbc_style() +  # Apply BBC-style aesthetics  
  labs(title = "Penguin Body Mass and Bill Length",  
    subtitle = "Dual-axis plot showing body mass in grams and pounds"  # Informative title and subtitle  
  ))

 
# Part 2b- Using secondary axes to combine line and bar charts ----

# Summarize data by species and calculate mean flipper length and body mass
penguins_summary <- penguins %>%
  group_by(species) %>%
  summarise(mean_flipper_length = mean(flipper_length_mm, na.rm = TRUE),
            mean_body_mass = mean(body_mass_g, na.rm = TRUE))

# Create the plot
(combined_plot <- ggplot(penguins_summary, aes(x = species)) +
  geom_bar(aes(y = mean_flipper_length), stat = "identity", fill = "slategrey") +  #Bar plot (filled grey) for mean flipper length (primary axis).
  geom_line(aes(y = mean_body_mass / 100), color = "salmon1", group = 1) +  # Line plot for mean body mass (secondary axis-salmon color), scaled for better alignment.
  scale_y_continuous(name = "Mean Flipper Length (mm)",  #Define primary y-axis and secondary y-axis. Label for primary y-axis (flipper length in mm)
                     sec.axis = sec_axis(~ . * 100, name = "Mean Body Mass (g)")) +  # Secondary axis for body mass (scaled back)
  bbc_style() +  # Apply consistent BBC-style plot design
  labs(title = "Penguin Flipper Length and Body Mass by Species", 
       subtitle = "Bar and line charts with secondary axis") + 
  theme(axis.title.y = element_text(color = 'salmon1', size = 13), # Customize axis title colors and sizes
        axis.title.y.right = element_text(color = 'slategrey', size = 13),
        plot.title = element_text(size = 25)))  # Adjust the title size - important to know that this can be done at times as bbc theme often times can have titles overflowing.. 















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