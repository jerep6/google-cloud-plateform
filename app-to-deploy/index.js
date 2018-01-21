const Koa = require('koa');
const koaBody = require('koa-body');
const Router = require('koa-router');
const KoaStatic = require('./app/middlewares/static');
const RootRouter = new Router();
const app = new Koa();

const UploadController = require('./app/controllers/upload.controller');

app.use(koaBody({
  jsonLimit: '1kb'
}));

// Routes
const uploadRouter = UploadController.registerRoute(new Router());
const staticRouter = new Router().all('/*', KoaStatic('static', { maxage: 1000 * 3600 }));

RootRouter.use('/static', staticRouter.routes(), staticRouter.allowedMethods());
RootRouter.use('/upload', uploadRouter.routes(), uploadRouter.allowedMethods());

app.use(RootRouter.routes());

app.listen(3000);
console.log('listening on port 3000');