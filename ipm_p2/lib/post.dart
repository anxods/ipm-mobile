import 'package:http/http.dart' as http;
import 'package:async/async.dart';
import 'dart:convert';
import 'dart:io';
import 'package:path/path.dart';

class Post {
  Future<bool> isInternetConnection() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        return true;
      }
    } on SocketException catch (_) {
      return false;
    }
  }

  Future<List> postImage(File imageFile) async {
    // We check if we have internet connection
    bool connection = await isInternetConnection();
    if (!connection) {
      return ["No Internet connection.", true];
    } else {
      var stream =
          new http.ByteStream(DelegatingStream.typed(imageFile.openRead()));
      var length = await imageFile.length();
      Map<String, String> headers = {
        HttpHeaders.authorizationHeader:
            "Basic YWNjXzJiM2UzNWRjNjg1ZjdhYTo0NTY5YTZlYWI3YjkxYTUzNGFmNWU3NjBkNjE4MTRmNA=="
      };
      int timeout = 10;

      var request = new http.MultipartRequest(
          "POST", Uri.parse('https://api.imagga.com/v2/tags'));

      request.headers.addAll(headers);
      var multipartFile = new http.MultipartFile('image', stream, length,
          filename: basename(imageFile.path));
      //request.fields['return_face_id'] = "1";
      request.files.add(multipartFile);

      try {
        var response = await request.send().timeout(Duration(seconds: timeout));

        if (response.statusCode == HttpStatus.ok) {
          var responseData = await response.stream.toBytes();
          var responseString = String.fromCharCodes(responseData);
          Map<String, dynamic> respuesta = jsonDecode(responseString);
          if (respuesta['status']['type'] == "success") {
            String firstresponse = respuesta["result"]["tags"][0]["tag"]["en"];
            String secondresponse = respuesta["result"]["tags"][1]["tag"]["en"];
            String thirdresponse = respuesta["result"]["tags"][2]["tag"]["en"];
            List<String> results = [
              firstresponse,
              secondresponse,
              thirdresponse
            ];
            return [firstresponse, secondresponse, thirdresponse, false];
          } else {
            return ["Error Servidor", true];
          }
        } else {
          return [response.statusCode.toString(), true];
        }
      } on Exception catch (e) {
        return ["Error $e", true];
      }
    }
  }
}
