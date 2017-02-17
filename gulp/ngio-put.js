'use strict';

module.exports = function (gulp, plugins, config) {

  const argv = plugins.argv;
  const cp = plugins.child_process;
  const execp = plugins.execp;
  const fs = plugins.fs;
  const path = plugins.path;
  const replace = plugins.replace;
  const dartLatest = path.join(config.angulario, 'public/docs/dart/latest');

  gulp.task('put-ngio-files', ['_put-dart-pages', '_put-ts-jade', '_put-includes', '_put-examples'], cb => {
    // Create mock cookbook so that sidenav still works
    const cookbook = path.join(dartLatest, 'cookbook');
    if (!fs.existsSync(cookbook)) fs.mkdirSync(cookbook);
    fs.writeFileSync(path.join(cookbook, '_data.json'), '{ "index": {}}');
    return cp.exec('./scripts/ngio-backport-finish.sh');
  });

  gulp.task('_put-dart-pages', ['_put-api', '_put-qs-etc', '_put-guide', '_put-router', '_put-tutorial']);

  gulp.task('_put-api', () => {
    const baseDir = 'src/angular';
    return gulp.src([
      `${baseDir}/api/_data.json`,
      `${baseDir}/api/index.jade`,
    ], { base: baseDir })
      // Adjust extend/include paths
      .pipe(replace(/\/angular\/api\//g, ''))
      .pipe(gulp.dest(dartLatest));
  });

  gulp.task('_put-qs-etc', () => {
    const baseDir = 'src/angular';
    return gulp.src([
      `${baseDir}/_data.json`,
      `${baseDir}/{_util-fns,quickstart,cheatsheet,glossary}.jade`,
    ], { base: baseDir })
      // Adjust extend/include paths
      .pipe(replace(/include \/_jade\/_util-fns/, 'include /_includes/_util-fns'))
      .pipe(replace(/include \/_jade\/_ts-temp/, 'include /docs/_includes/_ts-temp'))
      .pipe(replace(/\/_jade/g, '/docs'))
      .pipe(gulp.dest(dartLatest));
  });

  gulp.task('_put-guide', () => {
    const baseDir = 'src/angular';
    return gulp.src([
      `${baseDir}/guide/{_data.json,*.jade,images/**}`,
    ], { base: baseDir })
      // Adjust extend/include paths
      .pipe(replace(/include \/_jade\/_ts-temp/, 'include /docs/_includes/_ts-temp', {skipBinary:true}))
      .pipe(replace(/\/_jade/g, '/docs', {skipBinary:true}))
      .pipe(gulp.dest(dartLatest));
  });

  gulp.task('_put-router', () => {
    const baseDir = 'src/angular';
    return gulp.src([
      `${baseDir}/guide/router/{_data.json,*.jade}`,
    ], { base: baseDir })
      // Adjust extend/include paths
      .pipe(replace(/include \/_jade\/_ts-temp/, 'include /docs/_includes/_ts-temp', {skipBinary:true}))
      .pipe(replace(/\/_jade/g, '/docs', {skipBinary:true}))
      .pipe(gulp.dest(dartLatest));
  });

  gulp.task('_put-tutorial', () => {
    const baseDir = 'src/angular';
    return gulp.src([
      `${baseDir}/tutorial/_data.json`,
      `${baseDir}/tutorial/*.jade`,
    ], { base: baseDir })
      // Adjust extend/include paths
      .pipe(replace(/\/_jade/g, '/docs'))
      .pipe(gulp.dest(dartLatest));
  });

  function makeExampleAddSrcToPath(match, mixinName, _args) {
    var args = _args;
    if(_args.match('(^|\/)src\/')) {
      // Assume that we've already converted the Dart .jade to use src paths
    } else {
      args = _args.match('(^|\/)ts\/')
        ? args.replace(/((^|\/)ts\/)/, '$1src/')
        : `src/${_args}`;
      // Best-effort attempt at handling title changes too:
      args = args.replace(/'(app\/)/, "'src/$1");
    }
    return `+${mixinName}('${args}`;
  }

  gulp.task('_put-ts-jade', cb => {
    const baseDir = 'src/angular/_jade';
    const destDir = path.join(config.angulario, 'public/docs');
    return gulp.src([
      `${baseDir}/ts/_cache/**`,
    ], { base: baseDir })
      // Undo effects of extra step to removed br clear:

      .pipe(replace(/<!-- (br class="l-clear-[a-z]+") -->/, '<$1>'))

      // Undo effects of the _get-ts-jade task:

      // 2017-02: TS sources moved into `src` subfolder:
      .pipe(replace(/\+(makeExample|makeExcerpt)\(\'(.+)$/gm, makeExampleAddSrcToPath))
      // We don't need to include the ts _util-fns.jade file; comment it out.
      .pipe(replace(/\/\/- (include (\.\.\/)*_util-fns(\.jade)?)/g, '$1'))
      // General patch
      .pipe(replace(/(target="_blank") rel="noopener"/g, '$1'))
      // Patch toh-5; don't include TS-specific _see-addr-bar.jade
      .pipe(replace(/\/\/- (include (\.\.\/)*_includes\/_see-addr-bar(\.jade)?)/g, '$1'))
      // Patch guide/index - set the advancedLandingPage  because it is not worth trying to read it from the harp _data file
      .pipe(replace(/(var guideData = ){}; \/\/ ([^;]*);/, '$1$2;'))
      .pipe(replace(/(var advancedLandingPage =).*/, "$1 '';"))
      // Patch structural-directives
      .pipe(replace('## The *template* tag', '## The *&lt;template>* tag'))
      // Patch tempalte-syntax: w/o it the page doesn't render because of JS error: $("#page-footer").offset() is undefined
      .pipe(replace('## `*` and *template*', '## * and &lt;template&gt;'))
      // Patch glossary
      .pipe(replace("var docsLatest='/angular';", "var docsLatest='/' + current.path.slice(0,3).join('/');"))
      .pipe(gulp.dest(destDir));
  });

  gulp.task('_put-includes', () => {
    const baseDir = 'src/angular/_jade';
    const destDir = path.join(config.angulario, 'public/_includes');
    const fn = '_util-fns.jade';
    return execp(`cp ${baseDir}/${fn} ${destDir}/${fn}`).then(() =>
      cp.exec(`perl -ni -e 'print unless /^- (var jade2ng|.*return.*partial.*fullFileName)/' ${destDir}/${fn}`)
    );
  });

  gulp.task('_put-examples', cb => {
    const baseDir = 'public/docs/_examples';
    const ngioExDir = path.join(config.angulario, baseDir);
    // Some boilerplate files were made read-only, this prevents gulp.src/.dest() from being successful.
    // So first make the problematic files read/write.
    const find = `find ${ngioExDir} -path "*/dart/web/*" ! -path "*/build/*"`;
    cp.execSync(`${find} -name "a2docs.css" -exec chmod a+w {} +`);
    cp.execSync(`${find} -name "styles.css" -exec chmod a+w {} +`);
    return gulp.src([
      // EXAMPLES:
      `${baseDir}/*/dart/.*`,
      `${baseDir}/*/dart/**`,
      `!${baseDir}/*/dart/build/**`,
      `${baseDir}/*/e2e*.ts`,
    ], { base: baseDir })
      .pipe(gulp.dest(ngioExDir));
  });

};
