import 'package:flutter/material.dart';

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

  @override
  void initState() {
    super.initState();
    // we have to remove listener or we will leak memory
    _imageUrlFocusNode.addListener(_updateImageUrl);
  }

  void _updateImageUrl() {
    if (!_imageUrlFocusNode.hasFocus) {
      setState(() {});
    }
  }

  void _saveForm() {
    // will call on save for each text input field
    _formKey.currentState.save();
    print(_formProduct);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Edit Product"),
        actions: [
          IconButton(icon: Icon(Icons.save), onPressed: _saveForm),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          /* For very long FORMS (i.e. many input fields) OR in landscape mode (i.e. less vertical space on the screen),
        * because the ListView widget dynamically removes and re-adds widgets as they scroll out of and back into view.
        * we must use Column (combined with SingleChildScrollView) instead. */
          child: ListView(
            children: [
              TextFormField(
                decoration: InputDecoration(labelText: "Title"),
                textInputAction: TextInputAction.next,
                // called when next button pressed on keyboard
                onFieldSubmitted: (value) =>
                    FocusScope.of(context).requestFocus(_priceFocusNode),
                onSaved: (value) {
                  _formProduct.title = value;
                },
              ),
              TextFormField(
                  decoration: InputDecoration(labelText: "Price"),
                  textInputAction: TextInputAction.next,
                  keyboardType: TextInputType.number,
                  focusNode: _priceFocusNode,
                  onFieldSubmitted: (value) => FocusScope.of(context)
                      .requestFocus(_descriptionFocusNode),
                  onSaved: (value) {
                    _formProduct.price = double.parse(value);
                  }),
              TextFormField(
                  decoration: InputDecoration(labelText: "Description"),
                  maxLines: 3,
                  // shows enter on keyboard for new line, that has the side-effect
                  // we can't listen for onFieldSubmitted
                  keyboardType: TextInputType.multiline,
                  textInputAction: TextInputAction.next,
                  focusNode: _descriptionFocusNode,
                  onSaved: (value) {
                    _formProduct.description = value;
                  }),
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
                            child: Image.network(_imageUrlController.text),
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
  String id;
  String title;
  String description;
  double price;
  String imageUrl;
}
