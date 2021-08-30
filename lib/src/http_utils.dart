// ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓
//
// HTTP UTILS
//
// <#Author=>
// <#Date = 8/30/2021>
//
// ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓

library easy_web;

import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:prep/prep.dart' show PrepLog;

const _LOG = PrepLog.file("<#f=http_utils.dart>");

// ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░

Future<String?> getBody(
  final Uri uri, [
  final Duration timeout = const Duration(seconds: 5),
]) async {
  try {
    final _response = await http
        .get(uri)
        .timeout(timeout, onTimeout: () => http.Response.bytes([], 408));
    if (_response.statusCode == 200) {
      return _response.body.trim();
    } else {
      throw "Status code: ${_response.statusCode}.";
    }
  } catch (e) {
    // Would most likely be due to no/poor internet connection.
    _LOG.error("Failed to read body: $e", "<#l=36>");
    return null;
  }
}

// ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░

Future<Map<String, String>?> getBodyFields(final Uri uri) async {
  try {
    final _response = await http.get(uri);
    if (_response.statusCode == 200) {
      return jsonDecode(_response.body.trim()) as Map<String, String>?;
    } else {
      throw "Status code: ${_response.statusCode}.";
    }
  } catch (e) {
    // Would most likely be due to:
    // - No/poor internet connection.
    // - jsonDecode failed.
    _LOG.error("Failed to read body: $e", "<#l=55>");
    return null;
  }
}

// ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░

Future<String?> getBodyField(final String field, final Uri uri) {
  return getBodyFields(uri).then((__fields) {
    if (__fields != null) {
      if (__fields.containsKey(field)) {
        return __fields[field];
      }
      _LOG.error("Nonexistent field", "<#l=68>");
    }
    return null;
  });
}