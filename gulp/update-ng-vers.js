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
  gulp.task('update-pubspec-etc', ['update-sdk-vers', 'update-pkg-vers']);

  //---------------------------------------------------------------------------
  // Updating SDK version

  const SDK_VERS = '>=1.24.0 <2.0.0';

  gulp.task('update-sdk-vers', (cb) => {
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

  console.log('Using package versions:');
  for (var pkg in ngPkgVers) { console.log(`  ${pkg}: ${ngPkgVers[pkg].vers}`); }

  gulp.task('update-pkg-vers', ['update-sdk-vers',
    ...(argv.ngVers >= '4' ? ['_remove_platform_entries_etc', '_update-dart'] : []),
  ], (cb) => {
    const baseDir = getBaseDir();
    return gulp.src([
      `${baseDir}/**/pubspec.yaml`,
      `!${baseDir}/**/.pub/**`,
    ]) // , { base: baseDir }
      .pipe(replace(/(^\s+)(angular\w*):\s+(\S+)$/gm, pkgEntry))
      .pipe(gulp.dest(baseDir));
  });

  function pkgEntry(match, indent, pkg, currentVers) {
    if (argv.ngVers >= '4' || ngPkgVers['angular'].vers[0] >= '4') {
      pkg = pkg.replace(/^angular2/, 'angular');
    }
    let vers = ngPkgVers[pkg] ? mkVers(pkg) : currentVers;
    return `${indent}${pkg}: ${vers}`;
  }

  function mkVers(pkg) {
    let vers = ngPkgVers[pkg].vers;
    // ^ is meaningless when the major version number is 0; see http://semver.org/#spec-item-4
    return vers[0] != '0' ? `^${vers}` : vers;
  }

  // const depOvr = 'dependency_overrides:\n' +
  //   '  some-pkg:\n' +
  //   '    git: https://github.com/dart-lang/some-pkg.git\n';
  // const depOvr2 = 'git:\n' +
  //   '      url: https://github.com/dart-lang/some-pkg.git\n' +
  //   '      ref: 1.2.3\n';
  // const depOvr3 = 'dependency_overrides:\n' +
  //   `  some-pkg:\n    ${depOvr2}\n`;

  // gulp.task('_dep_overrides', ['_update-acx-vers', '_update-ng-vers'], (cb) => {
  //   const baseDir = getBaseDir();
  //   return gulp.src([
  //     `${baseDir}/**/pubspec.yaml`,
  //     `!${baseDir}/**/.pub/**`,
  //   ]) // , { base: baseDir }
  //     .pipe(replace(/\btransformers:/, `${depOvr}$&`))
  //     .pipe(gulp.dest(baseDir));
  // });

  const platform_star =
    `    platform_directives:
    - 'package:angular2?/common.dart#COMMON_DIRECTIVES'
    platform_pipes:
    - 'package:angular2?/common.dart#COMMON_PIPES'
`;

  gulp.task('_remove_platform_entries_etc', ['update-sdk-vers'], (cb) => {
    const baseDir = getBaseDir();
    return gulp.src([
      `${baseDir}/**/pubspec.yaml`,
      `!${baseDir}/**/.pub/**`,
    ]) // , { base: baseDir }
      .pipe(replace(new RegExp(platform_star), ''))
      .pipe(replace(/\s+resolved_identifiers:(\s+\w+: .*)+/g, ''))
      .pipe(gulp.dest(baseDir));
  });

  const formsImport = "import 'package:angular_forms/angular_forms.dart';"

  gulp.task('_update-dart', ['update-sdk-vers'], (cb) => {
    const baseDir = getBaseDir();
    return gulp.src([
      `${baseDir}/**/*.dart`,
      `${baseDir}/**/*.html`,
      `${baseDir}/**/*.css`,
      `!${baseDir}/**/.pub/**`,
    ]) // , { base: baseDir }
      .pipe(replace(/angular2\/(angular2|common|platform\/browser|platform\/common).dart/g, 'angular/angular.dart'))
      .pipe(replace(/angular2\/router.dart/g, 'angular_router/angular_router.dart'))
      .pipe(replace(/(import 'package:angular\/angular.dart';)([\s\S]*)FORM_DIRECTIVES/, `$1\n${formsImport}$2formDirectives`))
      .pipe(replace(/FORM_DIRECTIVES/g, 'formDirectives'))
      .pipe(replace(/(import 'package:angular\/angular.dart';)([\s\S]*)COMMON_DIRECTIVES/, `$1\n${formsImport}$2CORE_DIRECTIVES, formDirectives`))
      .pipe(replace(/COMMON_DIRECTIVES/g, 'CORE_DIRECTIVES, formDirectives'))
      .pipe(replace(/\bElementRef\b/g, 'Element'))
      .pipe(replace(/\/deep\//g, ':ng-deep'))
      .pipe(gulp.dest(baseDir));
  });

};
