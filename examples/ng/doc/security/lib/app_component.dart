import 'package:angular/angular.dart';

import 'src/bypass_security_component.dart';
import 'src/inner_html_binding_component.dart';

@Component(
  selector: 'my-app',
  template: '''
    <h1>Security</h1>
    <inner-html-binding></inner-html-binding>
    <bypass-security></bypass-security>
  ''',
  directives: [
    BypassSecurityComponent,
    InnerHtmlBindingComponent,
  ],
)
class AppComponent {}
