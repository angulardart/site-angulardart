// #docplaster
// #docregion v1
import 'package:angular/angular.dart';
// #enddocregion v1
/*
// #docregion v1
import 'package:http/browser_client.dart';
// #enddocregion v1
*/
// #docregion v1
import 'package:http/http.dart';
import 'package:server_communication/app_component.dart';

import 'main.template.dart' as ng;
// #enddocregion v1
import 'package:server_communication/in_memory_data_service.dart';

void main() {
  bootstrapStatic(
      AppComponent,
      [
        // in-memory web api provider
        const ClassProvider(Client, useClass: InMemoryDataService),
      ],
      ng.initReflector);
}
/*
// #docregion v1

void main() {
  bootstrapStatic(AppComponent, [
    const FactoryProvider(Client, () => new BrowserClient()),
  ],
  ng.initReflector);
}
// #enddocregion v1
*/

