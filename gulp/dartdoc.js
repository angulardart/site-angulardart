'use strict';

module.exports = function (gulp, plugins, config) {

  const argv = plugins.argv;
  const cp = plugins.child_process;
  const fs = plugins.fs;
  const path = plugins.path;

  const dartdocCmd = 'pub global run dartdoc'
  const libsToDoc = {
    acx: `angular_components`,
    ng:
     `angular2
      angular2.common
      angular2.compiler
      angular2.core
      angular2.platform.browser
      angular2.platform.common
      angular2.platform.common_dom
      angular2.router
      angular2.security`.replace(/\s+/g, ','),
  };

  const repoPath = config.repoPath;
  function path2ApiDocFor(r) {
    return path.resolve(repoPath[r], config.relDartDocApiDir);
  }

  const _projs = plugins.genDartdocForProjs();
  plugins.gutil.log(`Dartdocs targets: ${_projs.length ? _projs : 'no projects (all exist or are being skipped)'}.`);

  // Task: dartdoc
  // --dartdoc='all|none|acx|ng', default is 'all'.
  // --fast   skip prep and API doc generation if API docs already exist.
  // --clean  removes package doc/api (and so forces regeneration of docs; i.e. --fast is ignored)
  gulp.task('dartdoc', _projs.map(p => `dartdoc-${p}`));

  config.dartdocProj.forEach(p => {
    if (_projs.includes(p)) {
      gulp.task(`dartdoc-${p}`, [`_dartdoc-${p}`]);

      // Task: _dartdoc-* is like the 'dartdoc' task but builds the docs even if --fast is used
      // (but --fast will still skip copying boilerplate files)
      gulp.task(`_dartdoc-${p}`, [`_dartdoc-clean-${p}`], () => _dartdoc(p));

      gulp.task(`_dartdoc-clean-${p}`, ['_clean'], () => _cleanIfArgSet(p));
    } else {
      gulp.task(`dartdoc-${p}`, () => true);
    }
  });

  function _cleanIfArgSet(proj) {
    if (!argv.clean) return;
    const cmd = `rm -Rf ${path2ApiDocFor(proj)}`;
    plugins.gutil.log(cmd);
    cp.execSync(cmd);
  }

  function _dartdoc(proj) {
    if (!proj) throw `_dartdoc(): no project specified`;
    return _dartdoc1(proj, libsToDoc[proj]);
  }

  function _dartdoc1(proj, libs) {
    const args = [];
    if (libs) args.push(`--include=${libs}`);
    args.push(`--output ${config.relDartDocApiDir}`);
    return plugins.q.all(
      plugins.execp(`${dartdocCmd} ${args.join(' ')}`, { cwd: repoPath[proj] }),
      plugins.execp(`${dartdocCmd} --version`)
    );
  }

};
