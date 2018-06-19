import 'dart:async';
import 'dart:math';
import 'package:angular/angular.dart';

const minSize = 8;
const maxSize = minSize * 5;

@Component(
  selector: 'my-sizer',
  template: '''
    <div>
      <button (click)="dec()" [disabled]="size <= minSize">-</button>
      <button (click)="inc()" [disabled]="size >= maxSize">+</button>
      <label [style.font-size.px]="size">FontSize: {{size}}px</label>
    </div>''',
  exports: [minSize, maxSize],
)
class SizerComponent {
  int _size = minSize * 2;
  int get size => _size;
  @Input()
  void set size(/*String|int*/ val) {
    int z = val is int ? val : int.tryParse(val);
    if (z != null) _size = min(maxSize, max(minSize, z));
  }

  final _sizeChange = StreamController<int>();
  @Output()
  Stream<int> get sizeChange => _sizeChange.stream;

  void dec() => resize(-1);
  void inc() => resize(1);

  void resize(int delta) {
    size = size + delta;
    _sizeChange.add(size);
  }
}
