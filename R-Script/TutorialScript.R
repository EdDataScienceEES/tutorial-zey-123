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

# Part 2c- Facet by species  ----
# Vertical (by column)
(Vfaceted_plot <- ggplot(penguins, aes(x = flipper_length_mm, y = body_mass_g)) +  
    geom_point(aes(color = species), size = 3) +  
    facet_wrap(~species) +  # Create a panel for each species  
    bbc_style() +  
    labs(title = "Penguin Body Mass vs. Flipper Length",  
         subtitle = "Faceted by species for clearer comparisons")) 

#Horizontal (by row)
(Hfaceted_plot <- ggplot(penguins, aes(x = flipper_length_mm, y = body_mass_g)) +  
    geom_point(aes(color = species), size = 3) +  
    facet_wrap(~species, dir="v") +  # Create a panel for each species where dir='v' changes direction of facet
    bbc_style() +  
    labs(title = "Penguin Body Mass vs. Flipper Length",  
         subtitle = "Faceted by species for clearer comparisons")) 

# Adding label at bottom
(Lfaceted_plot <- ggplot(penguins, aes(x = flipper_length_mm, y = body_mass_g)) +  
    geom_point(aes(color = species), size = 3) +  
    facet_wrap(~species,dir="v", strip.position="bottom") +  # Create a panel for each species adding species names to the bottom using strip.position
    bbc_style() +  
    labs(title = "Penguin Body Mass vs. Flipper Length",  
         subtitle = "Faceted by species for clearer comparisons")) 



# Part 2c- Facet by species  (facet_grid) ----
# Start with a simple scatterplot
penguin_plot <- ggplot(penguins, aes(bill_length_mm, flipper_length_mm)) + geom_point()

# Facet into different layouts
penguin_plot + facet_grid(. ~ species)  # Arrange facets in a single row based on penguin species
penguin_plot + facet_grid(island ~ .)  # Stack facets in rows based on islands
penguin_plot + facet_grid(island ~ species)  # Create a grid using rows (islands) and columns (species)
penguin_plot + facet_wrap(~ species)  # Wrap facets into a rectangular layout automatically

# Let axis scales vary across facets for flexibility
penguin_plot + facet_grid(island ~ species, scales = "free")  # Both x and y-axis are free
penguin_plot + facet_grid(island ~ species, scales = "free_x")  # Only x-axis varies
penguin_plot + facet_grid(island ~ species, scales = "free_y")  # Only y-axis varies

# Customize facet labels for a polished look
penguin_plot + facet_grid(. ~ species, labeller = label_both)  # Labels show both variable names and values ("species: Adelie", "species: Chinstrap", etc.)
penguin_plot + facet_grid(species ~ ., labeller = label_bquote(alpha ^ .(species)))  # Use math expressions for labels ("𝛼Adelie", "𝛼Chinstrap", etc.)



# Part 2d- Refine visual aesthetics while ensuring accessibility with custom themes and color palettes.----

# For categorical data (species)
(categorical_plot <- ggplot(penguins, aes(x = flipper_length_mm, y = body_mass_g, color = species)) +  # Create a ggplot object with penguins data, map 'flipper_length_mm' to x-axis, 'body_mass_g' to y-axis, and color based on 'species' (categorical variable)
    geom_point(size = 3) +
    scale_color_scico_d(palette = "batlow") +  # Apply 'scico' discrete color palette (batlow) for categorical data (species). The '_d' indicates a discrete scale.
    bbc_style() +  
    labs(  
      title = "Penguin Data: Species-based Colors",  
      subtitle = "Using a colorblind-friendly palette for categorical data"  
    ))

# For continuous data (e.g., body_mass_g)
(continuous_plot <- ggplot(penguins, aes(x = flipper_length_mm, y = body_mass_g, color = body_mass_g)) +  # Create a ggplot object with 'body_mass_g' as the color aesthetic (continuous variable)
    geom_point(size = 3) + 
    scale_color_scico(palette = "bilbao", begin = 0, end = 1) +  # Apply 'scico' continuous color palette (bilbao) for continuous data ('body_mass_g'). The 'begin' and 'end' control the color range.
    bbc_style() +
    theme(plot.title = element_text(size = 25),
          legend.position = "none"  # Hide the legend (including the color gradient) to reduce clutter in the plot and focus the viewer’s attention on the data points themselves, especially since the color scale is self-explanatory/ not needed for context.
    ) +
    labs(
      title = "Penguin Data: Body Mass with Continuous Colors",  
      subtitle = "Using a colorblind-friendly palette for continuous data"  
    ))


