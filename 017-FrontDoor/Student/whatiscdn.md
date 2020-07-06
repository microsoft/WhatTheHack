A Content Delivery Network (CDN) is a made up of networked facilities, called Point of Presences (POPs), that form an intelligent mesh in a geographic area (regionally, nationally, or world wide based on provided) to provide enhanced delivery of "**web content**" over HTTP/HTTPs.  The strength of a CDN is the ability to push the "**Edge**" closer to users, using the physical scale of it's POPs and it's private network to distribute content and load efficiently.  This helps to optimize and secure a website's "**Origin**".  

Modern web development takes full advantage of the modern Web Browsers' (Edge, Chrome, Safari, Firefox, etc...) ability to participate in the dynamic nature of an application.  The use of [Javascript (JS)](https://en.wikipedia.org/wiki/JavaScript) running on the user's Web Browser creates rich interactions, [Cascading Style Sheets (CSS)](https://en.wikipedia.org/wiki/Cascading_Style_Sheets) to provide consistent and elegant presentation and style, and a variety of other supporting files (Images, Fonts, etc..) require a series of dependent web resources to be downloaded with each web page.  Which means with for each web page load there could be 100's of requests for subsequent support files.  To make it more complex, the need for this content to be available in large geographic areas (regionally, nationally, or world wide) puts an emphasis on far away a user is from the Origin.  

This is where leveraging a CDN becomes important.  In general the basic benefits of a CDN can be categorize as either **user-related** or **origin-related**.  For all the examples, the user will be in Tokyo, Japan and the website's "Origin" will be located in Azure's South Central US region in the State of Texas.

**User-Related benefits**:

*   <u>Faster user experience</u> - By "**caching**" some of the resources that are required for a web site, a CDN leverages it's POPs by creating a distributed copy or Cache of resources.  This means that the user's request for the web page (that has 40 different JS/CSS/Image files) will go to Texas, but the 40 dependent requests will stay go to the nearest POP, which most likely be in Tokyo Japan.
*   <u>More consistent user experience no matter the location of the user</u> - By using the CDN's ability to "**proxy**" the initial request, the user's request will be directed to the nearest POP and then have an optimized network path to the Origin.  The stronger the CDN's backend network is, the more consistent the user's experience is whether the user is 500 feet, or 5000 miles from the websites Origin.

**Origin-Related benefits:**

*   <u>Connection Management to Origin</u> - Instead of every single user establishing and managing  discrete connections to the Origin per user, the "**proxy**" will manage a pool of [persistent connections](https://www.w3.org/Protocols/rfc2616/rfc2616-sec8.html) to the Origin.  The CDN's proxy effect than acts as buffer for all users requesting web resources.  The Origin then sees much longer living connections, and doesn't need to manage the overhead of continually creating and destroying connections.
*   <u>SSL Termination at the Edge</u> - One of the most expensive operations when hitting a web site is the time to establish a connection and do the entire [Transport Layer Security (TLS) handshake](https://docs.microsoft.com/en-us/windows/win32/secauthn/tls-handshake-protocol#establishing-a-secure-session-by-using-tls "Transport Layer Security (TLS) handshake").  By moving this to the edge, the 9 part process of going back and forth between User and the Edge is now closest to the user.   **Note: A CDN's connection to the Origin should also be over HTTPS requiring handshaking, but the load is greatly reduced since this connection is persistent in nature.**
*   <u>Network Security can be enforced at the Edge</u> - For different forms attack such as Denial of Service (DoS) including Distributed Denial of Service (DDoS) and other forms of malicious activities, a layered strategy of Firewalls ([Layer 3](https://en.wikipedia.org/wiki/OSI_model#Layer_3:_Network_Layer) or [Layer 4](https://en.wikipedia.org/wiki/OSI_model#Layer_4:_Transport_Layer)) and Web Application Firewalls (WAF - [Layer 7](https://en.wikipedia.org/wiki/OSI_model#Layer_7:_Application_Layer)) are employed for mitigation.  The CDN itself will have it's own layer of protection that will mitigate massive DoS attacks to ensure stability of the network in general.  This is focused on safeguarding the CDN's network in total (which is massive), not just a particular website.  The definition of an attack is much different in terms of scale when it comes to an entire CDN vs a single website.  That is where utilizing the CDN's WAF offering provides a per website mitigation.  

**Definition of terms used above**:

*   **_Web Content_** _refers to resource that can be accessed via a [URI](https://en.wikipedia.org/wiki/Uniform_Resource_Identifier) with a HTTP or HTTPS scheme.  This can be almost any kind of file, generally in web terms Javascript (JS), Cascading Style Sheet (CSS), Images (JPEG, PNG, GIF, etc..), or [HTML](https://en.wikipedia.org/wiki/HTML) that is a stored file or created dynamically by a web site.  Another popular use of Web Content is software distribution (full installs or updates)._
*   **_Edge_** _refers to the closest ingress network location to a user that a website has control over.  Without a CDN, the Edge is that first firewall/router/server a user's request hits when making a HTTP request._
*   **_Origin_** _refers to where to accessible location where the content is hosted.  This is a location that accepts HTTP or HTTPS requests, could be a firewall, router (Layer 3 or Layer 7), a load balancer, web server, an Azure Storage Account, etc..._
*   _**Caching**, or in other terms, redundant copies of the same resources.  For a CDN, there is a layered caching strategy that is generally employed to efficiently replicate resources to each individual POP.  Each POP will have it's own cache of a resource, generally populated after the first request made that originates from a user that hits the specific POP_.  For example, a company's logo gets updated (call it FabrikamLogo.png).  There are three general cases to consider:
    1.  First Request from anywhere
        1.  User's request hit's the POP cache, it doesn't exist
        2.  User's request hit's the "Origin Shield", it doesn't exist
        3.  User's request hit's the Origin, which populates the Origin Shield cache and the POP's cache
        4.  User get the new Company Logo 
    2.  First Request from anywhere
        1.  User's request hit's the POP cache, it doesn't exist
        2.  User's request hit's the "Origin Shield", it exists and populates the POP's cache
        3.  User get the new Company Logo 
    3.  Second Request made to a POP
        1.  User's request hit's the POP cache, it exists
        2.  User get the new Company Logo 
*   _**Proxy**, and more specifically a [Layer 7](https://en.wikipedia.org/wiki/OSI_model#Layer_7:_Application_Layer) Transparent Proxy, is where the CDN presence itself as the website and acts as the intermediary between the user and the Origin_.  A normal user web to an Origin goes over the public internet which involves a series of routing hand-offs. 

*   Here is an example of a user accessing the Origin over the Public Internet and how it can happen, but it's not [(detail article)](http://www.theshulers.com/whitepapers/internet_whitepaper/index.html#route).

1.  User's device
2.  Local ISP (Internet Service Provider)  near user
3.  Regional ISP near user
4.  Network Service Provider (NSP) near user
5.  The Network Access Point (NAP) or Metropolitan Area Exchange (MAE) closest to user
6.  Continues to hop from NAP/MAE to NAP/MAE to the closest location to Origin (think City to City on the a highway system).  This can be several 
7.  Network Service Provider (NSP) near Origin
8.  Regional ISP near Origin
9.  Local ISP (Internet Service Provider)  Origin
10.  Origin

*   Here is an example of a user accessing the Origin using a Proxy within a CDN:

1.  User's device
2.  Local ISP (Internet Service Provider)  near user
3.  Regional ISP near user
4.  Network Service Provider (NSP) near user
5.  CDN's POP
6.  Direct route over the optimal path calculated by CDN's POP
    1.  **<u>If the website is using Azure CDN (Microsoft CDN Provider or Azure Front Door) and Origin is in Azure, the next hop is your Origin.</u>**
    2.  If the website is either not in Azure or the website uses a different CDN Provider, then the most optimal egress point is calculated a the reverse of #1 thru #4 is traversed.

*   **Origin Shield** refers to a centralized cache a CDN creates for an Origin.  Instead of each POP (could be in the 1000s based on the CDN Provider) hitting the Origin for each resource, it acts as a "shield" for the Origin.  
*   **Firewall** (Layer 3 or Layer 4) refers to a capability (either a physical network appliance, a virtual network appliance, or software) that can interrogate individual [packets](https://en.wikipedia.org/wiki/Network_packet) of data the route thru it.  Layer 3 Firewalls can decide to allow or block the individual packets based on header of the individual packet (IP Address, Port).  Layer 4 Firewalls add the capability of inspecting the session of a series of packets that make up a connection between a client an server, trending and understand the communication patterns vs just individual packets.
*   **Web Application Firewall** (Layer 7) refers to a capability (either a physical network appliance or a virtual network appliance) that can analyze and mitigate based on the payload of 1 to many packets that constitutes a specific HTTP/HTTPS request.  So instead of just being able to say "don't allow requests from IP Address X", it can be "don't allow GET requests to URL Y".  This is particularly powerful due to the nature of [complicated attacks that involve specific HTTP request patterns](https://en.wikipedia.org/wiki/Web_application_security) (either thru the Query String or posted body's) that are indicative to a particular web application platform.