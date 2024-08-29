import 'package:flutter/material.dart';
import 'package:restart_app/restart_app.dart';

class LSNoInternet extends StatelessWidget {
  const LSNoInternet({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pas de connexion Internet'),
        backgroundColor: Colors.redAccent,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.wifi_off,
                color: Colors.grey,
                size: 100,
              ),
              const SizedBox(height: 20),
              const Text(
                'Aucune connexion Internet détectée.',
                style: TextStyle(fontSize: 18),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 10),
              const Text(
                'Veuillez vérifier votre connexion réseau et réessayer.',
                style: TextStyle(fontSize: 16),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 40),
              ElevatedButton(
                onPressed: () {
                  Restart.restartApp();
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                  textStyle: const TextStyle(fontSize: 16),
                ),
                child: const Text('Réessayer'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
