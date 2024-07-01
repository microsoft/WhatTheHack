# Challenge 03 - Train and register the model - Coach's Guide 

[< Previous Solution](./Solution-02.md) - **[Home](./README.md)** - [Next Solution >](./Solution-04.md)

## Notes & Guidance

Sections:
1. Creating an MLFlow experiment
2. Reading the delta table with Spark
3. Performing a random split of the data
4. Creating a run within the experiment to fit the model
5. Loading the saved model and generating predictions with the validation data

Overview of student directions:
- This is a notebook based challenge. All the instructions and links required for participants to successfully complete this challenge can be found on Notebook 3 in the `student/resources.zip/notebooks` folder. 
- The students must follow the instructions, leverage the documentation and complete the code cells sequentially.

Coache's guidance:
- The full version of Notebook 3, with all code cells filled in, can be found for reference in the `coach/solutions.zip` folder of this GitHub.
- There may be multiple ways to attain the same solution and multiple valid functions to use in each section, but not every combination of methods might yield the end result.
- The aim of this challenge, as noted in the student guide, is to practice leveraging MLFlow within Fabric. This specific hack uses `sklearn` but other ML frameworks can be used in Fabric as well.
- To assist students, coaches can clear up doubts/give hints on the specifics of splitting the data and fitting the model but students should focus on learning how to structure runs and experiments on MLFlow.

## Success criteria
  - The heart.csv data is now saved as a delta table on the lakehouse
