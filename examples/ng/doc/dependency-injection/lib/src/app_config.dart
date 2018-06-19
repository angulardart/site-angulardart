// #docregion appTitleToken
import 'package:angular/angular.dart';

const appTitleToken = const OpaqueToken<String>('app.title');
// #enddocregion appTitleToken

// #docregion appTitle
const appTitle = 'Dependency Injection';
// #enddocregion appTitle

// #docregion appConfigMap
const appConfigMap = const {
  'apiEndpoint': 'api.heroes.com',
  'title': 'Dependency Injection',
  // ...
};

const appConfigMapToken = const OpaqueToken<Map>('app.config');
// #enddocregion appConfigMap


// #docregion AppConfig
class AppConfig {
  String apiEndpoint;
  String title;
}

AppConfig appConfigFactory() => AppConfig()
  ..apiEndpoint = 'api.heroes.com'
  ..title = 'Dependency Injection';
