//@dart=2.9
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/models/HttpException.dart';
import 'package:shop_app/provider/productProvider.dart';

class AddProductScreen extends StatefulWidget {
  static const routeName = "/add-product";

  @override
  _AddProductScreenState createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  final GlobalKey<FormState> _form = GlobalKey();
  final FocusNode priceScope = FocusNode();
  final FocusNode descriptionScope = FocusNode();
  File _image;
  final picker = ImagePicker();
  String selected = "Grocery";
  bool isInit = false;
  bool isEdit = false;
  var isLoading = false;
  Map<String, String> product = {
    'id': '',
    'name': '',
    'price': '',
    'description': '',
    'category': '',
    'path': '',
  };

  Future getImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
        print(_image.path);
      } else {
        print('No image selected.');
      }
    });
  }

  submit() async {
    if (!_form.currentState.validate()) return;
    _form.currentState.save();
    setState(() {
      isLoading = true;
    });
    try {
      if (!isEdit) {
        await Provider.of<ProductProvider>(context, listen: false)
            .addProduct(product);
      } else {
        await Provider.of<ProductProvider>(context, listen: false)
            .updateProduct(product);
      }
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(
            'Successful',
            style: TextStyle(
                color: Theme.of(context).brightness == Brightness.dark
                    ? null
                    : Colors.black),
          ),
          content: Text('Product added successfully!'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).pop();
              },
              child: Text(
                'Okay!',
                style: TextStyle(
                  color: Theme.of(context).accentColor,
                ),
              ),
            ),
          ],
        ),
      );
    } on HttpException catch (err) {
      openDialog(err.msg);
    }
    setState(() {
      isLoading = false;
    });
  }

  openDialog(String msg) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'An Error Occured!',
          style: TextStyle(
              color: Theme.of(context).brightness == Brightness.dark
                  ? null
                  : Colors.black),
        ),
        content: Text(msg),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text(
              "Okay!",
              style: TextStyle(
                color: Theme.of(context).accentColor,
              ),
            ),
          )
        ],
      ),
    );
  }

  @override
  void didChangeDependencies() {
    if (!isInit) {
      var productId = ModalRoute.of(context).settings.arguments as String;
      if (productId != null) {
        var lp = Provider.of<ProductProvider>(
          context,
          listen: false,
        ).findById(productId);
        product['name'] = lp.name;
        product['price'] = lp.price.toString();
        product['description'] = lp.description;
        product['category'] = lp.category;
        product['path'] = lp.image;
        product['id'] = productId;
        print(productId);
        setState(() {
          isEdit = true;
          isInit = true;
        });
      }
    }

    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Add Product',
          style: Theme.of(context).textTheme.headline6.copyWith(
                color: Theme.of(context).brightness == Brightness.dark
                    ? null
                    : Colors.white,
              ),
        ),
      ),
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Form(
              key: _form,
              child: Center(
                child: Container(
                  constraints: BoxConstraints(maxWidth: 800),
                  color: Theme.of(context).brightness == Brightness.dark
                      ? null
                      : Colors.white,
                  height: MediaQuery.of(context).size.height,
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(
                          height: 20,
                        ),
                        Container(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                width: 200,
                                height: 300,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(
                                    width: 2,
                                    color: Colors.grey.shade400,
                                  ),
                                ),
                                child: product['path'] != ''
                                    ? CachedNetworkImage(
                                        imageUrl: product['path'])
                                    : _image == null
                                        ? Icon(
                                            Icons.image_not_supported_outlined,
                                            color: Colors.grey,
                                            size: 50,
                                          )
                                        : Image.file(
                                            _image,
                                            fit: BoxFit.cover,
                                          ),
                              ),
                              SizedBox(
                                width: 20,
                              ),
                              Column(
                                children: [
                                  ElevatedButton(
                                    onPressed: getImage,
                                    child: Text(
                                      'Add Image',
                                      style: GoogleFonts.poppins(),
                                    ),
                                  ),
                                  Text(
                                    'Max size: 2MB',
                                    style: GoogleFonts.poppins(),
                                  )
                                ],
                              )
                            ],
                          ),
                        ),
                        SizedBox(height: 20),
                        Container(
                          margin: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 4),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 8),
                          child: DropdownButtonFormField(
                            items: [
                              DropdownMenuItem(
                                child: Text(
                                  'Grocery',
                                  style: GoogleFonts.poppins(),
                                ),
                                value: 'Grocery',
                              ),
                              DropdownMenuItem(
                                child: Text(
                                  'Mobile',
                                  style: GoogleFonts.poppins(),
                                ),
                                value: 'Mobiles',
                              ),
                              DropdownMenuItem(
                                child: Text(
                                  'Fashion',
                                  style: GoogleFonts.poppins(),
                                ),
                                value: 'Fashion',
                              ),
                              DropdownMenuItem(
                                child: Text(
                                  'Electronics',
                                  style: GoogleFonts.poppins(),
                                ),
                                value: 'Electronics',
                              ),
                              DropdownMenuItem(
                                child: Text(
                                  'Home',
                                  style: GoogleFonts.poppins(),
                                ),
                                value: 'Home',
                              ),
                              DropdownMenuItem(
                                child: Text(
                                  'Appliance',
                                  style: GoogleFonts.poppins(),
                                ),
                                value: 'Appliances',
                              ),
                              DropdownMenuItem(
                                child: Text(
                                  'Beauty, Toy & More',
                                  style: GoogleFonts.poppins(),
                                ),
                                value: 'Beauty, Toy & More',
                              ),
                            ],
                            value: product['category'] != ""
                                ? product['category']
                                : selected,
                            onChanged: (value) {
                              setState(() {
                                selected = value.toString();
                              });
                            },
                            onSaved: (newValue) =>
                                product['category'] = newValue,
                            decoration: InputDecoration(
                              icon: Icon(Icons.category_outlined),
                            ),
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 4),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 8),
                          child: TextFormField(
                            initialValue: product['name'],
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(4),
                                ),
                              ),
                              icon: Icon(Icons.shopping_basket_outlined),
                              labelText: 'Name',
                              labelStyle: GoogleFonts.poppins(),
                            ),
                            textInputAction: TextInputAction.next,
                            onFieldSubmitted: (value) =>
                                FocusScope.of(context).requestFocus(priceScope),
                            validator: (value) =>
                                value.isEmpty ? "Field is required!" : null,
                            onSaved: (newValue) {
                              product['name'] = newValue;
                            },
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 4),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 8),
                          child: TextFormField(
                            initialValue: product['price'],
                            focusNode: priceScope,
                            onFieldSubmitted: (value) => FocusScope.of(context)
                                .requestFocus(descriptionScope),
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(4),
                                ),
                              ),
                              icon: Container(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 4),
                                child: Text(
                                  '₹',
                                  style: TextStyle(
                                      fontSize: 28,
                                      color: Theme.of(context).brightness ==
                                              Brightness.dark
                                          ? Colors.white70
                                          : Colors.grey.shade600),
                                ),
                              ),
                              labelText: 'Price',
                              labelStyle: GoogleFonts.poppins(),
                            ),
                            keyboardType: TextInputType.number,
                            validator: (value) =>
                                value.isEmpty ? "Field is required!" : null,
                            onSaved: (newValue) => product['price'] = newValue,
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 4),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 8),
                          child: TextFormField(
                            initialValue: product['description'],
                            textInputAction: TextInputAction.next,
                            focusNode: descriptionScope,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(4),
                                ),
                              ),
                              icon: Icon(Icons.note_outlined),
                              labelText: 'Description',
                              labelStyle: GoogleFonts.poppins(),
                            ),
                            maxLines: 8,
                            validator: (value) =>
                                value.isEmpty ? "Field is required!" : null,
                            onSaved: (newValue) =>
                                product['description'] = newValue,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
      bottomNavigationBar: Container(
        // margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        width: double.infinity,
        height: 60,
        child: ElevatedButton(
          onPressed: () {
            if (_image == null && product['path'] == '') {
              openDialog('Image not Selected!');
            }
            product['path'] =
                product['path'] == '' ? _image.path : product['path'];
            submit();
          },
          child: Text(
            isEdit ? "Update" : 'Submit',
            style: GoogleFonts.poppins(fontSize: 18),
          ),
        ),
      ),
    );
  }
}
