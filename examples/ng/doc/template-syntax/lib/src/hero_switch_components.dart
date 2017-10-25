import 'package:angular/angular.dart';
import 'hero.dart';

@Component(
  selector: 'happy-hero',
  template: 'Wow. You like {{hero.name}}. What a happy hero ... just like you.',
)
class HappyHeroComponent {
  @Input()
  Hero hero;
}

@Component(
  selector: 'sad-hero',
  template: 'You like {{hero.name}}? Such a sad hero. Are you sad too?',
)
class SadHeroComponent {
  @Input()
  Hero hero;
}

@Component(
  selector: 'confused-hero',
  template: 'Are you as confused as {{hero.name}}?',
)
class ConfusedHeroComponent {
  @Input()
  Hero hero;
}

@Component(
  selector: 'unknown-hero',
  template: '{{message}}',
)
class UnknownHeroComponent {
  @Input()
  Hero hero;

  String get message => hero != null && hero.name.isNotEmpty
      ? '${hero.name} is strange and mysterious.'
      : 'Are you feeling indecisive?';
}

const List heroSwitchComponents = const [
  HappyHeroComponent,
  SadHeroComponent,
  ConfusedHeroComponent,
  UnknownHeroComponent
];
