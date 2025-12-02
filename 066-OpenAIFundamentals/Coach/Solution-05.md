# Challenge 05 - Responsible AI - Coach's Guide 

[< Previous Solution](./Solution-04.md) - **[Home](./README.md)**
## Notes & Guidance

### Knowledge Check 5.1 Answers:
- False: the service was trained on more than 100 languages but is designed to support only a handful.
- True: Content Safety has a monitoring page to help you track you moderation API performance and trends to inform your content moderation strategy.
- True: The Content Safety service has four severity levels, with the API score values ranging from 0 to 6 ([0,2,4,6)].

### Knowledge Check 5.2 Answers:
- True
- False - it will be returned if it was not deemed inappropriate
- False - your request will still complete without content filtering. You can see if it wasn't applied by looking for an error message in the content_filter_result object.

### Knowledge Check 5.3 Answers:
- False - you can specify which entity types you want to detect
- False - it is currently non-customizable on your data
- False - you can stream data or conduct analyses asynchronously with batch requests

