<style>
#toc-comp-testing .active {
  font-weight: bold;
  background-color: lightcyan;
}
</style>
<div id="toc-comp-testing" markdown="1">
- [Component testing](/guide/testing/component)
- [Running component tests](/guide/testing/component/running-tests)
- <span>Writing component tests</span>
  - [Basics](/guide/testing/component/basics): pubspec config, test
    API fundamentals
  - [Page objects](/guide/testing/component/page-objects): field annotation, initialization, and more
  - [Simulating user action](/guide/testing/component/simulating-user-action): click, type, clear
  - [Services](/guide/testing/component/services): local, external, mock, real
  - [`@Input()` and `@Output()`](/guide/testing/component/input-and-output)
  - [Routing components](/guide/testing/component/routing-components)
  - Appendices - _coming soon_
</div>
<script>
  (function (){
    var title = document.title;
    if (title.startsWith('Testing')) return; // On main page, nothing to highlight

    // Set top level topic
    var i = title.indexOf(':') > 0 ? 2 : title.startsWith('Run') ? 1 : 0;
    var topUl = $('#toc-comp-testing > ul');
    var activeElt = $(topUl).find('> li').eq(i);
    if (i == 2) activeElt = $(activeElt).find('span');
    activeElt.addClass('active');
    if (i < 2) return;

    // Set "Writing tests" subtopic
    var matches = title.match(/^[^:]+: (\S+)/);
    if (!matches) return;
    var subtopic = matches[1];
    var subtopicLi = $(topUl).find(`> li > ul > li:contains(${subtopic})`);
    subtopicLi.addClass('active');
  })();
</script>
