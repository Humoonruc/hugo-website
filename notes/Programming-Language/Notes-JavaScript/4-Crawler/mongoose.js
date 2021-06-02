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