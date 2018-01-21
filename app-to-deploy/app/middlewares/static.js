'use strict'

/**
 * Module dependencies.
 */

const { resolve } = require('path')
const assert = require('assert')
const send = require('koa-send')

/**
 * Expose `serve()`.
 */

module.exports = serve

/**
 * Serve static files from `root`.
 *
 * @param {String} root
 * @param {Object} [opts]
 * @return {Function}
 * @api public
 */

function serve (root, opts) {
  opts = Object.assign({}, opts)

  assert(root, 'root directory is required to serve files')

  // options
  opts.root = resolve(root)
  if (opts.index !== false) opts.index = opts.index || 'index.html'


  return async function serve (ctx, next) {
    await next()

    if (ctx.method !== 'HEAD' && ctx.method !== 'GET') return
    // response is already handled
    if (ctx.body != null || ctx.status !== 404) return // eslint-disable-line

    console.log(')))))))))))))', ctx.params['0'])
    const file = typeof ctx.params === 'object' ? ctx.params['0'] || `/${opts.index}` : ctx.request.path;

    try {
      await send(ctx, file, opts)
    } catch (err) {
      if (err.status !== 404) {
        throw err
      }
    }
  }
}