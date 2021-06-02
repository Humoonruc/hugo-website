// @ts-check
'use strict';
// better-sqlite3.js


// 连接数据库
const Database = require('better-sqlite3');
const db = new Database('better-sqlite3.db', {
  fileMustExist: false,
  verbose: console.log, // 每次执行SQL语句都打印出来
});


// 1. 单字段
db.prepare('DROP TABLE IF EXISTS lorem').run();
db.prepare(`CREATE TABLE IF NOT EXISTS lorem (info TEXT PRIMARY KEY NOT NULL)`).run();

const insert = db.prepare("INSERT INTO lorem (info) VALUES (?)");
for (let i = 0; i < 10; i++) {
  const info = insert.run("Ipsum " + i);
  // console.log(info.changes); // => 1，表明插入成功
}

const query = db.prepare("SELECT rowid AS id, info FROM lorem");
for (let row of query.iterate()) {
  console.log('line ' + row.id + ": " + row.info);
}


// 2. 双字段
db.prepare('DROP TABLE IF EXISTS cats').run();
db.prepare(
  `CREATE TABLE IF NOT EXISTS cats (
    name TEXT PRIMARY KEY NOT NULL, 
    age INT NOT NULL
    )`).run();

const insert1 = db.prepare("INSERT INTO cats (name, age) VALUES (?, ?)");
insert1.run('Tim', 3);

// 构建一个函数，将对象数组批量插入，且不需要在意对象成员的排序
const insert2 = db.prepare('INSERT INTO cats (name, age) VALUES (@name, @age)');
const insertMany = db.transaction(cats => {
  for (let cat of cats) insert2.run(cat);
});
insertMany([
  { name: 'Joey', age: 2 },
  { name: 'Sally', age: 4 },
  { name: 'Junior', age: 1 },
]);

const queryStatement = db.prepare('SELECT * FROM cats WHERE age > 2');
queryStatement.all()
  // .filter(row => row.age > 2) // 大于两岁的猫（当然筛选条件也可以放入SQL语句中）
  .sort((x, y) => x.age - y.age) // 按年龄排序
  .forEach(row => console.log(row));


// 断开连接
db.close();