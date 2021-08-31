// ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓
//
// COOKIE
//
// <#Author = Robert Mollentze>
// <#Date = 8/31/2021>
//
// Cookie Attributes:
// - 'Domain': What domain may access the cookie such as: 'roowarded.com'
// - 'P': What path under the domain may access the cookie, default '/'
//- 'Expires': Exact day/time the cookie will expire
// - 'Max-Age': How long the cookie is valid for
// - 'Secure': Only HTTPS access (Note: Does not take a value)
// - 'Http-Only': Only HTTP access (Note: Does not take a value)
//
// References:
//
// - Cookie Attributes:
//     https://wanago.io/2018/06/18/cookies-explaining-document-cookie-and-the-set-cookie-header/
//
// - How Cookies Work:
//     https://thoughtbot.com/blog/lucky-cookies
//
// - Option 1:
//     https://api.dart.dev/stable/2.10.5/dart-io/Cookie-class.html
//
// - Option 2:
//     https://api.dart.dev/stable/2.10.5/dart-html/CookieStore-class.html
//
// - Option 3:
//     https://api.dart.dev/stable/2.10.4/dart-html/Document/cookie.html
//
// - Checking if Cookies are Enabled:
//     https://api.dart.dev/stable/2.10.4/dart-html/Navigator/cookieEnabled.html
//
// - Wikipedia:
//     https://en.wikipedia.org/wiki/HTTP_cookie
//
// ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓

library easy_web;

import 'dart:html';

import 'package:prep/prep.dart' show PrepLog;

// ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░

const _LOG = PrepLog.file("<#f=cookie.dart>");

// ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░

bool _areCookiesWorking() => window.navigator.cookieEnabled != null;

// ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░

/// Returns value of cookie `name` or an empty string if match is not found or
/// an error occurs.
///
/// Note: Does not throw exceptions.
String getCookie(final String name) {
  try {
    final _doc = document.cookie;
    if (_doc != null) {
      final List<String> _cookies = _doc.isNotEmpty ? _doc.split(",") : [];
      if (_cookies.isNotEmpty) {
        for (final cookie in _cookies) {
          final List<String> _attributes =
              cookie.isNotEmpty ? cookie.split(";") : [];
          if (_attributes.isNotEmpty) {
            for (final attribute in _attributes) {
              final _keyValue = attribute.split("=");
              String key, value;
              if (_keyValue.length == 2) {
                key = _keyValue[0].trim();
                value = _keyValue[1].trim();
              } else if (_keyValue.length == 1) {
                key = _keyValue[0].trim();
                value = "";
              } else {
                throw 1;
              }
              if (name == key) {
                return value;
              }
            }
            throw 0;
          } else {
            throw 1;
          }
        }
      } else {
        throw 2;
      }
    } else {
      throw 3;
    }
    throw -1;
  } catch (e) {
    switch (e) {
      case 0:
        _LOG.alert("Cookie not found.", "<#l=102>");
        break;
      case 1:
        _LOG.alert("Cookies might be corrupt.", "<#l=105>");
        break;
      case 2:
        _LOG.alert("Cookies are empty.", "<#l=108>");
        break;
      case 3:
        _LOG.alert("Cookie denied.", "<#l=111>");
        break;
      default:
        _LOG.error("Failed to get cookie: $e", "<#l=114>");
        break;
    }
  }
  return "";
}

// ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░

/// Sets a secure cookie with an age of of 10 years and returns true or false
/// on success or failure.
///
/// Note: Does not throw exceptions.
bool setCookie(
  final String name,
  final String value, [
  final int expireInSeconds = 10 * 365 * 24 * 60 * 60,
]) {
  try {
    if (!_areCookiesWorking()) throw "Cookies not working.";
    document.cookie =
        "$name=$value; Max-Age=${expireInSeconds.toString()}; Domain=; P=/";
    if (getCookie(name) == "") throw "Validation failed.";
    return true;
  } catch (e) {
    _LOG.error("Failed to set cookie: $e", "<#l=139>");
    return false;
  }
}

// ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░

/// Returns value of cookie of `name` or creates new cookie with `name` and
/// `value` if nonexistent. Returns the value of the cookie on success or an
/// empty string if an error occurs.
///
/// Note: does not throw exceptions.
String flexGetCookie(
  final String name,
  final String value, [
  final int expireInSeconds = 10 * 365 * 24 * 60 * 60,
]) {
  final _value = getCookie(name);
  if (_value == "") {
    _LOG.info("Creating cookie...", "<#l=158>");
    if (!setCookie(name, value, expireInSeconds)) {
      return "";
    } else {
      return value;
    }
  } else {
    return _value;
  }
}

// ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░

/// - Deletes a cookie.
/// - Returns true or false on success or failure.
/// - All errors are logged.
/// - Will not throw exceptions.
bool deleteCookie(final String name) {
  try {
    if (!_areCookiesWorking()) throw "Cookies not working.";
    document.cookie = "$name=; Max-Age=; Domain=; P=/";
    if (getCookie(name) != "") throw "Validation failed.";
    return true;
  } catch (e) {
    _LOG.error("Failed to delete cookie: $e", "<#l=182>");
    return false;
  }
}

// ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░

bool isEnabledCookies() => window.navigator.cookieEnabled == true;