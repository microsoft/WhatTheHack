'use strict';

const http = require('node:http');
const https = require('node:https');
const os = require('node:os');
const fs = require('node:fs/promises');
const path = require('node:path');

const assets = new Map([
  ['/styles.css', ['styles.css', 'text/css; charset=utf-8']],
  ['/favicon.ico', ['favicon.ico', 'image/x-icon']],
  ['/web.png', ['web.png', 'image/png']],
]);

function escapeHtml(value) {
  return String(value ?? 'Unavailable').replace(/[&<>"']/g, (character) => ({
    '&': '&amp;', '<': '&lt;', '>': '&gt;', '"': '&quot;', "'": '&#39;',
  })[character]);
}

function page(title, content, request) {
  const status = request.headers.authorization
    ? 'Authorization header present (identity not verified)'
    : 'Not authenticated';
  return `<!DOCTYPE html>
<html lang="en">
  <head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <meta name="description" content="AKS sample web frontend">
    <title>${escapeHtml(title)}</title>
    <link rel="shortcut icon" href="/favicon.ico">
    <link rel="stylesheet" href="/styles.css">
  </head>
  <body>
    <div class="header"><div class="container"><h1 class="header-heading">Welcome to ${escapeHtml(os.hostname())}</h1></div></div>
    <div class="nav-bar"><div class="container"><ul class="nav">
      <li><a href="/">Home</a></li>
      <li><a href="/info">Info</a></li>
      <li><a href="/healthcheck.html">Healthcheck</a></li>
      <li><a href="/runtime">Node.js info</a></li>
      <li><a href="https://github.com/erjosito/whoami/blob/master/api/README.md">API docs</a></li>
      <li><a href="https://github.com/erjosito/whoami/blob/master/web/README.md">Web docs</a></li>
      <li style="color:LightGray;">${escapeHtml(status)}</li>
    </ul></div></div>
    <div class="content"><div class="container"><div class="main">${content}</div></div></div>
    <div class="footer"><div class="container">&copy; Copyleft 2020</div></div>
  </body>
</html>`;
}

function item(label, value) {
  return `<li>${escapeHtml(label)}: ${escapeHtml(value)}</li>`;
}

// Node's HTTP/HTTPS clients are covered by the AKS Azure Monitor auto-instrumentation.
function requestJson(url, { headers = {} } = {}) {
  return new Promise((resolve, reject) => {
    const client = url.protocol === 'https:' ? https : http;
    const request = client.get(url, { headers, signal: AbortSignal.timeout(3000) }, (response) => {
      if (response.statusCode < 200 || response.statusCode >= 300) {
        response.resume();
        reject(new Error(`HTTP ${response.statusCode}`));
        return;
      }
      let body = '';
      response.setEncoding('utf8');
      response.on('data', (chunk) => {
        body += chunk;
        if (body.length > 1024 * 1024) response.destroy(new Error('Response too large'));
      });
      response.on('end', () => {
        try { resolve(JSON.parse(body)); } catch (error) { reject(error); }
      });
      response.on('error', reject);
    });
    request.on('error', reject);
  });
}

async function getJson(url, requestImpl, options) {
  try {
    return { data: await requestImpl(url, options) };
  } catch (error) {
    console.error(`Request to ${url.origin} failed: ${error.message}`);
    return { data: null, error: error.message };
  }
}

function apiEndpoint(apiUrl, endpoint) {
  return new URL(endpoint, `${apiUrl.href.replace(/\/+$/, '')}/`);
}

async function home(request, apiUrl, requestImpl) {
  const results = apiUrl
    ? await Promise.all(['healthcheck', 'sqlversion', 'ip'].map((name) =>
        getJson(apiEndpoint(apiUrl, `api/${name}`), requestImpl)))
    : Array.from({ length: 3 }, () => ({ data: null, error: 'Set API_URL to reach the SQL API' }));
  const [health, sql, ip] = results;
  const apiValue = (result, key) => result.data?.[key] ?? result.error ?? 'Unavailable';
  return page('Sample container', `
    <h1>${escapeHtml(os.hostname())}</h1>
    <h3>Information retrieved from API ${escapeHtml(apiUrl?.origin ?? 'not configured')}:</h3>
    <p>Set API_URL to the address of the <a href="https://github.com/erjosito/whoami/blob/master/api/README.md">SQL API</a> to populate these values.</p>
    <ul>
      ${item('Healthcheck', apiValue(health, 'health'))}
      ${item('SQL Server version', apiValue(sql, 'sql_output'))}
      <li>Connectivity info for SQL API pod:<ul>
        ${item('Private IP address', apiValue(ip, 'my_private_ip'))}
        ${item('Public (egress) IP address', apiValue(ip, 'my_public_ip'))}
        ${item('Default gateway', apiValue(ip, 'my_default_gateway'))}
        ${item('HTTP request source IP address', apiValue(ip, 'your_address'))}
        ${item('HTTP request X-Forwarded-For header', apiValue(ip, 'x-forwarded-for'))}
        ${item('HTTP request Host header', apiValue(ip, 'host'))}
        ${item('HTTP requested path', apiValue(ip, 'path_accessed'))}
      </ul></li>
    </ul>
    <br>
    <h3>Direct access to API</h3>
    <p>These links require a reverse proxy such as the AKS Gateway API route to the API service.</p>
    <ul>
      <li><a href="/api/healthcheck">API health status</a></li>
      <li><a href="/api/sqlversion">SQL Server version</a></li>
      <li><a href="/api/ip">API connectivity information</a></li>
    </ul>`, request);
}

