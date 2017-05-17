// #docregion
import 'dart:async';

import 'package:angular2/angular2.dart';

@Component(
    selector: 'my-app',
    template: '''
      <h1>Demo: NgZone</h1>
      <p>
        Progress: {{progress}}%<br>
        <span *ngIf="progress >= 100">Done processing {{label}} of Angular zone!</span>
        &nbsp;
      </p>
      <button (click)="processWithinAngularZone()">Process within Angular zone</button>
      <button (click)="processOutsideOfAngularZone()">Process outside of Angular zone</button>
    ''')
class AppComponent {
  int progress = 0;
  String label;
  final NgZone _ngZone;

  AppComponent(this._ngZone);

  // Loop inside the Angular zone
  // so the UI DOES refresh after each setTimeout cycle
  void processWithinAngularZone() {
    label = 'inside';
    progress = 0;
    _increaseProgress(() => print('Inside Done!'));
  }

  // Loop outside of the Angular zone
  // so the UI DOES NOT refresh after each setTimeout cycle
  void processOutsideOfAngularZone() {
    label = 'outside';
    progress = 0;
    _ngZone.runOutsideAngular(() {
      _increaseProgress(() {
        // reenter the Angular zone and display done
        _ngZone.run(() => print('Outside Done!'));
      });
    });
  }

  void _increaseProgress(void doneCallback()) {
    progress += 1;
    print('Current progress: $progress%');
    if (progress < 100) {
      new Future<Null>.delayed(const Duration(milliseconds: 10),
          () => _increaseProgress(doneCallback));
    } else {
      doneCallback();
    }
  }
}
