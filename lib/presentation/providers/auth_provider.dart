import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

enum AuthState { initial, loading, success, error }

class AuthProvider with ChangeNotifier {
  final Dio dio;
  AuthProvider({required this.dio});

  AuthState _registerState = AuthState.initial;
  AuthState _loginState = AuthState.initial;
  AuthState _forgotPasswordState = AuthState.initial;
  AuthState _resetPasswordState = AuthState.initial;

  String _errorMessage = '';
  String? _token;

  AuthState get registerState => _registerState;
  AuthState get loginState => _loginState;
  AuthState get forgotPasswordState => _forgotPasswordState;
  AuthState get resetPasswordState => _resetPasswordState;

  String get errorMessage => _errorMessage;
  bool get isLoggedIn => _token != null;

  void _setupDioInterceptor() {
    dio.interceptors.clear();
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

  void resetAllStates() {
    _registerState = AuthState.initial;
    _loginState = AuthState.initial;
    _forgotPasswordState = AuthState.initial;
    _resetPasswordState = AuthState.initial;
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
        throw DioException(
            requestOptions: response.requestOptions, response: response);
      }
    } on DioException catch (e) {
      _registerState = AuthState.error;
      _errorMessage = e.response?.statusCode == 409
          ? 'Email sudah terdaftar.'
          : 'Gagal terhubung ke server.';
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
        throw DioException(
            requestOptions: response.requestOptions, response: response);
      }
    } on DioException catch (e) {
      _loginState = AuthState.error;
      if (e.response?.statusCode == 401) {
        _errorMessage = 'Email atau password salah.';
      } else if (e.response?.statusCode == 403) {
        _errorMessage = 'Harap verifikasi email Anda terlebih dahulu.';
      } else {
        _errorMessage = 'Gagal terhubung ke server.';
      }
    } catch (e) {
      _loginState = AuthState.error;
      _errorMessage = 'Terjadi kesalahan yang tidak diketahui.';
    }
    notifyListeners();
  }

  Future<void> forgotPassword({required String email}) async {
    _forgotPasswordState = AuthState.loading;
    notifyListeners();
    try {
      await dio.post('/auth/forgot-password', data: {'email': email});
      _forgotPasswordState = AuthState.success;
    } catch (e) {
      _forgotPasswordState = AuthState.error;
      _errorMessage = 'Gagal mengirim link reset. Silakan coba lagi.';
    }
    notifyListeners();
  }

  Future<void> resetPassword(
      {required String token, required String newPassword}) async {
    _resetPasswordState = AuthState.loading;
    notifyListeners();
    try {
      await dio.post('/auth/reset-password',
          data: {'token': token, 'newPassword': newPassword});
      _resetPasswordState = AuthState.success;
    } catch (e) {
      _resetPasswordState = AuthState.error;
      _errorMessage =
          'Token tidak valid atau kedaluwarsa. Silakan minta link baru.';
    }
    notifyListeners();
  }

  void logout() {
    _token = null;
    dio.interceptors.clear();
    notifyListeners();
  }
}
