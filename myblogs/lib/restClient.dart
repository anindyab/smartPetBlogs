import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'config.dart';

var accessToken;

Future<Null> getAccessToken() async {

  await http.post(Config.url, body: {"grant_type": "client_credentials", "client_id": Config.clientId,
    "client_secret": Config.clientSecret})
      .then((response) {
    print("Response status: ${response.statusCode}");
    print("Response body: ${response.body}");

    var localData = json.decode(response.body);
    accessToken = localData["access_token"];
  });
}

getAllBlogs() async {
  var response;

  await getAccessToken();

  if (await accessToken == null) {
    await accessToken();
  } else {
    response = await http
        .get(Uri.encodeFull('http://localhost:8080/o/blogs/all'), headers: {
      "Authorization":
      "Bearer " + accessToken
    });
  }

  return response;
}

getBlogDetail(blogId, refreshToken) async {
  var response;

  if (refreshToken) {
    await getAccessToken();
  }

  if (await accessToken == null) {
    await accessToken();
  } else {
    response = await http
        .get(Uri.encodeFull('http://localhost:8080/o/blogs/'+ blogId), headers: {
      "Authorization":
      "Bearer " + accessToken
    });
  }

  return response;
}
