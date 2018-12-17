// Gulp task to copy Angular docs (called Engineering Notes) on this site.
'use strict';

module.exports = function (gulp, plugins, config) {

  const path = plugins.path;
  const filter = plugins.filter;
  const replace = plugins.replace;

  const reEscapeRe = /[|\\{}()[\]^$+*?.]/g;
  const ngDocPath = 'site-angular/doc';
  const frontMatter = `---
title: "$2"
excerpt_separator: ""
---
{% raw %}
`;

  const readOnlyPerms = {
    owner: { write: false },
    group: { write: false },
    others: { write: false }
  };

  gulp.task('note-refresh', gulp.series(_pre_notess, _note_refresh, _post_notes));

  function _pre_notess(done) {
    const baseDir = path.join(config.source, 'angular', 'note');
    plugins.execSyncAndLog(`find . -name "*.md" ! -path "./index.md" -exec chmod a+w {} +`, { cwd: baseDir });
    done();
  }

  function _post_notes(done) {
    const baseDir = path.join(config.source, 'angular', 'note');
    plugins.execSyncAndLog(`find . -name "*.md" ! -path "./index.md" -exec chmod a-w {} +`, { cwd: baseDir });
    done();
  }

  function _note_refresh() {
    const baseDir = ngDocPath;
    const dest = path.join(config.source, 'angular', 'note');
    // const markdown = filter(`${baseDir}/**/*.md`, { restore: true }); // unnecessary atm

    return gulp.src([
      `${baseDir}/**/*.md`,
      `!${baseDir}/**/index.md`,
      `!${baseDir}/changelogs.md`,
      `!${baseDir}/developing`,
      `!${baseDir}/developing/**`,
      `!${baseDir}/angulardart-logo.png`,
    ], { base: baseDir })
      // Strip g3 comment block
      .pipe(replace(/<!-- !g3-begin[\S\s]*?!g3-end -->/, ''))
      // Add Jekyll frontmatter (+ raw tag) to *.md files
      .pipe(replace(/^(# (.*)\n\s*)?/, frontMatter))

      // Kramdown doesn't support :...: as a continuation line for a table cell. Adjust
      .pipe(replace(/\|(.*?)\|(.*?)\|\n:\s*(.*?):\s*(.*?):\n/g, '|$1 $3|$2 $4|\n'))
      // Make another pass to format 2nd overflow cell line
      .pipe(replace(/\|(.*?)\|(.*?)\|\n:\s*(.*?):\s*(.*?):\n/g, '|$1 $3|$2 $4|\n'))

      // Handle continuation line markers
      .pipe(replace(/\\\s*\n/g, '\n'))

      // Links to notes that we host on webdev should refer to webdev pages:
      .pipe(replace(re('effective/dependency-injection.md'), '/angular/note/effective/dependency-injection'))

      // Add endraw tag at end of page
      .pipe(replace(/$/, '\n{% endraw %}'))

      .pipe(plugins.chmod(readOnlyPerms))

      .pipe(gulp.dest(dest)); // Doesn't seem to work: { dirMode: 0o555 }
  }

  const escapedOrigDocUrl = 'https://github.com/dart-lang/angular/blob/master/doc/'.replace(reEscapeRe, '\\$&');

  function re(page) {
    let escapedPage = page.replace(reEscapeRe, '\\$&');
    return new RegExp(`(${escapedOrigDocUrl}|..\\/|\\b)${escapedPage}\\b`, 'g');
  }
};
