import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:restaurant/data/env/environment.dart';
import 'package:restaurant/data/local_secure/secure_storage.dart';

class PincodeServices {

  Future<List<String>> fetchStates() async {
    final token = await secureStorage.readToken();
    final response = await http.get(
      Uri.parse('${Environment.endpointBase}/get-states'),
      headers: {'Accept': 'application/json', 'xx-token': token!},
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return List<String>.from(data); // Assuming the response returns a list of district names as strings.
    } else {
      throw Exception('Failed to fetch districts.');

    }
  }


  Future<List<String>> fetchDistricts(String selectedState) async {
    final token = await secureStorage.readToken();
    final response = await http.get(
      Uri.parse('${Environment.endpointApi}/get-districts?state=selectedState'),
      headers: {'Accept': 'application/json', 'xx-token': token!},
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return List<String>.from(data); // Assuming the response returns a list of district names as strings.
    } else {
      throw Exception('Failed to fetch districts.');
    }
  }

  Future<List<String>> fetchTaluks(String selectedDistrict) async {
    final token = await secureStorage.readToken();
    final response = await http.get(
      Uri.parse('${Environment.endpointApi}/get-taluks?district=selectedDistrict'),
      headers: {'Accept': 'application/json', 'xx-token': token!},
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return List<String>.from(data); // Assuming the response returns a list of taluk names as strings.
    } else {
      throw Exception('Failed to fetch taluks.');
    }
  }

  Future<List<String>> fetchPincodesForSelectedTaluk(String selectedTaluk) async {

    final token = await secureStorage.readToken();
    final response = await http.get(
      Uri.parse('${Environment.endpointApi}/get-pincodes?taluk=selectedTaluk'),
      headers: {'Accept': 'application/json', 'xx-token': token!},
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return List<String>.from(data); // Assuming the response returns a list of taluk names as strings.
    } else {
      throw Exception('Failed to fetch taluks.');
    }
  }
}

final pincodeServices = PincodeServices();
