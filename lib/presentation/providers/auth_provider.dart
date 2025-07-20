import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

enum AuthState { initial, loading, success, error }

class AuthProvider with ChangeNotifier {
  final Dio dio;
  AuthProvider({required this.dio});

  AuthState _registerState = AuthState.initial;
  AuthState _loginState = AuthState.initial;
  String _errorMessage = '';
  String? _token;

  AuthState get registerState => _registerState;
  AuthState get loginState => _loginState;
  String get errorMessage => _errorMessage;
  bool get isLoggedIn => _token != null;

  void _setupDioInterceptor() {
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          if (_token != null) {
            options.headers['Authorization'] = 'Bearer $_token';
          }
          return handler.next(options);
        },
      ),
    );
  }

  void resetRegisterState() {
    _registerState = AuthState.initial;
    _errorMessage = '';
  }

  void resetLoginState() {
    _loginState = AuthState.initial;
    _errorMessage = '';
  }

  Future<void> register({
    required String name,
    required String email,
    required String password,
  }) async {
    _registerState = AuthState.loading;
    notifyListeners();
    try {
      final response = await dio.post(
        '/auth/register',
        data: {'name': name, 'email': email, 'password': password},
      );
      if (response.statusCode == 201) {
        _registerState = AuthState.success;
      } else {
        _registerState = AuthState.error;
        _errorMessage = 'Terjadi kesalahan. Silakan coba lagi.';
      }
    } on DioException catch (e) {
      _registerState = AuthState.error;
      if (e.response?.statusCode == 409) {
        _errorMessage = 'Email sudah terdaftar.';
      } else {
        _errorMessage = 'Gagal terhubung ke server.';
      }
    } catch (e) {
      _registerState = AuthState.error;
      _errorMessage = 'Terjadi kesalahan yang tidak diketahui.';
    }
    notifyListeners();
  }

  Future<void> login({
    required String email,
    required String password,
  }) async {
    _loginState = AuthState.loading;
    notifyListeners();
    try {
      final response = await dio.post(
        '/auth/login',
        data: {'email': email, 'password': password},
      );
      if (response.statusCode == 200) {
        _token = response.data['token'];
        _setupDioInterceptor();
        _loginState = AuthState.success;
      } else {
        _loginState = AuthState.error;
        _errorMessage = 'Terjadi kesalahan. Silakan coba lagi.';
      }
    } on DioException catch (e) {
      _loginState = AuthState.error;
      if (e.response?.statusCode == 401) {
        _errorMessage = 'Email atau password salah.';
      } else {
        _errorMessage = 'Gagal terhubung ke server.';
      }
    } catch (e) {
      _loginState = AuthState.error;
      _errorMessage = 'Terjadi kesalahan yang tidak diketahui.';
    }
    notifyListeners();
  }

  void logout() {
    _token = null;
    dio.interceptors.clear();
    notifyListeners();
  }
}
