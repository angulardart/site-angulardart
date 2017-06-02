// Gulp tasks related to adding the built examples (deployable files)
// to the site folder
'use strict';

module.exports = function (gulp, plugins, config) {

  const EXAMPLES_PATH = config.EXAMPLES_PATH;
  const LOCAL_TMP = config.LOCAL_TMP;
  const siteFolder = 'publish';
  const siteExPath = plugins.path.join(siteFolder, 'examples');

  const argv = plugins.argv;
  const execp = plugins.execp;
  const filter = require('gulp-filter');
  const fs = plugins.fs;
  const gutil = plugins.gutil;
  const path = plugins.path;
  const replace = plugins.replace;

  let examples = plugins.fs.readdirSync(EXAMPLES_PATH)
    .filter(name => !name.match(/^toh-0$|^_|\.|node_modules/));

  gulp.task('__list-examples', () => {
    gutil.log(`examples: ${examples}`)
  });

  gulp.task('add-examples-to-site', ['_examples-get-repos', '_examples-cp-to-site-folder']);

  gulp.task('_examples-get-repos', ['_clean'], (cb) => {
    // var promise = Promise.resolve(true);
    const promises = [];
    examples.forEach((name) => {
      const exPath = path.join(LOCAL_TMP, EXAMPLES_PATH, name)
      if (fs.existsSync(exPath)) {
        // gutil.log(`  Repo ${exPath} exists`);
        // TODO: pull?
      } else {
        // gutil.log(`  repo ${exPath} needs to be fetched`);
        const repo = `https://github.com/angular-examples/${name}.git`;
        const clone = `git clone --depth 1 --branch gh-pages ${repo} ${exPath}`;
        // promise = promise.then(() => plugins.execp(cmd));
        promises.push(execp(clone));
      }
    });
    // return promise;
    return plugins.q.all(promises);
  });

  gulp.task('_examples-cp-to-site-folder', ['_clean'], (cb) => {
    if (argv.clean) {
      gutil.log(`  Cleaning out ${siteExPath}`);
      plugins.del.sync(siteExPath);
    }
    if (fs.existsSync(siteExPath)) {
      gutil.log(`  No examples to copy since folder exists: '${siteExPath}'.`);
      gutil.log(`  Use '--clean' to have '${siteExPath}' refreshed.`);
      return;
    }
    gutil.log(`  Copying examples to ${siteExPath}`);
    const baseDir = LOCAL_TMP;
    const js = filter(`${baseDir}/examples/**/*.js`, { restore: true });
    const indexHtml = filter(`${baseDir}/examples/ng/doc/*/index.html`, { restore: true });
    return gulp.src([
      `${baseDir}/examples/**`,
      `!${baseDir}/examples/.git`,
      `!${baseDir}/examples/.git/**`,
    ], { base: baseDir })
      .pipe(indexHtml)
      .pipe(replace(/(<base href=")([^"]+">)/, `$1/examples/ng/doc$2`)) //, { skipBinary: true }
      .pipe(indexHtml.restore)
      .pipe(gulp.dest(siteFolder));
  });

};
