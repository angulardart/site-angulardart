/**
* Angular.io Live Example Directive (taken from ng1.io docs)
*
* Renders a link to a live/host example of the doc chapter
* app this directive is contained in.
*
* Usage:
*   <live-example [name="..."] [plnkr="..."] [img="..."] [lang="..."] [embedded] [srcText="..."]>text</live-example>
* Example:
*   <p>Run <live-example>Try the live example</live-example></p>.
*   // ~/resources/live-examples/{chapter}/ts/plnkr.html
*
*   <p>Run <live-example name="toh-1">this example</live-example></p>.
*   // ~/resources/live-examples/toh-1/ts/minimal.plnkr.html
*
*   <p>Run <live-example plnkr="minimal"></live-example></p>.
*   // ~/resources/live-examples/{chapter}/ts/minimal.plnkr.html
*
*   <live-example embedded></live-example>
*   // ~/resources/live-examples/{chapter}/ts/eplnkr.html
*
*   <live-example embedded plnkr="minimal"></live-example>
*   // ~/resources/live-examples/{chapter}/ts/minimal.eplnkr.html
*/

class LiveExample extends HTMLElement {
  static get observedAttributes() {return ['name']; }

  constructor() {
    return super(); 
  }

  // Respond to attribute changes.
  attributeChangedCallback(attr, oldValue, newValue) {
    if (attr === 'name') {
      // TODO: implement live-example for Dart
      this.textContent = `Live example placeholder for ${newValue}`;
    }
  }
}

customElements.define('live-example', LiveExample);