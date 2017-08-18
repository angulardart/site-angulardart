// Gulp tasks used to fetch angular.io repo files relevant to webdev/angular.
//
// For the most part get-* tasks put files under src/angular.
// The exception is get-ngio-examples+ which puts files under public.

'use strict';

module.exports = function (gulp, plugins, config) {

  const NgIoUtil = require('./ngio-util.js').NgIoUtil;

  const argv = plugins.argv;
  const cp = plugins.child_process;
  const fs = plugins.fs;
  const gutil = plugins.gutil;
  const Q = plugins.q;
  const path = plugins.path;
  const replace = plugins.replace;

  const angulario = config.angulario;
  const ngioExPath = path.join(angulario, 'public/docs/_examples');
  const EXAMPLES_PATH = config.EXAMPLES_PATH;
  const BOILERPLATE_PATH = path.join(EXAMPLES_PATH, '_boilerplate');

  // To force a refresh of Dart Jade file invoke with --dart.
  // You'd usually only do that if you put-ngio and made edits to Dart Jade.
  gulp.task('get-ngio-files', ['_clean', 'get-ngio-examples+', '_get-pages', '_get-resources']);

  gulp.task('_get-pages', ['_get-ts-jade', '_get-extra-dart', '_get-includes', ...(argv.dart ? ['_get-dart-pages'] : [])], cb => {
    return Q.all(
      // Remove <br clear> from selected .jade files
      cp.exec(`perl -pi -e 's/<(br class="l-clear-left")>/<!-- $1 -->/' src/angular/_jade/ts/_cache/guide/learning-angular.jade`),
      cp.exec(`perl -pi -e 's/<(br class="l-clear-left")>/<!-- $1 -->/' src/angular/_jade/ts/latest/guide/learning-angular.jade`),
      cp.exec(`perl -pi -e 's/<(br class="l-clear-both")>/<!-- $1 -->/' src/angular/_jade/ts/_cache/guide/lifecycle-hooks.jade`),
      cp.exec(`perl -pi -e 's/<(br class="l-clear-both")>/<!-- $1 -->/' src/angular/_jade/ts/latest/guide/lifecycle-hooks.jade`)
    );
  });

  gulp.task('_get-dart-pages', ['_get-api-ref-page', '_get-qs-etc', '_get-guide', '_get-router', '_get-tutorial']);

  function makeExampleRemoveSrcPath(match, mixinName, _args) {
    var args = _args.replace(/(^|['\/])src\//g, '$1');
    return `+${mixinName}('${args}'`;
  }

  function tsApiHrefToDart(match, hrefPrefix, urlDotdotSlashApiDontCare, dontcare2, urlRest) {
    // Simple argument values:
    // hrefPrefix: href=" or ](
    // urlRest: core/index/ViewChild-var.html" or it might end in )
    // console.log(`got match on ${match}, 1: ${hrefPrefix}, 3: ${urlRest}`);
    var matches = urlRest.match(/^(\w*)\/index\/(\w*)-(\w*)(\.html[ '"\)])$/);
    // console.log(`  >> urlRest matches ${matches}`);
    if (!matches) return match; // leave unchanged
    var i = 1; // matches[0] corresponds to the fully matched result
    var libName = matches[i++];
    if (libName == 'http') return match; // leave unchanged since ngDart doesn't have an HTTP library.
    if (libName == 'forms') libName = 'common';
    var apiPageEntryName = matches[i++];
    var apiEntryKind = matches[i++];
    var suffix = matches[i++];
    return hrefPrefix + '/angular/api/angular.' + libName + '/' + apiPageEntryName + '-class' + suffix;
  }

  function ngioExPathForDart(match, path) {
    return '`' + NgIoUtil.adjustTsExamplePathForDart(path) + '`';
  }

  gulp.task('_get-ts-jade', cb => _getTsJade('latest'));
  // TODO: drop this next task. We'll stop syncing the cache very soon.
  gulp.task('_get-ts-jade-cache', cb => _getTsJade('_cache'));

  function _getTsJade(dirName) {
    const baseDir = path.join(angulario, 'public/docs');
    return gulp.src([
      // Was: `${baseDir}/ts/${dirName}/**/*.jade`; given that we now might be fetching
      // from `ts/latest`, we need to select individual files:
      `${baseDir}/ts/${dirName}/guide/architecture.jade`,
      `${baseDir}/ts/${dirName}/guide/attribute-directives.jade`,
      `${baseDir}/ts/${dirName}/guide/dependency-injection.jade`,
      `${baseDir}/ts/${dirName}/guide/displaying-data.jade`,
      `${baseDir}/ts/${dirName}/guide/hierarchical-dependency-injection.jade`,
      `${baseDir}/ts/${dirName}/guide/index.jade`,
      `${baseDir}/ts/${dirName}/guide/lifecycle-hooks.jade`,
      `${baseDir}/ts/${dirName}/guide/security.jade`,
      `${baseDir}/ts/${dirName}/guide/server-communication.jade`,
      // `${baseDir}/ts/${dirName}/quickstart.jade`,
      // `${baseDir}/ts/${dirName}/_quickstart_repo.jade`,
      `${baseDir}/ts/${dirName}/tutorial/index.jade`,
      `${baseDir}/ts/${dirName}/tutorial/toh-pt1.jade`,
      `${baseDir}/ts/${dirName}/tutorial/toh-pt2.jade`,
      `${baseDir}/ts/${dirName}/tutorial/toh-pt3.jade`,
      `${baseDir}/ts/${dirName}/tutorial/toh-pt4.jade`,
      `${baseDir}/ts/${dirName}/tutorial/toh-pt5.jade`,
      `${baseDir}/ts/${dirName}/tutorial/toh-pt6.jade`,
      // These files are no longer Jade extended but we still sync them for diffs.
      `${baseDir}/ts/${dirName}/glossary.jade`,
      `${baseDir}/ts/${dirName}/guide/component-styles.jade`,
      `${baseDir}/ts/${dirName}/guide/learning-angular.jade`,
      `${baseDir}/ts/${dirName}/guide/pipes.jade`,
      `${baseDir}/ts/${dirName}/guide/structural-directives.jade`,
      `${baseDir}/ts/${dirName}/guide/template-syntax.jade`,
    ], { base: baseDir })
      // 2017-02: TS sources moved into `src` subfolder:
      .pipe(replace(/\+(makeExample|makeExcerpt)\(\'(.+)'/g, makeExampleRemoveSrcPath))
      // Catch remaining occurrences of `src`:
      .pipe(replace(/\/ts\/src\//g, '/ts/'))
      .pipe(replace(/(`|, )src\/(app\/)/g, '$1$2'))
      // Fix links to API entries from within markdown links, e.g. `href="..."` or `[DatePipe](...)` or var x = '...':
      // or [TemplateRef](../api/core/index/TemplateRef-class.html "API: TemplateRef")
      .pipe(replace(/(href="|\]\(|= ')((\.?\.\/)*api\/)([^ '"\)]*[ '"\)])/g, tsApiHrefToDart))
      // AngularJS --> Angular 1
      .pipe(replace(/AngularJS/g, 'Angular 1'))
      // Convert ngio-ex paths:
      .pipe(replace(/<ngio-ex path="([^"]+)"><\/ngio-ex>/g, ngioExPathForDart))
      .pipe(replace(/<span ngio-ex>([^<]+)<\/span>/g, ngioExPathForDart))
      .pipe(replace(/`([-\w\.]+\.ts)`/g, ngioExPathForDart))
      // A separate pattern for .html just because I don't want to
      // have `index.html` mapped to `web/index.html` (yet)
      .pipe(replace(/`([-\w]+(\.[-\w]+)+\.html)`/g, ngioExPathForDart))

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
      .pipe(replace('## The *&lt;template&gt;*', '## The *template* element'))
      // .pipe(replace(/([Nn]gSwitch)Case/g, '$1When')) // https://github.com/dart-lang/site-webdev/issues/503
      .pipe(replace(/\bfalsy/g, 'false'))
      .pipe(replace(/\btruthy/g, 'true'))
      .pipe(replace('`app/`', '`lib/`'))
      // Patch tempalte-syntax: w/o it the page doesn't render because of JS error: $("#page-footer").offset() is undefined
      .pipe(replace('## * and &lt;template&gt;', '## `*` and *template*'))
      .pipe(replace('"#toc"', '"#contents"'))
      // Patch glossary
      .pipe(replace("var docsLatest='/' + current.path.slice(0,3).join('/');", "var docsLatest='/angular';"))
      .pipe(gulp.dest('src/angular/_jade'));
  }

  gulp.task('_get-extra-dart', () => {
    const baseDir = path.join(angulario, 'public/docs/dart/latest');
    return gulp.src([
      // `${baseDir}/_util-fns.jade`, // 2017-03-24 stop syncing _util-fns.jade
      // `${baseDir}/_data.json`, // dropped as of https://github.com/dart-lang/site-webdev/pull/356
      `${baseDir}/api/_data.json`,
      `${baseDir}/guide/_data.json`,
      `${baseDir}/guide/router/_data.json`,
      `${baseDir}/tutorial/_data.json`,
    ], { base: baseDir })
      // Patch _util-fns.jade
      .pipe(replace(/include (\/|(\.\.\/)+)_includes\//, 'include /_jade/'))
      .pipe(gulp.dest('src/angular'));
  });

  gulp.task('_get-includes', () => {
    const baseDir = path.join(angulario, 'public/_includes');
    return true // 2017-03-24 stop syncing _util-fns.jade
    || gulp.src([
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

  gulp.task('_get-router', () => _getNgIoJadeForDir('guide/router'));

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
      if (entry.hide || (!fs.existsSync(filePath) && fileNameNoExt != 'router') || skipList.includes(fileNameNoExt)) {
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

      const sideNavGroup = entry.basics ? 'basic' : dir.startsWith('guide') ? 'advanced' : '';
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
      `!${baseDir}/resources/images/devguide/{cli-quickstart,ngcontainer,ngmodule,reactive-forms,upgrade}`,
      `!${baseDir}/resources/images/devguide/{cli-quickstart,ngcontainer,ngmodule,reactive-forms,upgrade}/**`,
      // Dart image is different for these:
      `!${baseDir}/resources/images/devguide/security/binding-inner-html.png`,
      // Skip images that we aren't updating (yet)
      `!${baseDir}/resources/images/devguide/router/{crisis-center-*,hero-*,shell-and-outlet}.png`,
      `!${baseDir}/resources/images/devguide/structural-directives/element-not-in-dom.png`,
      ], { base: baseDir }).pipe(gulp.dest('src'));
  });

  gulp.task('_get-rsrc-images2', cb => {
    const baseDir = path.join(angulario, 'public/docs/dart/latest');
    return gulp.src([
      `${baseDir}/guide/images/**`,
      `!${baseDir}/guide/images/create-ng2-project.png`
      ], { base: baseDir }).pipe(gulp.dest('src/angular'));
  });

  gulp.task('_get-rsrc-other', cb => {
    const baseDir = path.join(angulario, 'public');
    const ngIoApp = "angular.module('angularIOApp', ['ngMaterial', 'firebase'])";
    const dropFirebase = ngIoApp.replace(", 'firebase'", '')
    const stripSrc = `            // Adjust folder path: 2017/02 TS sources moved to src folder. Strip out \`src/\`
            .replace(/(^|(^|\\/)(dart|ts)\\/)src\\//, '$1')`;
    return gulp.src([
      `${baseDir}/resources/js/**/*`,
      `!${baseDir}/resources/js/controllers/**`,
      `${baseDir}/resources/css/_options.scss`,
      `${baseDir}/resources/css/layout/_{grids,layout}.scss`,
      `${baseDir}/resources/css/base/_{colors,mixins,reset}.scss`,
      `${baseDir}/resources/css/module/_{alert,api,banner,buttons,callout,code,code-box,code-shell,filetree,form,images,symbol,table}.scss`,
      `!${baseDir}/resources/js/vendor/{jquery,lang-*,prettify}.js`,
      `!${baseDir}/resources/js/directives/scroll-y-offset-element.js`,
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
      .pipe(replace('(!noDownload)', '(false)'))
      // Patch resources/js/util.js
      .pipe(replace("loc.indexOf('/docs/' + lang + '/')", "loc.indexOf('/angular/')"))
      .pipe(replace(/} \(\)\);/, '$&\n\nmodule.exports.NgIoUtil = NgIoUtil;'))
      .pipe(replace(/folder = folder/, `folder = folder\n${stripSrc}`))
      .pipe(replace('.match(/^(index|styles)', '.match(/^(main|index|styles)'))
      .pipe(replace("ts($|\\/)/, '$1dart$2')", "(dart|ts)($|\\/)/, '$1.$3')"))
      .pipe(gulp.dest('src'));
  });

  //==============================================================================================
  // As of 2017-03-14, _only_ copy over boilerplate files. We don't copy over sample code, since
  // the samples are exclusively tested in this repo.
  //
  // The main purpose of get-ngio-examples+ is to fetch the files necessary to
  // test, build and extract fragments from Dart examples. At the moment we achieve
  // this using the angular.io tooling (which is also copied over).

  gulp.task('get-ngio-examples+', ['_get-tools', '_get-ngio-boilerplate-src'], cb => {
    // Some boilerplate files were made read-only, this prevents gulp.src/.dest() from being successful.
    // So first make the problematic files read/write.
    const find = `find ${EXAMPLES_PATH} -path "*/dart/web/*" ! -path "*/build/*"`;
    cp.execSync(`${find} -name "a2docs.css" -exec chmod a+w {} +`);
    cp.execSync(`${find} -name "styles.css" -exec chmod a+w {} +`);
    const baseDir = ngioExPath;
    return gulp.src([
      // `${baseDir}/*/dart/.*`, `${baseDir}/*/dart/**`, // 2017-03-14: see note above
      // `!${baseDir}/*/dart/build/**`,
      // Support files (since the example source is already under webdev)
      `${baseDir}/_boilerplate/*.json`,
      // We don't need the plnkr, and we need to keep the old tsconfig (not under /src)
      `!${baseDir}/_boilerplate/plnkr.json`,
      `${baseDir}/{package.json,.gitignore}`,
      `${baseDir}/{protractor.config.js,protractor-helpers.ts,tsconfig.json}`,
      `${baseDir}/*/e2e*.ts`,
      // We no longer track updates to these files:
      `!${baseDir}/package.json`,
      `!${baseDir}/router/e2e-spec.ts`,
      // Skip files w/o Dart tests
      `!${baseDir}/{animations,cb-*,cli-*}/**`,
      `!${baseDir}/{homepage-*,ngmodule,node_modules,reactive-forms}/**`,
      `!${baseDir}/{setup,style-guide,styleguide,testing,upgrade*,webpack}/**`,
    ], { base: baseDir })
      // Patch security/e2e-spec.ts
      .pipe(replace(/(.toContain\('Template) alert\("0wned"\) (Syntax'\))/, '$1 $2', {skipBinary:true}))
      .pipe(gulp.dest(EXAMPLES_PATH));
  });

  gulp.task('_get-tools', ['_get-ngio-boilerplate-src'], cb => {
    const baseDir = config.angulario;
    return gulp.src([
      // `${baseDir}/scripts/examples-install.sh`, // As of 2017-03-21 we use a custom version
      `${baseDir}/tools/api-builder/**`, // necessary to build api.json and cheatsheet.json
      `${baseDir}/tools/doc-shredder/**`,
      `${baseDir}/tools/styles-builder/**`,
      `!${baseDir}/tools/doc-shredder/_test/**`,
    ], { base: baseDir })
      // Patch tools/doc-shredder/doc-shredder.js
      .pipe(replace("'**/dart/**/build/**'", "'**/dart/build/**'"))
      .pipe(replace("'**/dart/build/**'", "'**/build/web/**', '**/.*/**'"))
      .pipe(gulp.dest('.'));
  });

  // 2017/02: TS moved example sources into `src/`. This impacted the boilerplate files.
  // On the Dart side, we haven't adapted to this change (because we don't need to yet),
  // so this rule copies some boilerplate `src/` files into the boilerplate folder.
  gulp.task('_get-ngio-boilerplate-src', cb => {
    const ngBoilerplateDir = './public/docs/_examples/_boilerplate';
    const baseDir = `${config.angulario}/${ngBoilerplateDir}/src`;
    const cssImports
      = '@import url(https://fonts.googleapis.com/css?family=Roboto);\n'
      + '@import url(https://fonts.googleapis.com/css?family=Material+Icons);\n'
    return gulp.src([
      `${baseDir}/styles.css`,
      // `${baseDir}/tsconfig.json`, // Manually watch for differences (aside from paths having an extra ../)
    ], { base: baseDir })
      .pipe(replace(/\/\* Master Styles \*\//, `${cssImports}\n$&`))
      .pipe(gulp.dest(BOILERPLATE_PATH));
  });

};
