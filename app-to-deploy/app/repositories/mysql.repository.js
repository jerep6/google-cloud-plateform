const mysql = require('promise-mysql');
const config = require('../config/config');


mysql.createConnection(config.mysql)
  .then(createTable)
  .then(result => console.log('Table created'))
  .catch(error => console.log('Error when create table', error));

async function addFileMetadata(fileInformations) {
  const conn = await mysql.createConnection(config.mysql);
  conn.query('INSERT INTO IMAGES SET ?', fileInformations);
  console.log(`Save into database`, fileInformations);
  conn.end();
}

async function listFilesMetadata() {
  const conn = await mysql.createConnection(config.mysql)
  const result = conn.query('SELECT * FROM IMAGES');
  conn.end();
  return result;
}

async function createTable(connection) {
  return connection.query(`CREATE TABLE IF NOT EXISTS IMAGES (
      id INT NOT NULL AUTO_INCREMENT,
      name VARCHAR(256) NOT NULL,
      size INT NOT NULL,
      url VARCHAR(2048) NOT NULL,
      PRIMARY KEY (id)
    )`);
}

module.exports = {
  addFileMetadata,
  listFilesMetadata,
}