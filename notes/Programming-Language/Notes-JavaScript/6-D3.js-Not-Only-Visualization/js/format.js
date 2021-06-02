/**
 * @module format
 * @file
 * @author Humoonruc
 */

const d3 = require('d3');

console.log(d3.format('.2f')(666666.666));
console.log(d3.format('.2r')(666666.666));
console.log(d3.format('.2s')(666666.666));