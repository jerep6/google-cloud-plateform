const Koa = require('koa');
const koaBody = require('koa-body');
const Router = require('koa-router');
const KoaStatic = require('./middlewares/static');
const app = new Koa();
const config = require('./config/config');

const UploadController = require('./controllers/upload.controller');

app.use(koaBody({
  jsonLimit: '1kb'
}));

// Routes
const uploadRouter = UploadController.registerRoute(new Router());
const staticRouter = new Router().all('/*', KoaStatic('static', { maxage: 1000 * 3600 }));

const RootRouter = new Router({"prefix": config.url_path});
RootRouter.use('/static', staticRouter.routes(), staticRouter.allowedMethods());
RootRouter.use('/api/images', uploadRouter.routes(), uploadRouter.allowedMethods());

app.use(RootRouter.routes());

app.listen(3000);
console.log('listening on port 3000');