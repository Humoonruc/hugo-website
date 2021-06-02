// test-puppeteer-mongodb.js

// @ts-check
'use strict';


const puppeteer = require('puppeteer');
const { MongoClient } = require("mongodb");

main();


async function main() {

  // 启动服务器上的puppeteer
  const browser = await puppeteer.launch({
    headless: true,
    args: ["--no-sandbox", "--disable-setuid-sandbox"],
    defaultViewport: { width: 1366, height: 768, isMobile: false, },
  });
  let pages = await browser.pages();
  let currentPage = pages[0];


  // 爬取新闻链接
  const url = 'https://tv.cctv.com/lm/xwlb/day/20210428.shtml';
  await currentPage.goto(url);
  const links = await currentPage.$$eval('li>a', nodes => nodes.map(node => node.getAttribute('href')));
  await currentPage.close();
  await browser.close();


  // 数据
  const documents = links.map(link => {
    return { url: link };
  });
  console.log(documents);


  // 连接MongoDB服务
  const uri = 'mongodb://localhost:27017/';
  const client = new MongoClient(uri, {
    useNewUrlParser: true,
    useUnifiedTopology: true,
  });
  await client.connect()
    .then(() => console.log('Connected successfully to server.'))
    .catch(err => {
      console.log('Connected failed. ');
      console.error(err);
    });


  // 连接或创建数据库
  const database = client.db("dbWithUser");
  // 连接或创建 collection
  const news = database.collection("XinwenLianbo");
  // 添加 documents
  const insertResultMany = await news.insertMany(documents, { ordered: true });
  console.log(`${insertResultMany.insertedCount} items were inserted`);
  // 删除 documents
  const deleteManyResult = await news.deleteMany({});
  console.log("Deleted " + deleteManyResult.deletedCount + " documents");


  // 关闭与服务器的连接
  await client.close();
}