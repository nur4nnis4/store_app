import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:store_app/bloc/auth_bloc/auth_bloc.dart';
import 'package:store_app/widgets/custom_snackbar.dart';
import 'package:store_app/widgets/log_in_suggestion.dart';

class Authenticate extends StatelessWidget {
  final Widget child;
  const Authenticate({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthBloc, AuthState>(listener: (context, state) {
      if (state is AuthLoading) {
        ScaffoldMessenger.of(context).showSnackBar(
            CustomSnackbar.loadingSnackbar(context, text: state.message));
      } else if (state is SignOutLoading) {
        ScaffoldMessenger.of(context).showSnackBar(
            CustomSnackbar.loadingSnackbar(context, text: state.message));
      } else {
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
      }
    }, builder: (_, state) {
      if (state is AuthAuthenticated || state is SignOutLoading) {
        return child;
      } else {
        return Scaffold(body: LogInSuggestion());
      }
    });
  }
}
