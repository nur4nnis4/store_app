import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:store_app/providers/auth_provider.dart';

class MyAlertDialog {
  void removeCartItem(context, Function() func) {
    _showDialog(
        'Remove from cart',
        'Are you sure you want to remove this product from your cart?',
        'Remove',
        func,
        context);
  }

  void clearCart(context, Function() func) {
    _showDialog('Clear Cart', 'Are you sure you want to clear your cart?',
        'Clear', func, context);
  }

  Future<void> _showDialog(String title, String content, String buttonTitle,
      Function() func, BuildContext context) async {
    showDialog(
        context: context,
        builder: (BuildContext context) => AlertDialog(
              title: Text(
                title.toUpperCase(),
              ),
              content: Text(content),
              actions: [
                TextButton(
                  onPressed: func,
                  child: Text(buttonTitle.toUpperCase()),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text('Cancel'.toUpperCase()),
                )
              ],
            ));
  }

  /// Show sign out dialog
  static Future<void> signOut(context) async {
    showDialog(
        context: context,
        builder: (_) => AlertDialog(
              title: Text(
                'Sign Out'.toUpperCase(),
                style: TextStyle(
                  color: Theme.of(context).primaryColor,
                  fontWeight: FontWeight.w500,
                ),
              ),
              content: Text('Do you want to sign out?'),
              actions: [
                TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text('Cancel'.toUpperCase())),
                TextButton(
                    onPressed: () async {
                      await Provider.of<AuthProvider>(context, listen: false)
                          .signOut();
                      Navigator.pop(context);
                    },
                    child: Text('Sign Out'.toUpperCase())),
              ],
            ));
  }

  /// Display [AlertDialog] to pick image with [ImagePicker] and return the
  /// picked image path.
  static Future<dynamic> imagePicker(BuildContext context) async {
    return showDialog(
        context: context, builder: (context) => _ImagePickerDialog());
  }

  ///Show internet connection error dialog
  static Future<void> connectionError(BuildContext context) async {
    showDialog(
        context: context,
        builder: (BuildContext context) => AlertDialog(
              title: Text(
                'Oops!'.toUpperCase(),
                style: TextStyle(
                  color: Theme.of(context).primaryColor,
                  fontWeight: FontWeight.w500,
                  fontSize: 20,
                ),
              ),
              content: Text(
                  'It seems there is something wrong with your internet connection. Please connect to internet and try again.'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text('OK'),
                ),
              ],
            ));
  }

  ///Show internet connection error dialog
  static Future<void> error(BuildContext context, String errorText) async {
    showDialog(
        context: context,
        builder: (BuildContext context) => AlertDialog(
              title: Text(
                'Oops!'.toUpperCase(),
                style: TextStyle(
                  color: Theme.of(context).primaryColor,
                  fontWeight: FontWeight.w500,
                  fontSize: 20,
                ),
              ),
              content: Text(errorText),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text('OK'),
                ),
              ],
            ));
  }
}

class _ImagePickerDialog extends StatefulWidget {
  const _ImagePickerDialog({Key? key}) : super(key: key);

  @override
  _ImagePickerDialogState createState() => _ImagePickerDialogState();
}

class _ImagePickerDialogState extends State<_ImagePickerDialog> {
  Future<void> _pickImageCamera() async {
    final pickedImage = await ImagePicker()
        .pickImage(source: ImageSource.camera, imageQuality: 10);
    Navigator.pop(context, pickedImage!.path);
  }

  Future<void> _pickImageGallery() async {
    final pickedImage =
        await ImagePicker().pickImage(source: ImageSource.gallery);

    Navigator.pop(context, pickedImage!.path);
  }

  void _removeImage() async {
    Navigator.pop(context, '');
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        'Choose Option'.toUpperCase(),
        style: TextStyle(
          color: Theme.of(context).primaryColor,
          fontWeight: FontWeight.w500,
        ),
      ),
      content: SingleChildScrollView(
        child: ListBody(
          children: [
            ListTile(
              onTap: _pickImageCamera,
              leading: Icon(Icons.camera,
                  color: Theme.of(context).colorScheme.tertiary),
              title: Text('Camera'),
            ),
            ListTile(
              onTap: _pickImageGallery,
              leading: Icon(Icons.photo,
                  color: Theme.of(context).colorScheme.tertiary),
              title: Text('Gallery'),
            ),
            ListTile(
              onTap: _removeImage,
              leading: Icon(Icons.remove_circle,
                  color: Theme.of(context).colorScheme.tertiary),
              title: Text('Remove'),
            ),
          ],
        ),
      ),
    );
  }
}
