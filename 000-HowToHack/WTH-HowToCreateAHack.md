# How to Create/Develop a Hack

- Challenge development guidelines
    - Challenge Template
- Coaches guide 
    - Template needed?
- Repo Organization
    - Root Template
	- Host
	    - Guide (<-- Is this needed?  Or just put coaches guide doc in the "Host" folder?)
		- Resources (<-- this is where solution code lives)
	- Student
	    - Guide (<-- do we need a "guide" folder or should challenges just live in the "Student" folder?)
		    - Challenge Template?
        - Resources (<-- Resource folder makes sense)


## ORIGINAL CONTENT

We welcome all new hacks! The process for doing this is:
- Fork this repo into your own github account
- Create a new branch for your work
- Add a new top level folder using the next number in sequence, eg:
	- 011-BigNewHack
- Within this folder, create two folders, each with two folders with in that looks like this:
	- Host
		- Guides
		- Solutions
	- Student
		- Guides
		- Resources
- The content of each folder should be:
	- **Student/Guides**: The Student's Guide
	- **Student/Resources**: Any template or "starter" files that students may need in challenges
	- **Host/Guides**: The Proctor's Guide lives here as well as any Lecture slide decks
	- **Host/Solutions**: Specific files that the proctors might need that have solutions in them.
- Once your branch and repo have all your content and it formatted correctly, follow the instructions on this page to submit a pull request back to the main repository:
	- https://help.github.com/articles/creating-a-pull-request-from-a-fork/