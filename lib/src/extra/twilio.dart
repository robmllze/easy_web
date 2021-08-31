// ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓
//
// Twilio
//
// <#Author = Robert Mollentze>
// <#Date = 8/31/2021>
//
// Resources:
// - https://www.twilio.com/blog/sending-sms-messages-dart-twilio-programmable-sms
//
// ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓

library easy_web;

import 'dart:convert' show json;
import 'dart:convert' show base64, utf8;

import 'package:http/http.dart' as http;
import 'package:prep/prep.dart' show PrepLog;

const _LOG = PrepLog.file("<#f=twilio.dart>");

// ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░

class TwilioMessage {
  //
  //
  //

  final String _accountSid;
  final String _authToken;

  //
  //
  //

  const TwilioMessage(this._accountSid, this._authToken);

  //
  //
  //

  Future<Map<dynamic, dynamic>?> send({
    required final String from,
    required final String to,
    required final String body,
  }) {
    final _client = http.Client();
    final _url = Uri.https(
      "api.twilio.com",
      "/2010-04-01/Accounts/${this._accountSid}/Messages.json",
    );
    return _client.post(_url, headers: {
      "Content-Type": "application/x-www-form-urlencoded",
      "Authorization":
          "Basic " + _toAuthCredentials(this._accountSid, this._authToken)
    }, body: {
      "From": from,
      "To": to,
      "Body": body,
    }).then((__response) {
      return json.decode(__response.body) as Map?;
    }).catchError((e) {
      _LOG.error("Failed to send SMS: $e", "<#l=64>");
      return null;
    }).whenComplete(() {
      _client.close();
    });
  }
}

// ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░

// Returns base64 encoded Twilio credentials used in authorization headers of
// http requests.
String _toAuthCredentials(
  final String accountSid,
  final String authToken,
) {
  return base64.encode(utf8.encode(accountSid + ":" + authToken));
}

// ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░
//
// EXAMPLE RESPONSE:
//
// ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░

/*
{
  sid: SMb48c27f0da1a4b0199f47de7e3c7d2a0,
  date_created: Fri, 28 May 2021 19:17:56 +0000,
  date_updated: Fri, 28 May 2021 19:17:56 +0000,
  date_sent: null,
  account_sid: AC0011d4cf1d346388e9247ba65b2694b1,
  to: +61479100711,
  from: +61488881827,
  messaging_service_sid: null,
  body: Sent from your Twilio trial account - Hello there! This is from Roowarded! :),
  status: queued,
  num_segments: 1,
  num_media: 0,
  direction: outbound-api,
  api_version: 2010-04-01,
  price: null,
  price_unit: USD,
  error_code: null,
  error_message: null,
  uri: /2010-04-01/Accounts/AC0011d4cf1d346388e9247ba65b2694b1/Messages/SMb48c27f0da1a4b0199f47de7e3c7d2a0.json,
  subresource_uris: {media: /2010-04-01/Accounts/AC0011d4cf1d346388e9247ba65b2694b1/Messages/SMb48c27f0da1a4b0199f47de7e3c7d2a0/Media.json}
}
*/

// ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░
//
// EXAMPLE USAGE:
//
// ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░

/*
  TwilioMessage _messages = TwilioMessage(
    "AC0011d4cf1d346388e9247ba65b2694b1",
    "482ebdaecfa474db45188d07723845b0",
  );
  _messages
      .send(
          from: "+61488881827",
          to: "+61479100711",
          body: "Hello there! This is from Roowarded! :)")
      .then((__res) {
    browserAlert(__res.toString());
  });
*/