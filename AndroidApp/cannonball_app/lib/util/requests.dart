import 'dart:async';
import 'dart:io';
import 'dart:convert';

class Requests {
  static final String uri = "https://cannonball-220004.appspot.com/";
  static final HttpClient httpClient = new HttpClient();
  static HttpClientRequest request;
  static HttpClientResponse response;
  static String reply;

  static Future<String> GET(String url) async {
      request = await httpClient.getUrl(Uri.parse(uri+url));
      request.headers.set('content-type', 'application/json');
      response = await request.close();

      reply = await response.transform(utf8.decoder).join();
      httpClient.close();
      print(reply);
      return reply;
  }

  static Future<String> POST(Map myBody, String url) async {
      request = await httpClient.postUrl(Uri.parse(uri+url));
      request.headers.set('content-type', 'application/json');
      request.add(utf8.encode(json.encode(myBody)));
      response = await request.close();

      reply = await response.transform(utf8.decoder).join();
      httpClient.close();
      print(reply);
      return reply;
  }
}

