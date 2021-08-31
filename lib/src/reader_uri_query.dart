// ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓
//
// READER URI QUERY
//
// <#Author = Robert Mollentze>
// <#Date = 8/31/2021>
//
// References:
// - https://en.wikipedia.org/wiki/Uniform_Resource_Identifier
//
// ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓

library easy_web;

// ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░

class ReaderUriQuery {
  //
  //
  //

  static final ReaderUriQuery _instance = ReaderUriQuery._();
  static ReaderUriQuery get instance => _instance;
  factory ReaderUriQuery() => ReaderUriQuery._instance;
  ReaderUriQuery._() : this._queries = Uri.base.queryParameters;

  //
  //
  //

  final Map<String, String> _queries;

  //
  //
  //

  Map<String, String> get queries => Map.of(_queries);
  String? argAsString(final String param) => this._queries[param];

  //
  //
  //

  bool? argAsBool(final String param) {
    final _arg = this._queries[param]?.trim().toLowerCase();
    return _arg == null ? null : _arg == "true";
  }

  //
  //
  //

  num? argAsNum(final String param) {
    final _arg = this._queries[param]?.trim();
    return _arg == null ? null : num.tryParse(_arg);
  }
}