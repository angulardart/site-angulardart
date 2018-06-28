// Copyright (c) 2012, the Dart project authors.
// Please see the AUTHORS file for details.
// All rights reserved. Use of this source code
// is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:async';
import 'dart:html';
import 'dart:convert';

UListElement wordList = querySelector('#wordList');

void main() {
  querySelector('#getWords').onClick.listen(makeRequest);
}

// #docregion makeRequest
Future<void> makeRequest(/*Event*/ dynamic _) async {
  // FIXME(https://github.com/dart-lang/sdk/issues/33627): type argument
  const path = 'https://www.dartlang.org/f/portmanteaux.json';
  final httpRequest = HttpRequest();
  httpRequest
    ..open('GET', path)
    ..onLoadEnd.listen((e) => requestComplete(httpRequest))
    ..send('');
}
// #enddocregion makeRequest

// #docregion requestComplete
void requestComplete(HttpRequest request) {
  switch (request.status) {
    case 200:
      processResponse(request.responseText);
      return;
    default:
      final li = LIElement()..text = 'Request failed, status=${request.status}';
      wordList.children.add(li);
  }
}
// #enddocregion requestComplete

// #docregion processResponse
void processResponse(String jsonString) {
  for (final portmanteau in json.decode(jsonString)) {
    wordList.children.add(LIElement()..text = portmanteau);
  }
}
