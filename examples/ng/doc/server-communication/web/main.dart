import 'package:angular/angular.dart';
import 'package:http/http.dart';
import 'package:server_communication/app_component.template.dart' as ng;
import 'package:server_communication/in_memory_data_service.dart';

import 'main.template.dart' as self;

@GenerateInjector([
  const ClassProvider(Client, useClass: InMemoryDataService),
  // Using a real back end?
  // Import 'package:http/browser_client.dart' and change the above to:
  //   const ClassProvider(Client, useClass: BrowserClient),
])
final InjectorFactory injector = self.injector$Injector;

void main() {
  runApp(ng.AppComponentNgFactory, createInjector: injector);
}
