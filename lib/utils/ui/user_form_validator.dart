import 'package:store_app/core/error/exceptions.dart';

class UserFormValidator {
  bool validate(
      {String? username,
      String? name,
      String? email,
      String? password,
      String? phoneNumber}) {
    final Map<String, String> errors = {};
    // Validate Username
    if (username != null) {
      if (username.isEmpty)
        errors['username'] = 'Username must not be empty.';
      else if (username.contains(RegExp(r'[^\w_]')))
        errors['username'] =
            'Invalid username, only alphanumeric and underscore allowed';
      else if (username.startsWith('_'))
        errors['username'] = 'Username should not start with underscore';
      else if (username.length > 30)
        errors['username'] = 'Username should not be more than 30 characters';
    }

    // Validate displayName
    if (name != null) {
      if (name.isEmpty)
        errors['name'] = 'Name must not be empty.';
      else if (name.length > 30)
        errors['name'] = 'Name should not be more than 30 characters';
    }

    // Validate email

    if (email != null) {
      if (email.isEmpty)
        errors['email'] = 'Email must not be empty.';
      else if (!email.contains(RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')))
        errors['email'] = 'Please input a valid email address';
    }

    //Validate password

    if (password != null) {
      if (password.length < 8)
        errors['password'] = 'Password must be at least 8 characters long';
    }

    //Validate phoneNumber

    if (phoneNumber != null) {
      if (phoneNumber.contains(RegExp(r'\D')))
        errors['phoneNumber'] = 'Please input a valid phone number';
    }

    if (errors.isEmpty) {
      return true;
    } else {
      throw InputException(message: 'Input Error', error: errors);
    }
  }
}
