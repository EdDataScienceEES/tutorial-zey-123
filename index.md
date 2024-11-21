<img width="787" alt="Screenshot 2024-11-21 at 19 22 07" src="https://github.com/user-attachments/assets/282e48df-d8e4-483b-948e-bfe3c58fc157">

<h1 style="color: turquoise;">Advanced Data Visualization: Creating BBC-Style Plots in R (Part 3)</h1>

---

> <p align="center"> Created by Zeynep Yuksel - November 2024 </p>

---
<div align= "center">
     <img width="500" alt="Screenshot 2024-11-19 at 13 57 55" src="https://github.com/user-attachments/assets/428de24c-0989-4c09-90b5-21db51c4d52f">
</div>

<div align= "center">
     Source: WWF 
</div>


## Introduction & Overview

This tutorial explores advanced data visualization techniques in R, focusing on creating professional, BBC-style graphics using `ggplot2` and supplementary packages like `patchwork` and `scico`. It’s a fantastic tool for seeing what’s possible to elevate your plots to BBC-level standards,offering a starting point for those looking to improve their visuals. This is about exploring the range of options available to you as you get comfortable with the techniques. By the end, learners will be equipped to produce publication-ready visuals with polished themes, cohesive color palettes, and multi-panel layouts.  

Targeted at advanced data visualization enthusiasts (especially honours-year environmental/ecological science students), this tutorial is perfect for those who want to take their graphs to the next level. We’ll be using the `palmerpenguins` package, an open-source dataset containing information on three penguin species (Adelie, Chinstrap, and Gentoo) from the Palmer Archipelago in Antarctica (see citation at the end).

Prior to tackling this tutorial, make sure that you have covered part 1 and 2 of coding club Data Visualisation tutorials to make the most of this one :)

---

### Learning Objectives & Tutorial Aims

By completing this tutorial, learners will be able to:  
1. Apply BBC-style design principles, such as clarity, simplicity, and impactful storytelling, making use of the `bbplot` package.  
2. Utilize advanced `ggplot2` techniques, including annotations, custom themes, and secondary axes.
3. Apply color palettes from the `scico` package to ensure accessibility and visual appeal.  
4. Combine multiple plots seamlessly using the `patchwork` package.  

---
### Tutorial Steps  

1. Introduction to BBC-Style Design
   
   a. What Makes a Plot "BBC-Style" and the necessary libraries
   
   b. Introduction to using the `bbplot` package to make a simple line chart
   
3. Advanced `ggplot2` Techniques
   
   a. Adding annotations to highlight key points
   
   b. Adding depth to plots with secondary axes
   
   c. Showcasing patterns across groups using faceted layouts
   
   d. Refining visual aesthetics while ensuring accessibility with `scico`
   
5. Cohesive Multi-Panel Layouts with `patchwork`
   
   a. Combining Plots into a Story   

   b. Exploring different adjustments that can be done
   
7. Putting It All Together—Creating a Complete BBC-Style Plot
   
   a. Combine all techniques into a final visualization
   
   b. Combining multiple visualizations into a cohesive Story
   
9. Wrap Up!

---
## Installing data
We will be using the `palmerpenguins` package on R, which contains two datasets (`penguins` and `penguins_raw`). We will be using the `penguins` dataset as it is simplified and ready to use, containing data for 344 penguins of 3 different species.

This dataset is particularly relevant for creating BBC-style plots as it provides a clean, well-structured dataset with distinct categorical variables (species) and quantitative variables (bill length, flipper length, body mass, etc.), which are ideal for showcasing clear and impactful visualizations. BBC-style plots emphasize clarity and effective storytelling, and the penguins dataset allows us to explore and visualize data patterns in a way that aligns with these principles, such as comparing trends, emphasizing key data points, and maintaining an engaging yet simple design.

