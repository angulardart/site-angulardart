import 'package:angular2/di.dart';

import 'src/api.dart';
import 'src/api_impl.dart';

export 'src/api.dart' show GithubService, GithubIssue;

/// DI providerse for using the [GithubService] API.
const apiProviders = const [
  const Provider(GithubService, useClass: HtmlGithubService),
];
