// Gulp tasks related to creating sample code fragments.
'use strict';

module.exports = function (gulp, plugins, config) {

  const argv = plugins.argv;
  const cp = plugins.child_process;
  const del = plugins.del;
  const _exec = plugins.execSyncAndLog;
  const fs = plugins.fs;
  const gutil = plugins.gutil;
  const path = plugins.path;

  const frags = config.frags;
  const EXAMPLES_PATH = config.EXAMPLES_NG_DOC_PATH;
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

  gulp.task('create-example-fragments', done =>
    plugins.runSequence(
      '_clean-frags',
      ['_shred-api-examples', '_shred-devguide-examples', '_shred-generated-examples', '_shred-other-examples'],
      '_setup-ng-doc-links',
      done
    ));

  gulp.task('_clean-frags', () => plugins.delFv(config.frags.path));

  gulp.task('_shred-devguide-examples', done => shred(_devguideShredOptions, done));

  gulp.task('_setup-ng-doc-links', () => {
    if (!fs.existsSync(path.join(frags.path, config.EXAMPLES_NG_DOC_PATH))) {
      const base = path.basename(config.EXAMPLES_NG_DOC_PATH);
      const dir = path.dirname(config.EXAMPLES_NG_DOC_PATH);
      _exec(`mkdir -p ${dir}`, { cwd: frags.path });
      _exec(`ln -s ../.. ${base}`, { cwd: path.join(frags.path, dir) });
    }
  });

  gulp.task('_shred-generated-examples', done => {
    const options = Object.assign({}, _devguideShredOptions);
    options.examplesDir = path.join(config.LOCAL_TMP, EXAMPLES_PATH);
    return shred(options, done);
  });

  gulp.task('_shred-other-examples', done => {
    const options = Object.assign({}, _devguideShredOptions);
    options.examplesDir = path.join(config.EXAMPLES_ROOT, 'html');
    options.fragmentsDir = path.join(options.fragmentsDir, 'html');
    return shred(options, done);
  });

  gulp.task('_shred-api-examples', () => shred(_apiShredOptions).then(() => {
    // Setup path aliases for API doc fragments
    const frags = _apiShredOptions.fragmentsDir;
    if (!fs.existsSync(path.join(frags, 'doc'))) _exec(`ln -s .. doc`, { cwd: frags });
    if (!fs.existsSync(path.join(frags, 'docs'))) _exec(`ln -s doc docs`, { cwd: frags });
  }));

  function shred(options) {
    // Split big shredding task into partials 2016-06-14
    const exPath = path.join(options.examplesDir, (argv.filter || '') + '*');
    var examplePaths = plugins.globby.sync(exPath, { ignore: ['**/node_modules'] });
    var promise = Promise.resolve(true);
    examplePaths.forEach(function (examplePath) {
      promise = promise.then(() => docShredder.shredSingleExampleDir(options, examplePath));
    });
    return promise;
  }

  const wwwwRepoPath = '../site-www';
  const _wwwShredOptions = {
    examplesDir: path.join(wwwwRepoPath, 'examples'),
    fragmentsDir: path.join(wwwwRepoPath, config.frags.path),
    logLevel: config._logLevel
  };

  gulp.task('_clean-www-frags', () => plugins.delFv(_wwwShredOptions.fragmentsDir));
  gulp.task('create-www-fragments', ['_clean-www-frags'], () => shred(_wwwShredOptions));

};
