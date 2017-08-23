// Gulp tasks related to creating sample code fragments.
'use strict';

module.exports = function (gulp, plugins, config) {

  const argv = plugins.argv;
  const cp = plugins.child_process;
  const del = plugins.del;
  const fs = plugins.fs;
  const gutil = plugins.gutil;
  const path = plugins.path;

  const frags = config.frags;
  const DOCS_PATH = config.DOCS_PATH;
  const EXAMPLES_PATH = config.EXAMPLES_PATH;
  const TOOLS_PATH = config.TOOLS_PATH;

  const docShredder = require(path.resolve(TOOLS_PATH, 'doc-shredder/doc-shredder'));

  var _devguideShredOptions = {
    examplesDir: EXAMPLES_PATH,
    fragmentsDir: frags.path,
    logLevel: config._logLevel
  };

  var _apiShredOptions = {
    examplesDir: path.join(EXAMPLES_PATH, '..', 'api'),
    fragmentsDir: path.join(frags.path, frags.apiDirName),
    logLevel: config._logLevel
  };

  gulp.task('create-example-fragments',
    ['_clean', 'add-example-boilerplate', '_shred-api-examples',
     '_shred-devguide-examples', '_shred-generated-examples']);

  gulp.task('_shred-devguide-examples', ['_shred-clean-devguide'], done => shred(_devguideShredOptions, done));

  gulp.task('_shred-generated-examples', ['_shred-clean-devguide'], done => {
    const options = Object.assign({}, _devguideShredOptions);
    options.examplesDir = path.join(config.LOCAL_TMP, EXAMPLES_PATH);
    return shred(options, done);
  });

  gulp.task('_shred-api-examples', ['_shred-clean-api'], () => shred(_apiShredOptions).then(() => {
    // Setup path aliases for API doc fragments
    const frags = _apiShredOptions.fragmentsDir;
    if (!fs.existsSync(path.join(frags, 'doc'))) cp.execSync(`ln -s .. doc`, { cwd: frags });
    if (!fs.existsSync(path.join(frags, 'docs'))) cp.execSync(`ln -s doc docs`, { cwd: frags });
  }));

  function shred(options) {
    // Split big shredding task into partials 2016-06-14
    const exPath = path.join(options.examplesDir, (argv.filter || '') + '*');
    var examplePaths = plugins.globby.sync(exPath, { ignore: ['**/node_modules', '**/_boilerplate'] });
    var promise = Promise.resolve(true);
    examplePaths.forEach(function (examplePath) {
      promise = promise.then(() => docShredder.shredSingleExampleDir(options, examplePath));
    });
    return promise;
  }

  gulp.task('_shred-clean-devguide', ['_clean'], () => {
    const globPattern = `${argv.filter || '*'}*/*.*`;
    const cleanPath = path.join(_devguideShredOptions.fragmentsDir, globPattern);
    const args = [cleanPath, '!**/*.ovr.*', '!**/_api/**'];
    gutil.log(`_shred-clean-devguide (excluding _api): ${args}`);
    return del(args);
  });

  gulp.task('_shred-clean-api', ['_clean'], () => {
    const globPattern = `${argv.filter || '*'}*/*.*`;
    const cleanPath = path.join(_apiShredOptions.fragmentsDir, globPattern);
    const args = [cleanPath, '!**/*.ovr.*'];
    gutil.log(`_shred-clean-api: ${args}`);
    return del(args);
  });
};
