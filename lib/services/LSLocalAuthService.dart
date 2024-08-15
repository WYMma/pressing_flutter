import 'package:flutter/material.dart';
import 'package:local_auth/local_auth.dart';

class LSLocalAuthService {
  static final LocalAuthentication _localAuth = LocalAuthentication();

  static Future<bool> _canAuthenticate() async => await _localAuth.canCheckBiometrics || await _localAuth.isDeviceSupported();

  static Future<bool> authenticate() async {
    try {
      if (!await _canAuthenticate()) return false;
      return await _localAuth.authenticate(
        localizedReason: 'Veuillez vous authentifier pour continuer',
        options: const AuthenticationOptions(
          useErrorDialogs: true,
          stickyAuth: true,
        ),
      );
    } catch (e) {
      debugPrint('Error: $e');
      return false;
    }
  }


}