# Part 2d -Check for colorblind accessibility----
# 1. Accessibility check for the categorical plot (species-based colors)
# Extract the discrete palette used in the plot ('batlow' with 3 colors for species)
categorical_palette <- scico(3, palette = "batlow", categorical = TRUE)
# Check how this discrete palette appears for individuals with color vision deficiencies
palette_check(categorical_palette)

# 2. Accessibility check for the continuous plot (body_mass_g-based colors)
# Extract the continuous palette ('bilbao', spanning from 0 to 1)
continuous_palette <- scico(5, palette = "bilbao", begin = 0, end = 1)
# Check how this continuous palette appears for individuals with color vision deficiencies
palette_check(continuous_palette)



# Part 3:----

# Create the first plot (species vs flipper_length_mm)
(plot1 <- ggplot(penguins, aes(x = species, y = flipper_length_mm, fill = species)) +
  geom_boxplot() +                           # Creates a boxplot for flipper length across species
  scale_fill_scico_d(palette = "batlow") +    # Applies a discrete color palette for the species variable
  labs(title = "Flipper Length by Species",   # Adds a title to the plot
       subtitle = "Boxplot of flipper lengths across penguin species") +
  bbc_style())                                 # Apply BBC style directly

# Create the second plot (body_mass_g vs flipper_length_mm)
(plot2 <- ggplot(penguins, aes(x = flipper_length_mm, y = body_mass_g, color = species)) +
  geom_point(size = 3) +                       # Scatter plot showing body mass vs flipper length
  scale_color_scico_d(palette = "batlow") +     # Discrete color palette for the species variable
  labs(title = "Body Mass vs Flipper Length",  # Adds a title to the plot
       subtitle = "Scatter plot with species-based coloring") +
  bbc_style())                                 # Apply BBC style directly


# Create the third plot (density plot for body mass)
(plot3 <- ggplot(penguins, aes(x = body_mass_g, fill = species)) +
  geom_density(alpha = 0.5) +                  # Creates a density plot for body mass with transparency
  scale_fill_scico_d(palette = "batlow") +      # Applies the same discrete color palette for species
  labs(title = "Body Mass Distribution",       # Adds a title to the plot
       subtitle = "Density plot for penguin body mass across species") +
  bbc_style())                                # Apply BBC style directly


# Combine the plots using patchwork to create a cohesive layout
(final_plot <- plot1 + plot2 + plot3 +            # Combine the three plots
  plot_layout(ncol = 1) +                       # Arrange plots in one column
  plot_annotation(title = "Penguin Data Story",  # Add an overarching title
                  subtitle = "Exploring Penguin Species and Traits")) # Subtitle for context

#Making adjustments to the graphs as bbc produces big unreadable graphs:
# Create the first plot (species vs flipper_length_mm)
plot1 <- ggplot(penguins, aes(x = species, y = flipper_length_mm, fill = species)) +
  geom_boxplot() +                           # Creates a boxplot for flipper length across species
  scale_fill_scico_d(palette = "batlow") +    # Applies a discrete color palette for the species variable
  labs(title = "Flipper Length by Species",   # Adds a title to the plot
       subtitle = "Boxplot of flipper lengths across penguin species") +
  bbc_style() +                               # Apply BBC style directly
  theme(plot.title = element_text(size = 12), # Adjust title size for better fitting
        plot.subtitle = element_text(size = 10), # Adjust subtitle size for better fitting
        axis.text = element_text(size = 10))      # Adjust axis text size for better fitting

# Create the second plot (body_mass_g vs flipper_length_mm)
plot2 <- ggplot(penguins, aes(x = flipper_length_mm, y = body_mass_g, color = species)) +
  geom_point(size = 3) +                       # Scatter plot showing body mass vs flipper length
  scale_color_scico_d(palette = "batlow") +     # Discrete color palette for the species variable
  labs(title = "Body Mass vs Flipper Length",  # Adds a title to the plot
       subtitle = "Scatter plot with species-based coloring") +
  bbc_style() +                                # Apply BBC style directly
  theme(plot.title = element_text(size = 12),  # Adjust title size for better fitting
        plot.subtitle = element_text(size = 10), # Adjust subtitle size for better fitting
        axis.text = element_text(size = 10))      # Adjust axis text size for better fitting

# Create the third plot (density plot for body mass)
plot3 <- ggplot(penguins, aes(x = body_mass_g, fill = species)) +
  geom_density(alpha = 0.5) +                  # Creates a density plot for body mass with transparency
  scale_fill_scico_d(palette = "batlow") +      # Applies the same discrete color palette for species
  labs(title = "Body Mass Distribution",       # Adds a title to the plot
       subtitle = "Density plot for penguin body mass across species") +
  bbc_style() +                               # Apply BBC style directly
  theme(plot.title = element_text(size = 12),  # Adjust title size for better fitting
        plot.subtitle = element_text(size = 10), # Adjust subtitle size for better fitting
        axis.text = element_text(size = 10))      # Adjust axis text size for better fitting

