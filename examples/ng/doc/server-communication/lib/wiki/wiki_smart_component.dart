// #docregion
import 'dart:async';
import 'package:angular2/core.dart';
import 'package:stream_transformers/stream_transformers.dart';

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
    providers: const [WikipediaService])
class WikiSmartComponent {
  final WikipediaService _wikipediaService;
  List items = [];

  WikiSmartComponent(this._wikipediaService) {
    _onSearchTerm.stream
        .transform(new Debounce(new Duration(milliseconds: 300)))
        .distinct()
        .transform(new FlatMapLatest(
            (term) => _wikipediaService.search(term).asStream()))
        .forEach((data) {
      items = data;
    });
  }

  final _onSearchTerm = new StreamController<String>();

  void search(String term) => _onSearchTerm.add(term);
}
