// Copyright (c) 2016, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:angular/angular.dart';

@Component(
  selector: 'stats-component',
  styleUrls: ['stats.css'],
  templateUrl: 'stats.html',
  directives: [NgFor, NgIf],
)
class StatsComponent {
  @Input()
  Map<int, int> winningsMap;
}
