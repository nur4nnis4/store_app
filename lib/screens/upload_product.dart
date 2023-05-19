import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:store_app/bloc/auth_bloc/auth_bloc.dart';
import 'package:store_app/bloc/product_bloc/fetch_products_bloc/fetch_products_bloc.dart';
import 'package:store_app/bloc/product_bloc/upload_product_bloc/upload_product_bloc.dart';
import 'package:store_app/models/category_model.dart';
import 'package:store_app/models/product_model.dart';
import 'package:store_app/widgets/my_alert_dialog.dart';
import 'package:store_app/widgets/my_border.dart';
import 'package:store_app/authenticate.dart';
import 'package:store_app/widgets/custom_snackbar.dart';
import 'package:store_app/widgets/image_preview.dart';

class UploadProductScreen extends StatefulWidget {
  const UploadProductScreen({Key? key}) : super(key: key);

  @override
  _UploadProductScreenState createState() => _UploadProductScreenState();
}

class _UploadProductScreenState extends State<UploadProductScreen> {
  final _categories = CategoryModel.getCategories();
  late String _pickedCategory;
  late TextEditingController _nameController = TextEditingController();
  late TextEditingController _brandController = TextEditingController();
  late TextEditingController _priceController = TextEditingController();
  late TextEditingController _stockController = TextEditingController();
  late TextEditingController _descriptionController = TextEditingController();

