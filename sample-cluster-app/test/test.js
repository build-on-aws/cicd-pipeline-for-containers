/*
** Cluster Sample Application - https://github.com/aws-samples/cluster-sample-app
MIT No Attribution

Copyright 2022 Amazon,  Inc. or its affiliates. All Rights Reserved.

Permission is hereby granted, free of charge, to any person obtaining a copy of this
software and associated documentation files (the "Software"), to deal in the Software
without restriction, including without limitation the rights to use, copy, modify,
merge, publish, distribute, sublicense, and/or sell copies of the Software, and to
permit persons to whom the Software is furnished to do so.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED,
INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A
PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION 
*/

let chai = require('chai');
let chaiHttp = require('chai-http');

chai.use(chaiHttp);

describe('Testing sample app', () => {
  var server;
  beforeEach(function () {
    server = require('../src/app');
  });
  afterEach(function () {
    server.close();
  });

  it('Testing default page', (done) => {
    chai.request(server)
        .get('/')
        .end((err, res) => {
            chai.expect(res).to.have.status(200);
            chai.expect(res.text).to.contain('Greetings from Cluster Sample App!');
          done();
        });
  });

  it('Testing healthcheck', (done) => {
    chai.request(server)
        .get('/healthcheck')
        .end((err, res) => {
            chai.expect(res).to.have.status(200);
            chai.expect(res.text).to.equal('OK');
          done();
        });
  });

});