[Click here to read more on this dataset!](https://allisonhorst.github.io/palmerpenguins/) 

To install:
```r
install.packages("palmerpenguins")
library(palmerpenguins)
# To explore the dataset (a useful practice):
head(penguins)
view(penguins)
```
**Additionally,** the repository containing the script that will be used in this tutorial can be forked to your own GitHub account and added as a new RStudio project by copying the HTTPS link. Follow [this link](https://github.com/EdDataScienceEES/tutorial-zey-123) to access the repo and clone. Make a new script file making sure its informative and has your info, remember, following the [coding etiquette](https://ourcodingclub.github.io/tutorials/etiquette/) covered in previous tutorials is an important practice to adopt at this stage.

```r
# Data visualisation tutorial (part 3)
# Your Name
# Date           
```
---

## Part 1: Introduction to BBC-Style Design 
### 1.a.What Makes a Plot "BBC-Style" and the necessary libraries   

Simplicity, clarity, accessibility, and storytelling. Some examples of BBC plots and their applications in science and journalism:
  
   ![image](https://github.com/user-attachments/assets/e05474b2-e863-4358-84c0-589d97cb84f2)
<div align= "center">
     Source: BBC Data Journalism cookbook 
</div>

To make graphics that adhere to the BBC style as seen above and will be used to advance in data visualization through this tutorial, certain packages need to be installed and loaded: 

```r
# Install packages 
install.packages(c("dplyr", "ggplot2","patchwork","scico", "extrafont", "colorblindcheck", 
                   "tidyr", "gapminder", "ggalt", "forcats", "R.utils", "png","grid",
                   "ggpubr","scales","bbplot")) 
# Load libraries
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

```r
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
```r
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

```r
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

```r
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

```r
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

> Fantastic work! You've successfully added an arrow and mastered the art of annotating your graphics—an essential skill for creating visuals that truly tell a story. Your charts are no longer just data displays; they’re now engaging, insightful, and packed with personality! Keep going—there’s no limit to what you can create! 🚀


### 2.b. Add depth to your plots with secondary axes, allowing for comparisons
Now that you've nailed several ways to annotate your graphics, it's time to level up and dive into creating secondary axes. Secondary axes are used to display additional information, such as a transformed version of the primary data. This feature is especially useful when you want to compare metrics in different units, reveal relationships, or highlight alternative perspectives—all without overcrowding your plot. 

#### Using secondary axes to compare metrics in different units

We can see how this is done with our penguins dataset to show penguin body mass in both grams and pounds. 

```r
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
This is another common use of secondary axes in data visualization. This allows for the visualization and comparison of two related but differently scaled variables in a single, easy-to-understand plot. 

```r
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

> Yay! We’ve mastered secondary axes! First, we turned penguin body mass from grams to pounds on a secondary axis, making it easier for different audiences to grasp the data in their preferred units- especially important for graphics published on universal platforms like the BBC, where clarity and accessibility are key. Then, we had some fun by combining a bar chart (for flipper length) and a line chart (for body mass) in one plot, each with its own scale! With secondary axes, we can compare two related variables without making our plot look cluttered. It’s like giving your data a stylish makeover while keeping everything clear and easy to read. How cool is that?

### 2.c. Showcase patterns across groups using faceted layouts.
Now that we know how to annotate our graphics and set secondary axes, we can move onto faceting. Faceting splits data into subplots, making it easier to identify trends within groups. Although we have dipped our toes into faceting in [part 1](https://ourcodingclub.github.io/tutorials/datavis/) of the Coding Club's data visualisation series , here we will uncover some fun tips and tricks to truly make your facets shine.

Lets start with `facet_wrap()`, the go-to function in ggplot2 for creating small multiples. Unlike `facet_grid()`, it is used for a **single categorical variable**. This function creates multiple plots (or facets) based on the levels of that variable, wrapping them into a grid. You can specify the variable for faceting using `~`, and it will automatically arrange the facets into rows and columns, depending on the available space. This makes it especially useful when you want to display a large number of subplots without worrying about the combination of two categorical variables. 

Just like `facet_grid()`, you can control the scales of the axes with the `scales` argument, and `facet_wrap()` will give you a clean, organized way to compare different subsets of your data.

Here’s a quick cheat sheet on `facet_grid` before we dive into faceting our penguins using `facet_wrap()`:

```r
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

```
See how flexible and fun faceting can be? Whether you’re organizing by rows, columns, or both, it’s all about giving your audience a clear way to compare subsets of your data.

Ready to see this magic in action with our penguins? Let’s do it using `facet_wrap()`, keeping things playful and simple- just like penguins themselves! 🐧

```r
# Facet by species
# Vertical (by column)
(Vfaceted_plot <- ggplot(penguins, aes(x = flipper_length_mm, y = body_mass_g)) +  
    geom_point(aes(color = species), size = 3) +  
    facet_wrap(~species) +  # Create a panel for each species  
    bbc_style() +  
    labs(title = "Penguin Body Mass vs. Flipper Length",  
         subtitle = "Faceted by species for clearer comparisons")) 
```
<div align= "center">
     <img width="500" alt="Screenshot 2024-11-19 at 22 27 35" src="https://github.com/user-attachments/assets/41d9e3ca-0de2-4a24-aeab-a613428428a4">
</div>

As you can see, something seems off—the x-axis (flipper length) doesn't fit properly, which suggests that a horizontal arrangement of facets might work better for this specific example. We can fix this easily by adding the `dir='v'` command in `facet_wrap`.

```r
#Horizontal (by row)
(Hfaceted_plot <- ggplot(penguins, aes(x = flipper_length_mm, y = body_mass_g)) +  
    geom_point(aes(color = species), size = 3) +  
    facet_wrap(~species, dir="v") +  # Create a panel for each species where dir='v' changes direction of facet
    bbc_style() +  
    labs(title = "Penguin Body Mass vs. Flipper Length",  
         subtitle = "Faceted by species for clearer comparisons")) 
```
<div align= "center">
     <img width="500" alt="Screenshot 2024-11-19 at 22 31 52" src="https://github.com/user-attachments/assets/c2ccfc3b-bb6d-4b20-81d8-936fc659e38a">
</div>

Even better! We can take it up a notch by adjusting the layout so that the species names elegantly sit at the bottom of the facets. All it takes is adding the magical `strip.position = 'bottom'` command!

```r
# Adding label at bottom
(Lfaceted_plot <- ggplot(penguins, aes(x = flipper_length_mm, y = body_mass_g)) +  
    geom_point(aes(color = species), size = 3) +  
    facet_wrap(~species, strip.position="bottom") +  # Create a panel for each species adding species names to the bottom using strip.position
    bbc_style() +  
    labs(title = "Penguin Body Mass vs. Flipper Length",  
         subtitle = "Faceted by species for clearer comparisons")) 
```
<div align= "center">
     <img width="500" alt="Screenshot 2024-11-19 at 22 35 38" src="https://github.com/user-attachments/assets/db949b5d-b1f1-42c3-82cf-777b8130a6e9">
</div>

This creates a panel for each penguin species, allowing for comparisons across categories.

> And just like that, we’ve mastered the basics of the art of faceting! From wrapping subplots to customizing directions and labels, we’ve created a framework that makes exploring group-level patterns effortless and visually satisfying. Whether it's showcasing species-specific trends or breaking down comparisons by island, faceting lets the data speak clearly and beautifully. Feeling accomplished? You should be! 

### 2.d. Refine visual aesthetics while ensuring accessibility with custom themes and color palettes.
Now, let’s kick it up a gear and refine our visuals with custom themes and color palettes to make them truly shine and accessible. ✨ To achieve this, we will use the `scico` package. This package provides access to perceptually uniform and color-blindness friendly palettes developed by Fabio Crameri under the "Scientific Colour-Maps" label. The package includes 24 distinct palettes, featuring both diverging and sequential types, ensuring your plots are clear and effective for all audiences, including those with color vision deficiencies. This is especially important when sharing graphics on platforms like the BBC, where accessibility and clarity are key.

**Usage**: `scico(n, alpha = NULL, begin =0, end=1, direction=1, palette="bilbao", categorical = FALSE)`

**What the arguments mean**:

| Argument     | Description                                                                                  |
|--------------|----------------------------------------------------------------------------------------------|
| `n`          | The number of colors to generate for the palette.                                            |
| `alpha`      | The opacity of the generated colors. If `NULL`, RGB values are generated (alpha = 1).         |
| `begin`      | The starting point of the color sampling range (default is 0).                               |
| `end`        | The endpoint of the color sampling range (default is 1).                                     |
| `direction`  | The direction of the palette (1 for normal, -1 for reversed).                                |
| `palette`    | The name of the palette to sample from (use `scico_palette_names()` for available options).  |
| `categorical`| Boolean. Set to `TRUE` for categorical palettes and `FALSE` for continuous palettes.          |

We can also get an even nicer overview of the palette with running the `scico_palette_show()` function, aiding in decision-making when hoosing palettes:

<div align= "center">
     <img width="450" alt="Screenshot 2024-11-20 at 14 59 26" src="https://github.com/user-attachments/assets/731c3301-0ee2-4615-80d1-a4bc9d0b9014">
</div>

#### ggplot 2 support 
`scico` provides specific scale functions designed for use with `ggplot2`, such as `scale_color_scico()` for continuous data and `scale_color_scico_d()` for discrete data. These functions ensure that color palettes are applied properly, without needing to use `scico()` directly in the `ggplot2` function pipeline. While `scico` is lightweight and doesn't require `ggplot2`, if `ggplot2` is available, you'll have access to these scale `[color|fill]_scico()` functions to apply scientifically designed color palettes. So, instead of calling `scico()` directly, you should use `scale_color_scico()` or `scale_color_scico_d()` to apply a color palette to your plots.

When using scale_color_scico() for continuous/categorical data in the `ggplot2` function pipeline, the arguments you need to/can include are:
*  **palette**: This specifies the name of the color palette you want to use. Examples include "batlow", "davos", "bilbao", etc.
*  **begin (optional)**: This controls where to start sampling from the palette (a value between 0 and 1). The default is 0.
*  **end (optional):** This controls where to end sampling from the palette (a value between 0 and 1). The default is 1.

Let’s give it a try!

#### For categorical data (e.g `species`)
If you want to apply scico for a discrete variable (like species), use `scale_color_scico_d()`.

```r
# For categorical data (species)
(categorical_plot <- ggplot(penguins, aes(x = flipper_length_mm, y = body_mass_g, color = species)) +  # Create a ggplot object with penguins data, map 'flipper_length_mm' to x-axis, 'body_mass_g' to y-axis, and color based on 'species' (categorical variable)
    geom_point(size = 3) +
    scale_color_scico_d(palette = "batlow") +  # Apply 'scico' discrete color palette (batlow) for categorical data (species). The '_d' indicates a discrete scale.
    bbc_style() +  
    labs(  
      title = "Penguin Data: Species-based Colors",  
      subtitle = "Using a colorblind-friendly palette for categorical data"  
    ))

```
<div align= "center">
     <img width="500" alt="Screenshot 2024-11-20 at 15 36 11" src="https://github.com/user-attachments/assets/c1e330ac-7234-4eb9-ac18-1ad0b290845c">
</div>

This plot shows the relationship between flipper length and body mass for different penguin species, with each species represented by a distinct color using a colorblind-friendly discrete palette ("batlow"). The plot helps distinguish between species by color while visualizing how flipper length and body mass vary across them.


#### For continuous data (e.g `body_mass_g` or `flipper_length_mm`)
Say we want to look at `body_mass_g` or `flipper_length_mm`, which are continous variables, we have to use `scale_color_scico()` without the `_d` suffix:

```r
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

```
<div align= "center">
     <img width="500" alt="Screenshot 2024-11-20 at 15 36 56" src="https://github.com/user-attachments/assets/ae107a29-d1a9-455e-bff5-50bdf841b3c9">
</div>

This plot shows the relationship between flipper length and body mass for penguins, with body mass represented by a continuous color scale using the "bilbao" palette, and the legend is removed to reduce clutter, allowing the focus to be on the data points. The color scale provides insight into the variation in body mass across the data.

#### Accessibility check 
A helpful final step when using `scico` palettes is performing an accessibility check with `colorblindcheck::palette_check()`. This ensures that your chosen color palettes are accessible to all audiences, including those with color vision deficiencies. It aligns perfectly with the `scico` package’s mission of providing colorblind-friendly palettes and reinforces the broader goal of making thoughtful, inclusive color choices in visualizations.

To do this, make sure you have downloaded the `colorblindcheck` package earlier. We will be using the `palette_check()` function. This function evaluates how well a palette can be perceived by individuals with common types of color vision deficiencies, such as deuteranopia, protanopia, or tritanopia. Here's a concise example and explanation:

**Running the check**
```r
# Check for colorblind accessibility

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
```

**Analysis of `palette_check` output**

Running this gives you two outputs in your console, performing checks on both the continous data and categorical data. The table and explanation below provide a clear, concise summary and actionable steps for improving palette usability based on the analysis.

| Metric                 | Description                                                                                     | Key Insights                                                                                     |
|------------------------|-------------------------------------------------------------------------------------------------|--------------------------------------------------------------------------------------------------|
| **name**               | Type of vision simulated (normal, deuteranopia, protanopia, tritanopia).                       | Helps identify how the palette performs under various vision conditions.                        |
| **n**                  | Number of colors in the palette.                                                               | Indicates how many colors are being tested for distinguishability.                              |
| **tolerance**          | Threshold distance for distinguishable colors.                                                 | Pairs of colors closer than this may be indistinguishable.                                       |
| **ncp**                | Total number of color pairs tested.                                                            | Indicates the potential number of distinguishable color combinations in the palette.            |
| **ndcp**               | Number of distinguishable color pairs.                                                         | Lower values under colorblind simulations suggest blending; ideal is close to **ncp**.          |
| **min_dist**           | Smallest perceptual distance between any two colors.                                           | If below the **tolerance**, some colors may appear indistinguishable.                           |
| **mean_dist**          | Average perceptual distance across all pairs of colors.                                        | Higher values suggest better spread and differentiation between colors.                         |
| **max_dist**           | Largest perceptual distance between any two colors.                                            | Indicates the most contrasting colors in the palette.                                           |

**Interpretation of the Results**:
- **High `ndcp` Values**: The palette performs well when most color pairs are distinguishable across vision types.
- **Low `min_dist` Values**: Suggest that some colors are too close together and may blend for certain users.
- **Balanced `mean_dist`**: Ensures an even distribution of distinguishable colors, providing clarity in visualization.
- **Recommendation**: 
  - If `ndcp` drops significantly under certain vision types, consider using palettes designed for accessibility (e.g., `batlow` or `viridis`).
  - Ensure that `min_dist` exceeds the tolerance threshold to minimize indistinguishability issues.

**Action Plan**:
- Increase the number of colors (`n`) in the palette for finer granularity.
- Explore alternative palettes if accessibility is critical, especially for public or inclusive visualizations.


**In conclusion**, color is a big deal in data viz—it shapes how we see and understand information. While `scico`’s palettes are amazing for accessibility, there’s so much more out there! The `pals` package, for example, lets you test palettes like the Broc scale to see how they hold up. And scico isn’t alone—RColorBrewer and viridis are other popular picks, offering variety to keep things fresh. Emil Hvitfeldt’s R palette collection is a goldmine too (though not all are accessibility-focused). The takeaway? Have fun, mix it up, and think about how your colors connect with your audience. Always choose wisely!

#### Next Steps

You're nearly there! You've just unlocked some advanced ggplot2 skills, and now it's time to level up even further. In Part 3, we’ll dive into the magical world of multi-panel layouts using the patchwork package. It's like giving your plots a stylish, coordinated outfit! 😎

---

## Part 3: Cohesive Multi-Panel Layouts with `patchwork`

Well done for making it this far! When visualizing data, sometimes it's useful to combine multiple plots into one cohesive story. `patchwork` is a package designed to make it incredibly easy to do this by merging separate `ggplot2` plots into a single graphic. It's a great tool for creating complex layouts without the hassle, providing a more intuitive and exploratory API compared to other options like `gridExtra::grid.arrange()` or `cowplot::plot_grid`. Whether you need simple side-by-side plots or intricate, multi-panel layouts, patchwork makes it simple and fun.

####  3.a.Combining Plots into a Story   
Below is a code example using the penguin dataset to create multiple plots and combine them into a unified story with patchwork. Each plot represents a different aspect of the penguin data, and we’ll combine them to show different visual angles at once.

```r
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
```
<div align= "center">
     <img width="500" alt="Screenshot 2024-11-20 at 16 42 04" src="https://github.com/user-attachments/assets/5ef868af-e7dc-4dba-adfb-3c061e29d884">
</div>

As you can see, combining `patchwork` with the `bbc_style()` theme may produce plots that are difficult to read due to oversized elements. To address this, we can make a few adjustments. Specifically, by adding a line of code after applying the `bbc_style()` theme to all plots and combining them with `patchwork`, we can fine-tune the plot sizes for better readability. It is also important to note that by default, plots will arrange themselves in a grid. If you want to adjust the number of rows or columns, use `plot_layout()`.

```r
  bbc_style() +                                  # Apply BBC style directly
  theme(plot.title = element_text(size = 12),    # Adjust title size for better fitting
        plot.subtitle = element_text(size = 10), # Adjust subtitle size for better fitting
        axis.text = element_text(size = 10))     # Adjust axis text size for better fitting
```
<div align= "center">
     <img width="500" alt="Screenshot 2024-11-20 at 16 43 08" src="https://github.com/user-attachments/assets/fe0d1d39-1d7e-4cdf-901f-ff37f5b69ac1">
</div>

Voila! Better, isn't it?

#### 3.b. Exploring different adjustments that can be done when combining plots with `patchwork`
Combining plots using the `+` opperator and adding labels and titles as we did in the above example is only the basic use of `plot_layout()`. There are endless adjustments we can do to the stacking/placement of plots, annotate the composition, controlling layouts and many more. Below are short summaries of how the most common adjustments can be done and the outputs they give. These can be chosen and adopted to best fit the data and graphics you want to use. 

##### Stacking and Placing Plots
You can also stack or arrange plots side by side using the / and | operators:

To stack plots vertically:

```r
plot1 / plot2
```
<div align= "center">
     <img width="500" alt="Screenshot 2024-11-20 at 17 14 01" src="https://github.com/user-attachments/assets/d73afaf0-f837-4c86-b811-484af373669b">
</div>

To place plots side by side:
```r
plot1 | plot2
```
<div align= "center">
     <img width="500" alt="Screenshot 2024-11-20 at 17 14 47" src="https://github.com/user-attachments/assets/fa8706be-816e-45b4-a61d-e7bfb063b01c">
</div>

You can combine these operators for more complex layouts:
```r
plot1 | (plot2 / plot3)
```
<div align= "center">
     <img width="500" alt="Screenshot 2024-11-20 at 17 15 33" src="https://github.com/user-attachments/assets/6a991d08-94d6-462e-9b26-a068b49a1fa1">
</div>

##### Annotating the Composition
You can add an overall title or captions with `plot_annotation()`:

```r
(plot1 | (plot2 / plot3)) + plot_annotation(title = "Penguin Data Analysis")
```
<div align= "center">
     <img width="500" alt="Screenshot 2024-11-20 at 17 16 12" src="https://github.com/user-attachments/assets/88bccaef-1ffc-4e19-ae6f-360c961b3072">
</div>

Patchwork also provides the ability to auto-tag to identify subplots in text:

```r
plot1 + plot2 + plot3 + plot_layout(ncol = 2) + plot_annotation(tag_levels = 'I')
```
<div align= "center">
     <img width="500" alt="Screenshot 2024-11-20 at 17 26 38" src="https://github.com/user-attachments/assets/553c6b8b-7f01-4a3d-bc1f-49a56adeb5ed">
</div>


#### Hungry for more? 
This is just the beginning! While you now have the basics, there's so much more to explore with patchwork. Check out the [additional guides](https://patchwork.data-imaginist.com/articles/guides/layout.html#controlling-guides) to learn more about advanced features, such as consolidating all legends into one spot, removing duplicates, or aligning plots across multiple pages.


---

##  Part 4: Putting It All Together—Creating a Complete BBC-Style Plot
You’ve put in the work, experimented with various tools, and learned how to control every detail of your visualizations. Now, it’s time to stitch it all together into something truly spectacular! In this section, we’ll create a polished, final plot using everything you’ve learned so far—combining your skills with bbc-style theming, clever color choices, and layout tricks to make a plot that’s not only informative but also visually stunning.

We’ll be finishing off our penguin data story by bringing in multiple elements: the BBC style, attractive color palettes, and precise layout management. This is where all your creativity and hard work culminates into one eye-catching, ready-to-share plot.

So let’s dive in and get creative! Here’s how to finish strong with the `finalise_plot()` function, ensuring that everything is just right!

#### 4.a. Combine Techniques into a Final Visualization: 
Incorporating all elements: advanced `ggplot2` features,`bbplot` functions, `patchwork` layouts, and `scico` color palettes.

#### Mastering Annotations, Trend Lines, and BBC-Style Visuals: Flipper Length vs. Body Mass

```r
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
```
<div align= "center">
     <img width="500" alt="Screenshot 2024-11-20 at 19 40 37" src="https://github.com/user-attachments/assets/ebab760b-c5cb-4fa0-89ea-b31a1a91e2d4">
</div>

This plot combines multiple advanced visualization techniques to create an accessible and informative design. A scatter plot is enhanced with a linear trend line to highlight the relationship between flipper length and body mass, reinforcing key insights. The use of the `annotate()` function draws attention to this trend with a concise explanatory note, ensuring clarity and impact. A colorblind-friendly palette from the `scico` package (batlow) is applied to maintain accessibility, while the `bbc_style()` theme ensures a clean and professional appearance. Together, these elements align with the tutorial’s learning outcomes, demonstrating the ability to enrich plots with annotations, utilize accessible color palettes, and create polished visualizations for effective storytelling.

#### Exploring Species-Based Body Mass Distributions with Density Plots

```r
# Create the second plot: Density plot of body mass across species
(plot2 <- ggplot(penguins_clean, aes(x = body_mass_g, fill = species)) +
  geom_density(alpha = 0.7) +
  scale_fill_scico_d(palette = "batlow") +
  bbc_style() +
  labs(title = "Body Mass Distribution", subtitle = "Density plot showing species differences")+
  theme(plot.title = element_text(size = 18),
        plot.subtitle = element_text(size = 10)))
```
<div align= "center">
     <img width="500" alt="Screenshot 2024-11-20 at 19 43 33" src="https://github.com/user-attachments/assets/cf0a52d4-bfd2-4cf1-b07f-f552feacc595">
</div>

This plot uses a density visualization to highlight how the body mass of penguins differs across species. By applying the scico color palette, we ensure accessibility while enhancing visual distinction between species. The BBC-style formatting ensures clarity and a professional design, making the distribution patterns easy to interpret.

####  Faceted Scatter Plot with Secondary Axis and Species Insights

```r
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
```
<div align= "center">
     <img width="500" alt="Screenshot 2024-11-20 at 19 47 09" src="https://github.com/user-attachments/assets/587742c5-eb3e-4fd0-9ab1-752bd3292e6a">
</div>

This faceted scatter plot showcases the relationship between body mass and flipper length for each penguin species, highlighting species-specific patterns. The use of facets separates the data into clear, individual panels for each species, while the scatter plot points are color-coded using the scico package's accessible "batlow" palette. A secondary axis translates flipper length from millimeters to centimeters, catering to diverse audiences. Custom scaling ensures consistent axes across panels, while the bbc_style() theme enhances clarity and professionalism. This plot effectively communicates species differences with a clean, visually appealing design.


#### 4.b. Combining Multiple Visualizations into a Cohesive Story - using `patchwork` and `finalise_plot()`
Now it’s time to bring everything together! We’ll combine all of our awesome plots into one cohesive layout using the patchwork package. And don’t forget—once our masterpiece is ready, we’ll save it in the perfect BBC-style theme using `finalise_plot()`. If you’re thinking “wait, did we learn that already?”—no worries if it’s slipped your mind, we covered a lot! Let’s get it done! 😊

When working with R, it’s important to remember that unexpected challenges can arise—sometimes even with otherwise seamless tools. The **bbplot** package, for instance, is designed primarily for single plots. As a result, using **patchwork** in combination with `finalise_plot()` can lead to compatibility issues. However, as is often the case in R, there are multiple creative solutions to tackle such problems.  

To save and style your plots effectively, you can take one of two approaches:  
1. **Save individual plots with `finalise_plot()`**: This method is straightforward and allows you to take full advantage of bbplot’s styling features. Useful when you want to save individual plots and refer to plots seperately as opposed to together. 
2. **Use patchwork for combined plots and add features manually**: If you want to display multiple plots together, you can replicate the styling elements provided by `finalise_plot()`—like annotations and branding—and save the combined figure using `ggsave()`.  

Below, we demonstrate both approaches and highlight the outcomes they produce.


**Approach 1:** Saving individual plots with `finalise_plot()`: 
To remind yourself on the arguments needed for `finalise-plot()`, feel free to scroll back up to part 1b :). The plots below are all set to save in the repository's "Tutorial" folder. 

```r
# Save Plot 1
finalise_plot(
  plot_name = plot1,
  source = "Source: Palmer Penguins Dataset",
  save_filepath = "Tutorial/plot1.png",
  logo_image_path = logo_image_path,
  width_pixels = 640,
  height_pixels = 450)

# Save Plot 2
finalise_plot(
  plot_name = plot2,
  source = "Source: Palmer Penguins Dataset",
  save_filepath = "Tutorial/plot2.png",
  logo_image_path = logo_image_path,
  width_pixels = 640,
  height_pixels = 450)

# Save Plot 3
finalise_plot(
  plot_name = plot3,
  source = "Source: Palmer Penguins Dataset",
  save_filepath = "Tutorial/plot3.png",
  logo_image_path = logo_image_path,
  width_pixels = 640,
  height_pixels = 450)
```
This gives us the following graphs :


<div style="display: flex; justify-content: center;"> <!-- Plot 1 and Plot 2 in the same row -->
  <div style="margin-right: 10px; text-align: center;">
    <p><strong>Plot 1</strong></p>
    <img width="400" alt="Plot 1" src="https://github.com/user-attachments/assets/cc734104-60f1-43cf-9f6e-f4ff18b77c00">
  </div>
  <div style="text-align: center;">
    <p><strong>Plot 2</strong></p>
    <img width="400" alt="Plot 2" src="https://github.com/user-attachments/assets/1d1650b3-adce-4d3a-818e-98fc7e75faeb">
  </div>
</div>

<!-- Plot 3 in a separate row, centered -->
<div style="text-align: center; margin-top: 20px;">
  <p><strong>Plot 3</strong></p>
  <img width="400" alt="Plot 3" src="https://github.com/user-attachments/assets/f85c6559-2bc5-4205-98e1-021203b7735e">
</div>


**Approach 2:** Use `patchwork` for combined plots and add features manually:

```r
# Combine the original plots using patchwork
(final_combined_plot <- ((plot1 / plot2) | plot3) + # Stack plot1 and plot2, and place plot3 beside them
    plot_annotation(
      title = "Exploring Penguin Data: A Visual Journey",
      subtitle = "Combining multiple visualizations into one cohesive story",
      caption = "Data: Palmer Penguins | Visualization: BBC-Style"
    ))

# Save the combined plot directly with ggsave()
ggsave(
  filename = "Tutorial/final_combined_plot.png",
  plot = final_combined_plot,
  width = 12,  # Adjust as needed
  height = 8,  # Adjust as needed
  dpi = 300
)
```
This gives us the following graph with `finalise_plot()` features like captions added manually.

<div align= "center">
     <img width="550" alt="Screenshot 2024-11-21 at 15 49 31" src="https://github.com/user-attachments/assets/e3ecf61a-01fa-4884-9216-d54e575dbdbc">
</div>

We’ve succesfully pulled off the ultimate data visualization remix by combining multiple plots into a cohesive masterpiece using the **patchwork** package! Who knew that making sense of penguin data could be this fun? While **bbplot** is designed for single plots, we’ve flexed our creative muscles and found clever workarounds to keep our style intact. Whether you’re saving individual plots with `finalise_plot()` or adding some personal flair to a combined plot saved with **ggsave()**, both approaches let you share your work in style. So, whether you’re tackling penguins or another dataset, remember: R is full of surprises, and with a little creativity, you can always find a way to make your visualizations shine!


---
## Wrapping Up: A Positive Reflection on Your Progress
As we wrap up, let’s celebrate the insights gained through today’s exploration! We've made it through a comprehensive visual analysis of penguin data, and by the end of this journey, you should have a solid grasp of how to create impactful, BBC-style plots using ggplot2, patchwork, and the scico package. Our final visual story, created in part 4, shows how well we can bring together multiple elements—annotations, custom themes, faceted layouts, and more—to tell a cohesive and compelling data story.

<div align= "center">
     <img width="350" alt="Screenshot 2024-11-21 at 12 00 40" src="https://github.com/user-attachments/assets/518086f4-6060-453f-81f5-bb0aa034de96">
</div>

<div align= "center">
     A Penguin in its Natural Habitat (clearly celebrating the end of this looong tutorial with us!).Source:National Geographic
</div>



**By now, you should have:**
* Broadly understood advanced plotting techniques with ggplot2 and patchwork to combine multiple plots into one cohesive visual narrative.
* Gained a deeper understanding of how to apply BBC-style design principles, creating professional, clean, and effective visualizations.
* Discovered how to enhance your plots with annotations, secondary axes, and creative color palettes for accessibility and visual appeal.

Remember, the goal of this tutorial isn’t for you to memorize every function, but to explore and experiment! You can always revisit the script, refine your plots, and get inspiration from this journey for any future visualization tasks. If you’re ever in need of a refresher, feel free to refer to the resources shared throughout the tutorial and continue exploring the endless possibilities in R’s rich visualization ecosystem.

## Keep exploring and visualizing—your next project could be just a plot away!

---

_If you have any questions or feedback,  don't hesitate to reach out to me on zeynepdenizyuksel2004@gmail.com_

---

**Related Tutorials:**
* Beautiful and Informative Data-vis (starters on ggplot2): [click here!](https://ourcodingclub.github.io/tutorials/datavis/)
* Data Visualization 2 (customising your figures): [click here!](https://ourcodingclub.github.io/tutorials/data-vis-2/)
* Getting Started with Shiny (creating interactive web apps using the R language): [click here!](https://ourcodingclub.github.io/tutorials/shiny/)
* Storytelling with data (data visualisation meets graphic design to tell scientific stories): [click here!](https://ourcodingclub.github.io/tutorials/dataviz-storytelling/)
  

**Future Reading:**
* More on data visualization, the data-vis cheat sheet: [click here!](https://rstudio.github.io/cheatsheets/html/data-visualization.html)
* If you found it challenging to understand data wrangling and manipulation i.e what was done prior visualization on the data, read more on dplyr and how it works: 
[click here!](https://ourcodingclub.github.io/tutorials/data-manip-intro/)
* More on using controlling layouts with patchwork: [click here!](https://cran.r-project.org/web/packages/patchwork/vignettes/patchwork.html)
* More on aligning plots across multiple pages using patchwork: [click here!](https://patchwork.data-imaginist.com/articles/guides/multipage.html)

**Citation:**

_Alongside the sources used that were linked throughout the tutorial and can be found in the future readings & related tutorials above, the `palmerpenguins` dataset was used_:

Horst AM, Hill AP, Gorman KB (2020). palmerpenguins: Palmer Archipelago (Antarctica) penguin data. doi:10.5281/zenodo.3960218, R package version 0.1.0, https://allisonhorst.github.io/palmerpenguins/.

---

_**Why This Tutorial Stands Out**_  

_1. **Relevance:** Focuses on advanced visualization techniques highly applicable to scientific and journalistic work._  
_2. **Depth:** Goes beyond basics by introducing new packages and design principles._  
_3. **Creativity:** Integrates aesthetics, accessibility, and multi-panel storytelling for impactful visuals._
