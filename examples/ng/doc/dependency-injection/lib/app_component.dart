import 'package:angular/angular.dart';

import 'src/app_config.dart';
import 'src/car/car_component.dart';
import 'src/heroes/heroes_component.dart';
import 'src/logger_service.dart';
import 'src/user_service.dart';
import 'src/injector_component.dart';
import 'src/providers_component.dart';

@Component(
  selector: 'my-app',
  template: '''
    <h1>{{title}}</h1>
    <my-car></my-car>
    <my-injectors></my-injectors>
    <h2>User</h2>
    <p id="user">
      {{userInfo}}
      <button (click)="nextUser()">Next User</button>
    </p>
    <my-heroes id="authorized" *ngIf="isAuthorized"></my-heroes>
    <my-heroes id="unauthorized" *ngIf="!isAuthorized"></my-heroes>
    <my-providers></my-providers>
  ''',
  directives: [
    coreDirectives,
    CarComponent,
    HeroesComponent,
    InjectorComponent,
    ProvidersComponent,
  ],
  // #docregion providers
  providers: [
    ClassProvider(Logger),
    ClassProvider(UserService),
    // #docregion FactoryProvider
    FactoryProvider(AppConfig, appConfigFactory),
    // #enddocregion FactoryProvider
  ],
  // #enddocregion providers
)
class AppComponent {
  final UserService _userService;
  final String title;

  // #docregion AppComponent
  AppComponent(AppConfig config, this._userService) : title = config.title;
  // #enddocregion AppComponent

  bool get isAuthorized {
    return user.isAuthorized;
  }

  void nextUser() {
    _userService.getNewUser();
  }

  User get user {
    return _userService.user;
  }

  String get userInfo =>
      'Current user, ${user.name}, is' +
      (isAuthorized ? '' : ' not') +
      ' authorized. ';
}
