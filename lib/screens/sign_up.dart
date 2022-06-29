import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:store_app/models/user_model.dart';
import 'package:store_app/providers/auth_provider.dart';
import 'package:store_app/utils/ui/my_alert_dialog.dart';
import 'package:store_app/utils/ui/my_border.dart';
import 'package:store_app/widgets/image_preview.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  late FocusNode _passwordNode;
  late FocusNode _emailNode;
  late FocusNode _phoneNumberNode;
  String _pickedImagePath = '';
  final _formKey = new GlobalKey<FormState>();
  bool _passwordIsVisible = false;
  late UserModel _userModel;
  late String _password;
  late bool _isEmailValid;
  late bool _isLoading;
  String _emailErrorMessage = '';

  @override
  void initState() {
    super.initState();
    _userModel = new UserModel();
    _isLoading = false;
    _isEmailValid = true;
    _passwordNode = new FocusNode();
    _emailNode = new FocusNode();
    _phoneNumberNode = new FocusNode();
  }

  @override
  void dispose() {
    super.dispose();
    _passwordNode.dispose();
    _emailNode.dispose();
    _phoneNumberNode.dispose();
  }

  void _submitForm() async {
    final isValid = _formKey.currentState!.validate();
    FocusScope.of(context).unfocus();

    if (isValid) {
      _formKey.currentState!.save();
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      setState(() => _isLoading = true);

      authProvider
          .signUp(
              email: _userModel.email.toLowerCase().trim(),
              password: _password.trim(),
              userModel: _userModel)
          .then((_) {
        if (Navigator.canPop(context)) Navigator.pop(context);
      }).catchError((error) {
        if (error.toString().toLowerCase().contains('email')) {
          _isEmailValid = false;
          _emailErrorMessage = error.message.toString();
          _formKey.currentState!.validate();
        } else if (error.toString().toLowerCase().contains('network')) {
          MyAlertDialog.connectionError(context);
        } else {
          MyAlertDialog.error(context, error.message.toString());
        }
        print('Error: ${error.toString()}');
      }).whenComplete(() {
        _isEmailValid = true;
        setState(() => _isLoading = false);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
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

                // Upload Profile Picture
                Center(
                  child: Stack(children: [
                    ImagePreview(imagePath: _pickedImagePath),
                    Positioned(
                      right: 0,
                      bottom: 0,
                      child: SizedBox(
                        height: 26,
                        width: 26,
                        child: RawMaterialButton(
                          elevation: 5,
                          fillColor: Theme.of(context).primaryColor,
                          shape: CircleBorder(),
                          onPressed: () async {
                            MyAlertDialog.imagePicker(context)
                                .then((pickedImagePath) => setState(
                                    () => _pickedImagePath = pickedImagePath))
                                .then((_) =>
                                    _userModel.imageUrl = _pickedImagePath);
                          },
                          child: Icon(Icons.add_a_photo,
                              color: Colors.white, size: 14),
                        ),
                      ),
                    ),
                  ]),
                ),
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      // Full Name TextFormField
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: TextFormField(
                          key: ValueKey('Full Name'),
                          textCapitalization: TextCapitalization.words,
                          validator: (value) => value!.isEmpty
                              ? 'Please enter your full name'
                              : null,
                          maxLines: 1,
                          textInputAction: TextInputAction.next,
                          keyboardType: TextInputType.name,
                          decoration: InputDecoration(
                            labelText: 'Full Name',
                            contentPadding: EdgeInsets.all(12),
                            border: const OutlineInputBorder(),
                            enabledBorder: MyBorder.outlineInputBorder(context),
                            filled: true,
                            fillColor: Theme.of(context).cardColor,
                          ),
                          onEditingComplete: () =>
                              FocusScope.of(context).requestFocus(_emailNode),
                          onSaved: (value) => _userModel.fullName = value!,
                        ),
                      ),

                      // Email TextFormField
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: TextFormField(
                          key: ValueKey('Email'),
                          validator: (value) {
                            if (!_isEmailValid) {
                              return _emailErrorMessage;
                            }
                            return null;
                          },
                          focusNode: _emailNode,
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
                              .requestFocus(_phoneNumberNode),
                          onSaved: (value) => _userModel.email = value!,
                        ),
                      ),

                      // Phone Number TextFormField
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: TextFormField(
                          key: ValueKey('Phone Number'),
                          validator: (value) => value!.isEmpty
                              ? 'Please enter a valid phone number'
                              : null,
                          focusNode: _phoneNumberNode,
                          maxLines: 1,
                          textInputAction: TextInputAction.next,
                          keyboardType: TextInputType.phone,
                          decoration: InputDecoration(
                            labelText: 'Phone Number',
                            contentPadding: EdgeInsets.all(12),
                            border: const OutlineInputBorder(),
                            enabledBorder: MyBorder.outlineInputBorder(context),
                            filled: true,
                            fillColor: Theme.of(context).cardColor,
                          ),
                          onEditingComplete: () => FocusScope.of(context)
                              .requestFocus(_passwordNode),
                          onSaved: (value) => _userModel.phoneNumber = value!,
                        ),
                      ),

                      // Password TextFormField
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 14.0),
                        child: TextFormField(
                          key: ValueKey('Password'),
                          validator: (value) => value!.isEmpty ||
                                  value.length < 8
                              ? 'Password must be at least 8 characters long'
                              : null,
                          maxLines: 1,
                          focusNode: _passwordNode,
                          keyboardType: TextInputType.visiblePassword,
                          onEditingComplete: _submitForm,
                          obscureText: !_passwordIsVisible,
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
                                    _passwordIsVisible = !_passwordIsVisible),
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
                          onSaved: (value) => _password = value!,
                        ),
                      ),

                      SizedBox(
                          height: MediaQuery.of(context).size.height * 0.02),

                      // Sign Up button
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                          onPressed: _isLoading
                              ? () {}
                              : () {
                                  _submitForm();
                                  FocusScope.of(context).unfocus();
                                },
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                _isLoading
                                    ? CircularProgressIndicator(
                                        color: Colors.white,
                                      )
                                    : Text('Sign Up'),
                              ]),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
