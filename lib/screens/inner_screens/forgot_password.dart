import 'package:flutter/material.dart';
import 'package:store_app/core/constants/icons.dart';
import 'package:store_app/utils/ui/my_border.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({Key? key}) : super(key: key);

  @override
  _ForgotPasswordScreenState createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  late TextEditingController emailController = TextEditingController();
  final _formKey = new GlobalKey<FormState>();
  void _submitForm() async {
    final isValid = _formKey.currentState!.validate();
    if (isValid) {
      _formKey.currentState!.save();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Change Password'),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      ),
      body: Container(
        margin: EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 14),
                child: TextFormField(
                  key: ValueKey('Email'),
                  controller: emailController,
                  validator: (value) => value!.isEmpty || !value.contains('@')
                      ? 'Please enter a valid email address'
                      : null,
                  maxLines: 1,
                  textInputAction: TextInputAction.done,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    prefixIcon: Icon(mEmailIcon),
                    labelText: 'Email',
                    contentPadding: EdgeInsets.all(12),
                    border: const OutlineInputBorder(),
                    enabledBorder: MyBorder.outlineInputBorder(context),
                    filled: true,
                    fillColor: Theme.of(context).cardColor,
                  ),
                  onEditingComplete: _submitForm,
                ),
              ),

              // Reset button
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: () => _submitForm(),
                  child: Text('Change Password'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
