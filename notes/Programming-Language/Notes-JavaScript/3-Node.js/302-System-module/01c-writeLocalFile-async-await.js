'use strict';
// 01c-writeLocalFile-async-await.js

let fs = require("fs");

async function writeToFile() {
  await fs.writeFile("./data/output.txt", "我写入了一句话\n", "utf8", (err, data) => {
    if (err) console.error();
  });

  await fs.appendFile("./data/output.txt", "我追加了一句话\n", "utf8", (err, data) => {
    if (err) console.error();
  });
}
writeToFile();

// 异步操作，结果是不确定的，因为不知道写入和追加哪个先完成。
// 若写入先完成，则为两句话；若追加先完成，写入会覆盖，只有一句话。
// 用async/await，可以保证执行顺序