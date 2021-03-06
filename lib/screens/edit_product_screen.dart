import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/models/product.dart';
import 'package:provider/provider.dart';

import '../providers/products_provider.dart';

class EditProductScreen extends StatefulWidget {
  static const routeName = "/edit_product";

  @override
  _EditProductScreenState createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  // we have to dispose them when the state gets disposed because they will leak memory!
  final _priceFocusNode = FocusNode();
  final _descriptionFocusNode = FocusNode();
  final _imageUrlFocusNode = FocusNode();
  final _imageUrlController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final _formProduct = FormProduct();

  // just to avoid multiple state changes from didChangeDependencies
  var _isInit = true;
  var _isLoading = false;

  @override
  void initState() {
    super.initState();
    // we have to remove listener or we will leak memory
    _imageUrlFocusNode.addListener(_updateImageUrl);
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      String productId = ModalRoute.of(context).settings.arguments as String;
      if (productId != null) {
        Product product = Provider.of<ProductsProvider>(context, listen: false)
            .findById(productId);
        _formProduct.updateValuesFromProduct(product);
        _imageUrlController.text = product.imageUrl;
      }
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  void _updateImageUrl() {
    if (!_imageUrlFocusNode.hasFocus && _isValidUrl(_imageUrlController.text)) {
      setState(() {});
    }
  }

  // return future due to async but we don't need it
  Future<void> _saveForm() async {
    bool isValid = _formKey.currentState.validate();
    if (isValid) {
      setState(() {
        _isLoading = true;
      });
      // will call on save for each text input field
      _formKey.currentState.save();
      try {
        var result = await Provider.of<ProductsProvider>(context, listen: false)
            .addOrEditProduct(_formProduct.toProduct());

        ScaffoldMessenger.of(context).hideCurrentSnackBar();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: (_formProduct.id.isEmpty)
                ? const Text('New product was added!')
                : const Text('Product was edited!'),
            duration: Duration(seconds: 1),
          ),
        );
      } catch (error) {
        // showDialog return a future, wait for user interaction before finally
        await showDialog<Null>(
          context: context,
          builder: (ctx) => AlertDialog(
            title: Text("An error occurred!"),
            content: Text("Something went wrong!"),
            actions: [
              FlatButton(
                onPressed: Navigator.of(ctx).pop,
                child: Text("Ok"),
              ),
            ],
          ),
        );
      } finally {
        setState(() {
          _isLoading = false;
        });
        Navigator.of(context).pop();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: (_formProduct.id.isEmpty)
            ? const Text("Add Product")
            : const Text("Edit Product"),
        actions: [
          IconButton(icon: Icon(Icons.save), onPressed: _saveForm),
        ],
      ),
      body: (_isLoading)
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                autovalidateMode: AutovalidateMode.disabled,
                key: _formKey,
                /* For very long FORMS (i.e. many input fields) OR in landscape mode (i.e. less vertical space on the screen),
        * because the ListView widget dynamically removes and re-adds widgets as they scroll out of and back into view.
        * we must use Column (combined with SingleChildScrollView) instead. */
                child: ListView(
                  children: [
                    TextFormField(
                      initialValue: _formProduct.title,
                      decoration: InputDecoration(labelText: "Title"),
                      textInputAction: TextInputAction.next,
                      // called when next button pressed on keyboard
                      onFieldSubmitted: (value) =>
                          FocusScope.of(context).requestFocus(_priceFocusNode),
                      onSaved: (value) {
                        _formProduct.title = value;
                      },
                      validator: (value) {
                        // returning null means the value is correct otherwise the string will be used as error message
                        return (value.isEmpty) ? "Please enter a title" : null;
                      },
                    ),
                    TextFormField(
                      initialValue: (_formProduct.price != null)
                          ? _formProduct.price.toString()
                          : "",
                      decoration: InputDecoration(labelText: "Price"),
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.number,
                      focusNode: _priceFocusNode,
                      onFieldSubmitted: (value) => FocusScope.of(context)
                          .requestFocus(_descriptionFocusNode),
                      onSaved: (value) {
                        _formProduct.price = double.parse(value);
                      },
                      validator: (value) {
                        if (value.isEmpty) {
                          return "Please enter a price";
                        }
                        final price = double.tryParse(value);
                        if (price == null) {
                          return "Please enter a valid number";
                        }
                        if (price <= 0) {
                          return "Please enter a positive price";
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      initialValue: _formProduct.description,
                      decoration: InputDecoration(labelText: "Description"),
                      maxLines: 3,
                      // shows enter on keyboard for new line, that has the side-effect
                      // we can't listen for onFieldSubmitted
                      keyboardType: TextInputType.multiline,
                      textInputAction: TextInputAction.next,
                      focusNode: _descriptionFocusNode,
                      onSaved: (value) {
                        _formProduct.description = value;
                      },
                      validator: (value) {
                        return (value.isEmpty)
                            ? "Please enter a description"
                            : (value.length < 5)
                                ? "description too short"
                                : null;
                      },
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Container(
                          width: 100,
                          height: 100,
                          margin: EdgeInsets.only(top: 80, right: 10.0),
                          decoration: BoxDecoration(
                            border: Border.all(width: 1, color: Colors.grey),
                          ),
                          child: (_imageUrlController.text.isEmpty)
                              ? Text("Enter a URL")
                              : FittedBox(
                                  child:
                                      Image.network(_imageUrlController.text),
                                  fit: BoxFit.cover,
                                ),
                        ),
                        Expanded(
                          child: TextFormField(
                            decoration: InputDecoration(labelText: 'Image URL'),
                            keyboardType: TextInputType.url,
                            textInputAction: TextInputAction.done,
                            controller: _imageUrlController,
                            focusNode: _imageUrlFocusNode,
                            onEditingComplete: () {
                              setState(() {});
                            },
                            onFieldSubmitted: (_) {
                              _saveForm();
                            },
                            onSaved: (value) {
                              _formProduct.imageUrl = value;
                            },
                            validator: (value) {
                              return (value.isEmpty)
                                  ? "Please enter a URL"
                                  : (_isValidUrl(value))
                                      ? null
                                      : "Please enter a valid URL";
                            },
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
    );
  }

  bool _isValidUrl(String url) {
    var urlPattern =
        r"(https?|ftp)://([-A-Z0-9.]+)(/[-A-Z0-9+&@#/%=~_|!:,.;]*)?(\?[A-Z0-9+&@#/%=~_|!:‌​,.;]*)?";
    return RegExp(urlPattern, caseSensitive: false).hasMatch(url);
  }

  @override
  void dispose() {
    _priceFocusNode.dispose();
    _descriptionFocusNode.dispose();
    _imageUrlController.dispose();
    _imageUrlFocusNode.removeListener(_updateImageUrl);
    _imageUrlFocusNode.dispose();
    super.dispose();
  }
}

// useful way to capture form data with mutable fields
class FormProduct {
  String id = "";
  String title = "";
  String description = "";
  double price;
  String imageUrl;

  void updateValuesFromProduct(final Product product) {
    id = product.id;
    title = product.title;
    description = product.description;
    price = product.price;
    imageUrl = product.imageUrl;
  }

  Product toProduct() {
    return Product(
        id: id,
        title: title,
        description: description,
        price: price,
        imageUrl: imageUrl);
  }
}
