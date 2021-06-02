// @ts-check
'use strict';
// sqlite3.js


const sqlite3 = require('sqlite3').verbose();
const db = new sqlite3.Database('sqlite3.db'); // 在硬盘中建立数据库

db.serialize(() => {
  db.run('DROP TABLE IF EXISTS lorem');
  db.run("CREATE TABLE IF NOT EXISTS lorem (info TEXT PRIMARY KEY NOT NULL)");

  const statement = db.prepare("INSERT INTO lorem (info) VALUES (?)");
  for (let i = 0; i < 10; i++) {
    statement.run("Ipsum " + i);
  }
  statement.finalize();

  db.each("SELECT rowid AS id, info FROM lorem", (err, row) => {
    console.log(row.id + ": " + row.info);
  });
});

db.close();