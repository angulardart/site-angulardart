import 'package:angular/di.dart';

import 'src/api.dart';
import 'src/api_impl.dart';

export 'src/api.dart' show GithubService, GithubIssue;

/// DI providers for using the [GithubService] API.
const apiProviders = const [
  const Provider<GithubService>(GithubService, useClass: HtmlGithubService),
];
