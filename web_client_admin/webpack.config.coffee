path = require 'path'
# webpack = require 'webpack'
# ExtractTextPlugin = require 'extract-text-webpack-plugin'

module.exports =
    entry: "./src/entry.coffee"
    output:
        path: path.resolve(__dirname, "public", "js")
        filename: "web-client_dev.js"
        libraryTarget: "umd"
    module:
        rules: [
            {
                test: /\.coffee?/
                use: [
                    {
                        loader: 'coffee-loader'
                        options: { sourceMap: true }
                    }
                ]
            }
        ]
    devtool: "source-map"
