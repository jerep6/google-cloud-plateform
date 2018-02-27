module.exports = {
  database_mode: process.env.DATABASE_MODE || 'memory',
  img_directory: process.env.IMG_DIRECTORY || '/tmp',
  url_path: process.env.URL_PATH || '',
  mysql: {
    host: process.env.MYSQL_HOST || 'localhost',
    user: process.env.MYSQL_USER || 'xebia',
    password: process.env.MYSQL_PASSWORD || 'xebiaxebia',
    database: process.env.MYSQL_DATABASE || 'my_database'
  },
}