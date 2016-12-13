'use strict';

module.exports = function (gulp, plugins, config) {

  const argv = plugins.argv;
  const cp = plugins.child_process;
  const execp = plugins.execp;
  const fs = plugins.fs;
  const path = plugins.path;
  const replace = plugins.replace;
  const dartLatest = path.join(config.angulario, 'public/docs/dart/latest');

  gulp.task('put-ngio-files', ['_put-pages'], () => {
    // Create mock cookbook so that sidenav still works
    const cookbook = path.join(dartLatest, 'cookbook');
    if (!fs.existsSync(cookbook)) fs.mkdirSync(cookbook);
    fs.writeFileSync(path.join(cookbook, '_data.json'), '{ "index": {}}');
    return cp.exec('./scripts/ngio-backport-finish.sh');
  });

  gulp.task('_put-pages', ['_put-api', '_put-qs-etc', '_put-guide', '_put-tutorial']); //, '_put-extra-dart'

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

};
