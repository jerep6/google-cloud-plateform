
const database = [];

async function addFileMetadata(fileInformations) {
  database.push(fileInformations);
}

async function listFilesMetadata() {
  return database;
}

module.exports = {
  addFileMetadata,
  listFilesMetadata
}