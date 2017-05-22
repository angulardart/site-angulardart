// NOTE: Not currently used. Awaiting support for auxiliary routes.
// #docregion
import 'dart:async';

import 'package:angular2/angular2.dart';
import 'package:angular2/router.dart';
// import 'animations.dart' show slideInDownAnimation;

@Component(
  selector: 'crisis-center',
  templateUrl: 'compose_message_component.html',
  styles: const [':host { position: relative; bottom: 10%; }'],
  // animations: const [slideInDownAnimation]
  directives: const [COMMON_DIRECTIVES],
)
class ComposeMessageComponent {
  Router _router;

  //  @HostBinding('@routeAnimation') var routeAnimation = true;
  //  @HostBinding('style.display') var display = 'block';
  //  @HostBinding('style.position') var position = 'absolute';

  String details;
  bool sending = false;

  ComposeMessageComponent(this._router);

  Future<Null> send() async {
    sending = true;
    details = 'Sending Message...';
    await new Future.delayed(const Duration(seconds: 2));
    sending = false;
    closePopup();
  }

  void cancel() => closePopup();

  // #docregion closePopup
  void closePopup() {
    _router.navigate([
      {
        'outlets': {'popup': null}
      }
    ]);
  }
}
