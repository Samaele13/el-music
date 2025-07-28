import 'package:el_music/domain/usecases/create_transaction_usecase.dart';
import 'package:flutter/material.dart';

enum DataState { initial, loading, loaded, error }

class PaymentProvider with ChangeNotifier {
  final CreateTransactionUseCase createTransactionUseCase;

  PaymentProvider({required this.createTransactionUseCase});

  DataState _state = DataState.initial;
  String _paymentUrl = '';
  String _errorMessage = '';

  DataState get state => _state;
  String get paymentUrl => _paymentUrl;
  String get errorMessage => _errorMessage;

  void resetState() {
    _state = DataState.initial;
    _paymentUrl = '';
    _errorMessage = '';
  }

  Future<void> createTransaction(String plan) async {
    _state = DataState.loading;
    notifyListeners();

    final result = await createTransactionUseCase(plan);
    result.fold(
      (failure) {
        _errorMessage = 'Gagal membuat transaksi';
        _state = DataState.error;
      },
      (url) {
        _paymentUrl = url;
        _state = DataState.loaded;
      },
    );
    notifyListeners();
  }
}
