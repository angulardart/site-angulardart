// #docregion
import 'dart:math';
import 'package:angular2/core.dart';

@Component(
    selector: 'my-sizer',
    template: '''
      <div>
        <button (click)="dec()" [disabled]="size <= minSize">-</button>
        <button (click)="inc()" [disabled]="size >= maxSize">+</button>
        <label [style.font-size.px]="size">FontSize: {{size}}px</label>
      </div>''')
class SizerComponent {
  final minSize = 8;
  final maxSize = 40;

  int _size = 16;
  int get size => _size;
  @Input()
  void set size(/*int | String */val) {
    int z = val is int ? val : int.parse(val, onError: (_) => null);
    if (z != null) _size = min(maxSize, max(minSize, z));
  }

  @Output()
  final sizeChange = new EventEmitter<int>();

  void dec() => resize(-1);
  void inc() => resize(1);

  void resize(int delta) {
    size = size + delta;
    sizeChange.emit(size);
  }
}
