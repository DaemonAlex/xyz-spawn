const path = require("path");

module.exports = {
  webpack: {
    configure: (webpackConfig) => {
      // Use the best available source map when in in-game development mode
      if (webpackConfig.mode === 'development' && process.env.IN_GAME_DEV === '1') {
        webpackConfig.devtool = 'eval-source-map';
        webpackConfig.output.path = path.resolve(__dirname, 'build');
      }
      return webpackConfig;
    }
  },

  devServer: (devServerConfig) => {
    if (process.env.IN_GAME_DEV === '1') {
      devServerConfig.devMiddleware = devServerConfig.devMiddleware || {};
      devServerConfig.devMiddleware.writeToDisk = true;
    }
    return devServerConfig;
  }
};
