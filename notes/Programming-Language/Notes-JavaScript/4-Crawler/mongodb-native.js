// @ts-check
'use strict';
// mongodb-native.js

const { MongoClient } = require("mongodb");



main();


async function main() {

  // 连接 mongodb 服务器
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

  // 查找一个duc
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