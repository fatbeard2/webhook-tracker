#!/bin/sh

mix deps.get
mix compile
echo "Installing NPM assets..."
cd assets && npm install && node node_modules/webpack/bin/webpack.js --mode development
