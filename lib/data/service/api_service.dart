import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class ApiService {
  final Dio dio = Dio();
  Future<String> aimessage(String message) async {
    try {
      final apikey = dotenv.env["APIKEY"];
      final url = dotenv.env["URL"];
      if (apikey == null || apikey.isEmpty) {
        throw Exception("Api Error : No Api key found in .env file");
      }
      if (url == null || url.isEmpty) {
        throw Exception("Url error : No Url Found in .env file");
      }
      final response = await dio.post(
        url,
        options: Options(
          headers: {
            "Authorization": "Bearer $apikey",
            "Content-Type": "application/json",
          },
        ),
        data: {
          "model": "meta/llama-3.1-8b-instruct",
          "messages": [
            {"role": "user", "content": message},
          ],
          "temperature": 0.2,
          "top_p": 0.7,
          "max_tokens": 1024,
          "stream": false,
        },
      );
      if (response.statusCode! >= 400) {
        throw Exception("Api Error : Invalid Api - ${response.statusCode}");
      }
      final choices = response.data["choices"] as List;
      if (choices.isEmpty) {
        throw Exception("Api Error : No Choices found - ${response.data}");
      }
      final data = choices[0]["message"]["content"];
      if (data.isEmpty) {
        throw Exception("Api Error : No conent Found -${response.statusCode}");
      }
      return data;
    } on DioException catch (e) {
      throw Exception(
        "Dio Error :${e.response?.statusCode}-${e.response?.data}",
      );
    } catch (e) {
      rethrow;
    }
  }
}
