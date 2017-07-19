// #docregion
import 'dart:async';
import 'dart:math';
import 'package:angular2/angular2.dart';

const _minSize = 8;
const _maxSize = _minSize * 5;

@Component(
  selector: 'my-sizer',
  template: '''
    <div>
      <button (click)="dec()" [disabled]="size <= minSize">-</button>
      <button (click)="inc()" [disabled]="size >= maxSize">+</button>
      <label [style.font-size.px]="size">FontSize: {{size}}px</label>
    </div>''',
)
class SizerComponent {
  // TODO: under Angular 4 we will be able to just export the const
  final int minSize = _minSize, maxSize = _maxSize;

  int _size = _minSize * 2;
  int get size => _size;
  @Input()
  void set size(/*int | String */ val) {
    int z = val is int ? val : int.parse(val, onError: (_) => null);
    if (z != null) _size = min(maxSize, max(minSize, z));
  }

  final _sizeChange = new StreamController<int>();
  @Output()
  Stream<int> get sizeChange => _sizeChange.stream;

  void dec() => resize(-1);
  void inc() => resize(1);

  void resize(int delta) {
    size = size + delta;
    _sizeChange.add(size);
  }
}
