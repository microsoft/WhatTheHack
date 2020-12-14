import { group, check } from 'k6';
import http from 'k6/http';
import {parseHTML} from "k6/html";

export let options = {
	stages: [
		{ duration: '60s', target: 15 },
		{ duration: '2m30s', target: 15 },
		{ duration: '20s', target: 0 },
	  ],
	  noConnectionReuse: true,
	  noVUConnectionReuse: true
};

export default function() {

	group("Home Page", function() {
		let req, res, resources;
	    var homePage = __ENV.WebSiteURL;
		if ( __ENV.CDN == "true") {
			homePage += "?cdn=true";
		}

		res = http.get(__ENV.WebSiteURL);
		check(res, {
			"status code is 200": (res) => res.status == 200,
		  });
		const doc = parseHTML(res.body);
		resources = [];
		req = [];

		doc.find("link").toArray().forEach(function (item) {
			var cssFile = item.attr("href");

			if ( cssFile[0] == '/' ) {
				cssFile = `${__ENV.WebSiteURL}${cssFile}`;
			}
			resources.push(cssFile);
		});

		doc.find("img").toArray().forEach(function (item) {
			var imgFile = item.attr("src");

			if ( imgFile[0] == '/' ) {
				imgFile = `${__ENV.WebSiteURL}${imgFile}`;
			}
			resources.push(imgFile);
		});

		
		doc.find("script").toArray().forEach(function (item) {
			var jsFile = item.attr("src");

			if ( jsFile != null && jsFile.length > 0 ) {
				if ( jsFile[0] == '/' ) {
					jsFile = `${__ENV.WebSiteURL}${jsFile}`;
				}
				resources.push(jsFile);
			}
		});

		resources.forEach(function(item) {
			req.push({
				"method": "get",
				"url": item,
				"params": {
					"headers": {
						"Pragma": "no-cache",
						"Cache-Control": "no-cache",
						"User-Agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/81.0.4044.138 Safari/537.36 Edg/81.0.416.72",
						"Accept": "text/css,*/*;q=0.1",
						"Sec-Fetch-Site": "same-origin",
						"Sec-Fetch-Mode": "no-cors",
						"Sec-Fetch-Dest": "style",
						"Referer": __ENV.WebSiteURL,
						"Accept-Encoding": "gzip, deflate, br",
						"Accept-Language": "en-US,en;q=0.9"
					}
				}
			});
		});

		res = http.batch(req);

		res.forEach(function (item) {
			check(item, {
				"status code is 200": (res) => res.status == 200,
			  });
		});		
	});
	group("Message Page", function() {
		let req, res, resources;
		var messagePage = `${__ENV.WebSiteURL}/Message`;
		if ( __ENV.CDN == "true") {
			messagePage += "?cdn=true";
		}
		res = http.get(messagePage);
		check(res, {
			"status code is 200": (res) => res.status == 200,
		  });
		const doc = parseHTML(res.body);
		resources = [];
		req = [];

		doc.find("link").toArray().forEach(function (item) {
			var cssFile = item.attr("href");

			if ( cssFile[0] == '/' ) {
				cssFile = `${__ENV.WebSiteURL}${cssFile}`;
			}
			resources.push(cssFile);
		});

		doc.find("img").toArray().forEach(function (item) {
			var imgFile = item.attr("src");

			if ( imgFile[0] == '/' ) {
				imgFile = `${__ENV.WebSiteURL}${imgFile}`;
			}
			resources.push(imgFile);
		});

		
		doc.find("script").toArray().forEach(function (item) {
			var jsFile = item.attr("src");

			if ( jsFile != null && jsFile.length > 0 ) {
				if ( jsFile[0] == '/' ) {
					jsFile = `${__ENV.WebSiteURL}${jsFile}`;
				}
				resources.push(jsFile);
			}
		});

		resources.forEach(function(item) {
			req.push({
				"method": "get",
				"url": item,
				"params": {
					"headers": {
						"Pragma": "no-cache",
						"Cache-Control": "no-cache",
						"User-Agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/81.0.4044.138 Safari/537.36 Edg/81.0.416.72",
						"Accept": "text/css,*/*;q=0.1",
						"Sec-Fetch-Site": "same-origin",
						"Sec-Fetch-Mode": "no-cors",
						"Sec-Fetch-Dest": "style",
						"Referer": `${__ENV.WebSiteURL}/Message`,
						"Accept-Encoding": "gzip, deflate, br",
						"Accept-Language": "en-US,en;q=0.9"
					}
				}
			});
		});

		res = http.batch(req);

		res.forEach(function (item) {
			check(item, {
				"status code is 200": (res) => res.status == 200,
			  });
		});	
	});

}
