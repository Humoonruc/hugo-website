const url = 'https://500px.com/';
const path = require('path');
const imgDir = path.join(__dirname, 'img');

// 导出两个配置变量
module.exports.url = url;
module.exports.imgDir = imgDir;