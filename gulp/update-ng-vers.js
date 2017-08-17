// Gulp tasks related to updating the pubspec version of angular & sdk
'use strict';

module.exports = function (gulp, plugins, config) {

  const argv = plugins.argv;
  const EXAMPLES_PATH = config.EXAMPLES_PATH;
  const ngPkgVers = config.ngPkgVers;
  const path = plugins.path;
  const replace = plugins.replace;

  function getBaseDir() {
    return argv.path || path.resolve(EXAMPLES_PATH, '..');
  }

  // To update NG 3 code to NG 4 code use --ng-vers=4
  gulp.task('update-pubspec-etc', ['update-ng-vers', 'update-sdk-vers']);

  //---------------------------------------------------------------------------
  // Updating SDK version

  const SDK_VERS = '>=1.24.0 <2.0.0';

  gulp.task('update-sdk-vers', ['update-ng-vers'], (cb) => {
    const baseDir = getBaseDir();
    return gulp.src([
      `${baseDir}/**/pubspec.yaml`,
      `!${baseDir}/**/.pub/**`,
    ]) // , { base: baseDir }
      .pipe(replace(/^(\s+sdk): ['"][^'"]+['"]/m, `$1: '${SDK_VERS}'`))
      .pipe(gulp.dest(baseDir));
  });

  //---------------------------------------------------------------------------
  // Updating ACX and NG versions

  const ACX_VERS = ngPkgVers.angular_components.vers;
  const NG_VERS = ngPkgVers.angular.vers;
  const NG_TEST_VERS = ngPkgVers.angular_test.vers;

  const depOvr = 'dependency_overrides:\n' +
    '  angular2:\n' +
    '    git: https://github.com/dart-lang/angular2.git\n';
  const depOvr2 = 'git:\n' +
    '      url: https://github.com/dart-lang/angular2.git\n' +
    '      ref: 3.0.0-alpha+1\n';
  const depOvr3 = 'dependency_overrides:\n' +
    `  angular2:\n    ${depOvr2}\n`;

  gulp.task('update-ng-vers', [
    '_update-acx-vers', '_update-ng-vers',
    ...(argv.ngVers && argv.ngVers >= '4' ? ['_remove_platform_entries_etc', '_update-dart'] : []),
  ]);

  gulp.task('_update-acx-vers', (cb) => {
    const baseDir = getBaseDir();
    return gulp.src([
      `${baseDir}/**/pubspec.yaml`,
      `!${baseDir}/**/.pub/**`,
    ]) // , { base: baseDir }
      .pipe(replace(/(^\s+angular2?_components:) \S+$/m, `$1 ^${ACX_VERS}`))
      .pipe(gulp.dest(baseDir));
  });

  gulp.task('_update-ng-vers', ['_update-acx-vers'], (cb) => {
    const baseDir = getBaseDir();
    return gulp.src([
      `${baseDir}/**/pubspec.yaml`,
      `!${baseDir}/**/.pub/**`,
    ]) // , { base: baseDir }
      .pipe(replace(/(^\s+angular2:) \S+$/m, `$1 ^${NG_VERS}`))
      .pipe(replace(/(^\s+angular_test:) \S+$/m, `$1 ^${NG_TEST_VERS}`))
      .pipe(gulp.dest(baseDir));
  });

  gulp.task('_dep_overrides', ['_update-acx-vers', '_update-ng-vers'], (cb) => {
    const baseDir = getBaseDir();
    return gulp.src([
      `${baseDir}/**/pubspec.yaml`,
      `!${baseDir}/**/.pub/**`,
    ]) // , { base: baseDir }
      .pipe(replace(/\btransformers:/, `${depOvr}$&`))
      .pipe(gulp.dest(baseDir));
  });

  gulp.task('_dep_overrides2', ['_update-acx-vers', '_update-ng-vers'], (cb) => {
    const baseDir = getBaseDir();
    return gulp.src([
      `${baseDir}/**/pubspec.yaml`,
      `!${baseDir}/**/.pub/**`,
    ]) // , { base: baseDir }
      .pipe(replace('git: https://github.com/dart-lang/angular2.git', `${depOvr2}`))
      .pipe(gulp.dest(baseDir));
  });

  gulp.task('_remove_dep_overrides', ['_update-acx-vers', '_update-ng-vers'], (cb) => {
    const baseDir = getBaseDir();
    return gulp.src([
      `${baseDir}/**/pubspec.yaml`,
      `!${baseDir}/**/.pub/**`,
    ]) // , { base: baseDir }
      .pipe(replace(depOvr3, ''))
      .pipe(gulp.dest(baseDir));
  });

  const platform_star =
  `    platform_directives:
    - 'package:angular2/common.dart#COMMON_DIRECTIVES'
    platform_pipes:
    - 'package:angular2/common.dart#COMMON_PIPES'
`;

  gulp.task('_remove_platform_entries_etc', ['_update-acx-vers', '_update-ng-vers'], (cb) => {
    const baseDir = getBaseDir();
    return gulp.src([
      `${baseDir}/**/pubspec.yaml`,
      `!${baseDir}/**/.pub/**`,
    ]) // , { base: baseDir }
      .pipe(replace(platform_star, ''))
      .pipe(replace(/\s+resolved_identifiers:(\s+\w+: .*)+/g, ''))
      .pipe(gulp.dest(baseDir));
  });

  const formsImport = "import 'package:angular_forms/angular_forms.dart';"

  gulp.task('_update-dart', ['_update-acx-vers', '_update-ng-vers'], (cb) => {
    const baseDir = getBaseDir();
    return gulp.src([
      `${baseDir}/**/*.dart`,
      `!${baseDir}/**/.pub/**`,
    ]) // , { base: baseDir }
      .pipe(replace(/angular2\/(angular2|common|platform\/browser|platform\/common).dart/g, 'angular/angular.dart'))
      .pipe(replace(/angular2\/router.dart/g, 'angular_router/angular_router.dart'))
      .pipe(replace(/(import 'package:angular\/angular.dart';)([\s\S]*)FORM_DIRECTIVES/, `$1\n${formsImport}$2formDirectives`))
      .pipe(replace(/FORM_DIRECTIVES/g, 'formDirectives'))
      .pipe(replace(/(import 'package:angular\/angular.dart';)([\s\S]*)COMMON_DIRECTIVES/, `$1\n${formsImport}$2CORE_DIRECTIVES, formDirectives`))
      .pipe(replace(/COMMON_DIRECTIVES/g, 'CORE_DIRECTIVES, formDirectives'))
      .pipe(gulp.dest(baseDir));
  });

};
