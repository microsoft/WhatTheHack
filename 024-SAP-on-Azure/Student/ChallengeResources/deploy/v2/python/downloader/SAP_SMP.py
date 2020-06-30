#!/usr/bin/env python3
# 
#       SMP Downloader
#
#       License:        GNU General Public License (GPL)
#       (c) 2019        Microsoft Corp.
#

import urllib.error
import urllib.parse
import urllib.request

from bs4 import BeautifulSoup

from helper import *


class SMP:
    url_launchpad = "https://launchpad.support.sap.com"
    url_auth      = "https://authn.hana.ondemand.com/saml2/sp/mds"
    url_sso       = "https://accounts.sap.com/saml2/idp/sso"
    url_portal    = "https://authn.hana.ondemand.com/saml2/sp/acs/supportportal/supportportal"
    url_search    = "https://launchpad.support.sap.com/services/odata/svt/swdcuisrv/SearchResultSet"
    url_retrieve  = "https://launchpad.support.sap.com/services/odata/svt/swdcuisrv/DownloadItemSet"
    params_maint  = {
        "SWTYPSC" : "SPP",
        "V"       : "MAINT"
    }

    sess = None

    @staticmethod
    def process_page(url, desc=None, required_inputs=[], referer=None, extra_headers=None, post_data=None, body_prefix=None, allow_redirects=True):
        headers = SMP.sess.headers
        if referer:
            headers["Referer"]    = referer
        if extra_headers:
            for field in list(extra_headers.keys()):
                headers[field]    = extra_headers[field]
        if post_data:
            headers["Content-Type"] = "application/x-www-form-urlencoded"

        if not post_data:
            resp = SMP.sess.get(
                url,
                headers = headers,
                allow_redirects = allow_redirects,
            )
        else:
            resp = SMP.sess.post(
                url,
                headers = headers,
                data = post_data,
                allow_redirects = allow_redirects,
            )
        assert(resp.status_code < 400), \
            "Unable to %s (%s); status = %d" % (desc, url, resp.status_code)

        soup = BeautifulSoup(resp.content, 'html.parser')
        inputs = {}
        for i in soup.find_all("input"):
            field, value = i.get("name"), i.get("value")
            inputs[field] = value
        assert(all(i in inputs for i in required_inputs)), \
            "%s inputs (%s) does not contain required fields (%s)" % (desc, inputs, required_inputs)
        
        next_body = body_prefix + "&" if body_prefix else ""
        for cnt in range(len(required_inputs)):
            if cnt > 0:
                next_body += "&"
            i = required_inputs[cnt]
            next_body += "%s=%s" % (i, urllib.parse.quote(inputs[i]))

        return(resp.cookies, inputs, next_body)

    @staticmethod
    def init():
        SMP.sess = HTTPSession(
            headers = {
                "User-Agent": "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_14_2) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/72.0.3626.109 Safari/537.36",
            },
        )

        # --------------------------------------------------------
        # STEP 1 - Open SMP and obtain SAML envelope
        # --------------------------------------------------------
        (cookies_launchpad, inputs_launchpad, body_auth) = SMP.process_page(
            url       = SMP.url_launchpad,
            desc      = "open SMP",
            required_inputs = [
                "tenantId",
                "idpName",
                "requestUrl",
                "requestId",
                "relayState",
                "signature",
            ],
            body_prefix   = "action=sso",
        )

        # --------------------------------------------------------
        # STEP 2 - Connect to IDP and send SAML envelope
        # --------------------------------------------------------
        (cookies_auth, inputs_auth, body_sso) = SMP.process_page(
            url       = SMP.url_auth,
            desc      = "connect to IDP",
            required_inputs = [
                "SAMLRequest",
                "RelayState",
            ],
            referer     = SMP.url_launchpad,
            post_data   = body_auth,
        )
        
        # --------------------------------------------------------
        # STEP 3 - Prepare SAML request and send credentials
        # --------------------------------------------------------
        (cookies_sso, inputs_sso, body_sso) = SMP.process_page(
            url       = SMP.url_sso,
            desc      = "prepare SAML request",
            required_inputs = [
                "authenticity_token",
                "xsrfProtection",
                "idpSSOEndpoint",
                "spId",
                "spName",
            ],
            referer     = SMP.url_auth,
            post_data   = body_sso,
            body_prefix   = "utf8=%E2%9C%93&" + urllib.parse.urlencode({
                "targetUrl"      : "",
                "sourceUrl"      : "",
                "org"            : "",
                "mobileSSOToken" : "",
                "tfaToken"       : "",
                "css"            : "",
                "SAMLRequest"    : inputs_auth["SAMLRequest"],
                "RelayState"     : inputs_auth["RelayState"],
                "j_username"     : Config.credentials.sap_user,
                "j_password"     : Config.credentials.sap_password,
            })
        )

        # --------------------------------------------------------
        # STEP 4 - Obtain SAML response
        # --------------------------------------------------------
        (cookies_sso, inputs_sso, body_portal) = SMP.process_page(
            url             = SMP.url_sso,
            desc            = "obtain SAML response",
            required_inputs = [
                "SAMLResponse",
            ],
            referer         = SMP.url_sso,
            post_data       = body_sso,
            body_prefix     = "utf8=%E2%9C%93&" + urllib.parse.urlencode({
                "RelayState":     inputs_auth["RelayState"],
                "authenticity_token": inputs_sso["authenticity_token"],
            })
        )

        # --------------------------------------------------------
        # STEP 5: Obtain JSESSION
        # --------------------------------------------------------
        (cookies_portal, inputs_portal, body_search) = SMP.process_page(
            url             = SMP.url_launchpad,
            desc            = "obtain session",
            referer         = SMP.url_portal,
            post_data       = body_portal,
            allow_redirects = False,
        )

    @staticmethod
    def search(query):
        SMP.sess.headers["Accept"] = "application/json"
        payload = {
            "SEARCH_MAX_RESULT" : "500",
            "RESULT_PER_PAGE"   : "500",
            "SEARCH_STRING"     : query,
        }
        resp  = SMP.sess.get(
            SMP.url_search,
            params=payload
        )

        assert(resp.status_code == 200), \
            "Unable to retrieve search results; status = %d" % (resp.status_code)

        j = json.loads(resp.content.decode("utf-8"))
        assert("d" in j and "results" in j["d"]), \
            "Invalid search result format"
        results = j["d"]["results"]
        return results

    @staticmethod
    def retrieve(params, os_filter):
        SMP.sess.headers["Accept"] = "application/json"
        print("retrieving %s for %s..." % (params, os_filter))
        payload = {
            "_EVENT"        : "LIST",
            "EVENT"         : "LIST",
            "PECCLSC"       : "OS",
            "INCL_PECCLSC1" : "OS",
            "PECGRSC1"      : os_filter,
        }
        # Setting this to SUPPORT PACKAGES & PATCHES for now;
        # may need to update logic for future scenarios
        payload.update(SMP.params_maint)
        payload.update(params)
        resp  = SMP.sess.get(
            SMP.url_retrieve,
            params=payload,
        )
        assert(resp.status_code == 200), \
            "Unable to retrieve search results; status = %d" % (resp.status_code)
        j = json.loads(resp.content.decode("utf-8"))
        assert("d" in j and "results" in j["d"]), \
            "Invalid search result format"
        results = j["d"]["results"]
        return results
    
