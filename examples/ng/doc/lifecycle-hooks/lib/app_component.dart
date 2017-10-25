import 'package:angular/angular.dart';

import 'src/after_content_component.dart';
import 'src/after_view_component.dart';
import 'src/counter_component.dart';
import 'src/do_check_component.dart';
import 'src/on_changes_component.dart';
import 'src/peek_a_boo_parent_component.dart';
import 'src/spy_component.dart';

@Component(
    selector: 'my-app',
    templateUrl: 'app_component.html',
    directives: const [
      AfterContentParentComponent,
      AfterViewParentComponent,
      CounterParentComponent,
      DoCheckParentComponent,
      OnChangesParentComponent,
      PeekABooParentComponent,
      SpyParentComponent,
    ])
class AppComponent {}
