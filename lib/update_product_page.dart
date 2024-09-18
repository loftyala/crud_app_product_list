import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:crud_app_product_list/model/text_formField.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';

class UpdateProductPage extends StatefulWidget {
  const UpdateProductPage({super.key});

  @override
  State<UpdateProductPage> createState() => _UpdateProductPageState();
}

class _UpdateProductPageState extends State<UpdateProductPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  TextEditingController productName = TextEditingController();
  TextEditingController code = TextEditingController();
  TextEditingController image = TextEditingController();
  TextEditingController price = TextEditingController();
  TextEditingController qty = TextEditingController();
  TextEditingController totalPrice = TextEditingController();
  bool inProgress = false;

  @override
  void dispose() {
    productName.dispose();
    code.dispose();
    image.dispose();
    price.dispose();
    qty.dispose();
    totalPrice.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(leading: IconButton(onPressed: (){
        Navigator.pop(context);
      }, icon: Icon(Icons.arrow_back)),),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    SizedBox(height: 30),
                    Text(
                      'UPDATE PRODUCT',
                      style: TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 24),
                    ),
                    SizedBox(height: 20),

                    // First Row
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                "Product Name",
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              CustomTextFormField(
                                hintText: "Enter product name",
                                controller: productName,
                                validator: (String? value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter product name';
                                  }
                                  return null;
                                },
                              )
                            ],
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                "Product Code",
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              CustomTextFormField(
                                hintText: "Enter product code",
                                controller: code,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter product code';
                                  }
                                  return null;
                                },
                              )
                            ],
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                "Image",
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              CustomTextFormField(
                                hintText: "Put product image",
                                controller: image,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please add an image URL';
                                  }
                                  return null;
                                },
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // Second Row
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                "Unit Price",
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              CustomTextFormField(
                                controller: price,
                                hintText: "Enter unit price",
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter unit price';
                                  }
                                  return null;
                                },
                              )
                            ],
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                "QTY",
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              CustomTextFormField(
                                controller: qty,
                                hintText: "Enter product quantity",
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter quantity';
                                  }
                                  return null;
                                },
                              )
                            ],
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                "Total Price",
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              CustomTextFormField(
                                controller: totalPrice,
                                hintText: "Enter total price",
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter total price';
                                  }
                                  return null;
                                },
                              )
                            ],
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: 20),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.purple,
                        shape: RoundedRectangleBorder(),
                      ),
                      onPressed: OntapProductSaveButton,
                      child: Text('CONFIRM',
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 20)),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void OntapProductSaveButton() {
    if (_formKey.currentState!.validate()) {
      // If the form is valid, proceed with your save functionality
      addNewProduct();
    } else {
      print('Form is invalid');
    }
  }

  Future<void> addNewProduct() async {
    setState(() {
      inProgress = true;
    });

    Uri uri = Uri.parse("http://164.68.107.70:6060/api/v1/CreateProduct");
    Map<String, dynamic> requestBody = {
      "ProductName": productName.text,
      "ProductCode": code.text,
      "Img": image.text,
      "UnitPrice": price.text,
      "Qty": qty.text,
      "TotalPrice": totalPrice.text,
    };
    var response = await http.post(uri,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(requestBody));

    if (response.statusCode == 200) {

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("New product added successfully!"),
          backgroundColor: Colors.green,
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Failed to add product!"),
          backgroundColor: Colors.red,
        ),
      );
    }

    setState(() {
      inProgress = false;
    });
  }
}










































































/*
import 'package:flutter/material.dart';

import 'model/text_formField.dart';

class UpdateProduct extends StatefulWidget {
  const UpdateProduct({super.key});

  @override
  State<UpdateProduct> createState() => _UpdateProductState();
}

class _UpdateProductState extends State<UpdateProduct> {
  TextEditingController productName=TextEditingController();
  TextEditingController code=TextEditingController();
  TextEditingController image=TextEditingController();
  TextEditingController price=TextEditingController();
  TextEditingController qty=TextEditingController();
  TextEditingController totalPrice=TextEditingController();



  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView( // Scroll view for better flexibility
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SizedBox(height: 30,),
                  Text(
                    'UPDATE PRODUCT LIST',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
                  ),
                  SizedBox(height: 20,),
                  // First Row
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Product Name",
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            CustomTextFormField(
                                hintText: "Enter product name",
                            controller:productName ,
                            )
                          ],
                        ),
                      ),
                      const SizedBox(width: 8), // Space between columns
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Product Code",
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            CustomTextFormField(
                                hintText: "Enter product code",
                            controller: code,)
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Image",
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            CustomTextFormField(
                                hintText: "Put product image",
                            controller: image,)
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16), // Space between rows

                  // Second Row
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Unit Price",
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            CustomTextFormField(
                                controller: price,
                                hintText: "Enter unit price")
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "QTY",
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            CustomTextFormField(
                                controller: qty,
                                hintText: "Enter product quantity")
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Total Price",
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            CustomTextFormField(
                                controller: totalPrice,
                                hintText: "Enter total price")
                          ],
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 20,),
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.purple,
                        shape: RoundedRectangleBorder(),

                      ),
                      onPressed: (){
                        Navigator.pop(context);
                      },

                      child: Text('CONFIRM',style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 20),)),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
*/
