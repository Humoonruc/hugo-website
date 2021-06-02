const cheerio = require('cheerio');

function findImg(dom, callback) {
  let $ = cheerio.load(dom);
  $('img').each((i, elem) => {
    let imgSrc = $(this).attr('src');
    callback(imgSrc, i);
  });
}

module.exports.findImg = findImg;