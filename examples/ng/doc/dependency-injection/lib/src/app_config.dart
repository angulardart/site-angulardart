// #docregion appTitleToken
import 'package:angular/angular.dart';

const appTitleToken = OpaqueToken<String>('app.title');
// #enddocregion appTitleToken

// #docregion appTitle
const appTitle = 'Dependency Injection';
// #enddocregion appTitle

// #docregion appConfigMap
const appConfigMap = {
  'apiEndpoint': 'api.heroes.com',
  'title': 'Dependency Injection',
  // ...
};

const appConfigMapToken = OpaqueToken<Map>('app.config');
// #enddocregion appConfigMap

// #docregion AppConfig
class AppConfig {
  String apiEndpoint;
  String title;
}

AppConfig appConfigFactory() => AppConfig()
  ..apiEndpoint = 'api.heroes.com'
  ..title = 'Dependency Injection';
