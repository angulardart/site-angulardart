// #docregion
import 'dart:async';
import 'package:angular2/angular2.dart';
import 'package:stream_transform/stream_transform.dart';

import 'wikipedia_service.dart';

@Component(
  selector: 'my-wiki-smart',
  template: '''
    <h1>Smarter Wikipedia Demo</h1>
    <p><i>Fetches when typing stops</i></p>

    <input #term (keyup)="search(term.value)"/>
    <ul>
      <li *ngFor="let item of items">{{item}}</li>
    </ul>
  ''',
  directives: const [CORE_DIRECTIVES],
  providers: const [WikipediaService],
)
class WikiSmartComponent {
  final WikipediaService _wikipediaService;
  List items = [];

  WikiSmartComponent(this._wikipediaService) {
    _onSearchTerm.stream
        .transform(debounce(new Duration(milliseconds: 300)))
        .distinct()
        .transform(
            switchMap((term) => _wikipediaService.search(term).asStream()))
        .forEach((data) {
      items = data;
    });
  }

  final _onSearchTerm = new StreamController<String>();

  void search(String term) => _onSearchTerm.add(term);
}
