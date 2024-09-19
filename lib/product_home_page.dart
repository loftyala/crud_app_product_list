 import 'dart:convert';
import 'package:crud_app_product_list/newProductList.dart';
import 'package:crud_app_product_list/update_product_page.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'model/productModel.dart';

class ProductHomePage extends StatefulWidget {
  const ProductHomePage({super.key});

  @override
  State<ProductHomePage> createState() => _ProductHomePageState();
}

class _ProductHomePageState extends State<ProductHomePage> {
  List<ProductModel> productList = [];
  bool inProgress = false;

  @override
  void initState() {
    getProductList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.withOpacity(.2),
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Row(
          children: [
            Icon(Icons.baby_changing_station_outlined, color: Colors.purple),
            SizedBox(width: 8),
            Text(
              'CRUD',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
            ),
          ],
        ),
        elevation: 10,
        shadowColor: Colors.white,
        actions: [
          IconButton(
              onPressed: () {
                getProductList();
              },
              icon: Icon(Icons.refresh))
        ],
      ),
      body: inProgress
          ? Center(child: CircularProgressIndicator())
          : Padding(
        padding: const EdgeInsets.all(8.0),
        child: Card(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Text(
                  'Product List',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 24,
                    color: Colors.black,
                  ),
                ),
              ),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text(
                    "PRODUCT",
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey,
                    ),
                  ),
                  Text(
                    "UNIT PRICE",
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey,
                    ),
                  ),
                  Text(
                    "QTY",
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey,
                    ),
                  ),
                  Text(
                    "TOTAL PRICE",
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    "ACTION",
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10),
              Container(
                height: 1,
                width: MediaQuery.of(context).size.width * 6,
                color: Colors.grey,
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: productList.length,
                  itemBuilder: (context, index) {
                    final product = productList[index];
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Card(
                        elevation: 2,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment:
                            MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  product.img != null &&
                                      product.img!.isNotEmpty
                                      ? Image.network(
                                    product.img!,
                                    fit: BoxFit.cover,
                                    height: 40,
                                    width: 40,
                                    errorBuilder: (context, error,
                                        stackTrace) {
                                      return Image.asset(
                                        "images/task.jpeg",
                                        fit: BoxFit.cover,
                                        height: 40,
                                        width: 40,
                                      );
                                    },
                                  )
                                      : Image.asset(
                                    "images/task.jpeg",
                                    fit: BoxFit.cover,
                                    height: 40,
                                    width: 40,
                                  ),
                                  SizedBox(width: 8),
                                  Column(
                                    crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        product.productName ?? 'Title',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black,
                                          fontSize: 16,
                                        ),
                                      ),
                                      Text(
                                        product.productCode ?? 'Subtitle',
                                        style: TextStyle(
                                          fontWeight: FontWeight.normal,
                                          color: Colors.grey,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              Text(
                                "\$${product.unitPrice}",
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                "${product.qty}",
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                "\$${product.totalPrice}",
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              OverflowBar(
                                children: [
                                  Container(
                                    color: Colors.red,
                                    child: IconButton(
                                      onPressed: () {
                                        deleteProduct(product.sId, index);
                                      },
                                      icon: Icon(
                                        Icons.delete,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                  Container(
                                    color: Colors.green,
                                    child: IconButton(
                                      onPressed: () {
                                        Navigator.of(context).push(
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    UpdateProductPage()));
                                      },
                                      icon: Icon(
                                        Icons.edit_note,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (context) => NewProductAdd()));
        },
        backgroundColor: Color(0xFFF5EEFA),
        child: Text(
          'Create\n New',
          style: TextStyle(
              fontSize: 10, color: Colors.purple, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  void getProductList() async {
    inProgress = true;

    Uri uri = Uri.parse("http://164.68.107.70:6060/api/v1/ReadProduct");
    Response response = await http.get(uri);
    if (response.statusCode == 200) {
      Map<String, dynamic> jsonResponse = jsonDecode(response.body);
      for (var item in jsonResponse['data']) {
        ProductModel product = ProductModel.fromJson(item);
        setState(() {
          productList.insert(0, product);
        });
      }
    } else {
      print('Failed to load products: ${response.statusCode}');
      productList.clear();
      setState(() {});
    }
    inProgress = false;
  }

  void deleteProduct(String? productId, int index) async {
    if (productId == null) return;

    Uri uri = Uri.parse("http://164.68.107.70:6060/api/v1/DeleteProduct/$productId");
    Response response = await http.delete(uri);

    if (response.statusCode == 200) {
      var jsonResponse = jsonDecode(response.body);
      if (jsonResponse['acknowledged'] == true &&
          jsonResponse['deletedCount'] > 0) {
        setState(() {
          productList.removeAt(index);
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Product deleted successfully.")),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Failed to delete product.")),
        );
      }
    } else {
      print('Failed to delete product: ${response.statusCode}');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to delete product.")),
      );
    }
  }
}
