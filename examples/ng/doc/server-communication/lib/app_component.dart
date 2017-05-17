// #docplaster
// #docregion
import 'package:angular2/angular2.dart';

import 'toh/hero_list_component.dart';
import 'wiki/wiki_component.dart';
import 'wiki/wiki_smart_component.dart';

@Component(
    selector: 'my-app',
    template: '''
      <hero-list></hero-list>
      <my-wiki></my-wiki>
      <my-wiki-smart></my-wiki-smart>
    ''',
    directives: const [
      HeroListComponent,
      WikiComponent,
      WikiSmartComponent
    ])
class AppComponent {}
