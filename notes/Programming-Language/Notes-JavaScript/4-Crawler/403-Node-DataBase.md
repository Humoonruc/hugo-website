[TOC]

# 数据库

## RDBMS vs NoSQL

### 关系型数据库（RDBMS）

#### ACID规则

事务在英文中是transaction，和现实世界中的交易很类似，它有如下四个特性：

- A (Atomicity) 原子性
  - 原子性很容易理解，也就是说事务里的所有操作要么全部做完，要么都不做，事务成功的条件是事务里的所有操作都成功，只要有一个操作失败，整个事务就失败，需要回滚。比如银行转账，从A账户转100元至B账户，分为两个步骤：1）从A账户取100元；2）存入100元至B账户。这两步要么一起完成，要么一起不完成，如果只完成第一步，第二步失败，钱会莫名其妙少了100元。

- C (Consistency) 一致性
  - 一致性也比较容易理解，也就是说数据库要一直处于一致的状态，事务的运行不会改变数据库原本的一致性约束。例如现有完整性约束a+b=10，如果一个事务改变了a，那么必须得改变b，使得事务结束后依然满足a+b=10，否则事务失败。

- I (Isolation) 独立性
  - 所谓的独立性是指并发的事务之间不会互相影响，如果一个事务要访问的数据正在被另外一个事务修改，只要另外一个事务未提交，它所访问的数据就不受未提交事务的影响。比如现在有个交易是从A账户转100元至B账户，在这个交易还未完成的情况下，如果此时B查询自己的账户，是看不到新增加的100元的。

- D (Durability) 持久性
  - 持久性是指一旦事务提交后，它所做的修改将会永久的保存在数据库上，即使出现宕机也不会丢失。

#### RDBMS 的特征

- 高度组织化结构化数据
- 结构化查询语言（SQL）
- 数据和关系都存储在单独的表中
- 数据操纵语言，数据定义语言
- 严格的一致性
- 基础事务

### 非关系型数据库（NoSQL）

#### BASE规则

- Basically Available --基本可用
- Soft-state --软状态/柔性事务。 "Soft state" 可以理解为"无连接"的, 而 "Hard state" 是"面向连接"的
- Eventually Consistency -- 最终一致性， 也是 ACID 的最终目的。

#### NoSQL 的特征

- 代表着不仅仅是SQL
- 没有声明性查询语言
- 没有预定义的模式
- 键-值对存储，列存储，文档存储，图形数据库
- 最终一致性，而非ACID属性
- 非结构化和不可预知的数据
- CAP theorem：一个分布式系统不可能同时很好的满足一致性[^1]、可用性[^2]和分隔容忍性[^3]这三个需求，最多只能同时较好的满足两个
  - CA - 单点集群，满足一致性、可用性的系统，通常在可扩展性上不太强大。RDBMS
  - CP - 满足一致性，分区容忍性的系统，通常性能不是特别高。MongoDB, Redis
  - AP - 满足可用性，分区容忍性的系统，通常可能对一致性要求低一些。
- 高性能，高可用性和可伸缩性

[^1]: 一致性(Consistency)：所有节点在同一时间具有相同的数据。
[^2]: 可用性(Availability)：保证每个请求不管成功或者失败都有响应。
[^3]: 分隔容忍(Partition tolerance)：系统中任意信息的丢失或失败不会影响系统的继续运作。



## MongoDB

教程：https://www.runoob.com/mongodb/mongodb-databases-documents-collections.html

### 简介

MongoDB是==基于文档==的数据库

一个文档（一个键值对集合，就像JavaScript的对象）相当于RDBMS的一行。字段值可以包含其他文档，数组及文档数组。

一个集合（多个文档）相当于RDBMS的一张表

一组集合就构成了一个数据库

MongoDB Compass 和 Robo 3T 是 MongoDB 的图形界面管理工具。

### Windows 安装 MongoDB

#### 运行 MongoDB 服务器

MongoDB 将数据文件存储在 `\data\db` 目录下。但是这个数据目录不会主动创建，我们在安装完成后需要创建它。创建完毕后，从 `\bin` 目录运行 MongoDB 服务器：

```shell
C:\Program Files\MongoDB\Server\4.4\bin> mongod --dbpath "C:\Program Files\MongoDB\Server\4.4\data\db"  
```

