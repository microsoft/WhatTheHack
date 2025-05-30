# Challenge 03 - The Teachers Assistant—Batch Essay Grading - Coach's Guide 

[< Previous Solution](./Solution-02.md) - **[Home](./README.md)** - [Next Solution >](./Solution-04.md)

## Notes & Guidance

There are lot of opportunities for the students to get things wrong in this Challenge. Make sure they use the correct names for fields, model, and document type. These are in the document-intelligence-dictionary.json. Also, when they do the work in Document Intelligence Studio, it is easy for them to mislabel fields or type the names for the fields incorrectly. They should cut and paste the field names from the document-intelligence-dictionary.json. 

The signature field appears to only work by drawing a region and then selecting a field. 

Checkboxes sometimes can be finicky about how they are clicked and then assigned to a field. If you get an error, make sure you click the checkbox itself and not the check mark/X within the checkbox. 

If the model training fails, the student should retry the model training. Sometimes the Document Intelligence service might be under load and the training may just fail. 


Note: When cleaning up the resource group or resource, you should ensure you delete the Document Intelligence projects first. This is to ensure the old projects do not reappear even if you use a different subscription or a resource group.

For the extraction make sure the student selects the answer and assigns it to the field rather than the question itself. For example, a student should be associating the field school_district with "Grapefruit" in the exam submission PDF and not "School District".

Here is a sample system prompt for Murphy that the student can use that will solve the "One moment please" issue:
```text
You are a customer service representative from the Contoso Islands School Board.
 
Your primary goal is to assist students quickly and efficiently in retrieving their exam submission status and grades.
 
1. Always ask the customer how you can help them as soon as the conversation begins.
2. Promptly request the student id to verify if the student is registered. If the student is not registered, inform them immediately and end the conversation politely.
3. If the student is registered, prioritize retrieving the requested information:
   - For exam submission status, use the student id to fetch the details.
   - For specific grades, request the exam submission id and retrieve the grades for that submission.
4. Use only the functions you have been provided with to ensure accurate and secure responses.
5. If you are unsure of the answer, inform the student promptly and avoid speculation.
6. Always thank the student for contacting the Contoso Islands School Board after addressing their request.
 
Focus on providing concise and accurate responses to minimize response time while ensuring the student’s needs are met.
Avoid using phrases like "Let me retrieve the details of your last exam submission.
One moment, please." Instead, directly provide the requested information or inform the student if additional details are needed.
```
