import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:store_app/bloc/auth_bloc/auth_bloc.dart';
import 'package:store_app/core/constants/assets_path.dart';
import 'package:store_app/core/routes/route_name.dart';
import 'package:store_app/widgets/my_border.dart';

class LogInScreen extends StatefulWidget {
  const LogInScreen({Key? key}) : super(key: key);

  @override
  _LogInScreenState createState() => _LogInScreenState();
}

class _LogInScreenState extends State<LogInScreen> {
  late FocusNode _passwordNode;
  final _formKey = GlobalKey<FormState>();
  bool _passwordIsVisibile = false;

  late TextEditingController _passwordController = TextEditingController();
  late TextEditingController _emailController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _passwordNode = new FocusNode();
  }

  @override
  void dispose() {
    super.dispose();
    _passwordNode.dispose();
  }

  void _submitForm() async {
    final isValid = _formKey.currentState!.validate();
    FocusScope.of(context).unfocus();
    if (isValid) {
      context.read<AuthBloc>().add(SignInWithEmailEvent(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim()));
    }
  }

  void _googleSignIn() async {
    Provider.of<AuthBloc>(context, listen: false)
        .add(ContinueWithGoogleEvent());
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(),
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: Column(
              children: [
                SizedBox(height: MediaQuery.of(context).size.height * 0.1),
                //  App Logo
                Row(
                  children: [
                    Icon(
                      Icons.shopping_bag_rounded,
                      size: 32,
                      color: Theme.of(context).primaryColor,
                    ),
                    Text(
                      ' ShopApp',
                      style: TextStyle(fontSize: 22),
                    )
                  ],
                ),

                //Show Log In error message
                BlocBuilder<AuthBloc, AuthState>(
                  builder: (context, state) {
                    if (state is AuthError) {
                      return Container(
                          height: 65,
                          padding: EdgeInsets.only(top: 14),
                          child: Text(
                            state.errorMessage,
                            style: TextStyle(color: Colors.redAccent),
                          ));
                    } else {
                      return Container();
                    }
                  },
                ),

                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      // Email TextFormField
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        child: TextFormField(
                          controller: _emailController,
                          key: ValueKey('Email'),
                          validator: (value) =>
                              value!.isEmpty || !value.contains('@')
                                  ? 'Please enter a valid email address'
                                  : null,
                          maxLines: 1,
                          textInputAction: TextInputAction.next,
                          keyboardType: TextInputType.emailAddress,
                          decoration: InputDecoration(
                            labelText: 'Email',
                            contentPadding: EdgeInsets.all(12),
                            border: const OutlineInputBorder(),
                            enabledBorder: MyBorder.outlineInputBorder(context),
                            filled: true,
                            fillColor: Theme.of(context).cardColor,
                          ),
                          onEditingComplete: () => FocusScope.of(context)
                              .requestFocus(_passwordNode),
                        ),
                      ),

                      // Password TextFormField
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 14.0),
                        child: TextFormField(
                          controller: _passwordController,
                          key: ValueKey('Password'),
                          validator: (value) => value!.isEmpty
                              ? 'Please enter a valid password'
                              : null,
                          maxLines: 1,
                          focusNode: _passwordNode,
                          keyboardType: TextInputType.visiblePassword,
                          onEditingComplete: _submitForm,
                          obscureText: !_passwordIsVisibile,
                          decoration: InputDecoration(
                            contentPadding:
                                EdgeInsets.symmetric(horizontal: 12),
                            labelText: 'Password',
                            border: const OutlineInputBorder(),
                            enabledBorder: MyBorder.outlineInputBorder(context),
                            filled: true,
                            fillColor: Theme.of(context).cardColor,
                            suffix: SizedBox(
                              height: 32,
                              width: 28,
                              child: IconButton(
                                onPressed: () => setState(() =>
                                    _passwordIsVisibile = !_passwordIsVisibile),
                                splashRadius: 18,
                                iconSize: 18,
                                icon: Icon(
                                  _passwordIsVisibile
                                      ? Icons.visibility_off_outlined
                                      : Icons.visibility_outlined,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),

                      // Forgot Password Button
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                            onPressed: () {
                              Navigator.pushNamed(
                                  context, RouteName.forgotPasswordScreen);
                            },
                            child: Text(
                              'Forgot password ?',
                              style: TextStyle(
                                  color: Theme.of(context).primaryColor),
                            )),
                      ),
                      SizedBox(
                          height: MediaQuery.of(context).size.height * 0.02),

                      // Log in button
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                            onPressed: () => _submitForm(),
                            child: Text('Log In')),
                      ),
                    ],
                  ),
                ),

                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.06,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(child: Divider(thickness: 1)),
                      Text('  or   ',
                          style: Theme.of(context).textTheme.subtitle2),
                      Expanded(child: Divider(thickness: 1)),
                    ],
                  ),
                ),

                // Button Log In with Google
                _loginWithButton(
                  onPressed: _googleSignIn,
                  appLogoUrl: ImagePath.googleLogo,
                  title: 'Continue with Google',
                ),
                SizedBox(height: 16),
                _loginWithButton(
                  onPressed: () {},
                  appLogoUrl: ImagePath.facebookLogo,
                  title: 'Continue with Facebook',
                ),

                SizedBox(
                  height: 16,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Don\'t have an account? ',
                      style: Theme.of(context).textTheme.subtitle2,
                    ),
                    TextButton(
                        onPressed: () {
                          Navigator.pushNamed(context, RouteName.signUpScreen);
                        },
                        child: Text('Sign up'))
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _loginWithButton(
      {String title = '',
      String appLogoUrl = '',
      required Function() onPressed}) {
    return SizedBox(
      width: double.infinity,
      height: 40,
      child: Material(
        elevation: 0.6,
        borderRadius: BorderRadius.circular(4),
        color: Theme.of(context).cardColor,
        textStyle: Theme.of(context).textTheme.button,
        child: InkWell(
          onTap: onPressed,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                appLogoUrl,
                fit: BoxFit.contain,
                height: 16,
              ),
              SizedBox(width: 8),
              Text(
                title,
                style: Theme.of(context).textTheme.bodyText1,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
