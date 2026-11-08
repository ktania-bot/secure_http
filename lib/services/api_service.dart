import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

import '../models/post.dart';
import '../models/user.dart';

class ApiService {
  static const String _baseUrl = 'https://jsonplaceholder.typicode.com';
  static const Duration _defaultTimeout = Duration(seconds: 10);

  // GET /users. Timeout dapat diatur saat method dipanggil.
  Future<List<User>> getUsers({
    Duration timeout = _defaultTimeout,
  }) async {
    try {
      print('Request GET: $_baseUrl/users');

      final response = await http
          .get(Uri.parse('$_baseUrl/users'))
          .timeout(timeout);

      print('Response status: ${response.statusCode}');

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data
            .map((json) => User.fromJson(json as Map<String, dynamic>))
            .toList();
      }

      throw HttpException(
        'Gagal memuat data pengguna. Status: ${response.statusCode}',
      );
    } on TimeoutException {
      throw Exception(
        'Request pengguna melewati batas waktu '
        '(${timeout.inSeconds} detik). Silakan coba lagi.',
      );
    } on SocketException {
      throw Exception('Tidak ada koneksi internet. Periksa jaringan Anda.');
    } on FormatException {
      throw Exception('Format data pengguna tidak valid.');
    } on HttpException {
      rethrow;
    } catch (e) {
      throw Exception('Terjadi kesalahan saat memuat pengguna: $e');
    }
  }

  // GET /users/{id}
  Future<User> getUserById(int id) async {
    try {
      print('Request GET: $_baseUrl/users/$id');

      final response = await http
          .get(Uri.parse('$_baseUrl/users/$id'))
          .timeout(_defaultTimeout);

      print('Response status: ${response.statusCode}');

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        return User.fromJson(data);
      }

      throw HttpException(
        'Gagal memuat detail pengguna. Status: ${response.statusCode}',
      );
    } on TimeoutException {
      throw Exception('Request timeout. Periksa koneksi internet Anda.');
    } on SocketException {
      throw Exception('Tidak ada koneksi internet. Periksa jaringan Anda.');
    } on FormatException {
      throw Exception('Format data pengguna tidak valid.');
    } on HttpException {
      rethrow;
    } catch (e) {
      throw Exception('Terjadi kesalahan: $e');
    }
  }

  // GET /posts
  Future<List<Post>> getPosts() async {
    try {
      print('Request GET: $_baseUrl/posts');

      final response = await http
          .get(Uri.parse('$_baseUrl/posts'))
          .timeout(_defaultTimeout);

      print('Response status: ${response.statusCode}');

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data
            .map((json) => Post.fromJson(json as Map<String, dynamic>))
            .toList();
      }

      throw HttpException(
        'Gagal memuat data post. Status: ${response.statusCode}',
      );
    } on TimeoutException {
      throw Exception('Request post timeout. Silakan coba lagi.');
    } on SocketException {
      throw Exception('Tidak ada koneksi internet. Periksa jaringan Anda.');
    } on FormatException {
      throw Exception('Format data post tidak valid.');
    } on HttpException {
      rethrow;
    } catch (e) {
      throw Exception('Terjadi kesalahan saat memuat post: $e');
    }
  }

  // Simulasi login untuk mendapatkan token.
  Future<String> login(String email, String password) async {
    try {
      await Future.delayed(const Duration(seconds: 1));

      if (email.trim().isEmpty || password.isEmpty) {
        throw Exception('Email dan password tidak boleh kosong.');
      }

      // Token dummy karena login pada modul disimulasikan, bukan autentikasi server.
      final token = 'dummy_token_${DateTime.now().millisecondsSinceEpoch}';
      print('Login berhasil.');
      return token;
    } catch (e) {
      throw Exception('Login gagal: $e');
    }
  }
}
