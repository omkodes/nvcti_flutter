import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../domain/entities/booking_history.dart';
import '../../domain/entities/booking_request.dart';
import '../../domain/repositories/booking_repository.dart';
import '../models/booking_history_model.dart';

class BookingRepositoryImpl implements BookingRepository {
  final String webAppUrl = "https://script.google.com/macros/s/AKfycbyoj5akEkcNPi89vcTLtygu5hc5VyBGFHd8ADyJl2LQos5jB2GjmbPH02QScEixdlax/exec";

  @override
  Future<List<BookingHistory>> getBookings() async {
    try {
      final response = await http.get(Uri.parse(webAppUrl));

      if (response.statusCode == 200) {
        final body = jsonDecode(response.body);
        if (body['status'] == "success" && body['data'] != null) {
          return (body['data'] as List)
              .map((item) => BookingHistoryModel.fromJson(item))
              .toList();
        } else {
          throw Exception("No data available");
        }
      } else {
        throw Exception("Failed: ${response.statusCode}");
      }
    } catch (e) {
      throw Exception("Error fetching bookings: $e");
    }
  }

  @override
  Future<String> addBooking(BookingRequest request) async {
    try {
      var req = http.Request('POST', Uri.parse(webAppUrl))
        ..headers['Content-Type'] = 'application/json'
        ..body = jsonEncode(request.toJson())
        ..followRedirects = false;

      var client = http.Client();
      var streamedResponse = await client.send(req);
      var response = await http.Response.fromStream(streamedResponse);
      client.close();

      if (response.statusCode == 200 || response.statusCode == 302) {
        return "Request generated";
      } else {
        throw Exception("Failed with status ${response.statusCode}: ${response.body}");
      }
    } catch (e) {
      throw Exception("API call failed: $e");
    }
  }
}