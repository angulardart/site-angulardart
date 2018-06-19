import 'dart:async';
import 'package:angular/angular.dart';
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
  directives: [coreDirectives],
  providers: [WikipediaService],
)
class WikiSmartComponent {
  final WikipediaService _wikipediaService;
  List items = [];

  WikiSmartComponent(this._wikipediaService) {
    _onSearchTerm.stream
        .transform(debounce(Duration(milliseconds: 300)))
        .distinct()
        .transform(
            switchMap((term) => _wikipediaService.search(term).asStream()))
        .forEach((data) {
      items = data;
    });
  }

  final _onSearchTerm = StreamController<String>();

  void search(String term) => _onSearchTerm.add(term);
}
