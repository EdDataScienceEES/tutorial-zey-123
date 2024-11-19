# Advanced Data Visualization: Creating BBC-Style Plots in R (Part 3)
---
> <p align="center"> Created by Zeynep Yuksel - November 2024 </p>
---
<div align= "center">
     <img width="500" alt="Screenshot 2024-11-19 at 13 57 55" src="https://github.com/user-attachments/assets/428de24c-0989-4c09-90b5-21db51c4d52f">
</div>

_<p align="center"> **Source:** WWF </p>_

### Introduction & Overview

This tutorial explores advanced data visualization techniques in R, focusing on creating professional, BBC-style graphics using **ggplot2** and supplementary packages like **patchwork** and **scico**. By the end, learners will be equipped to produce publication-ready visuals with polished themes, cohesive color palettes, and multi-panel layouts.  

This tutorial targets advanced data visualization enthusiasts, such as 4th-year environmental/ecological science students, looking to elevate their storytelling through polished and professional graphs. The tutorial uses the `palmerpenguins` package on R, which is a dataset containing information on three penguin species (Adelie, Chinstrap and Gentoo) from the Palmer Archipelago, Antarctica. 

Prior to tackling this tutorial, make sure that you have covered part 1 and 2 of coding club Data Visualisation tutorials to make the most of this one :)

---

### Tutorial Aims  

1. Master advanced features of `ggplot2` for data storytelling.  
2. Learn to use `patchwork` for creating cohesive multi-panel layouts.  
3. Apply BBC-style aesthetics and design principles, leveraging the `scico` package for stunning and accessible color schemes.  

---

### Learning Objectives  

By completing this tutorial, learners will be able to:  
1. Utilize advanced `ggplot2` techniques, including annotations, custom themes, and secondary axes.  
2. Combine multiple plots seamlessly using the `patchwork` package.  
3. Apply color palettes from the `scico` package to ensure accessibility and visual appeal.  
4. Replicate BBC-style design principles, such as clarity, simplicity, and impactful storytelling.  

---
## Installing data
We will be using the `palmerpenguins` package on R, which contains two datasets (`penguins` and `penguins_raw`). We will be using the `penguins` dataset as it is simplified and ready to use, containing data for 344 penguins of 3 different species.

This dataset is particularly relevant for creating BBC-style plots as it provides a clean, well-structured dataset with distinct categorical variables (species) and quantitative variables (bill length, flipper length, body mass, etc.), which are ideal for showcasing clear and impactful visualizations. BBC-style plots emphasize clarity and effective storytelling, and the penguins dataset allows us to explore and visualize data patterns in a way that aligns with these principles, such as comparing trends, emphasizing key data points, and maintaining an engaging yet simple design.