#### 配置为系统服务

建立相应文件夹和 log 文件（`\data\log\mongo.log`）后，从 `\bin` 目录执行命令

```shell
C:\Program Files\MongoDB\Server\4.4\bin> mongod --bind_ip 0.0.0.0 --logpath "C:\Program Files\MongoDB\Server\4.4\data\log\mongo.log" --logappend --dbpath "C:\Program Files\MongoDB\Server\4.4\data\db" --port 27017 --serviceName "MongoDB" --serviceDisplayName "MongoDB" --install
```

将MongoDB配置为系统服务，默认开机时自动启动，可以用http://localhost:27017/访问。这样就不用每次从命令行启动了。

#### 试用

```shell
C:\Program Files\MongoDB\Server\4.4\bin> mongo # 进入 MongoDB 命令行
> db
test
> db.runoob.insert({x:10})
WriteResult({ "nInserted" : 1 })
> db.runoob.find()
{ "_id" : ObjectId("5604ff74a274a611b0c990aa"), "x" : 10 }
```



### Linux 安装与配置 MongoDB

在宝塔面板的软件商店中一键安装

![image-20210430221559831](http://humoon-image-hosting-service.oss-cn-beijing.aliyuncs.com/img/typora/JavaScript/image-20210430221559831.png)

出于安全性的考虑，默认 mongodb 监听的是 `127.0.0.1:27017`，不允许远程访问

<img src="http://humoon-image-hosting-service.oss-cn-beijing.aliyuncs.com/img/typora/JavaScript/image-20210430221841280.png" alt="image-20210430221841280" style="zoom: 67%;" />

要远程访问，需要点击设置，修改配置文件，使 MongoDB 允许所有 IP 访问

![image-20210430221954426](http://humoon-image-hosting-service.oss-cn-beijing.aliyuncs.com/img/typora/JavaScript/image-20210430221954426.png)

但这是很危险的，允许其他 IP 访问容易被黑

![服务器上MongoDB数据库被黑](http://humoon-image-hosting-service.oss-cn-beijing.aliyuncs.com/img/typora/JavaScript/服务器上MongoDB数据库被黑.png)

所以最好不修改配置文件，不允许远程访问

而且==要注意数据的备份（如存一份数据库，存一份文件）==

#### MongoDB GUI 远程连接

mongodb端口27017

ssh端口22

千万不要搞混

<img src="http://humoon-image-hosting-service.oss-cn-beijing.aliyuncs.com/img/typora/JavaScript/image-20210506225452381.png" alt="image-20210506225452381" style="zoom:50%;" />



<img src="http://humoon-image-hosting-service.oss-cn-beijing.aliyuncs.com/img/typora/JavaScript/2.png" alt="2" style="zoom:50%;" />

### 命令行操作

#### 进入命令行模式

从 `\bin` 目录执行 `mongo.exe`/`mongo` 命令即可进入 MongoDB 的命令行模式

```shell
C:\Program Files\MongoDB\Server\4.4\bin> mongo.exe # 或 mongo
```

在 Linux 上直接输入 `mongo`

<img src="http://humoon-image-hosting-service.oss-cn-beijing.aliyuncs.com/img/typora/JavaScript/image-20210430213627568.png" alt="image-20210430213627568" style="zoom: 80%;" />

#### 创建和删除数据库、集合

```bash
use DATABASE_NAME # 创建数据库
db.createCollection("COLLECTION_NAME"[, options]) # 创建集合，集合名要用双引号引起来
db.COLLECTION_NAME.insert(document) # 插入记录
db.COLLECTION_NAME.drop() # 删除集合
db.dropDatabase() # 删除当前数据库
```

options 可以是如下参数：

| 字段   | 类型 | 描述                                                         |
| :----- | :--- | :----------------------------------------------------------- |
| capped | 布尔 | （可选）如果为 true，则创建固定集合。固定集合是指有着固定大小的集合，当达到最大值时，它会自动覆盖最早的文档。当该值为 true 时，必须指定 size 参数。 |
| size   | 数值 | （可选）为固定集合指定一个最大值，即字节数。                 |
| max    | 数值 | （可选）指定固定集合中包含文档的最大数量。                   |

在插入文档时，MongoDB 首先检查固定集合的 size 字段，然后检查 max 字段。

注意：在 MongoDB 中，集合只有在内容插入后才会创建! 就是说，创建集合(数据表)后要再插入一个文档，集合才会真正创建。

#### 查看数据库、集合、记录

```shell
show databases # 查看数据库
show dbs # databases 可以简写为 dbs
use DATABASE_NAME # 进入数据库
show collections # 查看该数据库下所有集合
show tables # 两种方式完全等价
db.getCollection("COLLECTION_NAME").find({}[, options]).pretty() # 查看其下的所有 document
db.COLLECTION_NAME.find({}[, options]).pretty() # 两种写法等价
```

查询document时，options是一个对象，属性`_id`取0值时不显示id字段，如

```bash
 db.getCollection("XinwenLianbo").find({}, {_id:0})
```

#### 用户权限设置

```bash
# 创建用户
db.createUser(
     {
       user: "用户名",
       pwd: "密码",
       roles:[ { role: "权限内容", db: "DATABASE_NAME" } ] 
     }
)
# 权限内容包括：read（仅读），readWrite（读写），userAdmin（可以创建和修改用户）等

# 简写方式
use DATABASE_NAME
db.createUser(
    {
      user: "用户名",
      pwd: "密码",
      roles: ["权限内容"]
    }
 )
 
# 对用户开放对应数据库权限
db.grantRolesToUser("用户名", [ { role: "权限内容", db: "DATABASE_NAME" } ])
 
# 身份验证
db.auth("用户名", "密码")

# 删除用户
db.dropUser("用户名")
```

#### Bash 交互实例

```bash
show dbs
use test
db.createCollection("mycol", { capped : true, size : 6142800, max : 10000 } )
db.mycol.insert({"name":"创建含参数的集合"})
db.mycol2.insert({"name":"默认创建不含参数的集合"})
db.mycol.find({})
db.mycol2.find({})
db.mycol2.find({}, {_id:0 })
show tables
show dbs
db.mycol2.drop()
show tables
db.dropDatabase()
show tables
show dbs


use dbWithUser
db.mycol.insert({"name":"默认创建不含参数的集合"})
db.createUser({user:"user1",pwd:"123456",roles:[{role:"userAdmin",db:"dbWithUser"}] })
db.createUser({user: "user2",pwd: "123456",roles: ["readWrite"]}) 
db.getUsers()
db.auth("user2", "123456")
db.grantRolesToUser("user2", [ { role: "userAdmin", db: "dbWithUser" } ])
db.dropUser("user2")
db.getUsers()
db.dropUser("user1")
db.getUsers()
db.dropDatabase()
show dbs
```



```bash
> show dbs
admin   0.000GB
config  0.000GB
local   0.000GB
> use test
switched to db test
> db.createCollection("mycol", { capped : true, size : 6142800, max : 10000 } )
{ "ok" : 1 }
> db.mycol.insert({"name":"创建含参数的集合"})
WriteResult({ "nInserted" : 1 })
> db.mycol2.insert({"name":"默认创建不含参数的集合"})
WriteResult({ "nInserted" : 1 })
> db.mycol.find({})
{ "_id" : ObjectId("6093efef6672e8e0c47399a6"), "name" : "创建含参数的集合" }
> db.mycol2.find({})
{ "_id" : ObjectId("6093eff86672e8e0c47399a7"), "name" : "默认创建不含参数的集合" }
> db.mycol2.find({}, {_id:0})
{ "name" : "默认创建不含参数的集合" }
> show tables
mycol
mycol2
> show dbs
admin   0.000GB
config  0.000GB
local   0.000GB
test    0.000GB
> db.mycol2.drop()
true
> show tables
mycol
> db.dropDatabase()
{ "dropped" : "test", "ok" : 1 }
> show tables
> show dbs
admin   0.000GB
config  0.000GB
local   0.000GB
> use dbWithUser
switched to db dbWithUser
> db.mycol.insert({"name":"默认创建不含参数的集合"})
WriteResult({ "nInserted" : 1 })
> db.createUser({user:"user1",pwd:"123456",roles:[{role:"userAdmin",db:"dbWithUser"}] })
Successfully added user: {
        "user" : "user1",
        "roles" : [
                {
                        "role" : "userAdmin",
                        "db" : "dbWithUser"
                }
        ]
}
> db.createUser({user: "user2",pwd: "123456",roles: ["readWrite"]})
Successfully added user: { "user" : "user2", "roles" : [ "readWrite" ] }
> db.getUsers()
[
        {
                "_id" : "dbWithUser.user1",
                "userId" : UUID("d8b5a41f-bfbf-4f30-a769-caa36a18df4a"),
                "user" : "user1",
                "db" : "dbWithUser",
                "roles" : [
                        {
                                "role" : "userAdmin",
                                "db" : "dbWithUser"
                        }
                ],
                "mechanisms" : [
                        "SCRAM-SHA-1",
                        "SCRAM-SHA-256"
                ]
        },
        {
                "_id" : "dbWithUser.user2",
                "userId" : UUID("d736c035-5c1d-411a-b990-f51c85cbf0e6"),
                "user" : "user2",
                "db" : "dbWithUser",
                "roles" : [
                        {
                                "role" : "readWrite",
                                "db" : "dbWithUser"
                        }
                ],
                "mechanisms" : [
                        "SCRAM-SHA-1",
                        "SCRAM-SHA-256"
                ]
        }
]
> db.auth("user2", "123456")
1
> db.grantRolesToUser("user2", [ { role: "userAdmin", db: "dbWithUser" } ])
> db.dropUser("user2")
true
> db.getUsers()
[
        {
                "_id" : "dbWithUser.user1",
                "userId" : UUID("d8b5a41f-bfbf-4f30-a769-caa36a18df4a"),
                "user" : "user1",
                "db" : "dbWithUser",
                "roles" : [
                        {
                                "role" : "userAdmin",
                                "db" : "dbWithUser"
                        }
                ],
                "mechanisms" : [
                        "SCRAM-SHA-1",
                        "SCRAM-SHA-256"
                ]
        }
]
> db.dropUser("user1")
true
> db.getUsers()
[ ]
> db.dropDatabase()
{ "dropped" : "dbWithUser", "ok" : 1 }
> show dbs
admin   0.000GB
config  0.000GB
local   0.000GB
> db.getUsers()
[ ]
```



#### Linux 中其他命令

> 查看mongo安装位置： whereis mongod
>
> 启动MongDB：systemctl start mongod.service
>
> 停止MongDB：systemctl stop mongod.service
>
> 重启mongodb：systemctl restart mongod.servic
>
> 查看mongo状态：systemctl status mongod.service
>
> 设置开机启动：systemctl enable mongod.service



### Node.js 使用 MongoDB

https://www.runoob.com/nodejs/nodejs-mongodb.html

Node对MongoDB的原生支持是非常好的

#### mongodb 模块

http://mongodb.github.io/node-mongodb-native/

```shell
npm install mongodb --save
```



```js
// @ts-check
'use strict';
// mongodb-native.js

const { MongoClient } = require("mongodb");



main();


async function main() {

  // 连接本地 mongodb 服务器（因此要使用服务器上的mongodb，就要在服务器本地运行js脚本）
  const uri = 'mongodb://localhost:27017/';
  const client = new MongoClient(uri, { useNewUrlParser: true, useUnifiedTopology: true });
  await client.connect().then(() => console.log('Connected successfully to server.'))
    .catch(err => {
      console.log('Connected failed. ');
      console.error(err);
    });

  // 连接或创建数据库 mongodb-native
  const database = client.db("mongodb-native");
  // 连接或创建 collection: movies
  const movies = database.collection("movies");
  //mongodb创建数据库和collection都是惰性的，不添加数据不会创建


  // 增 insert
  await insert(movies);

  // 查 find
  await find(movies);

  //改 update & replace
  await modify(movies);

  //删 delete
  await remove(movies);

  //删除 collection
  await movies.drop();


  await client.close();
}

async function insert(collection) {

  // 插入一个 document
  const insertResultOne = await collection.insertOne({ name: "Red", town: "Beijing" });
  console.log(`${insertResultOne.insertedCount} documents were inserted with the _id: ${insertResultOne.insertedId}`);

  // 插入多个 document
  const docs = [
    { name: "Blue", town: "Shanghai" },
    { name: "Leon", town: "Guangzhou" }
  ];
  const insertResultMany = await collection.insertMany(docs, { ordered: true });
  console.log(`${insertResultMany.insertedCount} documents were inserted`);
}

async function find(collection) {

  // 查找一个doc
  const query = { name: "Leon" };
  const document = await collection.findOne(query, {}); // collection.findOne() 直接返回一个 document/对象
  console.log(document);


  // 查找多个doc
  const findOptions = {
    sort: { name: -1 }, // 按 name 字段降序（1为升序，-1为降序）
    projection: { _id: 0, name: 1, town: 1 }, // Include only `name` and `town`
  };
  const cursor = await collection.find({}, findOptions) // collection.find()返回cursor（不是对象数组！）
    .skip(1).limit(2); // 先跳过1条，然后最多取回2条

  if ((await cursor.count()) === 0) {
    console.log("No documents found!");
  }

  const resultArray = [];
  await cursor.forEach(doc => {
    console.log(doc); // 分别输出
    resultArray.push(doc); // 将查询结果转化为数组
  });
  console.log(resultArray);

  //另一种得到数组的方法，但这似乎是一个闭包，无法将数组传递出来，只能在闭包内部进行操作
  await cursor.toArray((err, result) => console.log(result));


  //计数
  const estimate1 = await collection.estimatedDocumentCount();
  const estimate2 = await collection.countDocuments({});
  console.log(`Estimated number of documents in the movies collection: ${estimate1} == ${estimate2}`);

  const countLeon = await collection.countDocuments({ name: "Leon" });
  console.log(`Number called Leon: ${countLeon}`);
}

async function modify(collection) {

  // collection.update(), 指定修改规则
  // 修改一个 document
  const filter1 = { name: "Blue" };
  const options1 = { upsert: true }; // create a document if no documents match the filter
  const updateDoc = { $set: { name: 'Yellow' } }; // 指定修改规则
  const updateOneResult = await collection.updateOne(filter1, updateDoc, options1);
  console.log(`${updateOneResult.matchedCount} document(s) matched the filter, updated ${updateOneResult.modifiedCount} document(s)`);
  const options2 = { projection: { _id: 0, name: 1, town: 1 } };
  collection.find({}, options2).forEach(console.log);

  // 修改多个 documents
  const filter2 = { name: { $type: "string" } };
  const updateDocs = { $set: { addedAttr: 'newAttr', } }; // 指定修改规则
  const updateManyResult = await collection.updateMany(filter2, updateDocs);
  console.log(`${updateManyResult.matchedCount} document(s) matched the filter, updated ${updateManyResult.modifiedCount} document(s)`);
  const options3 = { projection: { _id: 0, name: 1, town: 1, addedAttr: 1 }, };
  collection.find({}, options3).forEach(console.log);


  // collection.replace() 替换
  const replaceQuery = { name: 'Redd', };
  const replaceOptions = { upsert: true, }; //若无匹配，则插入而非替换
  const replacement = {
    title: "Sandcastles in the Sand",
    plot: "Robin Sparkles mourns for a relationship with a mall rat at an idyllic beach.",
  };
  const replaceResult = await collection.replaceOne(replaceQuery, replacement, replaceOptions);
  if (replaceResult.modifiedCount === 0 && replaceResult.upsertedCount === 0) {
    console.log("No changes made to the collection.");
  } else {
    if (replaceResult.matchedCount === 1) {
      console.log("Matched " + replaceResult.matchedCount + " documents.");
    }
    if (replaceResult.modifiedCount === 1) {
      console.log("Updated one document.");
    }
    if (replaceResult.upsertedCount === 1) { //没有与query匹配的doc, 也就不存在替换；按照option，直接插入
      console.log(
        "Inserted one new document with an _id of " + replaceResult.upsertedId._id
      );
    }
  }
  collection.find({}).forEach(console.log);
}

async function remove(collection) {

  // 删除一个 document
  const deleteQuery = { name: { $type: "string" } };
  const deleteOneResult = await collection.deleteOne(deleteQuery);
  if (deleteOneResult.deletedCount === 1) {
    console.log("Successfully deleted a document.");
  } else {
    console.log("No documents matched the query. Deleted 0 documents.");
  }

  // 删除多个 documents
  const deleteManyResult = await collection.deleteMany({});
  console.log("Deleted " + deleteManyResult.deletedCount + " documents");
}
```



#### mongoose 模块

http://mongoosejs.com/



```shell
npm install mongoose --save
```



```js
// @ts-check
'use strict';
// mongoose.js

// 需要先在本地文件夹安装 mongoose 模块
const mongoose = require('mongoose');


// 连接数据库 mongoose（若无则创建）
const url = 'mongodb://localhost/mongoose';
// 完整写法包括用户名、密码和端口号
// const url = 'mongodb://username:password@localhost:port/article';
mongoose.connect(url, { useNewUrlParser: true, useUnifiedTopology: true })
  .then(() => console.log('Connected successfully to server.'))
  .catch(err => {
    console.log('Connected failed');
    console.log(err);
  });


// 定义一个模板，规定了字段及其数据类型
const ArticleSchema = new mongoose.Schema({
  title: String,
  author: String,
  content: String,
  publishTime: Date,
});
/**
 * 定义一个 model，同时在数据库中创建一个 collection，其中的document都要按照模板
 * @param String: 第一个参数表示数据库中 collection 的名字，如该值为 'Article'，数据库中这个 collection 就叫 'articles'（全小写+'s'）
 */
const Article = mongoose.model('Article', ArticleSchema);


main();


async function main() {
  await insertDocuments();
  await searchDocuments();
  await editDocument();
  await searchDocuments();
  await removeDocument();
  await searchDocuments();
  await mongoose.connection.close();
}



async function insertDocuments() {

  let doc1 = new Article({
    title: 'node.js',
    author: 'node',
    content: 'node.js is great!',
    publishTime: new Date(),
  });
  let doc2 = new Article({
    title: 'MongoDB in Node.js',
    author: 'MongoDB',
    content: 'MongoDB is great!',
    publishTime: new Date(),
  });
  let doc3 = new Article({
    title: 'MongoDB in Node.js',
    author: 'MongoDB and Redis',
    content: 'MongoDB is greater than Redis!',
    publishTime: new Date(),
  });
  const documentArray = [doc2, doc3];

  // 插入也可以用 document.save()
  await Article.create(doc1)
    .then(() => console.log('One document saved.'))
    .catch(err => {
      console.log('Insert one document failed');
      console.log(err);
    });
  await Article.insertMany(documentArray) // 批量保存 document array
    .then(() => console.log('Documents saved.'))
    .catch(err => {
      console.log('Insert documents failed');
      console.log(err);
    });
}

async function searchDocuments() {
  /**
   * 查询
   * @param 第一个参数是一个json对象，定义查找条件
   * @param 第二个参数是回调函数，操作查询结果
   */
  await Article.find({})
    .then(docs => {
      if (docs.length === 0) {
        console.log("No documents matched the query.");
      } else {
        console.log('Results: ' + docs);
      }
    })
    .catch(err => console.error(err));

  // await Article.findOne({})
  //   .then(doc => console.log('One result: ' + doc))
  //   .catch(err => console.error(err));

  // await Article.find({ title: 'MongoDB in Node.js', })
  //   .then(docs => console.log('Special results: ' + docs))
  //   .catch(err => console.error(err));
}

async function editDocument() {
  //在回调函数中修改
  await Article.findOne({}, (err, doc) => {
    if (err) {
      console.log('error');
      return;
    }
    doc.title = 'javascript';
    doc.save();
    console.log('Modified: ' + doc);
  });
  //也可以用 Article.replaceOne()和Article.update*()
}

async function removeDocument() {
  // 删除也可以用document.remove()
  await Article.deleteOne({})
    .then(() => { console.log('A document deleted.'); })
    .catch(err => console.error(err));

  await Article.deleteMany({})
    .then(() => { console.log('documents deleted.'); })
    .catch(err => console.error(err));
}
```

## Redis

## MySQL

### Linux MySQL

#### 宝塔面板管理

宝塔面板的“管理”选项允许许多在线的可视化操作，可以直接创建好数据库及其关联用户

![image-20210507011938223](http://humoon-image-hosting-service.oss-cn-beijing.aliyuncs.com/img/typora/JavaScript/image-20210507011938223.png)

![image-20210507012114451](http://humoon-image-hosting-service.oss-cn-beijing.aliyuncs.com/img/typora/JavaScript/image-20210507012114451.png)

#### 命令行操作

命令行需要记忆的命令就寥寥无几了：

```bash
[root@host]# mysql -u USER_NAME -p  # 连接 MySQL
Enter password:******
Welcome to the MySQL monitor.  Commands end with ; or \g.
Your MySQL connection id is 127
Server version: 5.6.50-log Source distribution

Copyright (c) 2000, 2020, Oracle and/or its affiliates. All rights reserved.

Oracle is a registered trademark of Oracle Corporation and/or its
affiliates. Other names may be trademarks of their respective
owners.

Type 'help;' or '\h' for help. Type '\c' to clear the current input statement.


mysql> status; # 查看mysql运行状态
--------------
mysql  Ver 14.14 Distrib 5.6.50, for Linux (x86_64) using  EditLine wrapper

Connection id:          127
Current database:
Current user:           humoon@localhost
SSL:                    Not in use
Current pager:          stdout
Using outfile:          ''
Using delimiter:        ;
Server version:         5.6.50-log Source distribution
Protocol version:       10
Connection:             Localhost via UNIX socket
Server characterset:    utf8mb4
Db     characterset:    utf8mb4
Client characterset:    utf8
Conn.  characterset:    utf8
UNIX socket:            /tmp/mysql.sock
Uptime:                 49 days 13 hours 40 min 4 sec

Threads: 1  Questions: 930  Slow queries: 0  Opens: 81  Flush tables: 2  Open tables: 11  Queries per second avg: 0.000
--------------


mysql> show databases; # 查看所有数据库
+--------------------+
| Database           |
+--------------------+
| information_schema |
| humoon-test        |
+--------------------+
2 rows in set (0.00 sec)


mysql> use humoon-test; # 进入数据库
Database changed


mysql> show tables; # 查看数据库中所有表
+-----------------------+
| Tables_in_humoon-test |
+-----------------------+
| fruits                |
+-----------------------+
1 row in set (0.00 sec)


mysql> desc fruits; # 查看表结构
+-------+------+------+-----+---------+-------+
| Field | Type | Null | Key | Default | Extra |
+-------+------+------+-----+---------+-------+
| name  | text | NO   |     | NULL    |       |
+-------+------+------+-----+---------+-------+
1 row in set (0.01 sec)


mysql> select * from fruits; # 查询
+--------+
| name   |
+--------+
| apple  |
| peer   |
| banana |
+--------+
3 rows in set (0.00 sec)


mysql> quit; # 退出 MySQL 命令行模式
Bye
```

### mysql 模块

[mysql - npm (npmjs.com)](https://www.npmjs.com/package/mysql)

```js
// @ts-check
'use strict';
// mysql.js


const mysql = require('mysql');


// 1. 创建连接
const connection = mysql.createConnection({
  host: 'localhost', // 默认值
  port: 3306, // 默认值
  user: 'humoon',
  password: '123456',
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
// 批量插入，注意语法
const persons = [
  [2, 'John', 25, 'Paris', 4000],
  [3, 'Robert', 30, 'Berlin', 6000]
];
connection.query(
  'INSERT INTO employees VALUES ?', // 因为插入的数据字段是全的，顺序也一致，故可以省略 (id, name, age, city, salary)
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
```



```bash
[root@VM-0-16-centos news-literature-crawling]# node mysql.js
connected as id 108
Table created
Table altered
[
  RowDataPacket {
    id: 1,
    name: 'Jack',
    age: 22,
    city: 'London',
    salary: 5000
  },
  RowDataPacket {
    id: 2,
    name: 'John',
    age: 25,
    city: 'Paris',
    salary: 4000
  }
]
[
  {
    "id": 1,
    "name": "Jack",
    "age": 22,
    "city": "London",
    "salary": 5000
  },
  {
    "id": 2,
    "name": "John",
    "age": 25,
    "city": "Paris",
    "salary": 4000
  }
]
```



```bash
mysql> show databases;
+--------------------+
| Database           |
+--------------------+
| information_schema |
| humoon-test        |
+--------------------+
2 rows in set (0.00 sec)


mysql> use humoon-test
Database changed


mysql> show tables;
+-----------------------+
| Tables_in_humoon-test |
+-----------------------+
| employees             |
| fruits                |
+-----------------------+
2 rows in set (0.00 sec)


mysql> desc employees;
+--------+--------------+------+-----+---------+-------+
| Field  | Type         | Null | Key | Default | Extra |
+--------+--------------+------+-----+---------+-------+
| id     | int(11)      | NO   | PRI | NULL    |       |
| name   | varchar(255) | YES  |     | NULL    |       |
| age    | int(3)       | YES  |     | NULL    |       |
| city   | varchar(255) | YES  |     | NULL    |       |
| salary | int(10)      | YES  |     | NULL    |       |
+--------+--------------+------+-----+---------+-------+
5 rows in set (0.00 sec)


mysql> select * from employees;
+----+--------+------+--------+--------+
| id | name   | age  | city   | salary |
+----+--------+------+--------+--------+
|  1 | Jack   |   22 | London |   5000 |
|  2 | John   |   25 | Paris  |   4000 |
|  3 | Robert |   30 | Berlin |   6000 |
+----+--------+------+--------+--------+
3 rows in set (0.00 sec)
```



## SQLite

文件式数据库，不需要服务器，非常方便，适合个人小规模使用。

### sqlite3 模块

这个模块中的sql操作是异步的

[API · mapbox/node-sqlite3 Wiki (github.com)](https://github.com/mapbox/node-sqlite3/wiki/API#new-sqlite3databasefilename-mode-callback)

```js
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
```

### better-sqlite3 模块

这个模块中的sql操作都是同步的，代码清晰易读。

#### 安装与使用

```bash
npm install --save better-sqlite3
```

```js
const Database = require('better-sqlite3');
```

#### 主要 API

API: https://github.com/JoshuaWise/better-sqlite3/blob/master/docs/api.md

`new Database(databaseFilePath, [options])`，连接/创建数据库文件

`Database.prepare(string) -> Statement`，构建sql语句

`Database.transaction(function) -> function，`构建泛函

`Statement.run([...bindParameters]) -> object，`运行sql语句

`Statement.get([...bindParameters]) -> row`，返回查询结果

`Statement.all([...bindParameters]) -> array of rows，`返回多个查询结果组成的数组

`Statement.iterate([...bindParameters]) -> iterator，`返回多个查询结果构成的迭代器，可以配合 `for...of...`



```js
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

const queryStatement = db.prepare('SELECT name, age FROM cats');
const rows = queryStatement.all();
rows.filter(row=>row.age>2)
  .forEach(row => console.log(row));


// 断开连接
db.close();
```



```bash
DROP TABLE IF EXISTS lorem
CREATE TABLE IF NOT EXISTS lorem (info TEXT PRIMARY KEY NOT NULL)
INSERT INTO lorem (info) VALUES ('Ipsum 0')
INSERT INTO lorem (info) VALUES ('Ipsum 1')
INSERT INTO lorem (info) VALUES ('Ipsum 2')
INSERT INTO lorem (info) VALUES ('Ipsum 3')
INSERT INTO lorem (info) VALUES ('Ipsum 4')
INSERT INTO lorem (info) VALUES ('Ipsum 5')
INSERT INTO lorem (info) VALUES ('Ipsum 6')
INSERT INTO lorem (info) VALUES ('Ipsum 7')
INSERT INTO lorem (info) VALUES ('Ipsum 8')
INSERT INTO lorem (info) VALUES ('Ipsum 9')
SELECT rowid AS id, info FROM lorem
line 1: Ipsum 0
line 2: Ipsum 1
line 3: Ipsum 2
line 4: Ipsum 3
line 5: Ipsum 4
line 6: Ipsum 5
line 7: Ipsum 6
line 8: Ipsum 7
line 9: Ipsum 8
line 10: Ipsum 9
DROP TABLE IF EXISTS cats
CREATE TABLE IF NOT EXISTS cats (
    name TEXT PRIMARY KEY NOT NULL,
    age INT NOT NULL
    )
INSERT INTO cats (name, age) VALUES ('Tim', 3.0)
BEGIN
INSERT INTO cats (name, age) VALUES ('Joey', 2.0)
INSERT INTO cats (name, age) VALUES ('Sally', 4.0)
INSERT INTO cats (name, age) VALUES ('Junior', 1.0)
COMMIT
SELECT name, age FROM cats
{ name: 'Tim', age: 3 }
{ name: 'Joey', age: 2 }
{ name: 'Sally', age: 4 }
{ name: 'Junior', age: 1 }
```

