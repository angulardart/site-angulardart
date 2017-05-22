bogus({template: String}) {}

var t1 = bogus(
  // #docregion show-hero
  template: '<h1>{{title}}</h1><h2>{{hero}} details!</h2>',
  // #enddocregion show-hero
);

var t2 = bogus(
  // #docregion show-hero-2
  template: '<h1>{{title}}</h1><h2>{{hero.name}} details!</h2>',
  // #enddocregion show-hero-2
);

var t4 = bogus(
  // #docregion multi-line-strings
  template: '''
    <h1>{{title}}</h1>
    <h2>{{hero.name}} details!</h2>
    <div><label>id: </label>{{hero.id}}</div>
    <div><label>name: </label>{{hero.name}}</div>
  ''',
  // #enddocregion multi-line-strings
);

/*
// #docregion name-input
<div>
  <label>name: </label>
  <input [(ngModel)]="hero.name" placeholder="name">
</div>
// #enddocregion name-input
*/

// #docregion app-component-1
class AppComponent {
  String title = 'Tour of Heroes';
  var hero = 'Windstorm';
}