[Click here to read more on this dataset](https://allisonhorst.github.io/palmerpenguins/) 

To install:
```
install.packages("palmerpenguins")
library(palmerpenguins)
# To explore the dataset (a useful practice):
head(penguins)
view(penguins)
```
**Additionally,** the repository containing the script that will be used in this tutorial can be forked to your own GitHub account and added as a new RStudio project by copying the HTTPS link. Follow [this link](https://github.com/EdDataScienceEES/tutorial-zey-123) to access the repo and clone. Make a new script file making sure its informative and has your info, remember, following the coding etiquette covered in previous tutorials is an important practice to adopt at this stage.

```
# Data visualisation tutorial (part 3)
# Your Name
# Date           
```
---

## Part 1: Introduction to BBC-Style Design 
### 1.a.What Makes a Plot "BBC-Style" and the necessary libraries   

Simplicity, clarity, accessibility, and storytelling. Some examples of BBC plots and their applications in science and journalism:
  
   ![image](https://github.com/user-attachments/assets/e05474b2-e863-4358-84c0-589d97cb84f2)
_<p align="center"> **Source:** BBC Data Journalism cookbook </p>_

To make graphics that adhere to the BBC style as seen above and will be used to advance in data visualization through this tutorial, certain packages need to be installed and loaded: 

```
# Install packages 
install.packages(c("dplyr", "ggplot2","patchwork","scico", "extrafont", "colorblindcheck", 
                   "tidyr", "gapminder", "ggalt", "forcats", "R.utils", "png","grid",
                   "ggpubr","scales","bbplot")) 
# Load libraries
# Load necessary libraries
library(dplyr)         # Data manipulation (filter, sort, summarize)
library(ggplot2)       # Create customizable plots and graphics
library(patchwork)     # Combine multiple ggplot2 plots into one
library(scico)         # Scientific color palettes for plots
library(extrafont)     # Use custom fonts in plots
library(colorblindcheck) # Check color-blind friendliness of plots
library(tidyr)         # Clean and reshape data for easier analysis
library(gapminder)     # Gapminder dataset for example visualizations
library(ggalt)         # Add additional plot types to ggplot2
library(forcats)       # Work with categorical data (factors)
library(R.utils)       # Helpful utilities for various tasks
library(png)           # Read/write PNG images
library(grid)          # Arrange graphical objects in plots
library(ggpubr)        # Create publication-ready plots
library(scales)        # Scale and format axes, colors, and labels in plots
library(bbplot)        # BBC-style plots for clean, simple visuals
```

With these packages all set up, we’ve got everything we need to dive into creating some stunning graphics. Ready to bring your data to life? Let’s do this! 

### 1.b.Understanding and using the `bbplot` package to make a simple line chart

To start off, we can look deeper into the main package necessary for obtaining these graphs, `bbplot`and how we can use it. The `bbpolot` package provides two main functions: `bbc_style()` and `finalise_plot()`:

* `bbc_style()`: This function is a pre-defined ggplot theme designed to apply a consistent BBC-style aesthetic to your chart. It adjusts text size, font (Helvetica), color, axis lines, axis text, margins, and other standard visual elements to create polished, professional visuals. These design choices are guided by recommendations and input from the BBC’s design team. This function is added to your ggplot workflow <ins>after</ins> you’ve created your plot and doesn’t take any arguments. Key features include bold styling for titles, legend placement at the top, and unobtrusive gridlines. However, it is important to note that the `bbc_style()` function does not automatically set colors for plot elements like lines in line charts or bars in bar charts. You need to define these colors separately using standard ggplot2 functions while creating your chart.

>For any additional customizations (e.g., changing axis text or adding annotations), apply the `theme()` function after calling the `bbc_style()`. This ensures your custom settings are not overwritten.

* `finalise_plot()`: Designed to prepare your BBC-style plot for publication or presentation. This function ensures that your chart adheres to specific layout standards by: a) adding a title and source (title- top, source-bottom of plot) and b)exporting your plot, saving final plot as a png with specified dimensions and resolution.
<ins>Function arguments:</ins> `finalise_plot(plot_name,source, save_filepath, width_pixels = 640, height_pixels = 450)`
>_note that the `width_pixels` is set to 640px by default, and `height_pixels` is set to 450px by default_
> this function goes beyond simply saving your chart. It also aligns the title and subtitle to the left, following BBC graphic standards while also giving you the opportunity to add a footer with the BBC logo on the right (if function `logo_image_path`= ____ is added to finalise plot command).

Below is an example of how the `bbc_style()` and its two functions can be used. This is an example for a simple line chart, using data from `palmerpenguins` package. 

```
# Prepare the data by grouping by year and calculating the average body mass
line_df <- penguins %>%
  group_by(year) %>%
  summarise(avg_body_mass = mean(body_mass_g, na.rm = TRUE))  # #Aggregates the data into meaningful metrics (average body mass) to simplify visualization

# Create a basic line plot 
(line_plot <- ggplot(line_df, aes(x = year, y = avg_body_mass)) +
  geom_line(colour = "#1380A1", size = 1) +  # Line plot with custom color and size
  geom_hline(yintercept = 0, size = 1, colour = "#333333") +  # Add a horizontal line at y = 0
  bbc_style() +
theme(panel.grid.major.x = element_line(color="#cbcbcb"), # Additional customizations (gridlines) added following bbc_style() command...
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

```
This gives us the following line chart, where the `bbc_style()` function essentially modified arguments in the `theme` function of `ggplot2`: 

<div align= "center">
     <img width="502" alt="Screenshot 2024-11-19 at 14 35 05" src="https://github.com/user-attachments/assets/90112323-94fc-42ed-945a-5ad7bf469b2e">
</div>

> #### _If you're interested in generating different kinds of graphics like multiple line charts, bar (normal, stacked and grouped) charts, dumbell charts and histograms with the BBC style, check out [the BBC Visual and Data Journalism cookbook for R graphics](https://bbc.github.io/rcookbook/#add_annotations).This tutorial only explores the package without going into much detail as the main focus is around advanced data visualization alongside a simple introduction to the BBC theme_ :)

---

## Part 2: Advanced `ggplot2` Techniques
Building on the solid foundations you mastered in Part 1, where you learned to create simple BBC-style plots using the `bbplot` package, this section delves deeper into enhancing storytelling through advanced `ggplot2` features. While Part 1 focused on the core principles of simplicity, clarity, and accessibility in BBC-style design, here you’ll expand those skills to create more dynamic and customized visualizations.

Get ready to enhance the polished aesthetics of BBC-style visuals and transform your plots into even more engaging and informative masterpieces!🎨✨

### 2.a. Adding Annotations to Highlight Key Points
Annotations are helpful for drawing attention to specific data points or trends in your visualization. We can use annotations with our penguin data to call out for important clusters or outliers when making a new scatter plot, showing us the relationship pengiun body mass vs flipper length. The easiest way to do this is by using the `annotate()` function. 

#### Adding annotations with the `annotate()` function
```
# Adding annotations (Highlighting a key year in the penguins dataset)  
(annotated_plot <- ggplot(penguins, aes(x = flipper_length_mm, y = body_mass_g)) +  #Mapping the x-axis to flipper_length_mm and the y-axis to body_mass_g.
    geom_point(aes(color = species), size = 3) +  #Plotting individual penguins as points on the chart, and coloring these points based on the species of penguin, setting size to 3. 
    annotate("text", x = 205, y = 4100, label = "Note this cluster!", size = 7, color = "black", family="Helvetica") +  #Placing a text annotation at the specified coordinates. Sets the annotation's text to "Note this cluster!" with a font size of 7 and color black.
    bbc_style() +  #Applying BBC-style formatting
    labs(title = "Penguin Body Mass vs. Flipper Length", subtitle = "Annotated clusters of penguins")) #Setting plot title and subtitles.

```
This gives us the following output: 

<div align= "center">
     <img width="507" alt="Screenshot 2024-11-19 at 17 56 51" src="https://github.com/user-attachments/assets/b1f31517-aa79-4c56-a5e1-166fb6b99c35">
</div>

The exact positioning of the annotation depends on the `x` and `y` arguments. We can also insert line breaks in our label using `\n` and adjust the spacing between lines with the `lineheight` parameter.

```
#Adding line breaks
(annotated_plot <- ggplot(penguins, aes(x = flipper_length_mm, y = body_mass_g)) +  
    geom_point(aes(color = species), size = 3) +
    annotate("text", x = 205, y = 4100, label = "Note\n this\n cluster!", size = 7, color = "black", family="Helvetica", lineheight = 0.8) +
    bbc_style() +  
    labs(title = "Penguin Body Mass vs. Flipper Length", subtitle = "Annotated clusters of penguins")) #Setting plot title and subtitles.

```
You can see the magic at work here—it’s a step up from what we did earlier. Nicer, isn’t it?

<div align= "center">
     <img width="496" alt="Screenshot 2024-11-19 at 17 54 53" src="https://github.com/user-attachments/assets/a540d625-a847-4410-8a84-cade46be884a">
</div>

#### Directly tying annotations to data using the `geom_label()` function
Luckily, there’s a smarter way to add data-based labels that saves both time and effort—hooray for efficiency! 🎉 While manually specifying x and y coordinates is great for pinpointing specific spots on your plot, doing this repeatedly for multiple (or all) points can quickly become a chore. Why not let your data do the heavy lifting instead? 😊

By using `geom_label()`, you can directly tie annotations to your data. Here’s an example applied to the penguin dataset, where each datapoint gets labels with just one line of code. 

```
#Adding labels based on data
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

```
Previously, we used the `annotate()` function to manually add annotations to specific points on the plot. This method is useful when you want to place text annotations at precise coordinates, but it requires specifying each position manually, which can be time-consuming if you're working with many data points. To improve efficiency and tie annotations directly to the data, we switched to `geom_label()`. Unlike `annotate()`, which requires manual coordinate input, `geom_label()` automatically places labels at positions determined by the data itself. This makes it more efficient when labeling multiple points at once. Both `annotate()` and `geom_label()` allow for the addition of text annotations, but `geom_label()` has the added benefit of placing a background box around each label, enhancing readability. While `annotate()` is better suited for static, fixed annotations, `geom_label()` is ideal for dynamic labeling tied directly to the data points.

<div align= "center">
     <img width="500" alt="Screenshot 2024-11-19 at 18 59 58" src="https://github.com/user-attachments/assets/36b571ff-0929-4513-8294-237091259531">
</div>

As you can see, this does end up looking a bit messy- definitely not the best choise for scatter plots with many datapoints. But this is what this function does and can be particularly useful with bar graphs:). 

