import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:store_app/bloc/auth_bloc/auth_bloc.dart';
import 'package:store_app/widgets/my_border.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  late FocusNode _passwordNode = FocusNode();
  late FocusNode _emailNode = FocusNode();

  late TextEditingController _passwordController = TextEditingController();
  late TextEditingController _nameController = TextEditingController();
  late TextEditingController _emailController = TextEditingController();

  late bool _passwordIsVisible = false;

  @override
  void dispose() {
    super.dispose();
    _passwordNode.dispose();
    _emailNode.dispose();

    _passwordController.dispose();
    _nameController.dispose();
    _emailController.dispose();
  }

  void _submitForm() async {
    FocusScope.of(context).unfocus();
    Provider.of<AuthBloc>(context, listen: false).add(SignUpWithEmailEvent(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
        name: _nameController.text.trim()));
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthAuthenticated) {
          if (Navigator.canPop(context)) Navigator.pop(context);
        }
      },
      child: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Scaffold(
          appBar: AppBar(),
          body: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.fromLTRB(
                  20, MediaQuery.of(context).size.height * 0.06, 20, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Sign Up',
                    style: TextStyle(fontSize: 22),
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.07),
                  BlocBuilder<AuthBloc, AuthState>(
                    builder: (context, state) {
                      return Form(
                        child: Column(
                          children: [
                            // Full Name TextFormField
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 8),
                              child: TextFormField(
                                controller: _nameController,
                                key: ValueKey('Full Name'),
                                textCapitalization: TextCapitalization.words,
                                maxLines: 1,
                                textInputAction: TextInputAction.next,
                                keyboardType: TextInputType.name,
                                decoration: InputDecoration(
                                  labelText: 'Full Name',
                                  errorText: state is AuthError
                                      ? state.nameError
                                      : null,
                                  errorMaxLines: 2,
                                  contentPadding: EdgeInsets.all(12),
                                  border: const OutlineInputBorder(),
                                  enabledBorder:
                                      MyBorder.outlineInputBorder(context),
                                  filled: true,
                                  fillColor: Theme.of(context).cardColor,
                                ),
                                onEditingComplete: () => FocusScope.of(context)
                                    .requestFocus(_emailNode),
                              ),
                            ),

                            // Email TextFormField
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 8),
                              child: TextFormField(
                                controller: _emailController,
                                key: ValueKey('Email'),
                                focusNode: _emailNode,
                                maxLines: 1,
                                textInputAction: TextInputAction.next,
                                keyboardType: TextInputType.emailAddress,
                                decoration: InputDecoration(
                                  labelText: 'Email',
                                  errorText: state is AuthError
                                      ? state.emailError
                                      : null,
                                  errorMaxLines: 2,
                                  contentPadding: EdgeInsets.all(12),
                                  border: const OutlineInputBorder(),
                                  enabledBorder:
                                      MyBorder.outlineInputBorder(context),
                                  filled: true,
                                  fillColor: Theme.of(context).cardColor,
                                ),
                                onEditingComplete: () => FocusScope.of(context)
                                    .requestFocus(_passwordNode),
                              ),
                            ),

                            // Password TextFormField
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 14.0),
                              child: TextFormField(
                                controller: _passwordController,
                                key: ValueKey('Password'),
                                maxLines: 1,
                                focusNode: _passwordNode,
                                keyboardType: TextInputType.visiblePassword,
                                onEditingComplete: _submitForm,
                                obscureText: !_passwordIsVisible,
                                decoration: InputDecoration(
                                  contentPadding:
                                      EdgeInsets.symmetric(horizontal: 12),
                                  labelText: 'Password',
                                  errorText: state is AuthError
                                      ? state.passwordError
                                      : null,
                                  errorMaxLines: 2,
                                  border: const OutlineInputBorder(),
                                  enabledBorder:
                                      MyBorder.outlineInputBorder(context),
                                  filled: true,
                                  fillColor: Theme.of(context).cardColor,
                                  suffix: SizedBox(
                                    height: 32,
                                    width: 28,
                                    child: IconButton(
                                      onPressed: () => setState(() =>
                                          _passwordIsVisible =
                                              !_passwordIsVisible),
                                      splashRadius: 18,
                                      iconSize: 18,
                                      icon: Icon(
                                        _passwordIsVisible
                                            ? Icons.visibility_off_outlined
                                            : Icons.visibility_outlined,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),

                            SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.02),

                            // Sign Up button
                            SizedBox(
                              width: double.infinity,
                              height: 50,
                              child: ElevatedButton(
                                onPressed: () {
                                  _submitForm();
                                  FocusScope.of(context).unfocus();
                                },
                                child: Text('Sign Up'),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
