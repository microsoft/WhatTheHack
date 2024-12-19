# Challenge 02 - Data preparation with Data Wrangler - Coach's Guide

[< Previous Solution](./Solution-01.md) - **[Home](./README.md)** - [Next Solution >](./Solution-03.md)

## Notes & Guidance

In this challenge, hack participants must use Data Wrangler to prepare the heart dataset for model training. The purpose is to focus on transforming and preparing the data for the next challenges. They will have the flexibility to either write code in a notebook or leverage Data Wrangler’s intuitive interface to streamline the pre-processing tasks.

### Sections

1.	Read the .csv file into a pandas dataframe in the notebook. (Notebook 2)
2.	Launch the Data Wrangler and interact with the data cleaning operations (Notebook 2)
3.	Apply the operations using python codes (Notebook 2)
4.	Develop feature engineering using spark. (Notebook 2)
5.	Write the dataframe to the lakehouse as a delta table. (Notebook 2)

### Student step-by-step instructions
- Launching Data Wrangler:
  -  Participants must create a pandas dataframe the fabric notebook. It’s necessary to complete the first cell in notebook 2.
  -  Once executed, under the notebook ribbon Home tab, select Launch Data Wrangler. You'll see a list of activated pandas DataFrames available for editing.
  -  Select the DataFrame you just created in last cell and open in Data Wrangler. From the Pandas dataframe list, select `df`.

    
- Data Cleaning Operations – (Data Wrangler)
  - *Removing Unnecessary Columns*
     - On the *Operations* panel, expand *Schema* and select *Drop columns*.
     - Select `RowNumber`. This column will appear in red in the preview, to show they're changed by the code (in this case, dropped.)
     - Select **Apply**, a new step is created in the **Cleaning steps panel** on the bottom left.
      
  - *Dropping Missing Values*
    - On the **Operations** panel, select **Find and replace**, and then select **Drop missing values**.
    - Select the `RestingBP`, `Cholesterol` and `FastingBS` columns. Those are the columns that are pointed as having missing values on the right-hand side menu of the screen.
    - Select **Apply**, a new step is created in the **Cleaning steps panel** on the bottom left.
   
  - *Dropping Duplicate Rows*
    - On the **Operations** panel, select **Find and replace**, and then select **Drop duplicate rows**.
    - Select **Apply**, a new step is created in the **Cleaning steps panel** on the bottom left.
   
- Feature Engineering - (Notebook)
  - This part is notebook based. Participants will work in cells 09, 10, and 11 to transform categorical values into numerical labels.
  - You can also explore how to one-hot encode the categorical columns with Data Wrangler. However, this will not create labels in your existing columns, but rather a new column for each category with True and False values. Using this alternative format might need some modification to the code in the model training process. Please discuss this possibility with hack attendees to raise awareness of this Data Wrangler feature.

### Overview of student directions (running Notebook 2)
- This section of the challenge is notebook based. All the instructions and links required for participants to successfully complete this section can be found on Notebook 2 in the `student/resources.zip/notebooks` folder.
- To run the notebook, go to your Fabric workspace and select Notebook 2. Ensure that it is correctly attached to the lakehouse. You might need to connect to the lakehouse you previously created on the left-hand side file explorer menu.
- The students must follow the instructions, leverage the documentation and complete the code cells sequentially.

### Coaches' guidance

-	This challenge has 3 main sections, Data Wrangler operations, feature engineering and saving processed data to a delta table. 
-	The full version of Notebook 2, with all code cells filled in, can be found for reference in the `coach/solutions` folder of this GitHub.
-	The aim of this challenge, as noted in the student guide, is to understand data preparation using data wrangler and fabric notebooks.
-	To assist students, coaches can clear up doubts regarding the Python syntax or how to get started with notebooks, but students should focus on learning how to operate data wrangler, navigate the Fabric UI, code in notebooks and read/write to the delta lake.

  
## Success criteria
-	The heart dataset totally shaped, cleaned and prepared for the model training.
-	No data duplicated or exceeded columns.
-	No missing values.
-	No categorical values.


