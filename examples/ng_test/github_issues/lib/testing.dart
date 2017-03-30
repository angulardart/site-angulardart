import 'dart:async';

import 'package:mockito/mockito_no_mirrors.dart';
import 'package:pageloader/objects.dart';

import 'api.dart';

class MockGithubService extends Mock implements GithubService {}

@EnsureTag('issue-list')
class IssueListPO {
  @ByTagName('bs-progress')
  @optional
  Lazy<PageLoaderElement> _progressBar;

  @ByCss('.github-issue')
  Lazy<List<IssueItemPO>> _items;

  @ByCss('.expansion')
  @optional
  Lazy<PageLoaderElement> _expansion;

  /// Whether the progress bar is visible.
  Future<bool> get isLoading async => (await _progressBar()) != null;

  /// Items in the table.
  Future<List<IssueItemPO>> get items => _items();

  /// Visible description.
  Future<String> get description async => (await _expansion()).visibleText;
}

class IssueItemPO {
  @ByTagName('bs-toggle-button')
  PageLoaderElement _toggleButton;

  @ByCss('.author')
  PageLoaderElement _author;

  @ByCss('.title')
  PageLoaderElement _title;

  /// Author.
  Future<String> get author => _author.visibleText;

  /// Title
  Future<String> get title => _title.visibleText;

  /// Whether the button is toggled.
  Future<bool> get isToggled async =>
      (await _toggleButton.visibleText) == 'Hide';

  /// Toggle the button.
  Future<Null> toggle() => _toggleButton.click();
}
