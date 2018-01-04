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
// #enddocregion v1
import 'package:server_communication/in_memory_data_service.dart';

void main() {
 bootstrap(AppComponent, [
   // in-memory web api provider
   provide(Client, useClass: InMemoryDataService)
 ]);
}
/*
// #docregion v1

void main() {
  bootstrap(AppComponent, [
    provide(Client, useFactory: () => new BrowserClient(), deps: [])
  ]);
}
// #enddocregion v1
*/

