var webpack = require('webpack')
var path    = require('path')

module.exports = {
  entry: {
    site: path.resolve(__dirname, 'source/assets/javascripts/site.js'),
  },

  resolve: {
    modules: [
      path.resolve(__dirname, 'source/assets/javascripts'),
      path.resolve(__dirname, 'node_modules'),
    ],
  },

  output: {
    path: path.resolve(__dirname, 'tmp/webpack'),
    filename: 'assets/javascripts/[name].js',
  },
}
