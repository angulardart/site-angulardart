// #docplaster
// #docregion
import 'dart:async';

import 'package:angular2/angular2.dart';
import 'package:angular2/router.dart';
import 'package:stream_transform/stream_transform.dart';

import 'hero_search_service.dart';
import 'hero.dart';

@Component(
  selector: 'hero-search',
  templateUrl: 'hero_search_component.html',
  styleUrls: const ['hero_search_component.css'],
  directives: const [CORE_DIRECTIVES],
  providers: const [HeroSearchService],
  pipes: const [COMMON_PIPES],
)
class HeroSearchComponent implements OnInit {
  HeroSearchService _heroSearchService;
  Router _router;

  // #docregion search
  Stream<List<Hero>> heroes;
  // #enddocregion search
  // #docregion searchTerms
  StreamController<String> _searchTerms =
      new StreamController<String>.broadcast();
  // #enddocregion searchTerms

  HeroSearchComponent(this._heroSearchService, this._router) {}
  // #docregion searchTerms

  // Push a search term into the stream.
  void search(String term) => _searchTerms.add(term);
  // #enddocregion searchTerms
  // #docregion search

  Future<Null> ngOnInit() async {
    heroes = _searchTerms.stream
        .transform(debounce(new Duration(milliseconds: 300)))
        .distinct()
        .transform(switchMap((term) => term.isEmpty
            ? new Stream<List<Hero>>.fromIterable([<Hero>[]])
            : _heroSearchService.search(term).asStream()))
        .handleError((e) {
      print(e); // for demo purposes only
    });
  }
  // #enddocregion search

  void gotoDetail(Hero hero) {
    var link = [
      'HeroDetail',
      {'id': hero.id.toString()}
    ];
    _router.navigate(link);
  }
}
