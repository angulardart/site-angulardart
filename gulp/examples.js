// Gulp tasks related to adding the built examples (deployable files)
// to the site folder
'use strict';

module.exports = function (gulp, plugins, config) {

  const EXAMPLES_PATH = config.EXAMPLES_PATH;
  const LOCAL_TMP = config.LOCAL_TMP;
  const siteExPath = plugins.path.join(config.siteFolder, 'examples');

  const argv = plugins.argv;
  const execp = plugins.execp;
  const filter = require('gulp-filter');
  const fs = plugins.fs;
  const gutil = plugins.gutil;
  const path = plugins.path;
  const rename = plugins.rename;
  const replace = plugins.replace;

  const tmpReposPath = path.join(LOCAL_TMP, 'deploy-repos');
  const ngMajorVers = config.ngPkgVers.angular.vers[0]; // good enough until version 9!

  let examples = plugins.fs.readdirSync(EXAMPLES_PATH)
    .filter(name => !name.match(/^_|\.|node_modules/));

  gulp.task('__list-examples', () => {
    gutil.log(`examples: ${examples}`)
  });

  gulp.task('add-examples-to-site', ['_examples-get-repos', '_examples-cp-to-site-folder']);

  gulp.task('_examples-get-repos', ['_clean'], () => {
    const promises = [];
    examples.forEach((name) => {
      const exPath = path.join(tmpReposPath, EXAMPLES_PATH, name)
      if (fs.existsSync(exPath)) {
      } else {
        const repo = `https://github.com/angular-examples/${name}.git`;
        const clone = `git clone --depth 1 --branch gh-pages ${repo} ${exPath}`;
        promises.push(execp(clone));
      }
    });
    return plugins.q.all(promises);
  });

  let c = 0;
  gulp.task('_examples-cp-to-site-folder', ['_clean', '_examples-get-repos'], done => {
    if (fs.existsSync(siteExPath)) {
      gutil.log(`  No examples to copy since folder exists: '${siteExPath}'.`);
      gutil.log(`  Use '--clean' to have '${siteExPath}' refreshed.`);
      done();
      return;
    }
    gutil.log(`  Copying version ${ngMajorVers} of examples to ${siteExPath}`);
    const baseDir = tmpReposPath;
    const indexHtml = filter(`${baseDir}/examples/ng/doc/*/*/index.html`, { restore: true });
    return gulp.src([
      `${baseDir}/examples/ng/doc/*/${ngMajorVers}/**`,
      `!${baseDir}/examples/ng/doc/*/${ngMajorVers}`,
    ], { base: baseDir })
      // Adjust the <base href>:
      .pipe(indexHtml)
      .pipe(replace(/(<base href=")([^"]+)\/\d+(\/">)/, '$1/examples/ng/doc$2$3'))
      .pipe(indexHtml.restore)
      // Strip out NG version number from the path:
      .pipe(rename(p => {
        p.dirname = p.dirname.replace(`/${ngMajorVers}/`, '/').replace(`/${ngMajorVers}`, '');
      }))
      .pipe(gulp.dest(config.siteFolder));
  });

};
