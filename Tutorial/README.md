### Advanced Data Visualization: Creating BBC-Style Plots in R (Part 3)
---
> <p align="center"> Created by Zeynep Yuksel - November 2024 </p>
---
<div align= "center">
     <img width="500" alt="Screenshot 2024-11-19 at 13 57 55" src="https://github.com/user-attachments/assets/428de24c-0989-4c09-90b5-21db51c4d52f">
</div>

### Overview

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
### 1.a. What Makes a Plot "BBC-Style" and the necessary libraries   
   - Simplicity, clarity, accessibility, and storytelling.  
   - Examples of BBC plots and their applications in science and journalism:
  
   ![image](https://github.com/user-attachments/assets/e05474b2-e863-4358-84c0-589d97cb84f2)

To make graphics that adhere to the BBC style as seen above, certain packages need to be installed and loaded: 

```
# Install packages 
install.packages(c("dplyr", "tidyr", "gapminder", "ggplot2", "ggalt", "forcats", "R.utils", "png","grid","ggpubr","scales","bbplot"))
# Load libraries
library(dplyr) #Data manipulation (filtering, grouping, summarizing).
library(tidyr) #Data tidying (reshaping, pivoting). 
library(ggplot2) #Data visualization using the grammar of graphics.
library(ggalt) #Adds advanced plot elements like dumbbell plots.
library(forcats) #Simplifies working with categorical variables (factors).
library (R.utils) #Utilities for file and system operations.
library(png) #Reads and writes PNG image files.
library(grid) #Creates and manipulates graphical objects.
library(ggpubr) #Enhances ggplot2 with publication-ready themes and annotations.
library(scales) #Customizes scales (axes, colors) in visualizations.
library(bbplot) #Making ggplot graphics in BBC news style.
```

Once these packages are installed, we essentially got everything to start creating our lovely graphics. 

### Understanding and using the `bbplot` package to make a simple line chart

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
     <img width="402" alt="Screenshot 2024-11-19 at 14 35 05" src="https://github.com/user-attachments/assets/90112323-94fc-42ed-945a-5ad7bf469b2e">
</div>


### 1.b. **Dataset Overview**  
   - Use the **Global Biodiversity Indicators** dataset (or similar public datasets).  
   - Brief explanation of key variables (e.g., species richness, time trends, regions).  

---

## Part 2: Advanced `ggplot2` Techniques

### 2.a. Custom Themes for Clean Design 
   - Use `theme_minimal()` as a base and extend it for a BBC-style theme:  
     ```
     theme_bbc <- theme_minimal() +
       theme(
         text = element_text(family = "Helvetica", color = "black"),
         panel.grid.minor = element_blank(),
         panel.grid.major.x = element_blank(),
         axis.line = element_line(color = "black")
       )
     ```

### 2.b. Annotations for Context
   - Add meaningful annotations with `annotate()`:  
     ```r
     annotate("text", x = 2000, y = 50, label = "Biodiversity decline begins", size = 4)
     ```

### 2.c. Secondary Axes for Comparisons 
   - Example: Overlay biodiversity trends with temperature anomalies:  
     ```r
     scale_y_continuous(sec.axis = sec_axis(~., name = "Temperature Anomaly"))
     ```

### 2.d. Using Custom Fonts and Titles
   - Apply BBC-style fonts using the `extrafont` package.

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
