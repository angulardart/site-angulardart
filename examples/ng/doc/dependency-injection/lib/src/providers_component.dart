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
  template: '{{logger}}',
  // #docregion ClassProvider
  providers: [
    const ClassProvider(Logger),
  ],
  // #enddocregion ClassProvider
)
class ClassProviderComponent extends _Base {
  ClassProviderComponent(Logger logger) : super(logger);
}

@Injectable()
class BetterLogger extends Logger {}

@Component(
  selector: 'use-class',
  template: '{{logger}}',
  providers: [
    // #docregion ClassProvider-useClass
    const ClassProvider(Logger, useClass: BetterLogger),
    // #enddocregion ClassProvider-useClass
  ],
)
class ClassProviderUseClassComponent extends _Base {
  ClassProviderUseClassComponent(Logger logger) : super(logger);
}

// #docregion EvenBetterLogger
@Injectable()
class EvenBetterLogger extends Logger {
  final UserService _userService;

  EvenBetterLogger(this._userService);

  String toString() => super.toString() + ' (user:${_userService.user.name})';
}
// #enddocregion EvenBetterLogger

@Component(
  selector: 'use-class-deps',
  template: '{{logger}}',
  providers: [
    // #docregion logger-with-dependencies
    const ClassProvider(UserService),
    const ClassProvider(Logger, useClass: EvenBetterLogger),
    // #enddocregion logger-with-dependencies
  ],
)
class ServiceWithDepsComponent extends _Base {
  ServiceWithDepsComponent(Logger logger) : super(logger);
}

@Injectable()
class NewLogger extends Logger implements OldLogger {}

class OldLogger extends Logger {
  OldLogger() {
    throw new Exception("Don't call the Old Logger!");
  }
}

@Component(
  selector: 'two-new-loggers',
  template: '{{logger}}',
  providers: [
    // #docregion two-NewLoggers
    const ClassProvider(NewLogger),
    const ClassProvider(OldLogger, useClass: NewLogger),
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
  template: '{{logger}}',
  providers: [
    // #docregion ExistingProvider
    const ClassProvider(NewLogger),
    const ExistingProvider(OldLogger, NewLogger),
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
  @override
  void fine(String msg) {}
  @override
  String toString() => '';
}
// #enddocregion const-class

// #docregion const-object
const silentLogger = const SilentLogger();
// #enddocregion const-object, silent-logger

@Component(
  selector: 'value-provider',
  template: '{{logger}}',
  providers: [
    // #docregion ValueProvider
    const ValueProvider(Logger, silentLogger),
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
  template: '{{logger}}',
  providers: [
    heroServiceProvider,
    const ClassProvider(Logger),
    const ClassProvider(UserService),
  ],
)
class FactoryProviderComponent extends _Base {
  FactoryProviderComponent(Logger o, HeroService heroService) : super(o) {
    log('Got ${heroService.getAll().length} heroes');
  }
}

@Component(
  selector: 'value-provider-for-token',
  template: '{{log}}',
  providers: [
    // #docregion ValueProvider-forToken
    const ValueProvider.forToken(appTitleToken, appTitle)
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
  template: '{{log}}',
  providers: [
    // #docregion ValueProvider-map-forToken
    const ValueProvider.forToken(appConfigMapToken, appConfigMap)
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
    const ValueProvider(Logger, null),
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

    <class-provider></class-provider>
    <use-class></use-class>
    <use-class-deps></use-class-deps>
    <two-new-loggers></two-new-loggers>
    <existing-provider></existing-provider>
    <value-provider></value-provider>
    <factory-provider></factory-provider>
    <value-provider-for-token></value-provider-for-token>
    <value-provider-for-map></value-provider-for-map>
    <optional-injection></optional-injection>
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
