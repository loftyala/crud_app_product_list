import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:crud_app_product_list/model/text_formField.dart';
import 'package:http/http.dart' as http;

class UpdateProductPage extends StatefulWidget {
  final String productId;  // Product ID passed from the previous screen
  final Map<String, dynamic> productData; // Pre-filled product data

  const UpdateProductPage({
    Key? key,
    required this.productId,
    required this.productData,
  }) : super(key: key);

  @override
  State<UpdateProductPage> createState() => _UpdateProductPageState();
}

class _UpdateProductPageState extends State<UpdateProductPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  late TextEditingController productName;
  late TextEditingController code;
  late TextEditingController image;
  late TextEditingController price;
  late TextEditingController qty;
  late TextEditingController totalPrice;
  bool inProgress = false;

  @override
  void initState() {
    super.initState();
    // Initialize controllers with the existing product data
    productName = TextEditingController(text: widget.productData['ProductName']);
    code = TextEditingController(text: widget.productData['ProductCode']);
    image = TextEditingController(text: widget.productData['Img']);
    price = TextEditingController(text: widget.productData['UnitPrice'].toString());
    qty = TextEditingController(text: widget.productData['Qty'].toString());
    totalPrice = TextEditingController(text: widget.productData['TotalPrice'].toString());
  }

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
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back),
        ),
      ),
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
                    buildTextFieldRow(),
                    const SizedBox(height: 16),
                    // Second Row
                    buildPriceQtyRow(),
                    SizedBox(height: 20),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.purple,
                        shape: RoundedRectangleBorder(),
                      ),
                      onPressed: OntapProductUpdateButton,
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

  Widget buildTextFieldRow() {
    return Row(
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
              ),
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
              ),
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
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget buildPriceQtyRow() {
    return Row(
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
              ),
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
              ),
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
              ),
            ],
          ),
        ),
      ],
    );
  }

  void OntapProductUpdateButton() {
    if (_formKey.currentState!.validate()) {
      // If the form is valid, proceed with the update functionality
      updateProduct();
    } else {
      print('Form is invalid');
    }
  }

  Future<void> updateProduct() async {
    setState(() {
      inProgress = true;
    });

    Uri uri = Uri.parse("http://164.68.107.70:6060/api/v1/UpdateProduct/${widget.productId}");
    Map<String, dynamic> requestBody = {
      "ProductName": productName.text,
      "ProductCode": code.text,
      "Img": image.text,
      "UnitPrice": price.text,
      "Qty": qty.text,
      "TotalPrice": totalPrice.text,
    };

    var response = await http.put(
      uri,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(requestBody),
    );

    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Product updated successfully!"),
          backgroundColor: Colors.green,
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Failed to update product!"),
          backgroundColor: Colors.red,
        ),
      );
    }

    setState(() {
      inProgress = false;
    });
  }
}
