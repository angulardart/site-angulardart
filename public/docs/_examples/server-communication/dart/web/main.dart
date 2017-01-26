// #docplaster
// #docregion v1, final
import 'package:angular2/core.dart';
import 'package:angular2/platform/browser.dart';
// #docregion http-providers
import 'package:http/browser_client.dart';
// #enddocregion http-providers

import 'package:server_communication/app_component.dart';
// #enddocregion v1
// #docregion in-mem-web-api-imports
import "package:server_communication/hero_data.dart";

// #enddocregion in-mem-web-api-imports
// #docregion in-mem-web-api-providers
void main() {
  bootstrap(AppComponent, const [
    // in-memory web api provider
    const Provider(BrowserClient,
        useFactory: HttpClientBackendServiceFactory, deps: const [])
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