#### Adding a line
Finally, among the many annotation features offered by ggplot2, one important capability to highlight is the ability to add an arrow. This feature can be very useful for drawing attention to specific parts of your plot. To do this, we will use the `geom_segment` function. 

```
# Adding arrows 
annotated_plot + geom_curve(aes(x = 205, y = 3800, xend = 200, yend = 3700),  # Set the start and end points of the arrow. If x/yend> x/y then the curve downward curve (sad face), if otherwise than upward smile :)
             colour = "#555555", #Setting the color of the curve to a light gray shade for subtle visibility.
             size = 0.5, # Thickness of the curve
             curvature = -0.1, #Determines the degree and direction of the curve; negative values create downward curves, while positive values create upward curves.
             arrow = arrow(length = unit(0.03, "npc")))  #Adds an arrowhead to the end of the curve with a specified length of 0.03 normalized parent coordinates (npc).
```

As specified in the above code, it is important to note that in `aes()`, the start coordinates are (x, y), and end coordinates of curve are (xend, yend); downward curves (like a frown) occur if the start is higher than the end, and upward curves (like a smile) occur if the opposite is true. This is also controlled by the `curvature` argument in `geom_curve` with negative values producing downard curves and positive values producing upward curves.

<div align= "center">
     <img width="500" alt="Screenshot 2024-11-19 at 21 04 48" src="https://github.com/user-attachments/assets/832b3424-003c-4531-834f-d8d0ba30ef31">
