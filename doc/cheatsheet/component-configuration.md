@cheatsheetSection
Component configuration
@cheatsheetIndex 6
@description
`@Component` extends `@Directive`,
so the `@Directive` configuration applies to components as well

@cheatsheetItem
syntax:
`viewProviders: const [MyService, const Provider(...)]`|`viewProviders:`
description:
List of dependency injection providers scoped to this component's view.

See: [viewProviders property](/angular/api/angular2.core/Component/viewProviders)


@cheatsheetItem
syntax:
`template: 'Hello {{name}}'
templateUrl: 'my-component.html'`|`template:`|`templateUrl:`
description:
Inline template or external template URL of the component's view.

See: [Architecture Overview](/angular/guide/architecture)


@cheatsheetItem
syntax:
`styles: const ['.primary {color: red}']
styleUrls: const ['my-component.css']`|`styles:`|`styleUrls:`
description:
List of inline CSS styles or external stylesheet URLs for styling the component’s view.

See: [Component Styles](/angular/guide/component-styles)


@cheatsheetItem
syntax:
`directives: const [COMMON_DIRECTIVES, MyDirective, MyComponent]`|`directives:`
description:
List of directives used in the component's template.

See: [Architecture Overview](/angular/guide/architecture), [CORE_DIRECTIVES](/angular/api/angular2.common/CORE_DIRECTIVES-constant), [COMMON_DIRECTIVES](/angular/api/angular2.common/COMMON_DIRECTIVES-constant)


@cheatsheetItem
syntax:
`pipes: const [COMMON_PIPES, MyPipe, ...]`|`pipes:`
description:
List of pipes used in the component's template.

See: [Pipes](/angular/guide/pipes), [COMMON_PIPES](/angular/api/angular2.common/COMMON_PIPES-constant)
