// #docregion '', v1
import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart';

import 'hero.dart';

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
  Future<List<Hero>> getAll() async {
    try {
      final response = await _http.get(_heroesUrl);
      final heroes = (_extractData(response) as List)
          .map((value) => Hero.fromJson(value))
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
          headers: _headers, body: json.encode({'name': name}));
      return Hero.fromJson(_extractData(response));
    } catch (e) {
      throw _handleError(e);
    }
  }
  // #enddocregion create

  // #docregion extract-data
  dynamic _extractData(Response resp) => json.decode(resp.body)['data'];
  // #enddocregion extract-data
  // #docregion error-handling

  Exception _handleError(dynamic e) {
    print(e); // for demo purposes only
    return Exception('Server error; cause: $e');
  }
  // #enddocregion error-handling, methods
}
// #enddocregion

/*
  // #docregion endpoint-json
  static const _heroesUrl = 'heroes.json'; // URL to JSON file
  // #enddocregion endpoint-json
*/