</div>

Fantastic work! You've successfully added an arrow and mastered the art of annotating your graphics—an essential skill for creating visuals that truly tell a story. Your charts are no longer just data displays; they’re now engaging, insightful, and packed with personality! Keep going—there’s no limit to what you can create! 🚀


### 2.b. Add depth to your plots with secondary axes, allowing for comparisons
Now that you've nailed several ways to annotate your graphics, it's time to level up and dive into creating secondary axes. Secondary axes are used to display additional information, such as a transformed version of the primary data. This feature is especially useful when you want to compare metrics in different units, reveal relationships, or highlight alternative perspectives—all without overcrowding your plot. 

#### Using secondary axes to compare metrics in different units

We can see how this is done with our penguins dataset to show penguin body mass in both grams and pounds. 

```
# Using a secondary y-axis to show body mass in pounds  
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
```
In this example, the secondary axis provides a dual perspective: body mass in grams (primary axis) and pounds (secondary axis). This is particularly handy for audiences who might be more familiar with one unit over the other. By visually linking both scales, you make your data more accessible and engaging to a broader audience while maintaining clarity.

Within the `scale_y_continous` argument, `sec.axis` creates a secondary y-axis by applying a transformation to the primary y-axis values. The transformation `~ . / 453.592` converts body mass from grams to pounds (1 pound ≈ 453.592 grams).
And `name = "Body Mass (lbs)"` assigns a label to the secondary axis to clearly indicate the units being displayed. 

<div align= "center">
    <img width="500" alt="Screenshot 2024-11-19 at 21 34 41" src="https://github.com/user-attachments/assets/0b5f1ec4-7239-4f23-8639-f679cab74f08">
</div>

#### Using secondary axes to combine line and bar charts
This is another common use of secondary axes in data visualization. This allows for the visualization and comparison of two related but differently scaled variables in a single, easy-to-understand plot. How fun :). 

```
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

```
<div align= "center">
     <img width="500" alt="Screenshot 2024-11-19 at 21 54 11" src="https://github.com/user-attachments/assets/7030033f-ddd6-4f40-9050-992da1f3ca8f">
</div>

What the data is showing us:
* The bar chart displays the mean flipper length for each penguin species, highlighting the differences in flipper sizes across species.
* The line chart overlays the mean body mass of the penguins, scaled for alignment with the flipper length values.
* The secondary y-axis provides an alternative scale for the body mass values, showing both the flipper length in millimeters and body mass in grams on the same plot, which makes the comparison between these two variables more intuitive.


### 2.c. Showcase patterns across groups using faceted layouts.
Now that we know how to annotate our graphics and set secondary axes, we can move onto faceting. Faceting splits data into subplots, making it easier to identify trends within groups.

```
# Facet by species  
faceted_plot <- ggplot(penguins, aes(x = flipper_length_mm, y = body_mass_g)) +  
  geom_point(aes(color = species), size = 3) +  
  facet_wrap(~species) +  # Create a panel for each species  
  bbc_style() +  
  labs(title = "Penguin Body Mass vs. Flipper Length",  
       subtitle = "Faceted by species for clearer comparisons")  

# Display the plot  
faceted_plot  
```

