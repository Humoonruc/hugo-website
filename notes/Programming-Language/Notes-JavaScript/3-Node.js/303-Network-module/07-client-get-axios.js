//@ts-check
'use strict';

// 07-client-get-axios.js


// 1. 内置标准模块 http/https
const https = require('https');
const options = {
  hostname: 'nodejs.cn',
  port: 443,
  path: '/todos',
  method: 'GET'
};

https
  .request(options, response => {
    console.log(`状态码: ${response.statusCode}`);
    response.on('data', d => {
      process.stdout.write(d)
    });
    response.on('error', console.error);
  })
  .on('error', error => {
    console.error(error)
  })
// .end();


// 2. 第三方模块

const axios = require('axios');

// promise写法
axios
  .get('https://www.runoob.com/', {
    params: {
      s: "node"
    }
  }).then(function (response) {
    console.log(response);
  }).catch(function (error) {
    console.log(error);
  });

// async/await写法
async function getRequest() {
  try {
    const response = await axios.get('https://www.runoob.com/', {
      params: {
        s: "node",
      },
    });
    console.log(response);
  } catch (error) {
    console.error(error);
  }
}
getRequest();