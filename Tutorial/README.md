### Advanced Data Visualization: Creating BBC-Style Plots in R with ggplot2 (Part 3)
---
> <p align="center"> Created by Zeynep Yuksel - November 2024 </p>
---

### Overview

This tutorial explores advanced data visualization techniques in R, focusing on creating professional, BBC-style graphics using **ggplot2** and supplementary packages like **patchwork** and **scico**. By the end, learners will be equipped to produce publication-ready visuals with polished themes, cohesive color palettes, and multi-panel layouts.  

This tutorial targets advanced data visualization enthusiasts, such as 4th-year environmental/ecological science students, looking to elevate their storytelling through polished and professional graphs. The tutorial uses publicly available data from OurWorldInData to efficiently target the learning outcomes mentioned below.

Prior to tackling this tutorial, make sure that you have covered part 1 and 2 of coding club tutorials to make the most of this one :)

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
## Downloading data
Will be using publicly available data from OurWorldInData, consisting of ____ for relevance to BBC...
The data for this tutorial can be downloaded from __(link to dataset)__. 

Alternatively, the repository containing the script and dataset can be forked to your own GitHub account and added as a new RStudio project by copying the HTTPS link. Follow this(insert link to repo) link to access the repo and clone. Make a new script file making sure its informative, remember, following the coding etiquette covered in previous tutorials is an important practice at this stage.  

    ```
     # Data visualisation tutorial
     # Your Name
     # Date
     # Step 1: Load the libraries that will be necessary for this tutorial
       library(dplyr)
       library(ggplot2)
                
     ```

---

## Part 1: Introduction to BBC-Style Design**  
1. **What Makes a Plot "BBC-Style"?**  
   - Simplicity, clarity, accessibility, and storytelling.  
   - Examples of BBC plots and their applications in science and journalism.  

2. **Dataset Overview**  
   - Use the **Global Biodiversity Indicators** dataset (or similar public datasets).  
   - Brief explanation of key variables (e.g., species richness, time trends, regions).  

---

#### **Part 2: Advanced `ggplot2` Techniques**  

1. **Custom Themes for Clean Design**  
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

2. **Annotations for Context**  
   - Add meaningful annotations with `annotate()`:  
     ```r
     annotate("text", x = 2000, y = 50, label = "Biodiversity decline begins", size = 4)
     ```

3. **Secondary Axes for Comparisons**  
   - Example: Overlay biodiversity trends with temperature anomalies:  
     ```r
     scale_y_continuous(sec.axis = sec_axis(~., name = "Temperature Anomaly"))
     ```

4. **Using Custom Fonts and Titles**  
   - Apply BBC-style fonts using the `extrafont` package.

---

#### **Part 3: Cohesive Multi-Panel Layouts with `patchwork`**  

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

#### **Part 4: Applying Accessible and Aesthetic Color Palettes with `scico`**  

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

#### **Part 5: Putting It All Together—Creating a Complete BBC-Style Plot**  

1. **Combine Techniques into a Final Visualization**  
   - Incorporate all elements: advanced `ggplot2` features, `patchwork` layouts, and `scico` color palettes.  

2. **Example: Biodiversity Decline Over Time**  
   - Multi-panel layout comparing global vs. regional trends, with annotations and a cohesive color scheme.  

---

#### **Part 6: Challenges and Extensions**  

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

---

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
