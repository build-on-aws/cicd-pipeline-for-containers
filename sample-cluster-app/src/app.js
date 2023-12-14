/*
** Cluster Sample Application - https://github.com/aws-samples/cluster-sample-app 
MIT No Attribution
Copyright 2022 Amazon, Inc. or its affiliates. All Rights Reserved.

Permission is hereby granted, free of charge, to any person obtaining a copy of this
software and associated documentation files (the "Software"), to deal in the Software
without restriction, including without limitation the rights to use, copy, modify,
merge, publish, distribute, sublicense, and/or sell copies of the Software, and to
permit persons to whom the Software is furnished to do so.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED,
INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A
PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

*/

// A basic node application leveraging the Express lib
const express = require("express");
const { networkInterfaces } = require('os');

const app = express();
const applicationHttpPort = process.env.CLUSTER_SAMPLE_APP_PORT || 3000;

let mainPageHitCounter = 1;
let healthCheckHitCounter = 0;

var server = app.listen(applicationHttpPort, () => {
  console.info("Cluster sample app started...");
  console.info("Listening on port "+ applicationHttpPort);
});

// Default REST handler (HTTP GET on /)
app.get("/", (req, res, next) => {
  console.debug('Processing a GET request on / from host '+req.headers['host']);
  res.send(getHTMLContent());
  mainPageHitCounter+=1;
});

// Default REST handler for the healthcheck (HTTP GET on /healtcheck)
app.get("/healthcheck", (req, res, next) => {
  console.debug('Processing a GET request on /healthcheck from host '+req.headers['host']);
  res.send("OK");
  healthCheckHitCounter+=1;
});

// Returns the HTML content of the main page
function getHTMLContent() {
  
  const dateLocaleOptions = {weekday: 'long', year: 'numeric', month: 'long', day: 'numeric', hour: 'numeric', minute: 'numeric', second: 'numeric', hour12: false, timeZoneName: 'short'};

  let htmlContent = `<head><style>${getCSSString()}</style></head>`;
  htmlContent = htmlContent + '<body>';
  htmlContent = htmlContent + '<div style="display: inline-block; text-align: center; padding: 20px;"><h1>Greetings from Cluster Sample App!</h1>';
  htmlContent = htmlContent + `<h3>Today is ${new Date().toLocaleString('en-US', dateLocaleOptions)}`+'</h3>';
  htmlContent = htmlContent + `<p>This web page has been hit ${mainPageHitCounter} time(s)</p>`;
  htmlContent = htmlContent + `<p>The healthcheck of this application has been hit ${healthCheckHitCounter} time(s)</p>`;

  htmlContent = htmlContent + '<div><p>This app is running in a container having the following IP addresses: ';
  htmlContent = htmlContent + '<table text-align: center; border-style: solid;><th>Name</th><th>Type</th><th>CIDR</th><th>Address</th>';
  getAllIPAddrs().forEach((ip) => {
    htmlContent = htmlContent + `<tr><td>${ip.name}</td><td>${ip.infos.family}</td><td>${ip.infos.cidr}</td><td>${ip.infos.address}</td></tr>`;
  });
  htmlContent = htmlContent + '</table></p></div></body>';

  return htmlContent;
}

// Returns the CSS style used on main page
function getCSSString() {
  let css = 'body { text-align: center; font-family:verdana; font-size:12px}';
  css = css + 'table { width: 98%; border: 1px solid black; }';
  css = css + 'th { background-color: #f7a105; color: white; font-family:verdana; font-size:12px}';
  css = css + 'th, td { border: 1px; padding: 3px; text-align: center; }';
  css = css + 'tr:nth-child(even) {background-color: #f2f2f2;}';
  return css;
}

// Computes a list of IPv4 addresses seen from the app
function getAllIPAddrs() {

  const ipv4Addrs = [];
  const netInterfaces = networkInterfaces();

  for (const interfaceName of Object.keys(netInterfaces)) {
    for (const interfaceDetails of netInterfaces[interfaceName]) {
      // Skip over non-IPv4 and internal (i.e. 127.0.0.1) addresses
      if (interfaceDetails.family === 'IPv4' && !interfaceDetails.internal) {
        ipv4Addrs.push({interfaceName, infos: interfaceDetails});
      }
    }
  }

  return ipv4Addrs;

}

module.exports = server;
