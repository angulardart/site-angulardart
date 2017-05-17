// #docplaster
// #docregion , v1
import 'dart:async';
import 'dart:convert';

import 'package:angular2/angular2.dart';
import 'package:http/http.dart';

import 'hero.dart';

@Injectable()
class HeroService {
  static final _headers = {'Content-Type': 'application/json'};
  // #docregion endpoint, http-get
  static const _heroesUrl = 'api/heroes'; // URL to web API
  // #enddocregion endpoint, http-get
  final Client _http;

  // #docregion ctor
  HeroService(this._http);
  // #enddocregion ctor

  // #docregion methods, error-handling, http-get
  Future<List<Hero>> getHeroes() async {
    try {
      final response = await _http.get(_heroesUrl);
      final heroes = _extractData(response)
          .map((value) => new Hero.fromJson(value))
          .toList();
      return heroes;
    } catch (e) {
      throw _handleError(e);
    }
  }
  // #enddocregion error-handling, http-get, v1

  // #docregion create, create-sig
  Future<Hero> create(String name) async {
    // #enddocregion create-sig
    try {
      final response = await _http.post(_heroesUrl,
          headers: _headers, body: JSON.encode({'name': name}));
      return new Hero.fromJson(_extractData(response));
    } catch (e) {
      throw _handleError(e);
    }
  }
  // #enddocregion create, v1

  // #docregion extract-data
  dynamic _extractData(Response resp) => JSON.decode(resp.body)['data'];
  // #enddocregion extract-data
  // #docregion error-handling

  Exception _handleError(dynamic e) {
    print(e); // for demo purposes only
    return new Exception('Server error; cause: $e');
  }
  // #enddocregion error-handling, methods
}
// #enddocregion

/*
  // #docregion endpoint-json
  static const _heroesUrl = 'heroes.json'; // URL to JSON file
  // #enddocregion endpoint-json
*/
