import "dart:convert";
import "dart:io";

import 'package:flutter/foundation.dart';

import "package:dartz/dartz.dart";
import "package:http/http.dart" as http;
import "package:http_parser/http_parser.dart";
import '../core/caching/shared_prefs.dart';
import 'package:mime/mime.dart';

enum HttpResponseStatus {
  noInternet,
  success,
  unAuthorized,
  invalidData,
  failure,
}

isConnectedToInternet() async {
  try {
    if (!kIsWeb) {
      var result = await InternetAddress.lookup("google.com");
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        return true;
      }
    }
    return true;
  } on SocketException catch (_) {
    return false;
  }
}

class FailureModel {
  String? message;
  HttpResponseStatus responseStatus;
  FailureModel({required this.responseStatus, this.message});
}

abstract class HttpHelper {
  // todo: post
  static Future<http.Response> postData({
    required String linkUrl,
    required Map data,
    required String? token,
  }) async {
    var headers = {
      'Authorization': "$token",
      'accept': 'application/json',
      'Content-Type': 'application/json'
    };

    var response = await http.post(
      Uri.parse(linkUrl),
      body: json.encode(data),
      headers: headers,
    );

    return response;
  }

  // todo: get
  static Future<http.Response> getData({
    required String linkUrl,
    required String? token,
  }) async {
    var headers = {
      'Authorization': "$token",
      'Accept': 'application/json',
    };

    var response = await http.get(Uri.parse(linkUrl), headers: headers);

    return response;
  }

  // todo: put
  static Future<http.Response> putData({
    required String linkUrl,
    required Map<String, dynamic> data,
    required String? token,
  }) async {
    var headers = {
      'Authorization': "$token",
      'Accept': 'application/json',
    };

    var response = await http.put(Uri.parse(linkUrl),
        body: json.encode(data), headers: headers);

    return response;
  }

  // todo: patch
  static Future<http.Response> patchData({
    required String linkUrl,
    required Map<String, dynamic> data,
    required String? token,
  }) async {
    var headers = {
      'Authorization': "$token",
      'Accept': 'application/json',
      'Content-Type': 'application/json'
    };

    String jsonBody = json.encode(data);

    var response =
        await http.patch(Uri.parse(linkUrl), body: jsonBody, headers: headers);

    return response;
  }

  // todo: delete
  static Future<http.Response> deleteData({
    required String linkUrl,
    Map? data,
    required String? token,
  }) async {
    var headers = {
      'Authorization': "$token",
      'Accept': 'application/json',
    };

    var response =
        await http.delete(Uri.parse(linkUrl), body: data, headers: headers);

    return response;
  }

  // todo: patch file
  static Future<http.Response> patchFile({
    required String linkUrl,
    required File file,
    required String name,
    required String? token,
    String? fieldName,
    Map<String, dynamic>? field,
  }) async {
    try {
      // Log the upload attempt
      print("Attempting to upload file...");

      // Create the multipart request
      var request = http.MultipartRequest('PATCH', Uri.parse(linkUrl));
      request.headers['Authorization'] = 'Bearer $token';

      // Check if file exists
      if (!await file.exists()) {
        throw Exception("File not found at path: ${file.path}");
      }

      print("resss 1");

      // Determine the MIME type of the file
      var mimeType = lookupMimeType(file.path) ?? 'application/octet-stream';
      print("Detected MIME type: $mimeType");

      // Split the MIME type into type and subtype
      var mimeTypeData = mimeType.split('/');
      if (mimeTypeData.length != 2) {
        throw Exception("Invalid MIME type: $mimeType");
      }

      // Add the file to the request
      request.files.add(await http.MultipartFile.fromPath(
        name,
        file.path,
        contentType: MediaType(mimeTypeData[0], mimeTypeData[1]),
      ));

      // Add the field
      if (fieldName != null && field != null) {
        request.fields[fieldName] = json.encode(field);
      }

      // Send the request
      final response = await request.send();

      // Convert the response to http.Response
      final http.Response res = await http.Response.fromStream(response);

      // Decode the response body
      var resFile = json.decode(res.body);

      // Log the response details
      print("Response Status: ${response.statusCode}");
      print("Response Headers: ${response.headers}");
      print("Response Body: ${res.body}");

      // Check for success
      if (response.statusCode != 200) {
        print("Failed to upload file: ${resFile['message']}");
      }

      return res;
    } catch (e) {
      // Log any errors
      print("Error in patchFile: $e");
      rethrow;
    }
  }

