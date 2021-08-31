// ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓
//
// API PUBLIC IP
//
// <#Author = Robert Mollentze>
// <#Date = 8/31/2021>
//
// ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓

library easy_web;

import 'dart:convert';

import 'package:meta/meta.dart';
import 'package:prep/prep.dart' show PrepLog;

import '/src/http_utils.dart';

const _LOG = PrepLog.file("<#f=public_ip.dart>");

// ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░
//
// PUBLIC IPV4
//
// ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░

class MyPublicIpv4 {
  //
  //
  //

  static final MyPublicIpv4 instance = MyPublicIpv4._();
  factory MyPublicIpv4() => instance;
  MyPublicIpv4._();

  //
  //
  //

  Future<String?>? _futureIp;
  String? _ip;

  //
  //
  //

  /// Source: https://ipv4.wtfismyip.com/text
  @protected
  static Future<String?> $fetchA() => //
      getBody(
        Uri.https("ipv4.wtfismyip.com", "/text"),
        const Duration(seconds: 5),
      );

  /// Source: https://www.ipify.org
  @protected
  static Future<String?> $fetchB() => //
      getBody(
        Uri.https("api.ipify.org", ""),
        const Duration(seconds: 5),
      );

  /// Source: https://api4.my-ip.io/ip
  @protected
  static Future<String?> $fetchC() => //
      getBody(
        Uri.https("api4.my-ip.io", "/ip"),
        const Duration(seconds: 5),
      );

  /// Source: https://ip4.seeip.org/geoip
  @protected
  static Future<String?> $fetchD() => //
      Future<String?>(() async {
        final _res = await getBody(
          Uri.https("ip4.seeip.org", "/geoip"),
          const Duration(seconds: 5),
        );
        return _res != null ? jsonDecode(_res)["ip"] as String? : null;
      });

  //
  //
  //

  Future<String?> fetch() {
    return Future<String?>(() async {
      this._futureIp = MyPublicIpv4.$fetchA();
      this._ip = await this._futureIp;
      if (this._ip != null && isValidIpv4_4(this._ip!)) {
        _LOG.info("Got public IPv4 from source #a", "<#l=91>");
        return this._ip;
      }
      this._futureIp = MyPublicIpv4.$fetchB();
      this._ip = await this._futureIp;
      if (this._ip != null && isValidIpv4_4(this._ip!)) {
        _LOG.info("Got public IPv4 from source #b", "<#l=97>");
        return this._ip;
      }
      this._ip = await MyPublicIpv4.$fetchC();
      if (this._ip != null && isValidIpv4_4(this._ip!)) {
        _LOG.info("Got public IPv4 from source #c", "<#l=102>");
        return this._ip;
      }
      this._ip = await MyPublicIpv4.$fetchD();
      if (this._ip != null && isValidIpv4_4(this._ip!)) {
        _LOG.info("Got public IPv4 from source #d", "<#l=107>");
        return this._ip;
      }
      _LOG.error("Failed to get public IPv4. All sources failed.", "<#l=110>");
      return null;
    });
  }

  //
  //
  //

  static Future<String?> get ip => instance._ip == null
      ? MyPublicIpv4.instance.fetch()
      : MyPublicIpv4.instance._futureIp!;

  //
  //
  //

  static Future<String?> get ipExpanded =>
      MyPublicIpv4.ip.then((__ip) => __ip != null ? expandedIpv4(__ip) : null);
}

// ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░
//
// PUBLIC IPV6
//
// NB: IPv6 not well supported globally.
//
// ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░

class MyPublicIpv6 {
  //
  //
  //

  static final MyPublicIpv6 instance = MyPublicIpv6._();
  factory MyPublicIpv6() => instance;
  MyPublicIpv6._();

  //
  //
  //

  Future<String?>? _futureIp;
  String? _ip;

  //
  //
  //

  /// Source: https://www.api64.ipify.org
  @protected
  static Future<String?> $fetchA() => //
      getBody(
        Uri.https("api64.ipify.org", ""),
        const Duration(seconds: 5),
      ).then((__res) => __res?.toLowerCase());

  /// Source: https://api6.my-ip.io/ip
  @protected
  static Future<String?> $fetchB() => //
      getBody(
        Uri.https("api6.my-ip.io", "/ip"),
        const Duration(seconds: 5),
      ).then((__res) => __res?.toLowerCase());

