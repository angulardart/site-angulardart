import 'dart:convert';
import 'dart:html';

import 'package:angular/angular.dart';

// #docregion pipe-metadata
@Pipe('fetch', pure: false)
// #enddocregion pipe-metadata
class FetchJsonPipe extends PipeTransform {
  dynamic _cachedData;
  String _cachedUrl;

  dynamic transform(String url) {
    if (url != _cachedUrl) {
      _cachedUrl = url;
      _cachedData = null;
      HttpRequest.getString(url).then((s) {
        _cachedData = json.decode(s);
      });
    }
    return _cachedData;
  }
}
