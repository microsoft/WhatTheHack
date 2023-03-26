# Challenge 01 - Creating a landing page - Coach's Guide 

[< Previous Solution](./Solution-00.md) - **[Home](./README.md)** - [Next Solution >](./Solution-02.md)

## Notes & Guidance

- You will need to provide the student with the `Resources.zip` file.
- The student will be working with `src/client/landing.html` - a sample landing page implementation with elements of the code redacted.
- There are comments inline to guide the students where to add the code. 

The suggested code is listed below in the section **// -- REMOVE FOR STUDENT -- //**


    function queryButtonClick() {
    
    // -- REMOVE FOR STUDENT -- //
    
    const urlParams = new URLSearchParams(window.location.search);
    token = urlParams.get('token');
    
    // -- REMOVE FOR STUDENT -- //
    
    $('#raw-token').text(token);
    $('#token-details').attr('open', true);          
    }




