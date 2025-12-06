import 'dart:async';

import 'package:as_projeto/utils/results.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirebaseService {
  var firebaseInstance = FirebaseAuth.instance;

  final StreamController<Results> _resultsLogin =
      StreamController<Results>.broadcast();

  final StreamController<Results> _resultsRegister =
      StreamController<Results>.broadcast();

  Stream<Results> get resultsLogin => _resultsLogin.stream;
  Stream<Results> get resultsRegister => _resultsRegister.stream;

  makeLoginFirebase(String email, String password) async {
    _resultsLogin.add(LoadingResult());

    const maxRetries = 3;
    var retryCount = 0;

    while (retryCount < maxRetries) {
      try {
        var response = await firebaseInstance
            .signInWithEmailAndPassword(email: email, password: password)
            .timeout(
              const Duration(seconds: 90),
              onTimeout: () {
                throw Exception("network-timeout");
              },
            );

        if (response.user != null) {
          _resultsLogin.add(SuccessResult());
          return;
        }
      } on FirebaseAuthException catch (exception) {
        // Se não for erro de rede, não tenta novamente
        final message = exception.message?.toLowerCase() ?? '';
        if (exception.code != 'network-request-failed' &&
            !message.contains('network') &&
            !message.contains('recaptcha')) {
          _resultsLogin.add(ErrorResult(code: exception.code));
          return;
        }

        // Se for erro de rede e ainda tiver tentativas, tenta novamente
        if (retryCount < maxRetries - 1) {
          retryCount++;
          await Future.delayed(
            Duration(seconds: retryCount * 2),
          ); // Backoff exponencial
          continue;
        }

        // Última tentativa falhou
        _resultsLogin.add(ErrorResult(code: "network-recaptcha-error"));
        return;
      } on Exception catch (genericException) {
        final errorString = genericException.toString().toLowerCase();
        bool isNetworkError =
            errorString.contains("network-timeout") ||
            errorString.contains("timeout") ||
            errorString.contains("recaptcha") ||
            errorString.contains("network error") ||
            errorString.contains("network") ||
            errorString.contains("unreachable") ||
            errorString.contains("interrupted");

        // Se não for erro de rede, não tenta novamente
        if (!isNetworkError) {
          String errorCode = genericException.toString();
          _resultsLogin.add(ErrorResult(code: errorCode));
          return;
        }

        // Se for erro de rede e ainda tiver tentativas, tenta novamente
        if (retryCount < maxRetries - 1) {
          retryCount++;
          await Future.delayed(
            Duration(seconds: retryCount * 2),
          ); // Backoff exponencial
          continue;
        }

        // Última tentativa falhou
        String errorCode;
        if (errorString.contains("network-timeout") ||
            errorString.contains("timeout")) {
          errorCode = "network-timeout";
        } else if (errorString.contains("recaptcha") ||
            errorString.contains("network error")) {
          errorCode = "network-recaptcha-error";
        } else {
          errorCode = "network-error";
        }

        _resultsLogin.add(ErrorResult(code: errorCode));
        return;
      }
    }
  }

  register(String email, String password) async {
    _resultsRegister.add(LoadingResult());

    const maxRetries = 3;
    var retryCount = 0;

    while (retryCount < maxRetries) {
      try {
        var response = await firebaseInstance
            .createUserWithEmailAndPassword(email: email, password: password)
            .timeout(
              const Duration(seconds: 90),
              onTimeout: () {
                throw Exception("network-timeout");
              },
            );

        if (response.user != null) {
          _resultsRegister.add(SuccessResult());
          return;
        }
      } on FirebaseAuthException catch (exception) {
        // Se não for erro de rede, não tenta novamente
        final message = exception.message?.toLowerCase() ?? '';
        if (exception.code != 'network-request-failed' &&
            !message.contains('network') &&
            !message.contains('recaptcha')) {
          _resultsRegister.add(ErrorResult(code: exception.code));
          return;
        }

        // Se for erro de rede e ainda tiver tentativas, tenta novamente
        if (retryCount < maxRetries - 1) {
          retryCount++;
          await Future.delayed(
            Duration(seconds: retryCount * 2),
          ); // Backoff exponencial
          continue;
        }

        // Última tentativa falhou
        _resultsRegister.add(ErrorResult(code: "network-recaptcha-error"));
        return;
      } on Exception catch (genericException) {
        final errorString = genericException.toString().toLowerCase();
        bool isNetworkError =
            errorString.contains("network-timeout") ||
            errorString.contains("timeout") ||
            errorString.contains("recaptcha") ||
            errorString.contains("network error") ||
            errorString.contains("network") ||
            errorString.contains("unreachable") ||
            errorString.contains("interrupted");

        // Se não for erro de rede, não tenta novamente
        if (!isNetworkError) {
          String errorCode = genericException.toString();
          _resultsRegister.add(ErrorResult(code: errorCode));
          return;
        }

        // Se for erro de rede e ainda tiver tentativas, tenta novamente
        if (retryCount < maxRetries - 1) {
          retryCount++;
          await Future.delayed(
            Duration(seconds: retryCount * 2),
          ); // Backoff exponencial
          continue;
        }

        // Última tentativa falhou
        String errorCode;
        if (errorString.contains("network-timeout") ||
            errorString.contains("timeout")) {
          errorCode = "network-timeout";
        } else if (errorString.contains("recaptcha") ||
            errorString.contains("network error")) {
          errorCode = "network-recaptcha-error";
        } else {
          errorCode = "network-error";
        }

        _resultsRegister.add(ErrorResult(code: errorCode));
        return;
      }
    }
  }

  signOut() async {
    await firebaseInstance.signOut();
  }
}
