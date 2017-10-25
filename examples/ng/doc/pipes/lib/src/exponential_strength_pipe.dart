import 'dart:math' as math;
import 'package:angular/angular.dart';

/*
 * Raise the value exponentially
 * Takes an exponent argument that defaults to 1.
 * Usage:
 *   value | exponentialStrength:exponent
 * Example:
 *   {{ 2 |  exponentialStrength:10}}
 *   formats to: 1024
 */
@Pipe('exponentialStrength')
class ExponentialStrengthPipe extends PipeTransform {
  num transform(num value, num exponent) => math.pow(value ?? 0, exponent ?? 1);
}
