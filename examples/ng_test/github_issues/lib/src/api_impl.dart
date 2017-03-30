import 'dart:async';
import 'dart:convert';
import 'dart:html';

import 'package:angular2/di.dart';

import 'api.dart';

/// An implementation of [GithubService] using `dart:html`.
@Injectable()
class HtmlGithubService implements GithubService {
  static const String _apiEndpoint = 'https://api.github.com';
  static const String _repoEndpoint = '$_apiEndpoint/repos/dart-lang/angular2';
  static const String _allIssuesEndpoint = '$_repoEndpoint/issues?filter=all';

  @override
  Stream<GithubIssue> getIssues() async* {
    final payload = await HttpRequest.getString(_allIssuesEndpoint);
    final json = JSON.decode(payload) as List<Map<String, dynamic>>;
    for (final issue in json) {
      yield new GithubIssue.parse(issue);
    }
  }
}
