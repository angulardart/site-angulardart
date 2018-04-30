// Gulp tasks related to adding the built example apps (deployable files)
// to the site folder
'use strict';

module.exports = function (gulp, plugins, config) {

  const EXAMPLES_ROOT = config.EXAMPLES_ROOT;
  const LOCAL_TMP = config.LOCAL_TMP;
  const siteExPath = plugins.path.join(config.siteFolder, 'examples');

  const argv = plugins.argv;
  const cp = plugins.child_process;
  const _exec = plugins.execSyncAndLog;
  const execp = plugins.execp;
  const filter = plugins.filter;
  const fs = plugins.fs;
  const gutil = plugins.gutil;
  const path = plugins.path;
  const rename = plugins.rename;
  const replace = plugins.replace;

  const chooseRegEx = argv.filter || '.';
  const skipRegEx = argv.skip || null;

  const tmpReposPath = path.join(LOCAL_TMP, 'deploy-repos');
  const ngMajorVers = config.ngPkgVers.angular.vers[0]; // good enough until version 9!

  const findCmd = `find ${EXAMPLES_ROOT} -type f -name ".docsync.json"`;
  const examplesFullPath = (cp.execSync(findCmd) + '').split(/\s+/).filter(p => p).map(p => path.dirname(p));
  const examples = examplesFullPath.map(p => path.basename(p))
    .filter(p => !p.match(skipRegEx))
    .filter(p => p.match(chooseRegEx))
    .sort();

  gulp.task('__list-examples', () => {
    gutil.log(`Angular major version: ${ngMajorVers}`);
    gutil.log(`examples:\n  ${examples.join('\n  ')}`);
  });

  gulp.task('add-example-apps-to-site', ['_clean'], done =>
    plugins.runSequence('_examples-get-repos', '_examples-cp-to-site-folder', done));

  gulp.task('_examples-get-repos', () => {
    // const promises = [];
    examples.forEach(name => {
      const exPath = path.join(tmpReposPath, EXAMPLES_ROOT, name)
      if (fs.existsSync(exPath)) {
        _exec('git checkout gh-pages', { cwd: exPath });
        _exec('git pull', { cwd: exPath });
      } else {
        const repo = `${config.ghNgEx}/${name}.git`;
        // To checkout gh-pages only use: --depth 1 --branch gh-pages.
        _exec(`git clone ${repo} ${exPath}`);
        _exec('git fetch', { cwd: exPath });
        _exec('git checkout gh-pages', { cwd: exPath });
      }
    });
    // return plugins.q.all(promises);
    // return promises.reduce(plugins.q.when, plugins.q(true)).then(() => done());
  });

  let c = 0;
  gulp.task('_examples-cp-to-site-folder', done => {
    if (fs.existsSync(siteExPath)) {
      gutil.log(`  No examples to copy since folder exists: '${siteExPath}'.`);
      gutil.log(`  Use '--clean' to have '${siteExPath}' refreshed.`);
      done();
      return;
    }
    gutil.log(`  Copying version ${ngMajorVers} of examples to ${siteExPath}`);
    const baseDir = tmpReposPath;
    const indexHtml = filter(`${baseDir}/**/index.html`, { restore: true });
    const re = new RegExp(`/${ngMajorVers}(/|$)`);
    return gulp.src([
      `${baseDir}/examples/*/${ngMajorVers}/**`,
      `!${baseDir}/examples/*/${ngMajorVers}/`,
      `${baseDir}/examples/*/*/${ngMajorVers}/**`,
      `!${baseDir}/examples/*/*/${ngMajorVers}/`,
    ], { base: baseDir })
      // Adjust the <base href>:
      .pipe(indexHtml)
      .pipe(replace(/(<base href=")([^"]+)\/\d+(\/.*?">)/, '$1/examples$2$3'))
      .pipe(indexHtml.restore)
      // Strip out NG version number from the path:
      .pipe(rename(p => p.dirname = p.dirname.replace(re, '$1')))
      .pipe(gulp.dest(config.siteFolder));
  });

  // General exec task. Args: --cmd='some-cmd with args'
  // This task is useful to, e.g., create repo dev branches.
  gulp.task('examples-repo-exec', () => examplesRepoExec(argv.cmd));

  function examplesRepoExec(cmd) {
    if (!cmd) throw `Invalid command: ${cmd}`;
    const dir = argv.path || path.join(tmpReposPath, EXAMPLES_ROOT);
    examples.map(name => path.join(dir, name)).forEach((exPath) => {
      _exec(cmd, { cwd: exPath });
    });
  }

};
