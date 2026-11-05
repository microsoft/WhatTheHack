'use strict';

const { test } = require('node:test');
const assert = require('node:assert/strict');
const http = require('node:http');
const { createApp } = require('./server');

async function start(server, context) {
  await new Promise((resolve) => server.listen(0, '127.0.0.1', resolve));
  context.after(() => new Promise((resolve) => server.close(resolve)));
  return `http://127.0.0.1:${server.address().port}`;
}

test('serves healthcheck and assets without an API', async (context) => {
  const base = await start(createApp({ apiUrl: '' }), context);
  const health = await fetch(`${base}/healthcheck.html`);
  assert.equal(health.status, 200);
  assert.deepEqual(await health.json(), { health: 'OK' });
  assert.match((await (await fetch(`${base}/`)).text()), /Set API_URL to reach the SQL API/);
  assert.match((await (await fetch(`${base}/styles.css`)).text()), /Base styles/);
  assert.equal((await fetch(`${base}/favicon.ico`)).status, 200);
  assert.equal((await fetch(`${base}/missing`)).status, 404);
  assert.equal((await fetch(`${base}/`, { method: 'POST' })).status, 405);
});

test('renders API data and escapes untrusted values', async (context) => {
  const paths = [];
  const api = http.createServer((request, response) => {
    paths.push(request.url);
    response.setHeader('Content-Type', 'application/json');
    if (request.url === '/api/healthcheck') response.end(JSON.stringify({ health: 'OK' }));
    else if (request.url === '/api/sqlversion') response.end(JSON.stringify({ sql_output: '<script>alert(1)</script>' }));
    else response.end(JSON.stringify({ my_private_ip: '10.0.0.2', host: 'api.local' }));
  });
  const apiUrl = await start(api, context);
  const webUrl = await start(createApp({ apiUrl: `${apiUrl}/` }), context);
  const response = await fetch(webUrl, { headers: { Authorization: 'Bearer fake', 'X-Forwarded-For': '<img>' } });
  const html = await response.text();
  assert.equal(response.status, 200);
  assert.match(html, /Healthcheck: OK/);
  assert.match(html, /SQL Server version: &lt;script&gt;alert\(1\)&lt;\/script&gt;/);
  assert.doesNotMatch(html, /<script>/);
  assert.match(html, /10\.0\.0\.2/);
  assert.match(html, /Authorization header present \(identity not verified\)/);
  assert.deepEqual(paths.sort(), ['/api/healthcheck', '/api/ip', '/api/sqlversion']);
});

test('info and runtime pages return useful data without external services', async (context) => {
  const fakeRequest = async (url, options) => {
    if (url.hostname === 'api.ipify.org') return { ip: '203.0.113.1' };
    if (url.hostname === 'ipwho.is') return { country: 'Test country' };
    assert.deepEqual(options.headers, { Metadata: 'true' });
    return { compute: { name: 'test-vm', location: 'eastus2' } };
  };
  const base = await start(createApp({ apiUrl: '', requestImpl: fakeRequest }), context);
  const info = await (await fetch(`${base}/info`)).text();
  assert.match(info, /Node\.js/);
  assert.match(info, /Test country/);
  assert.match(info, /test-vm/);
  assert.match((await (await fetch(`${base}/runtime`)).text()), /Node\.js runtime/);
});

test('rejects a non-HTTP API_URL', () => {
  assert.throws(() => createApp({ apiUrl: 'file:///etc/passwd' }), /HTTP\(S\)/);
});

test('reports API HTTP errors without failing the web page', async (context) => {
  const api = http.createServer((request, response) => {
    response.writeHead(503);
    response.end('Unavailable');
  });
  const apiUrl = await start(api, context);
  const webUrl = await start(createApp({ apiUrl }), context);
  const response = await fetch(webUrl);
  assert.equal(response.status, 200);
  assert.match(await response.text(), /Healthcheck: HTTP 503/);
});