  /// Source: https://ip6.seeip.org/geoip
  @protected
  static Future<String?> $fetchC() => //
      Future<String?>(() async {
        final _res = await getBody(
          Uri.https("ip6.seeip.org", "/geoip"),
          const Duration(seconds: 5),
        );
        return _res != null
            ? jsonDecode(_res)["ip"].toString().toLowerCase()
            : null;
      });

  /// Source: https://ipv6.wtfismyip.com/text
  @protected
  static Future<String?> $fetchD() => //
      getBody(
        Uri.https("ipv6.wtfismyip.com", "/text"),
        const Duration(seconds: 5),
      ).then((__res) => __res?.toLowerCase());

//
//
//

  Future<String?> fetch() {
    return Future<String?>(() async {
      this._futureIp = MyPublicIpv6.$fetchA();
      this._ip = await this._futureIp;
      if (this._ip != null && isValidIpv6_1(this._ip!)) {
        _LOG.info("Got public IPv6 from source #a", "<#l=205>");
        return this._ip;
      }
      this._futureIp = MyPublicIpv6.$fetchB();
      this._ip = await this._futureIp;
      if (this._ip != null && isValidIpv6_1(this._ip!)) {
        _LOG.info("Got public IPv6 from source #b", "<#l=211>");
        return this._ip;
      }
      this._futureIp = MyPublicIpv6.$fetchC();
      this._ip = await this._futureIp;
      if (this._ip != null && isValidIpv6_1(this._ip!)) {
        _LOG.info("Got public IPv6 from source #c", "<#l=217>");
        return this._ip;
      }
      // this._futureIp = MyPublicIpv6.$fetchD();
      // this._ip = await this._futureIp;
      // if (this._ip != null && isValidIpv6_1(this._ip!)) {
      //   _LOG.info("Got public IPv6 from source #d", "<#l=223>");
      //   return this._ip;
      // }
      _LOG.error("Failed to get public IPv6. All sources failed.", "<#l=226>");
      return null;
    });
  }

  //
  //
  //

  static Future<String?> get ip => instance._ip == null
      ? MyPublicIpv6.instance.fetch()
      : MyPublicIpv6.instance._futureIp!;

  //
  //
  //

  static Future<String?> get ipExpanded =>
      MyPublicIpv6.ip.then((__ip) => __ip != null ? expandedIpv6(__ip) : null);
}

// ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░

const VALID_IPV4_4 = //
    r"^(\d{1,3}\.){3}\d{1,3}([/\\]\b(0?[1-9]|[1-2][0-9]|3[0-2])\b)?$";

bool isValidIpv4_4(final String ipv4) => //
    ipv4.isEmpty ? false : RegExp(VALID_IPV4_4).hasMatch(ipv4);

/// May contain only characters a-z, A-Z, or 0-9 and must contain at least
/// one colon.
bool isValidIpv6_1(final String ipv6) => //
    ipv6.isEmpty
        ? false
        : RegExp(r"^([a-fA-F\d:]+:+)+[a-fA-F\d]+$").hasMatch(ipv6);

// ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░

// TEST

/*
  String pretty(final String ugly) =>
    "Input: \"$ugly\"\nOutput: \"${expandedIpv4(ugly)}\"\n";
  // INVALID:
  print(pretty(""));
  print(pretty("."));
  print(pretty("." * 3));
  print(pretty("." * 4));
  print(pretty("." * 5));
  print(pretty("/1"));
  print(pretty("Hello World!"));
  print(pretty("192.168.0"));
  print(pretty("192/168\\0.1"));
  print(pretty("0.0.20.0/123"));
  // VALID:
  print(pretty("192.168.0.1"));
  print(pretty("0.0.20.0/32"));
*/

// ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░

String expandedIpv4(final String ipv4Valid) {
  final _split = ipv4Valid.split(RegExp(r"[./\\]"));
  if (_split.length == 4 || _split.length == 5) {
    final _res = //
        "${_split[0].padLeft(3, "0")}."
        "${_split[1].padLeft(3, "0")}."
        "${_split[2].padLeft(3, "0")}."
        "${_split[3].padLeft(3, "0")}";
    if (_split.length == 5) {
      return "$_res/${_split[4].padLeft(2, "0")}";
    }
    return _res;
  }
  return "";
}

// ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░

// TEST
/*
  String pretty(final String ugly) =>
    "Input: \"$ugly\"\nOutput: \"${compressedIpv4(ugly)}\"\n";
  // INVALID:
  print(pretty(""));
  print(pretty("."*2));
  print(pretty("."*3));
  print(pretty("."*4));
  print(pretty("."*6));
  print(pretty("Hello World!"));
  print(pretty("192.168.000.0000000"));
  // VALID:
  print(pretty("192.168.0.0"));
  print(pretty("192.168.0.0/32"));
  print(pretty("192.168.0.0/09"));
*/

// ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░

String compressedIpv4(final String ipv4Valid) {
  final _expanded = expandedIpv4(ipv4Valid);
  final _split = _expanded.split(RegExp(r"[./\\]"));
  final _shortened = <String>[];
  for (final el in _split) {
    final _s = el.replaceFirst(RegExp(r"^0+"), "");
    _shortened.add(_s.isNotEmpty ? _s : "0");
  }
  if (_split.length == 4 || _split.length == 5) {
    final _res = //
        "${_shortened[0]}."
        "${_shortened[1]}."
        "${_shortened[2]}."
        "${_shortened[3]}";
    if (_split.length == 5) {
      return "$_res/${_shortened[4]}";
    }
    return _res;
  }
  return "";
}

// ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░

// TEST

/*
  String pretty(final String ugly) =>
    "Input: \"$ugly\"\nOutput: \"${expandedIpv6(ugly)}\"\n";
  // INVALID:
  print(pretty(""));
  print(pretty(":"));
  print(pretty(":" * 2));
  print(pretty(":" * 7));
  print(pretty(":" * 8));
  print(pretty("/1"));
  print(pretty("Hello World!"));
  print(pretty("123"));
  print(pretty("123::::"));
  print(pretty("123::4::5::"));
  print(pretty("2001:db8:122:344::192.0.2.32/33"));  
  // VALID:
  print(pretty(":123"));
  print(pretty("::123"));
  print(pretty("123:"));
  print(pretty("123::"));
  print(pretty("123::4:5"));
  print(pretty("2001:db8:122:344::/96"));
  print(pretty("2001:db8:122:344::192.0.2.32/1"));
*/

// ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░

String expandedIpv6(final String ipv6) {
  final _split = ipv6.split(":");
  final _d = 8 - _split.length;
  if (_d < 0) {
    return "";
  }
  final _res = <String>[];
  bool _inserted = false;
  int n = 0;
  for (final el in _split) {
    n++;
    if (!_inserted && el.isEmpty) {
      _inserted = true;
      for (int n = 0; n <= _d; n++) {
        _res.add("0" * 4);
      }
    } else {
      if (n == _split.length) {
        if (el.contains(".")) {
          _res.add(expandedIpv4(el));
        } else if (!RegExp(r"^\D").hasMatch(el)) {
          _res.add(el.padLeft(4, "0"));
        } else {
          _res.add(el);
        }
      } else {
        _res.add(el.padLeft(4, "0"));
      }
    }
  }
  return _res.join(":");
}

// ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░

// TODO: Test and refine.
String compressedIpv6(final String ipv6Valid) {
  final _expanded = expandedIpv6(ipv6Valid);
  final _split = _expanded.split(":");
  final _shortened = <String>[];
  int n = 0;
  for (final el in _split) {
    n++;
    if (n == _split.length) {
      if (el.contains(".")) {
        final _s = compressedIpv4(el);
        if (_s.isEmpty) {
          return "";
        }
        _shortened.add(_s);
      }
    } else {
      final _s = el.replaceFirst(RegExp(r"^0+"), "");
      _shortened.add(_s.isNotEmpty ? _s : "0");
    }
  }
  final _level0 = _shortened.join(":");
  String? _level1;
  for (int n = 8; n != 0; n--) {
    _level1 = _level0.replaceFirst(
        RegExp(":*${("0" * n).split("").join(":")}{1}:*"), "::");
    if (_level1.length != _level0.length) {
      break;
    }
  }
  return _level1!;
}