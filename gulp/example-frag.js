// Gulp tasks related to creating sample code fragments.

module.exports = function (gulp, plugins, config) {

  const argv = plugins.argv;
  const del = plugins.del;
  const gutil = plugins.gutil;
  const path = plugins.path;

  const DOCS_PATH = config.DOCS_PATH;
  const EXAMPLES_PATH = config.EXAMPLES_PATH;
  const TOOLS_PATH = config.TOOLS_PATH;

  const fragDirPath = path.join('src', 'angular', '_fragments');

  const docShredder = require(path.resolve(TOOLS_PATH, 'doc-shredder/doc-shredder'));

  const ANGULAR_PROJECT_PATH = '../angular';

  const isSilent = !!argv.silent;
  if (isSilent) gutil.log = gutil.noop;
  const _dgeniLogLevel = argv.dgeniLog || (isSilent ? 'error' : 'info');

  var _devguideShredOptions =  {
    examplesDir: path.join(DOCS_PATH, '_examples'),
    fragmentsDir: fragDirPath,
    // zipDir: path.join(RESOURCES_PATH, 'zips'),
    logLevel: _dgeniLogLevel
  };

  var _devguideShredJadeOptions =  {
    jadeDir: DOCS_PATH,
    logLevel: _dgeniLogLevel
  };

  var _apiShredOptions =  {
    lang: 'ts',
    examplesDir: path.join(ANGULAR_PROJECT_PATH, 'modules/@angular/examples'),
    fragmentsDir: path.join(fragDirPath, '_api'),
    // zipDir: path.join(RESOURCES_PATH, 'zips/api'),
    logLevel: _dgeniLogLevel
  };

  const relDartDocApiDir = path.join('doc', 'api');
  var _apiShredOptionsForDart =  {
    lang: 'dart',
    examplesDir: path.resolve(ANGULAR_PROJECT_PATH + '2_api_examples'),
    fragmentsDir: path.join(fragDirPath, '_api'),
    // zipDir: path.join(RESOURCES_PATH, 'zips/api'),
    logLevel: _dgeniLogLevel
  };

  gulp.task('create-examples-fragments', ['_shred-devguide-examples']);

  gulp.task('_shred-devguide-examples', ['_shred-clean-devguide', 'add-example-boilerplate'], function() {
    // Split big shredding task into partials 2016-06-14
    const exPath = path.join(EXAMPLES_PATH, (argv.filter || '') + '*');
    var examplePaths = plugins.globby.sync(exPath, {ignore: ['**/node_modules', '**/_boilerplate']});
    var promise = Promise.resolve(true);
    examplePaths.forEach(function (examplePath) {
      promise = promise.then(() => docShredder.shredSingleExampleDir(_devguideShredOptions, examplePath));
    });
    return promise;
  });

  gulp.task('_shred-clean-devguide', function(cb) {
    var cleanPath = argv.filter
      ? path.join(_devguideShredOptions.fragmentsDir, `${argv.filter}*/*.*`)
      : _devguideShredOptions.fragmentsDir;
    gutil.log(`_shred-clean: ${cleanPath}`);
    return del([ cleanPath, '!**/*.ovr.*', '!**/_api/**']);
  });

};
