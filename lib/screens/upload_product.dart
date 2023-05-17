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
  final _categories = CategoryModel().getCategories();
  FocusNode _brandFocusNode = new FocusNode();
  FocusNode _priceFocusNode = new FocusNode();
  FocusNode _quantityFocusNode = new FocusNode();
  FocusNode _categoryFocusNode = new FocusNode();
  FocusNode _descriptionFocusNode = new FocusNode();
  ProductModel _productModel = new ProductModel();
  final _formKey = new GlobalKey<FormState>();
  String _pickedImagePath = '';

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _productModel.category = _categories[0].name;
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
      Provider.of<UploadProductBloc>(context, listen: false).add(
          UploadProductEvent(product: _productModel, accessToken: accessToken));
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
                                _productModel.imageUrl = _pickedImagePath;
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
                            onSaved: (value) => _productModel.name = value!,
                          ),

                          // Brand Section
                          _sectionTitle('Brand'),
                          TextFormField(
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
                            onSaved: (value) => _productModel.brand = value!,
                          ),

                          // Price Section
                          _sectionTitle('Price'),
                          TextFormField(
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
                            onSaved: (value) =>
                                _productModel.price = double.parse(value!),
                          ),

                          // Quantity Section
                          _sectionTitle('Quantity'),
                          TextFormField(
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
                            onSaved: (value) =>
                                _productModel.stock = int.parse(value!),
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
                            value: _productModel.category,
                            onChanged: (String? value) {
                              setState(() {
                                _productModel.category = value.toString();
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
                            onSaved: (value) =>
                                _productModel.description = value!,
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