  FocusNode _brandFocusNode = FocusNode();
  FocusNode _priceFocusNode = FocusNode();
  FocusNode _quantityFocusNode = FocusNode();
  FocusNode _categoryFocusNode = FocusNode();
  FocusNode _descriptionFocusNode = FocusNode();
  final _formKey = GlobalKey<FormState>();
  String _pickedImagePath = '';

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _pickedCategory = _categories[0].name;
  }

  @override
  void dispose() {
    super.dispose();
    _brandFocusNode.dispose();
    _priceFocusNode.dispose();
    _quantityFocusNode.dispose();
    _categoryFocusNode.dispose();
    _descriptionFocusNode.dispose();
  }

  void _submitForm({required String accessToken}) async {
    final isValid = _formKey.currentState!.validate();
    if (isValid) {
      _formKey.currentState!.save();

      final product = ProductModel(
        name: _nameController.text.trim(),
        price: double.parse(_priceController.text.trim()),
        brand: _brandController.text.trim(),
        description: _descriptionController.text.trim(),
        imageUrl: _pickedImagePath,
        category: _pickedCategory,
        stock: int.parse(_stockController.text.trim()),
      );
      Provider.of<UploadProductBloc>(context, listen: false)
          .add(UploadProductEvent(product: product, accessToken: accessToken));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Authenticate(
      child: BlocListener<UploadProductBloc, UploadProductState>(
        listener: (context, state) {
          if (state is UploadProductLoading) {
            ScaffoldMessenger.of(context).showSnackBar(
                CustomSnackbar.loadingSnackbar(context, text: 'Uploading...'));
          } else if (state is UploadProductSuccess) {
            // Refresh products
            context.read<FetchProductsBloc>().add(FetchProductsEvent());

            // Show success snackbar
            ScaffoldMessenger.of(context).showSnackBar(
                CustomSnackbar.snackbarAlert(context, content: 'Success'));
          } else if (state is UploadProductError) {
            MyAlertDialog.error(context, state.message);
          }
        },
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Scaffold(
            appBar: AppBar(
              title: Text('New Product'),
              centerTitle: true,
              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            ),
            body: SingleChildScrollView(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(18.0),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Upload Picture Section
                          Center(
                            child: InkWell(
                              onTap: () async {
                                final pickedImagePath =
                                    await MyAlertDialog.imagePicker(context);
                                setState(
                                    () => _pickedImagePath = pickedImagePath);
                              },
                              child: Stack(
                                alignment: Alignment.center,
                                children: [
                                  ImagePreview(
                                    imagePath: _pickedImagePath,
                                    height: 190,
                                    width: 190,
                                  ),
                                  Icon(
                                    Icons.add_circle,
                                    size: 30,
                                    color: Colors.grey[500],
                                  ),
                                ],
                              ),
                            ),
                          ),

                          // Name Section
                          _sectionTitle('Name'),
                          TextFormField(
                            controller: _nameController,
                            textCapitalization: TextCapitalization.words,
                            textInputAction: TextInputAction.next,
                            validator: (value) =>
                                value!.isEmpty ? 'Requiered' : null,
                            decoration: InputDecoration(
                              hintText: 'Add product name...',
                              enabledBorder:
                                  MyBorder.underlineInputBorder(context),
                            ),
                            onEditingComplete: () => FocusScope.of(context)
                                .requestFocus(_brandFocusNode),
                          ),

                          // Brand Section
                          _sectionTitle('Brand'),
                          TextFormField(
                            controller: _brandController,
                            textCapitalization: TextCapitalization.words,
                            textInputAction: TextInputAction.next,
                            focusNode: _brandFocusNode,
                            validator: (value) =>
                                value!.isEmpty ? 'Requiered' : null,
                            decoration: InputDecoration(
                              hintText: 'Add product brand...',
                              enabledBorder:
                                  MyBorder.underlineInputBorder(context),
                            ),
                            onEditingComplete: () => FocusScope.of(context)
                                .requestFocus(_priceFocusNode),
                          ),

                          // Price Section
                          _sectionTitle('Price'),
                          TextFormField(
                            controller: _priceController,
                            keyboardType: TextInputType.number,
                            textInputAction: TextInputAction.next,
                            focusNode: _priceFocusNode,
                            // inputFormatters: [
                            //   FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                            // ],
                            validator: (value) =>
                                value!.isEmpty ? 'Requiered' : null,
                            decoration: InputDecoration(
                              hintText: 'Add product price...',
                              enabledBorder:
                                  MyBorder.underlineInputBorder(context),
                            ),
                            onEditingComplete: () => FocusScope.of(context)
                                .requestFocus(_quantityFocusNode),
                          ),

                          // Quantity Section
                          _sectionTitle('Stock'),
                          TextFormField(
                            controller: _stockController,
                            keyboardType: TextInputType.number,
                            textInputAction: TextInputAction.next,
                            focusNode: _quantityFocusNode,
                            validator: (value) =>
                                value!.isEmpty ? 'Requiered' : null,
                            decoration: InputDecoration(
                              hintText: 'Add product quantity...',
                              enabledBorder:
                                  MyBorder.underlineInputBorder(context),
                            ),
                            onEditingComplete: () => FocusScope.of(context)
                                .requestFocus(_categoryFocusNode),
                          ),

                          // Category section
                          _sectionTitle('Category'),
                          DropdownButtonFormField(
                            focusNode: _categoryFocusNode,
                            onTap: () {
                              FocusScope.of(context)
                                  .requestFocus(_descriptionFocusNode);
                            },
                            items: _categories
                                .map(
                                  (category) => DropdownMenuItem<String>(
                                    child: Text(category.name),
                                    value: category.name,
                                  ),
                                )
                                .toList(),
                            value: _pickedCategory,
                            onChanged: (String? value) {
                              setState(() {
                                _pickedCategory = value.toString();
                              });
                            },
                            decoration: InputDecoration(
                              enabledBorder:
                                  MyBorder.underlineInputBorder(context),
                            ),
                          ),

                          // Description Section
                          _sectionTitle('Description'),
                          SizedBox(height: 10),
                          TextFormField(
                            controller: _descriptionController,
                            keyboardType: TextInputType.multiline,
                            maxLines: 10,
                            textCapitalization: TextCapitalization.sentences,
                            textInputAction: TextInputAction.done,
                            focusNode: _descriptionFocusNode,
                            decoration: InputDecoration(
                              hintText: 'Add product description...',
                              border: OutlineInputBorder(),
                              enabledBorder:
                                  MyBorder.outlineInputBorder(context),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Upload Product Button

                  Container(
                    height: 60,
                    width: MediaQuery.of(context).size.width,
                    child: Material(
                      color: Theme.of(context).primaryColor,
                      child: InkWell(
                        onTap: () {
                          final currentAuthBlocState =
                              BlocProvider.of<AuthBloc>(context).state;
                          if (currentAuthBlocState is AuthAuthenticated) {
                            _submitForm(
                                accessToken: currentAuthBlocState.authToken);
                          }
                        },
                        child: Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Upload',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  letterSpacing: 0.5,
                                ),
                              ),
                              SizedBox(width: 8),
                              _isLoading
                                  ? CircularProgressIndicator(
                                      color: Colors.white,
                                    )
                                  : Icon(
                                      Icons.cloud_upload_outlined,
                                      color: Colors.white,
                                    ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(top: 24, bottom: 14),
      child: Text(
        title,
        style: Theme.of(context).textTheme.headline3,
      ),
    );
  }
}
