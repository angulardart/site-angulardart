// TODO This gulp task file currently only contains the new task for getting Dart sample code.
// Eventually, we'll be migrating the other ngio-get task from the main gulpfile to here.
'use strict';

module.exports = function (gulp, plugins, config) {

  const cp = plugins.child_process;
  const path = plugins.path;
  const replace = plugins.replace;

  // The main purpose of get-ngio-examples+ is to fetch the files necessary to
  // test, build and extract fragments from Dart examples. At the moment we achieve
  // this using the angular.io tooling (which is also copied over).
  //
  // As a tempoary means of managing updates to single-source Jade files, this task
  // also copies over select Jade TS files and folder.
   
  gulp.task('get-ngio-examples+', cb => {
    // Some boilerplate files were made read-only, this prevents gulp.src/.dest() from being successful.
    // So first make the problematic files read/write.
    const find = 'find public/docs/_examples -path "*/dart/web/*" ! -path "*/build/*"';
    cp.execSync(`${find} -name "a2docs.css" -exec chmod a+w {} +`);
    cp.execSync(`${find} -name "styles.css" -exec chmod a+w {} +`);
    const baseDir = config.angulario;
    return gulp.src([
      // EXAMPLES
      `${baseDir}/public/docs/_examples/{_boilerplate/*,package.json,.gitignore}`,
      `${baseDir}/public/docs/_examples/{protractor.config.js,protractor-helpers.ts,tsconfig.json}`,
      `!${baseDir}/public/docs/_examples/_boilerplate/systemjs*`,
      `${baseDir}/public/docs/_examples/*/e2e*.ts`,
      `${baseDir}/public/docs/_examples/*/dart*/**`,
      // Skip ts sample code
      // `!${baseDir}/public/docs/_examples/*/ts`, // this is now excluded from above.
      // Skip generated files and folders
      `!${baseDir}/public/docs/_examples/*/dart/{build,.pub}/**`,
      `!${baseDir}/public/docs/_examples/*/dart/{.packages,pubspec.lock}`,
      // Skip examples w/o Dart tests
      `!${baseDir}/public/docs/_examples/{animations,cb-*,cli-*}/**`,
      `!${baseDir}/public/docs/_examples/{homepage-*,ngmodule,node_modules}/**`,
      `!${baseDir}/public/docs/_examples/{router,security}/**`, // no tests yet, but should have some soon
      `!${baseDir}/public/docs/_examples/{setup,style-?guide,testing,upgrade*,webpack}/**`,

      // TOOLING
      `${baseDir}/scripts/examples-install.sh`,
      `${baseDir}/tools/api-builder/**`, // necessary to build cheatsheet.json
      `${baseDir}/tools/doc-shredder/**`,
      `!${baseDir}/tools/doc-shredder/_test/**`,
      `${baseDir}/tools/styles-builder/**`,

      // // JADE
      // `${baseDir}/public/{404.jade,_data.json,_layout.jade,index.jade}`,
      // `${baseDir}/public/_includes/**`,
      // `${baseDir}/public/docs/_includes/**`,
      // `${baseDir}/public/docs/{_data.json,_layout.jade,index.jade}`,
      // `${baseDir}/public/docs/ts/_cache/**`,
      // `${baseDir}/public/docs/ts/latest/**`, // copy over but gitignore
      
      // // RESOURCES
      // `${baseDir}/public/resources/{css,images,js}/**`, // copy over but gitignore

    ], { base: baseDir })
      // // We don't need to include the ts _util-fns.jade file; comment it out.
      // .pipe(replace(/include (\.\.\/)*_util-fns(\.jade)?/g, '//- $&'))
      // // General patch
      // .pipe(replace(/target="_blank"/g, '$& rel="noopener"'))
      // // Patch toh-5; don't include TS-specific _see-addr-bar.jade
      // .pipe(replace(/include (\.\.\/)*_includes\/_see-addr-bar(\.jade)?/g, '//- $&'))
      // // Patch guide/index - set the advancedLandingPage  because it is not worth trying to read it from the harp _data file
      // .pipe(replace(/(var guideData =)[^;]*/, '$1 {}'))
      // .pipe(replace(/(var advancedLandingPage =)[^;]*/, "$1 'attribute-directives'"))
      // // Patch structural-directives
      // .pipe(replace('## The *&lt;template>* tag', '## The *template* tag'))
      // // Patch tempalte-syntax: w/o it the page doesn't render because of JS error: $("#page-footer").offset() is undefined
      // .pipe(replace('## * and &lt;template&gt;', '## `*` and *template*'))
      // // Patch glossary
      // .pipe(replace("var docsLatest='/' + current.path.slice(0,3).join('/');", "var docsLatest='/angular';"))
      .pipe(gulp.dest('.'));
  });

};
