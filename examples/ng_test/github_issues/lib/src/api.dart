import 'dart:async';

/// A simple Dart interface for accessing the GitHub APIs.
abstract class GithubService {
  /// Returns all [GithubIssue]s for `https://github.com/dart-lang/angular2`.
  Stream<GithubIssue> getIssues();
}

/// A typed API over the JSON blob from Github representing an issue.
///
/// See: https://developer.github.com/v3/issues/.
class GithubIssue {
  /// ID of the issue.
  final int id;

  /// URL of the issue.
  final Uri url;

  /// Title of the issue.
  final String title;

  /// Author of the issue.
  final String author;

  /// Description of the issue.
  final String description;

  const GithubIssue({
    this.id,
    this.url,
    this.title,
    this.author,
    this.description,
  });

  factory GithubIssue.parse(Map<String, dynamic> json) {
    return new GithubIssue(
      id: json['id'],
      url: Uri.parse(json['html_url']),
      title: json['title'],
      author: json['user']['login'],
      description: json['body'],
    );
  }
}
