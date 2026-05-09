import 'dart:async';

// Web-only stubs for the small slice of dart:io APIs this app references.
// These exist so the Flutter web build can compile; they are not meant to be
// called at runtime because file I/O is unsupported in browsers.

class HttpStatus {
  static const int ok = 200;
}

class HttpException implements Exception {
  HttpException(this.message, {this.uri});

  final String message;
  final Uri? uri;

  @override
  String toString() {
    final uriPart = uri == null ? '' : ', uri = $uri';
    return 'HttpException: $message$uriPart';
  }
}

class IOSink {
  void add(List<int> data) {
    _unsupported();
  }

  Future<void> flush() => Future.error(_unsupported());

  Future<void> close() => Future.error(_unsupported());
}

class Directory {
  Directory(this.path);

  final String path;

  Directory get parent => Directory(path);

  Future<Directory> create({bool recursive = false}) =>
      Future.error(_unsupported());
}

class File {
  File(this.path);

  final String path;

  Directory get parent => Directory(path);

  Future<bool> exists() => Future.error(_unsupported());

  IOSink openWrite() => IOSink();

  Future<File> delete() => Future.error(_unsupported());
}

class Cookie {
  Cookie(this.name, this.value);

  final String name;
  final String value;

  static Cookie fromSetCookieValue(String value) {
    final firstSegment = value.split(';').first;
    final separatorIndex = firstSegment.indexOf('=');
    if (separatorIndex == -1) {
      throw const FormatException('Invalid Set-Cookie header');
    }
    final name = firstSegment.substring(0, separatorIndex).trim();
    final cookieValue = firstSegment.substring(separatorIndex + 1).trim();
    return Cookie(name, cookieValue);
  }
}

UnsupportedError _unsupported() =>
    UnsupportedError('dart:io is not available on web builds.');
