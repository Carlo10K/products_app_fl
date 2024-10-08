import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

class AuthService extends ChangeNotifier {
  final String _baseUrl = 'identitytoolkit.googleapis.com';
  final String _firebaseToken = 'AIzaSyBLcmuXgZUIl3Hl62g-O79nsaA7ZtKRXsY';
  final storage = const FlutterSecureStorage();

  /// Si retorna null es correcto
  Future<String?> createUser(String email, String password) async {
    final Map<String, dynamic> authData = {
      'email': email,
      'password': password,
      'returnSecureToken': true
    };

    final url =
        Uri.https(_baseUrl, '/v1/accounts:signUp', {'key': _firebaseToken});

    final res = await http.post(url, body: json.encode(authData));
    final Map<String, dynamic> decodedRes = json.decode(res.body);

    if (decodedRes.containsKey('idToken')) {
      await storage.write(key: 'idToken', value: decodedRes['idToken']);
      return null;
    } else {
      return decodedRes['error']['message'];
    }
  }

  //si returna null es correcto
  Future<String?> login(String email, String password) async {
    final Map<String, dynamic> authData = {
      'email': email,
      'password': password,
      'returnSecureToken': true
    };

    final url = Uri.https(
        _baseUrl, '/v1/accounts:signInWithPassword', {'key': _firebaseToken});

    final res = await http.post(url, body: json.encode(authData));
    final Map<String, dynamic> decodedRes = json.decode(res.body);

    if (decodedRes.containsKey('idToken')) {
      await storage.write(key: 'idToken', value: decodedRes['idToken']);
      return null;
    } else {
      return decodedRes['error']['message'];
    }
  }

  Future logout() async {
    await storage.delete(key: 'idToken');
  }

  Future<String> readToken() async {
    return await storage.read(key: 'idToken') ?? '';
  }
}
