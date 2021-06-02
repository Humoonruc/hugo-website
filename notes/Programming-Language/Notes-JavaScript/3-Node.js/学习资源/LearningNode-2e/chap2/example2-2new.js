"use strict";

let buf = Buffer.from('This is my pretty example');
let json = JSON.stringify(buf);

let buf2 = new Buffer(JSON.parse(json).data);

console.log(buf2.toString()); // this is my pretty example
