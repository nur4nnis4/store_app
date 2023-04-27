import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:store_app/providers/auth_provider.dart';
import 'package:store_app/widgets/log_in_suggestion.dart';

class Authenticate extends StatefulWidget {
  final Widget child;
  const Authenticate({Key? key, required this.child}) : super(key: key);

  @override
  _AuthenticateState createState() => _AuthenticateState();
}

class _AuthenticateState extends State<Authenticate> {
  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(builder: (_, _authProvider, __) {
      if (_authProvider.isLoggedIn) {
        return widget.child;
      } else {
        return Scaffold(body: LogInSuggestion());
      }
    });
  }
}