  // todo: post file
  static Future<http.Response> postFile({
    required String linkUrl,
    required File file,
    required String name,
    required String? token,
    String? fieldName,
    Map<String, dynamic>? field,
  }) async {
    try {
      // Log the upload attempt
      print("Attempting to upload file...");

      // Create the multipart request
      var request = http.MultipartRequest('POST', Uri.parse(linkUrl));
      request.headers['Authorization'] = 'Bearer $token';

      // Check if file exists
      if (!await file.exists()) {
        throw Exception("File not found at path: ${file.path}");
      }

      print("resss 1");

      // Determine the MIME type of the file
      var mimeType = lookupMimeType(file.path) ?? 'application/octet-stream';
      print("Detected MIME type: $mimeType");

      // Split the MIME type into type and subtype
      var mimeTypeData = mimeType.split('/');
      if (mimeTypeData.length != 2) {
        throw Exception("Invalid MIME type: $mimeType");
      }

      // Add the file to the request
      request.files.add(await http.MultipartFile.fromPath(
        name,
        file.path,
        contentType: MediaType(mimeTypeData[0], mimeTypeData[1]),
      ));

      // Add the field
      if (fieldName != null && field != null) {
        request.fields[fieldName] = json.encode(field);
      }

      // Send the request
      final response = await request.send();

      // Convert the response to http.Response
      final http.Response res = await http.Response.fromStream(response);

      // Decode the response body
      var resFile = json.decode(res.body);

      // Log the response details
      print("Response Status: ${response.statusCode}");
      print("Response Headers: ${response.headers}");
      print("Response Body: ${res.body}");

      // Check for success
      if (response.statusCode != 200) {
        print("Failed to upload file: ${resFile['message']}");
      }

      return res;
    } catch (e) {
      // Log any errors
      print("Error in patchFile: $e");
      rethrow;
    }
  }

  // todo: post form
  // todo: patch form
  // todo: put form

  // todo: handle request
  static Future<Either<FailureModel, Map>> handleRequest(
    Future<http.Response> Function(String token) requestFunction,
  ) async {
    try {
      if (await isConnectedToInternet()) {
        String customToken = CacheHelper.getData(key: 'customToken') ?? "";

        print("customToken");
        print(customToken);

        http.Response response = await requestFunction(customToken);

        if (response.statusCode == 200 || response.statusCode == 201) {
          print(
              "++++++++++Backend Response +++++++++++${jsonDecode(response.body)}");
          return Right(jsonDecode(response.body));
        } else if (response.statusCode == 400 || response.statusCode == 401) {
          /// bad request(invalid data).
          String message = jsonDecode(response.body)['message'];
          print('errrrrorrrr mesegr $message');
          return Left(FailureModel(
              responseStatus: HttpResponseStatus.invalidData,
              message: message));
        } else {
          String message = jsonDecode(response.body)['message'];
          print('!!!!!!!!!!!!!!!!!! backend request error: $message');
          return Left(FailureModel(responseStatus: HttpResponseStatus.failure));
        }
      } else {
        return Left(
            FailureModel(responseStatus: HttpResponseStatus.noInternet));
      }
    } catch (e) {
      print("requestHandler");
      print(e.toString());
      return Left(FailureModel(responseStatus: HttpResponseStatus.failure));
    }
  }
}
