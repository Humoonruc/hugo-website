// test-mysql.js

// @ts-check
'use strict';


const mysql = require('mysql');


// 1. 创建连接
const connection = mysql.createConnection({
  host: 'localhost', // 默认值
  port: 3306, // 默认值
  user: 'humoon',
  password: 'hmfyx520',
  database: 'humoon-test', // 可选
});
connection.connect(err => {
  if (err) console.error('error connecting: ' + err.stack);
  else console.log('connected as id ' + connection.threadId);
});


// 2. 创建表
connection.query('DROP TABLE IF EXISTS employees');
connection.query(
  `CREATE TABLE IF NOT EXISTS employees (
    id INT PRIMARY KEY,
    name VARCHAR(255), 
    age INT(3), 
    city VARCHAR(255)
    )`,
  (err, result) => {
    if (err) console.error(err);
    console.log("Table created");
  });


// 3. 添加列
connection.query(
  `ALTER TABLE employees ADD COLUMN salary INT(10)`,
  (err, result) => {
    if (err) console.error(err);
    console.log("Table altered");
  });


// 4. 插入记录
connection.query(
  'INSERT INTO employees (id, name, age, city, salary) VALUES (?, ?, ?, ?, ?)',
  [1, 'Jack', 22, 'London', 5000],
  (err, result) => { }
);
// 批量插入
const persons = [
  [2, 'John', 25, 'Paris', 4000],
  [3, 'Robert', 30, 'Berlin', 6000]
];
connection.query(
  'INSERT INTO employees VALUES ?',
  [persons],
  (err, result) => { }
);


// 5. 查询
connection.query(
  'SELECT * FROM employees WHERE salary<5500',
  (err, result) => {
    if (err) console.error(err);
    console.log(result); // 结果为RowDataPacket类的对象
    console.log(JSON.stringify(result, null, 2)); // 转化为标准的json格式
  });


// 关闭连接
connection.end();