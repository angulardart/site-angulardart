import 'package:angular/angular.dart';

import 'app_config.dart';
import 'heroes/hero_service_provider.dart';
import 'heroes/hero_service.dart';
import 'logger_service.dart';
import 'user_service.dart';

abstract class _Base {
  final Logger logger;
  _Base([this.logger]);

  void log(String msg) => logger?.fine(msg);
}

@Component(
  selector: 'class-provider',
  template: 'ClassProvider: {{logger}}',
  // #docregion ClassProvider
  providers: [
    ClassProvider(Logger),
  ],
  // #enddocregion ClassProvider
)
class ClassProviderComponent extends _Base {
  ClassProviderComponent(Logger logger) : super(logger);
}

class BetterLogger extends Logger {
  String get id => 'BetterLogger';
}

@Component(
  selector: 'use-class',
  template: 'ClassProvider, useClass: {{logger}}',
  providers: [
    // #docregion ClassProvider-useClass
    ClassProvider(Logger, useClass: BetterLogger),
    // #enddocregion ClassProvider-useClass
  ],
)
class ClassProviderUseClassComponent extends _Base {
  ClassProviderUseClassComponent(Logger logger) : super(logger);
}

// #docregion EvenBetterLogger
class EvenBetterLogger extends Logger {
  final UserService _userService;

  EvenBetterLogger(this._userService);

  String get id => 'EvenBetterLogger';
  String toString() => super.toString() + ' (user:${_userService.user.name})';
}
// #enddocregion EvenBetterLogger

@Component(
  selector: 'use-class-deps',
  template: 'ClassProvider, useClass: {{logger}}',
  providers: [
    // #docregion logger-with-dependencies
    ClassProvider(UserService),
    ClassProvider(Logger, useClass: EvenBetterLogger),
    // #enddocregion logger-with-dependencies
  ],
)
class ServiceWithDepsComponent extends _Base {
  ServiceWithDepsComponent(Logger logger) : super(logger);
}

class NewLogger extends Logger implements OldLogger {
  String get id => 'NewLogger';
}

class OldLogger extends Logger {
  OldLogger() {
    throw Exception("Don't call the Old Logger!");
  }
  String get id => 'OldLogger';
}

@Component(
  selector: 'two-new-loggers',
  template: 'Two new loggers: {{logger}}',
  providers: [
    // #docregion two-NewLoggers
    ClassProvider(NewLogger),
    ClassProvider(OldLogger, useClass: NewLogger),
    // #enddocregion two-NewLoggers
  ],
)
class TwoNewLoggersComponent extends _Base {
  TwoNewLoggersComponent(NewLogger logger, OldLogger o) : super(logger) {
    log('The newLogger and oldLogger are identical: ${identical(logger, o)}');
  }
}

@Component(
  selector: 'existing-provider',
  template: 'ExistingProvider: {{logger}}',
  providers: [
    // #docregion ExistingProvider
    ClassProvider(NewLogger),
    ExistingProvider(OldLogger, NewLogger),
    // #enddocregion ExistingProvider
  ],
)
class ExistingProviderComponent extends _Base {
  ExistingProviderComponent(NewLogger logger, OldLogger o) : super(o) {
    log('The newLogger and oldLogger are identical: ${identical(logger, o)}');
  }
}

// #docregion const-class, silent-logger
class SilentLogger implements Logger {
  const SilentLogger();
  String get id => 'SilentLogger';
  @override
  void fine(String msg) {}
  @override
  String toString() => '';
}
// #enddocregion const-class

// #docregion const-object
const silentLogger = SilentLogger();
// #enddocregion const-object, silent-logger

@Component(
  selector: 'value-provider',
  template: 'ValueProvider: {{logger}}',
  providers: [
    // #docregion ValueProvider
    ValueProvider(Logger, silentLogger),
    // #enddocregion ValueProvider
  ],
)
class ValueProviderComponent extends _Base {
  ValueProviderComponent(Logger logger) : super(logger) {
    log('Hello?');
  }
}

@Component(
  selector: 'factory-provider',
  template: 'FactoryProvider: {{logger}}',
  providers: [
    heroServiceProvider,
    ClassProvider(Logger),
    ClassProvider(UserService),
  ],
)
class FactoryProviderComponent extends _Base {
  FactoryProviderComponent(Logger o, HeroService heroService) : super(o) {
    log('Got ${heroService.getAll().length} heroes');
  }
}

@Component(
  selector: 'value-provider-for-token',
  template: 'ValueProvider.forToken: {{log}}',
  providers: [
    // #docregion ValueProvider-forToken
    ValueProvider.forToken(appTitleToken, appTitle)
    // #enddocregion ValueProvider-forToken
  ],
)
class ValueProviderForTokenComponent {
  String log;

  ValueProviderForTokenComponent(@Inject(appTitleToken) title)
      : log = 'App config map title is $title';
}

@Component(
  selector: 'value-provider-for-map',
  template: 'ValueProvider.forToken, map: {{log}}',
  providers: [
    // #docregion ValueProvider-map-forToken
    ValueProvider.forToken(appConfigMapToken, appConfigMap)
    // #enddocregion ValueProvider-map-forToken
  ],
)
class ValueProviderForMapComponent {
  String log;

  ValueProviderForMapComponent(@Inject(appConfigMapToken) Map config) {
    final title = config == null ? 'null config' : config['title'];
    log = 'App config map title is $title';
  }
}

@Component(
  selector: 'optional-injection',
  template: '{{message}}',
  providers: [
    ValueProvider(Logger, null),
  ],
)
class HeroService1 extends _Base {
  String message;
  // #docregion Optional
  HeroService1(@Optional() Logger logger) : super(logger) {
    logger?.fine('Hello');
    // #enddocregion Optional
    message = 'Optional logger is $logger';
    // #docregion Optional
  }
  // #enddocregion Optional
}

@Component(
  selector: 'my-providers',
  template: '''
    <h2>Provider variations</h2>

    <ul>
      <li><class-provider></class-provider></li>
      <li><use-class></use-class></li>
      <li><use-class-deps></use-class-deps></li>
      <li><two-new-loggers></two-new-loggers></li>
      <li><existing-provider></existing-provider></li>
      <li><value-provider></value-provider></li>
      <li><factory-provider></factory-provider></li>
      <li><value-provider-for-token></value-provider-for-token></li>
      <li><value-provider-for-map></value-provider-for-map></li>
      <li><optional-injection></optional-injection></li>
    </ul>
  ''',
  directives: [
    ClassProviderComponent,
    ClassProviderUseClassComponent,
    ServiceWithDepsComponent,
    TwoNewLoggersComponent,
    ExistingProviderComponent,
    ValueProviderComponent,
    FactoryProviderComponent,
    ValueProviderForTokenComponent,
    ValueProviderForMapComponent,
    HeroService1
  ],
)
class ProvidersComponent {}
