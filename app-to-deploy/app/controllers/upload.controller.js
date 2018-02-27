const http = require('https');
const path = require('path');
const fs = require('fs');
const config = require('../config/config');
const repository = getRepository();

function getRepository() {
  switch (config.database_mode) {
    case 'mysql': return require('../repositories/mysql.repository');
    default: return require('../repositories/memory.repository');
  }
}

function registerRoute(router) {
  router.post('/', uploadImage);
  router.get('/', listImages);
  return router;
}

async function listImages(ctx) {
  ctx.body = await repository.listFilesMetadata();
}

async function uploadImage(ctx) {
  const body = ctx.request.body;

  if(!body.url || !body.name) {
    ctx.throw(400, 'field "url" and "name" are mandatory in the payload');
  }

  const pathToSave = path.join(config.img_directory, body.name);
  await download(body.url, pathToSave);

  const metadata = {
    name: body.name,
    url: body.url,
    size: fs.statSync(pathToSave).size
  };

  await repository.addFileMetadata(metadata);
  ctx.body = metadata;
}


function download(url, dest) {
  return new Promise((resolve, reject) => {
    const file = fs.createWriteStream(dest);

    http.get(url, response => {
      response.pipe(file);

      file.on('finish', () => {
        file.close(resolve) // close() is async, call cb after close completes.
      });
    })
      .on('error', err => {
        fs.unlink(dest); // Delete the file async. (But we don't check the result)
        if (cb) reject(err);
      });
  });
};

module.exports = { registerRoute };