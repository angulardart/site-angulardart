// #docregion imports
import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart';

import 'hero.dart';
// #enddocregion imports

class HeroService {
  // #docregion update
  static final _headers = {'Content-Type': 'application/json'};
  // #enddocregion update
  // #docregion getAll
  static const _heroesUrl = 'api/heroes'; // URL to web API

  final Client _http;

  HeroService(this._http);

  Future<List<Hero>> getAll() async {
    try {
      final response = await _http.get(_heroesUrl);
      final heroes = (_extractData(response) as List)
          .map((json) => Hero.fromJson(json))
          .toList();
      return heroes;
      // #docregion catch
    } catch (e) {
      throw _handleError(e);
    }
    // #enddocregion catch
  }

  // #docregion extract-data
  dynamic _extractData(Response resp) => json.decode(resp.body)['data'];
  // #enddocregion extract-data

  // #docregion handleError
  Exception _handleError(dynamic e) {
    print(e); // for demo purposes only
    return Exception('Server error; cause: $e');
  }
  // #enddocregion handleError, getAll

  // #docregion get
  Future<Hero> get(int id) async {
    try {
      final response = await _http.get('$_heroesUrl/$id');
      return Hero.fromJson(_extractData(response));
    } catch (e) {
      throw _handleError(e);
    }
  }
  // #enddocregion get

  // #docregion create
  Future<Hero> create(String name) async {
    try {
      final response = await _http.post(_heroesUrl,
          headers: _headers, body: json.encode({'name': name}));
      return Hero.fromJson(_extractData(response));
    } catch (e) {
      throw _handleError(e);
    }
  }
  // #enddocregion create

  // #docregion update
  Future<Hero> update(Hero hero) async {
    try {
      final url = '$_heroesUrl/${hero.id}';
      final response =
          await _http.put(url, headers: _headers, body: json.encode(hero));
      return Hero.fromJson(_extractData(response));
    } catch (e) {
      throw _handleError(e);
    }
  }
  // #enddocregion update

  // #docregion delete
  Future<void> delete(int id) async {
    try {
      final url = '$_heroesUrl/$id';
      await _http.delete(url, headers: _headers);
    } catch (e) {
      throw _handleError(e);
    }
  }
  // #enddocregion delete

}