This creates a panel for each penguin species, allowing for comparisons across categories.

### 2.d. Refine visual aesthetics while ensuring accessibility with custom themes and color palettes.
Tips for Advanced Customization:
* Combining BBC Style and Custom Themes: Use theme() after bbc_style() to further refine plot elements.
* Choosing Accessible Color Palettes: Use the scico package to ensure your plots are accessible to all audiences, including those with color vision deficiencies.

Example: Accessible Color Palette
```
library(scico)  

accessible_plot <- ggplot(penguins, aes(x = flipper_length_mm, y = body_mass_g, color = species)) +  
  geom_point(size = 3) +  
  scale_color_scico(palette = "batlow") +  # Accessible color palette  
  bbc_style() +  
  labs(title = "Penguin Data with Accessible Colors",  
       subtitle = "Using scico for a colorblind-friendly palette")  

# Display the plot  
accessible_plot  
```

#### Next Steps
Now that you've mastered advanced ggplot2 techniques, we’ll move on to Part 3, where you’ll combine multiple plots into cohesive layouts using the patchwork package.

---

## **Part 3: Cohesive Multi-Panel Layouts with `patchwork`**  

1. **Combining Plots into a Story**  
   - Example: Compare biodiversity trends across continents side by side.  
     ```r
     library(patchwork)
     p1 + p2 + plot_layout(ncol = 2)
     ```

2. **Nested Layouts for Emphasis**  
   - Example: Centralize the global trend while showing regional breakdowns around it.  

3. **Adding Titles and Captions Across Panels**  
   - Use `plot_annotation()` for overarching titles and notes.  

---

## **Part 4: Applying Accessible and Aesthetic Color Palettes with `scico`**  

1. **Introduction to `scico`**  
   - Highlight benefits: perceptually uniform, colorblind-friendly palettes.  
   - Example: Using `scico` for a sequential palette:  
     ```r
     scale_color_scico(palette = "batlow")
     ```

2. **Ensuring Accessibility**  
   - Use the `colorblindcheck` package to verify accessibility.  

3. **Challenge: Choose a Palette for Your Data Story**  
   - Prompt learners to justify their palette choice based on context and audience.  

---

##  **Part 5: Putting It All Together—Creating a Complete BBC-Style Plot**  

1. **Combine Techniques into a Final Visualization**  
   - Incorporate all elements: advanced `ggplot2` features, `patchwork` layouts, and `scico` color palettes.  

2. **Example: Biodiversity Decline Over Time**  
   - Multi-panel layout comparing global vs. regional trends, with annotations and a cohesive color scheme.  

---

##  **Part 6: Challenges and Extensions**  

1. **Recreate a BBC Plot**  
   - Challenge learners to replicate a provided example using real-world data.  

2. **Create Your Own Story**  
   - Encourage learners to visualize a dataset of their choice using the skills learned.  

3. **Going Further**  
   - Introduce integrating these plots into R Markdown reports or Shiny apps.  

---

### **Reproducibility**  

1. **Dataset Access**  
   - Provide a pre-processed version of the dataset along with instructions for loading it.  

2. **Code Availability**  
   - Full code snippets in the tutorial repository with comments and explanations.  

3. **Dependencies**  
   - Include a list of required R packages and a script for installing them:  
     ```r
     install.packages(c("ggplot2", "patchwork", "scico", "extrafont", "colorblindcheck"))
     ```  

### **Creativity**  

- **Visual Appeal**  
  - Include polished visuals with carefully chosen fonts, colors, and layouts.  

- **Interactive Examples**  
  - Add GIFs or animations to demonstrate dynamic elements (if applicable).  

- **Engaging Narrative**  
  - Frame examples within a broader data-driven story to maintain interest.  

---

### **Conclusion**  

1. Summarize key skills and their applications.  
2. Provide resources for further learning: links to ggplot2, scico, patchwork documentation.  
3. Encourage learners to share their plots and stories with the community.  

---

### **Why This Tutorial Stands Out**  

1. **Relevance:** Focuses on advanced visualization techniques highly applicable to scientific and journalistic work.  
2. **Depth:** Goes beyond basics by introducing new packages and design principles.  
3. **Creativity:** Integrates aesthetics, accessibility, and multi-panel storytelling for impactful visuals.
