import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:sunmi_printer_example/model/api/print_img_res.dart';

const String url = '192.168.14.185:8089';

Future<PrintImgRes> fetchLabelImg(List<Map<String, dynamic>> body) async {

  final uri = Uri.http(url, '/v1/app/label/printSunmi' );
  print(uri);

  final response =
      await http.post(
        uri, 
        headers: {
          "Content-Type": "application/json",
        },
        body: jsonEncode(body),
      );

  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    return PrintImgRes.fromJson(json.decode(response.body));
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Failed to fetch label images');
  }
}



Future<PrintImgRes> fetchUIDImg(List<Map<String, dynamic>> param) async {

  final uri = Uri.http(url, '/v1/app/label/printSunmi' );
  print(uri);
  var body = json.encode(param);
  final response =
      await http.post(
        uri, 
        headers: {
          "Content-Type": "application/json",
        },
        body: body,
      );


  if (response.statusCode == 200) {
    // final bytes = Uint8List.fromList(response.bodyBytes);
    PrintImgRes res = PrintImgRes.fromJson(json.decode(response.body));
    // var url = res.data.url[0];
    return res;
  } else {
    print(response.statusCode);
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Failed to fetch label images');
  }
}