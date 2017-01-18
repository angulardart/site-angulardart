// Gulp tasks used to fetch angular.io repo files relevant to webdev/angular.
//
// For the most part get-* tasks put files under src/angular.
// The exception is get-ngio-examples+ which puts files under public.

'use strict';

module.exports = function (gulp, plugins, config) {

  const argv = plugins.argv;
  const cp = plugins.child_process;
  const fs = plugins.fs;
  const gutil = plugins.gutil;
  const Q = plugins.q;
  const path = plugins.path;
  const replace = plugins.replace;

  const angulario = config.angulario;
  
  // To force a refresh of Dart Jade file invoke with --dart. 
  // You'd usually only do that if you put-ngio and made edits to Dart Jade.
  gulp.task('get-ngio-files', ['_clean', 'get-ngio-examples+', '_get-pages', '_get-resources']);

  gulp.task('_get-pages', ['_get-ts-jade', '_get-extra-dart', '_get-includes', ...(argv.dart ? ['_get-dart-pages'] : [])], () => {
    return Q.all(
      // Remove <br clear> from selected .jade files
      cp.exec(`perl -pi -e 's/<(br class="l-clear-left")>/<!-- $1 -->/' src/angular/_jade/ts/_cache/guide/learning-angular.jade`),
      cp.exec(`perl -pi -e 's/<(br class="l-clear-both")>/<!-- $1 -->/' src/angular/_jade/ts/_cache/guide/lifecycle-hooks.jade`)
    );
  });

  gulp.task('_get-dart-pages', ['_get-api-ref-page', '_get-qs-etc', '_get-guide', '_get-tutorial']);

  gulp.task('_get-ts-jade', cb => {
    const baseDir = path.join(angulario, 'public/docs');
    return gulp.src([
      `${baseDir}/ts/_cache/**/*.jade`,
    ], { base: baseDir })
      // We don't need to include the ts _util-fns.jade file; comment it out.
      .pipe(replace(/include (\.\.\/)*_util-fns(\.jade)?/g, '//- $&'))
      // General patch
      .pipe(replace(/target="_blank"/g, '$& rel="noopener"'))
      // Patch toh-5; don't include TS-specific _see-addr-bar.jade
      .pipe(replace(/include (\.\.\/)*_includes\/_see-addr-bar(\.jade)?/g, '//- $&'))
      // Patch guide/index - set the advancedLandingPage  because it is not worth trying to read it from the harp _data file
      .pipe(replace(/(var guideData = )([^;]*);/, '$1{}; // $2;'))
      .pipe(replace(/(var advancedLandingPage = )([^;]*);/, "$1'attribute-directives'; // $2;"))
      // Patch structural-directives
      .pipe(replace('## The *&lt;template>* tag', '## The *template* tag'))
      // Patch tempalte-syntax: w/o it the page doesn't render because of JS error: $("#page-footer").offset() is undefined
      .pipe(replace('## * and &lt;template&gt;', '## `*` and *template*'))
      // Patch glossary
      .pipe(replace("var docsLatest='/' + current.path.slice(0,3).join('/');", "var docsLatest='/angular';"))
      .pipe(gulp.dest('src/angular/_jade'));
  });

  gulp.task('_get-extra-dart', () => {
    const baseDir = path.join(angulario, 'public/docs/dart/latest');
    return gulp.src([
      `${baseDir}/_util-fns.jade`,
      `${baseDir}/_data.json`,
      `${baseDir}/api/_data.json`,
      `${baseDir}/guide/_data.json`,
      `${baseDir}/tutorial/_data.json`,
    ], { base: baseDir })
      // Patch _util-fns.jade
      .pipe(replace(/include (\/|(\.\.\/)+)_includes\//, 'include /_jade/'))
      .pipe(gulp.dest('src/angular'));
  });

  gulp.task('_get-includes', () => {
    const baseDir = path.join(angulario, 'public/_includes');
    return gulp.src([
      `${baseDir}/_util-fns.jade`,
    ], { base: baseDir })
      // Patch _util-fns.jade
      .pipe(replace(/^/, '- var jade2ng = true;\n'))
      .pipe(replace(/(\-  )( var frag = partial\(fullFileName\);)/, '$1 return \'!= partial("\' + fullFileName + \'")\';\n$1$2'))
      .pipe(gulp.dest('src/angular/_jade'));
  });

  gulp.task('_get-api-ref-page', () => _getNgIoJadeForDir('api'));

  gulp.task('_get-qs-etc', () => {
    // Only get quickstart, cheatsheet, glossary.
    const skipList =  ["index", "cli-quickstart", "tutorial", "guide", "cookbook", "api/", "resources", "help", "styleguide"];
    return _getNgIoJadeForDir('', null, skipList);
  });

  gulp.task('_get-guide', () => {
    _getNgIoJadeForDir('guide', null, [
      // Skip pages that are now exclusively at the top level
      'cheatsheet', 'glossary',
      // Skip obviously TS-specific pages
      'ngmodule', 'npm-packages', 'typescript-configuration', 'webpack',
      // Skip pages that we don't yet (or might never) have
      'browser-support', 'style-guide', 'upgrade',
      // Skip pages which we have already customized
      // TODO: remove this once the link to ng.io is broken
      'testing',
    ]);
    return true;
  });

  function jekyllStrEscape(s) { return !s ? s : s.match(/:/) ? `"${s}"` : s; }

  gulp.task('_get-tutorial', () => _getNgIoJadeForDir('tutorial'));

  function _getNgIoJadeForDir(dir, _data, _skiplist) {
    const skipList = _skiplist || [];
    const srcDir = path.join(angulario, `public/docs/dart/latest/${dir}`);
    const destDir = path.resolve(`./src/angular/${dir}`);
    const data = _data || require(path.join(srcDir, '_data.json'));

    // Create array to establish prev/next page links
    const prevNextArray = [];
    Object.keys(data).forEach(fileNameNoExt => {
      const fileName = `${fileNameNoExt}.jade`;
      const filePath = path.join(srcDir, fileName);
      const entry = data[fileNameNoExt];
      if (entry.hide || !fs.existsSync(filePath) || skipList.includes(fileNameNoExt)) {
        return true;
      }
      prevNextArray.push(fileNameNoExt);
    });

    Object.keys(data).forEach(fileNameNoExt => {
      const fileName = `${fileNameNoExt}.jade`;
      const filePath = path.join(srcDir, fileName);
      const entry = data[fileNameNoExt];
      if (/*entry.hide ||*/ !fs.existsSync(filePath) || skipList.includes(fileNameNoExt)) {
        gutil.log(`  >> skipping ${fileName}`);
        return true;
      }

      let pageConfig = 'layout: angular\n'
            + `title: ${jekyllStrEscape(entry.title)}\n`;
      if (entry['long-title']) pageConfig = pageConfig + `long-title: ${jekyllStrEscape(entry['long-title'])}\n`;
      const desc = entry.description || entry.intro || entry.banner;
      if (desc) pageConfig = pageConfig + `description: ${jekyllStrEscape(desc)}\n`;

      const sideNavGroup = entry.basics ? 'basic' : dir === 'guide' ? 'advanced' : '';
      if (sideNavGroup) pageConfig = pageConfig + `sideNavGroup: ${sideNavGroup}\n`;
      if (dir == 'api' || fileNameNoExt.match(/quickstart|cheatsheet|learning-angular/)) pageConfig = pageConfig + `toc: false\n`;

      // Handle prev/next links
      // Sample:
      //   nextpage:
      //     title: The Hero Editor
      //     url: /angular/tutorial/toh-pt1
      const pageIdx = prevNextArray.indexOf(fileNameNoExt);
      if (dir && pageIdx > -1 /*&& entry.nextable*/) {
        if (pageIdx > 0) {
          const _linkUri = prevNextArray[pageIdx-1];
          const _otherEntry = data[_linkUri];
          pageConfig = pageConfig + `prevpage:\n`
            + `  title: ${jekyllStrEscape(_otherEntry.title)}\n`
            + `  url: /angular/${dir}/${_linkUri}\n`;
        }
        if (pageIdx < prevNextArray.length - 1) {
          const _linkUri = prevNextArray[pageIdx+1];
          const _otherEntry = data[_linkUri];
          pageConfig = pageConfig + `nextpage:\n`
            + `  title: ${jekyllStrEscape(_otherEntry.title)}\n`
            + `  url: /angular/${dir}/${_linkUri}\n`;
        }
      }

      const jekyllYaml = `---\n${pageConfig}---\n`;
      const destFile = path.join(destDir, fileName);
      let jade = fs.readFileSync(filePath, {encoding: 'utf-8'});
      jade = jade
        .replace(/^/, `//- FilePath: ${destFile.replace(/.*\/(src\/)/, '$1')}\n`)
        // General patches
        .replace(/extends +(\.\.\/)*ts\//, 'extends /_jade/ts/')
        .replace(/(extends|include) \/docs(\/_includes)?/, '$1 /_jade')
        .replace(/include (\.\.\/)*_includes\/(_ts-temp(\.jade)?)/g, 'include /_jade/$2')
        .replace('src="api-list.json"', 'src="/angular/api/api-list.json"');
      // File reside in webdev; this tweak is no longer needed:
      // if (fileNameNoExt != 'index') {
      //   const exampleName = fileNameNoExt.replace(/pt/, '');
      //   jade = jade.replace(/block includes/, `$&\n  - var _example = '${exampleName}';`);
      // }
      fs.writeFileSync(destFile, jekyllYaml + jade);
      gutil.log(`  ${fileNameNoExt} -> ${destFile}`);
    });
    return true;
  }

  gulp.task('_get-resources', ['_get-rsrc-images1', '_get-rsrc-images2', '_get-rsrc-other']);

  gulp.task('_get-rsrc-images1', cb => {
    const baseDir = path.join(angulario, 'public');
    return gulp.src([
      `${baseDir}/resources/images/devguide/**`,
      `${baseDir}/resources/images/logos/inverse/shield/22*`,
      // Skip TS-specific
      `!${baseDir}/resources/images/devguide/{*test*,plunker*}`,
      `!${baseDir}/resources/images/devguide/*test*/**`,
      `!${baseDir}/resources/images/devguide/{cli-quickstart,ngmodule,upgrade}`,
      `!${baseDir}/resources/images/devguide/{cli-quickstart,ngmodule,upgrade}/**`,
      ], { base: baseDir }).pipe(gulp.dest('src'));
  });

  gulp.task('_get-rsrc-images2', cb => {
    const baseDir = path.join(angulario, 'public/docs/dart/latest');
    return gulp.src([`${baseDir}/guide/images/**`], { base: baseDir }).pipe(gulp.dest('src/angular'));
  });

  gulp.task('_get-rsrc-other', cb => {
    const baseDir = path.join(angulario, 'public');
    const ngIoApp = "angular.module('angularIOApp', ['ngMaterial', 'firebase'])";
    const dropFirebase = ngIoApp.replace(", 'firebase'", '')
    return gulp.src([
      `${baseDir}/resources/js/**/*`,
      `${baseDir}/resources/css/_options.scss`,
      `${baseDir}/resources/css/layout/_{grids,layout}.scss`,
      `${baseDir}/resources/css/base/_{colors,mixins,reset}.scss`,
      `${baseDir}/resources/css/module/_{alert,api,banner,buttons,callout,code,code-box,code-shell,filetree,form,symbol,table}.scss`,
      `!${baseDir}/resources/js/vendor/{jquery,lang-*,prettify}.js`,
      `!${baseDir}/resources/js/controllers/resources-controller.js`,
    ], { base: baseDir })
      // Patch resources/js/site.js
      .pipe(replace(ngIoApp, dropFirebase))
      // Patch resources/js/directives/api-list.js
      .pipe(replace(
        `<a ng-href="{{ item.path }}">`,
        `<a ng-href="{{ \\'/angular/api/\\' + item.path }}" target="_blank" rel="noopener">`
      ))
      // Patch live-example.js
      .pipe(replace(/target: '_blank/g, '$&" rel="noopener'))
      // Patch resources/js/util.js
      .pipe(replace("loc.indexOf('/docs/' + lang + '/')", "loc.indexOf('/angular/')"))
      .pipe(gulp.dest('src'));
  });

  //==============================================================================================
  // The main purpose of get-ngio-examples+ is to fetch the files necessary to
  // test, build and extract fragments from Dart examples. At the moment we achieve
  // this using the angular.io tooling (which is also copied over).
   
  gulp.task('get-ngio-examples+', cb => {
    // Some boilerplate files were made read-only, this prevents gulp.src/.dest() from being successful.
    // So first make the problematic files read/write.
    const find = 'find public/docs/_examples -path "*/dart/web/*" ! -path "*/build/*"';
    cp.execSync(`${find} -name "a2docs.css" -exec chmod a+w {} +`);
    cp.execSync(`${find} -name "styles.css" -exec chmod a+w {} +`);
    const baseDir = config.angulario;
    return gulp.src([
      // EXAMPLES: support files (since the example source is already under webdev)
      `${baseDir}/public/docs/_examples/{_boilerplate/*,package.json,.gitignore}`,
      `${baseDir}/public/docs/_examples/{protractor.config.js,protractor-helpers.ts,tsconfig.json}`,
      `!${baseDir}/public/docs/_examples/_boilerplate/systemjs*`,
      `${baseDir}/public/docs/_examples/*/e2e*.ts`,
      // Skip files w/o Dart tests
      `!${baseDir}/public/docs/_examples/{animations,cb-*,cli-*}/**`,
      `!${baseDir}/public/docs/_examples/{homepage-*,ngmodule,node_modules}/**`,
      `!${baseDir}/public/docs/_examples/{router,security}/**`, // no tests yet, but should have some soon
      `!${baseDir}/public/docs/_examples/{setup,style-?guide,testing,upgrade*,webpack}/**`,

      // TOOLING
      `${baseDir}/scripts/examples-install.sh`,
      `${baseDir}/tools/api-builder/**`, // necessary to build api.json and cheatsheet.json
      `${baseDir}/tools/doc-shredder/**`,
      `!${baseDir}/tools/doc-shredder/_test/**`,
      `${baseDir}/tools/styles-builder/**`,
    ], { base: baseDir })
      .pipe(gulp.dest('.'));
  });

};