# Combine the plots using patchwork to create a cohesive layout
(final_plot <- plot1 + plot2 + plot3 +            # Combine the three plots
  plot_layout(ncol = 1,                         # Arrange plots in one column
              heights = c(1, 1, 1)) +            # Set the height of each plot to be the same (you can adjust these if needed)
  plot_annotation(title = "Penguin Data Story",  # Add an overarching title
                  subtitle = "Exploring Penguin Species and Traits")) # Subtitle for context


#To stack plots vertically:
plot1 / plot2
#To place plots side by side:
plot1 | plot2
#You can combine these operators for more complex layouts:
plot1 | (plot2 / plot3)
#You can add an overall title or captions with `plot_annotation()`:
(plot1 | (plot2 / plot3)) + plot_annotation(title = "Penguin Data Analysis")
plot1 + plot2 + plot3 + plot_layout(ncol = 2) + plot_annotation(tag_levels = 'I')


# Part 4 ----


# Prepare data: Use the penguins dataset and remove any NA values
penguins_clean <- penguins %>% drop_na()

# Create the first plot: Flipper length vs. Body mass with a trend line and annotation
(plot1 <- ggplot(penguins_clean, aes(x = flipper_length_mm, y = body_mass_g, color = species)) +
  geom_point(size = 3) +
  geom_smooth(method = "lm", linetype = "dashed", color = "black") +  # Add a linear trend line
  annotate("text", x = 190, y = 5000, label = "Trend: Larger flippers = heavier body", 
           color = "black", size = 4, hjust = 0) +  # Add annotation
  scale_color_scico_d(palette = "batlow") +  # Apply scico color palette
  bbc_style() +  # Apply BBC-style theme
  labs(title = "Flipper Length vs.\n Body Mass", subtitle = "Trend highlighted with a linear fit")+
    theme(plot.title = element_text(size = 18),
          plot.subtitle = element_text(size = 10)))

# Create the second plot: Density plot of body mass across species
(plot2 <- ggplot(penguins_clean, aes(x = body_mass_g, fill = species)) +
  geom_density(alpha = 0.7) +
  scale_fill_scico_d(palette = "batlow") +
  bbc_style() +
  labs(title = "Body Mass Distribution", subtitle = "Density plot showing species differences")+
  theme(plot.title = element_text(size = 18),
        plot.subtitle = element_text(size = 10)))

# Create the third plot: Faceted scatter plot with a secondary axis for flipper length in cm
(plot3 <- ggplot(penguins_clean, aes(x = flipper_length_mm, y = body_mass_g, color = species)) +
  geom_point(size = 2) +  # Scatter plot with smaller points for better visibility in facets
  scale_color_scico_d(palette = "batlow") +  # Use a colorblind-friendly palette
  scale_x_continuous(
    sec.axis = sec_axis(~./10, name = "Flipper Length (cm)"),  # Add a secondary axis for flipper length in cm
    limits = c(170, 240)  # Set limits for flipper length to provide consistent scaling
  ) +
  scale_y_continuous(
    limits = c(2500, 6500)  # Set limits for body mass to avoid overcrowding
  ) +
  bbc_style() +  # Apply the BBC style for consistency
  labs(
    title = "Flipper Length (mm) vs.\n Body Mass by Species",  # Title of the plot
    subtitle = "Faceted by Species",  # Subtitle for additional context
    x = "Flipper Length (mm)",  # X-axis label
    y = "Body Mass (g)"  # Y-axis label
  ) +
  facet_wrap(~species, ncol = 1, strip.position = "top") +  # Facet by species with single column for readability
  theme(
    strip.text = element_text(size = 12, face = "bold"),  # Customize facet strip text for better visibility
    axis.text.x = element_text(angle = 45, hjust = 1),  # Rotate x-axis text for better spacing
    panel.spacing = unit(1, "lines"),  # Increase spacing between facets
    plot.title = element_text(size = 18),
    plot.subtitle = element_text(size = 10)))


# Combine all plots using patchwork
(final_plot <- (plot1 / plot2) | plot3 +  # Stack plot1 and plot2, and place plot3 beside them
  plot_annotation(
    title = "Exploring Penguin Data: A Visual Journey",
    subtitle = "Combining multiple visualizations into one cohesive story",
    caption = "Data: Palmer Penguins | Visualization: BBC-Style"
  ))

# Save the combined plot using finalise_plot
finalise_plot(
  plot_name = final_plot,
  source_name = "Data source: Palmer Penguins dataset",
  save_filepath = "Tutorial/final_penguin_plot.png"  # Adjust this to your folder structure
)


##############################################
# End of Tutorial
##############################################