async function info(request, requestImpl) {
  const privateIps = Object.values(os.networkInterfaces()).flat()
    .filter((address) => address && address.family === 'IPv4' && !address.internal)
    .map((address) => address.address);
  const publicIp = await getJson(new URL('https://api.ipify.org?format=json'), requestImpl);
  const ip = publicIp.data?.ip;
  const location = ip
    ? await getJson(new URL(`https://ipwho.is/${encodeURIComponent(ip)}`), requestImpl)
    : { data: null };
  // IMDS is a fixed link-local endpoint; never forward caller input or identity tokens to it.
  const metadata = await getJson(new URL('http://169.254.169.254/metadata/instance?api-version=2021-02-01'),
    requestImpl, { headers: { Metadata: 'true' } });
  const compute = metadata.data?.compute;
  return page('Container info', `
    <h1>${escapeHtml(os.hostname())}</h1>
    <h3>Local information</h3>
    <ul>${item('Name', os.hostname())}
      ${item('Software', `Node.js ${process.version}`)}
      ${item('Kernel info', `${os.type()} ${os.release()} ${os.arch()}`)}
      ${item('Private IP address', privateIps.join(', ') || 'Unavailable')}
      ${item('Public IP address', ip ?? publicIp.error ?? 'Unavailable')}</ul>
    <h3>Request information</h3>
    <ul>${item('Client IP', request.headers['client-ip'])}
      ${item('Remote address', request.socket.remoteAddress)}
      ${item('X-Forwarded-For', request.headers['x-forwarded-for'])}</ul>
    <h3>Geolocation information</h3>
    <ul>${item('Country', location.data?.country)}
      ${item('Region', location.data?.region)}
      ${item('City', location.data?.city)}</ul>
    <h3>Azure instance metadata</h3>
    <p>Available on Azure hosts; only non-sensitive instance properties are shown.</p>
    <ul>${item('Name', compute?.name)}
      ${item('Location', compute?.location)}
      ${item('VM size', compute?.vmSize)}</ul>`, request);
}

function createApp({ apiUrl = process.env.API_URL, requestImpl = requestJson } = {}) {
  let parsedApiUrl;
  if (apiUrl) {
    parsedApiUrl = new URL(apiUrl);
    if (!['http:', 'https:'].includes(parsedApiUrl.protocol)) {
      throw new Error('API_URL must be an HTTP(S) URL');
    }
  }
  return http.createServer(async (request, response) => {
    const send = (status, body, type = 'text/html; charset=utf-8') => {
      response.writeHead(status, { 'Content-Type': type, 'X-Content-Type-Options': 'nosniff' });
      response.end(body);
    };
    if (request.method !== 'GET' && request.method !== 'HEAD') {
      send(405, 'Method not allowed', 'text/plain; charset=utf-8');
      return;
    }
    try {
      const pathname = new URL(request.url, 'http://localhost').pathname;
      if (assets.has(pathname)) {
        const [filename, type] = assets.get(pathname);
        send(200, await fs.readFile(path.join(__dirname, filename)), type);
      } else if (pathname === '/healthcheck.html' || pathname === '/healthcheck') {
        send(200, JSON.stringify({ health: 'OK' }), 'application/json; charset=utf-8');
      } else if (pathname === '/runtime') {
        send(200, page('Node.js info', `<h1>Node.js runtime</h1><ul>
          ${item('Version', process.version)}${item('Platform', process.platform)}
          ${item('Architecture', process.arch)}</ul>`, request));
      } else if (pathname === '/info') {
        send(200, await info(request, requestImpl));
      } else if (pathname === '/' || pathname === '/index.html') {
        send(200, await home(request, parsedApiUrl, requestImpl));
      } else {
        send(404, 'Not found', 'text/plain; charset=utf-8');
      }
    } catch (error) {
      console.error('Web request failed:', error);
      send(500, 'Internal server error', 'text/plain; charset=utf-8');
    }
  });
}

if (require.main === module) {
  const port = Number(process.env.PORT || 8080);
  if (!Number.isInteger(port) || port < 1 || port > 65535) throw new Error('PORT must be a valid TCP port');
  const server = createApp();
  server.listen(port, '0.0.0.0', () => console.log(`Web listening on port ${port}`));
}

module.exports = { createApp };