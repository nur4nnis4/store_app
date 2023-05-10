import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:store_app/bloc/auth_bloc/auth_bloc.dart';
import 'package:store_app/core/routes/route_name.dart';
import 'package:store_app/widgets/my_button.dart';

class LogInSuggestion extends StatelessWidget {
  const LogInSuggestion({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        // If auth state is AuthAuthenticated, pop sign in / sign up screen
        if (state is AuthAuthenticated) {
          Navigator.pop(context);
        }
      },
      child: Container(
        padding: const EdgeInsets.fromLTRB(35.0, 0.0, 35.0, 0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: 30.0),
            Text(
              'You are not logged in.',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.headline5,
            ),
            SizedBox(height: 20.0),
            Text(
              'There are a lot of great offers and features waiting for you. Join now !',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.overline,
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.1),
            Row(
              children: [
                Expanded(
                  flex: 1,
                  child: MyButton.outlined(
                      context: context,
                      text: 'Log in',
                      onPressed: () =>
                          Navigator.pushNamed(context, RouteName.logInScreen)),
                ),
                SizedBox(width: 8),
                Expanded(
                    flex: 1,
                    child: MyButton.text(
                      context: context,
                      onPressed: () =>
                          Navigator.pushNamed(context, RouteName.signUpScreen),
                      text: 'Sign Up',
                    ))
              ],
            )
          ],
        ),
      ),
    );
  }
}
