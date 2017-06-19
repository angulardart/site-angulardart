// #docplaster
// #docregion v1, final
import 'package:angular2/angular2.dart';
import 'package:angular2/platform/browser.dart';

import 'package:server_communication/app_component.dart';
// #enddocregion v1
// #docregion in-mem-web-api-imports
import 'package:server_communication/in_memory_data_service.dart';
import 'package:http/http.dart';

// #enddocregion in-mem-web-api-imports
// #docregion in-mem-web-api-providers
void main() {
  bootstrap(AppComponent, [
    // in-memory web api provider
    provide(Client, useClass: InMemoryDataService)
  ]);
}
// #enddocregion final, in-mem-web-api-providers
/*
// #docregion v1

void main() {
  bootstrap(AppComponent, [
    provide(BrowserClient, useFactory: () => new BrowserClient(), deps: [])
  ]);
}
// #enddocregion v1
*/
