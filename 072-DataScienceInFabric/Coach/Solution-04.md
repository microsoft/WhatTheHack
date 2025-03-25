# Challenge 04 - Generate batch predictions - Coach's Guide 

[< Previous Solution](./Solution-03.md) - **[Home](./README.md)** - [Next Solution >](./Solution-05.md)

## Notes & Guidance

In this challenge, participants must use the model trained in Challenge 3 to generate predictions over a simulated set of data. Participants complete the challenge by making the new predictions available as a delta table in the lakehouse, which they will use on Challenge 6 to create a PowerBI report showing their findings.

### Sections
1. Simulate input data to be used for predictions
2. Load the model and generate predictions
3. Format predictions and save them to a delta table
   
### Overview of student directions:
- This is a notebook based challenge. All the instructions and links required for participants to successfully complete this challenge can be found on Notebook 4 in the `student/resources.zip/notebooks` folder.
- To run the notebook, go to your Fabric workspace and select Notebook 4. Ensure that it is correctly attached to the lakehouse.
- The students must follow the instructions, leverage the documentation and complete the code cells sequentially.

### Coaches' guidance:
- The full version of Notebook 4, with all code cells filled in, can be found for reference in the `coach/solutions` folder of this GitHub.
- The aim of this challenge, as noted in the student guide, is to learn how to use the PREDICT function from a Spark notebook with a pre-trained model. Simulating the data is a necessary previous step, but not the focus of this challenge.
- To assist students, coaches can clear up doubts/give hints on how to create the simulated data, but students should focus on learning how to load the model and generate predictions.

## Success criteria
  - The predictions have been saved as a delta table to the lakehouse

