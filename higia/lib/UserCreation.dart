import 'package:flutter/material.dart';
import 'package:higia/atvPreferida.dart';
import 'package:higia/dadosRegisto.dart';
import 'package:higia/services/service_locator.dart';
import 'package:higia/services/user_service.dart';

final userService = getIt<UserService>();

class UserCreation extends StatefulWidget {
  final RegistrationData data;
  const UserCreation({super.key, required this.data});

  @override
  State<UserCreation> createState() => _UserCreationState();
}

class _UserCreationState extends State<UserCreation> {
  Future<bool> _createUser() async {
    try {
      final id = await userService.createUser(widget.data);
      return id != null;
    } catch (e) {
      debugPrint('Failed to create user: $e');
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(
          onPressed: () async {
            bool success = await _createUser();
            if (success) {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (_) => Atvpreferida(data: widget.data)),
              );
            } else {
              // handle failure (e.g., show error message)
            }
          },
          child: const Text('Create User and Continue'),
        ),
      ),
    );
  }
}
