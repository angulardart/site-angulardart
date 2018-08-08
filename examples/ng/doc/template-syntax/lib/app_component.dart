import 'dart:html';
// #docregion exports
import 'dart:math' as math;
// #enddocregion exports

import 'package:angular/angular.dart';
import 'package:angular_forms/angular_forms.dart';
import 'package:angular_components/angular_components.dart';

import 'src/hero.dart';
import 'src/hero_component.dart';
import 'src/hero_form_component.dart';
import 'src/hero_switch_components.dart';
import 'src/click_directive.dart';
import 'src/sizer_component.dart';

// #docregion exports
enum Color { red, green, blue }
// #enddocregion exports

/// Giant grab bag of stuff to drive the chapter
// #docregion exports
@Component(
  // #enddocregion exports
  selector: 'my-app',
  templateUrl: 'app_component.html',
  styleUrls: ['app_component.css'],
  directives: [
    coreDirectives,
    formDirectives,
    BigHeroComponent,
    HeroComponent,
    HeroFormComponent,
    heroSwitchComponents,
    ClickDirective,
    ClickDirective2,
    SizerComponent,
    MaterialRadioComponent,
    MaterialRadioGroupComponent,
  ],
  // #docregion exports
  exports: [Color, math.min],
  // #enddocregion exports
  providers: [materialProviders],
  pipes: [commonPipes],
  // #docregion exports
)
class AppComponent implements OnInit {
  // #enddocregion exports
  ChangeDetectorRef cd;

  AppComponent(this.cd);

  @override
  void ngOnInit() {
    resetHeroes();
    setCurrentClasses();
    setCurrentStyles();
  }

  List<Element> prevHeroesNoTrackBy = [];

  @ViewChildren('noTrackBy')
  set heroesNoTrackBy(List<Element> elements) {
    final isSame = elements.every((e) => prevHeroesNoTrackBy.contains(e));
    if (isSame) return;
    prevHeroesNoTrackBy = elements;
    heroesNoTrackByCount++;
    cd.detectChanges();
  }

  List<Element> prevHeroesWithTrackBy = [];

  @ViewChildren('withTrackBy')
  set heroesWithTrackBy(List<Element> elements) {
    final isSame = elements.every((e) => prevHeroesWithTrackBy.contains(e));
    if (isSame) return;
    prevHeroesWithTrackBy = elements;
    heroesWithTrackByCount++;
    cd.detectChanges();
  }

  String actionName = 'Go for it';
  String badCurly = 'bad curly';
  String classes = 'special';
  String help = '';

  void alert([String msg]) => window.alert(msg);
  void callFax(String value) => alert('Faxing $value ...');
  void callPhone(String value) => alert('Calling $value ...');
  bool canSave = true;

  void changeIds() {
    this.resetHeroes();
    this.heroes.forEach((h) => h.id += 10 * this.heroIdIncrement++);
    this.heroesWithTrackByCountReset = -1;
  }

  void clearTrackByCounts() {
    final trackByCountReset = this.heroesWithTrackByCountReset;
    this.resetHeroes();
    this.heroesNoTrackByCount = -1;
    this.heroesWithTrackByCount = trackByCountReset;
    this.heroIdIncrement = 1;
  }

  String clicked = '';
  String clickMessage = '';
  String clickMessage2 = '';

  Color color = Color.red;
  void colorToggle() {
    color = (color == Color.red) ? Color.blue : Color.red;
  }

  Hero currentHero;

  void deleteHero([Hero hero]) {
    alert('Deleted ${hero?.name ?? 'the hero'}.');
  }

  // #docregion evil-title
  String evilTitle =
      'Template <script>alert("evil never sleeps")</script>Syntax';
  // #enddocregion evil-title

  dynamic /*String|int*/ fontSizePx = '16';

  String title = 'Template Syntax';

  int getVal() => 2;

  String name = Hero.mockHeroes[0].name;
  Hero hero; // defined to demonstrate template context precedence
  final List<Hero> heroes = [];

  // trackBy change counting
  int heroesNoTrackByCount = -1;
  int heroesWithTrackByCount = -1;
  int heroesWithTrackByCountReset = 0;

  int heroIdIncrement = 1;

  // heroImageUrl = 'http://www.wpclipart.com/cartoon/people/hero/hero_silhoutte_T.png';
  // Public Domain terms of use: http://www.wpclipart.com/terms.html
  final String heroImageUrl = 'assets/images/hero.png';
  // villainImageUrl = 'http://www.clker.com/cliparts/u/s/y/L/x/9/villain-man-hi.png'
  // Public Domain terms of use http://www.clker.com/disclaimer.html
  final String villainImageUrl = 'assets/images/villain.png';

  final String iconUrl = 'assets/images/ng-logo.png';
  bool isActive = false;
  bool isSpecial = true;
  bool isUnchanged = true;

  final Hero nullHero = null;

  void onClickMe(UIEvent event) {
    HtmlElement el = event?.target;
    var evtMsg = event != null ? 'Event target class is ${el.className}.' : '';
    alert('Click me.$evtMsg');
  }

  void onSave([UIEvent event]) {
    HtmlElement el = event?.target;
    var evtMsg = event != null ? ' Event target is ${el.innerHtml}.' : '';
    alert('Saved.$evtMsg');
    event?.stopPropagation();
  }

  void onSubmit(form) {/* referenced but not used */}

  Map product = {'name': 'frimfram', 'price': 42};

  // updates with fresh set of cloned heroes
  void resetHeroes() {
    heroes.clear();
    Hero.mockHeroes.forEach((hero) => heroes.add(Hero.copy(hero)));
    currentHero = heroes[0];
    heroesWithTrackByCountReset = 0;
  }

  void setUppercaseName(String name) {
    currentHero.name = name.toUpperCase();
  }

  // #docregion setClasses
  Map<String, bool> currentClasses = <String, bool>{};
  void setCurrentClasses() {
    currentClasses = <String, bool>{
      'saveable': canSave,
      'modified': !isUnchanged,
      'special': isSpecial
    };
  }
  // #enddocregion setClasses

  // #docregion setStyles
  Map<String, String> currentStyles = <String, String>{};
  void setCurrentStyles() {
    currentStyles = <String, String>{
      'font-style': canSave ? 'italic' : 'normal',
      'font-weight': !isUnchanged ? 'bold' : 'normal',
      'font-size': isSpecial ? '24px' : '12px'
    };
  }
  // #enddocregion setStyles

  // #docregion trackByHeroId
  Object trackByHeroId(_, dynamic o) => o is Hero ? o.id : o;
  // #enddocregion trackByHeroId
  // #docregion exports
}
