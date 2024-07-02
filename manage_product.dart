import 'package:flutter/material.dart';
import 'api_file.dart';
import 'manage_catagory.dart';


class ProductManagementBox extends StatefulWidget {
  @override
  _ProductManagementBoxState createState() => _ProductManagementBoxState();
}

class _ProductManagementBoxState extends State<ProductManagementBox> {
  final _formKey = GlobalKey<FormState>();
  final _productNameController = TextEditingController();
  final _priceController = TextEditingController();
  final _stockController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _categoryIdController = TextEditingController();

  final _searchController = TextEditingController();

  List<Map<String, dynamic>> _products = [];
  List<Map<String, dynamic>> _filteredProducts = [];

  @override
  void initState() {
    super.initState();
    _fetchProducts();
    _searchController.addListener(_filterProducts);
  }

  Future<void> _fetchProducts() async {
    try {
      var response = await ProductDataFromServer("fetch_product", {});
      if (response["success"] == true) {
        setState(() {
          _products = List<Map<String, dynamic>>.from(response["data"]);
          _filteredProducts = List.from(_products);
        });
      } else {
        print('Failed to load products');
      }
    } catch (e) {
      print('Error fetching products: $e');
    }
  }

  void _filterProducts() {
    setState(() {
      _filteredProducts = _products.where((product) {
        return product['product_name']
            .toLowerCase()
            .contains(_searchController.text.toLowerCase());
      }).toList();
    });
  }



 void showUpdateDialog(Map<String, dynamic> product) {
    _productNameController.text = product['product_name'] ?? '';
    _priceController.text = product['price']?.toString() ?? '';
    _stockController.text = product['stock']?.toString() ?? '';
    _descriptionController.text = product['description'] ?? '';
    _categoryIdController.text = product['category_id']?.toString() ?? '';

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Update Product'),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                TextFormField(
                  controller: _productNameController,
                  decoration: InputDecoration(labelText: 'Name'),
                ),
                TextFormField(
                  controller: _priceController,
                  decoration: InputDecoration(labelText: 'Price'),
                  keyboardType: TextInputType.number,
                ),
                TextFormField(
                  controller: _stockController,
                  decoration: InputDecoration(labelText: 'Stock'),
                  keyboardType: TextInputType.number,
                ),
                TextFormField(
                  controller: _descriptionController,
                  decoration: InputDecoration(labelText: 'Description'),
                ),
                TextFormField(
                  controller: _categoryIdController,
                  decoration: InputDecoration(labelText: 'Category ID'),
                  keyboardType: TextInputType.number,
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            ElevatedButton(
              child: Text('Update'),
              onPressed: () async {
                await updateProduct(product);
                Navigator.of(context).pop();
              },
            ),
            ElevatedButton(
              onPressed: () async {
                await deleteProduct(product);
                Navigator.of(context).pop();
              },
              child: Text('Delete'),
            ),
          ],
        );
      },
    );
  }

  Future<void> updateProduct(Map<String, dynamic> product) async {
    String productId = product['product_id']?.toString() ?? '0'; // Replace 'product_id' with your actual identifier

    try {
      var data = {
        "action": "update_product",
        "product_id": productId,
        "product_name": _productNameController.text,
        "price": _priceController.text,
        "stock": _stockController.text,
        "description": _descriptionController.text,
        "category_id": _categoryIdController.text,
      };

      var response = await ProductDataFromServer("update_product", data);

      if (response["success"] == true) {
        // Handle success, e.g., refresh product list
        _fetchProducts();
      } else {
        showErrorDialog('Failed to update product. Please try again.');
      }
    } catch (e) {
      print('Error updating product: $e');
      showErrorDialog('An unexpected error occurred. Please try again later.');
    }
  }

void _saveProduct() {
  if (_formKey.currentState!.validate()) {
    _productNameController.clear();
    _priceController.clear();
    _stockController.clear();
    _descriptionController.clear();
    _categoryIdController.clear();
  }
}


 Future<void> insert() async {
  String productName = _productNameController.text;
  String price = _priceController.text;
  String stock = _stockController.text;
  String description = _descriptionController.text;
  String categoryId = _categoryIdController.text;

  // Validate required fields
  if (productName.isEmpty || price.isEmpty || stock.isEmpty || categoryId.isEmpty) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Error'),
          content: Text('Please fill all required fields.'),
          actions: <Widget>[
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
    return;
  }

  try {
    var data = {
      "action": "add_product",
      "product_name": productName,
      "price": price,
      "stock": stock,
      "description": description,
      "category_id": categoryId,
    };

    var response = await ProductDataFromServer("add_product", data);

    if (response["success"] == true) {
      _saveProduct(); // Clear form fields after successful insert
      _fetchProducts(); // Refresh product list
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Error'),
            content: Text('Failed to add product. Please try again.'),
            actions: <Widget>[
              TextButton(
                child: Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }
  } catch (e) {
    print('Error adding product: $e');
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Error'),
          content: Text('An unexpected error occurred. Please try again later.'),
          actions: <Widget>[
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}

   Future<void> deleteProduct(Map<String, dynamic> product) async {
    String productId = product['product_id']?.toString() ?? '0'; // Replace 'product_id' with your actual identifier

    try {
      var data = {
        "action": "delete_product",
        "product_id": productId,
      };

      var response = await ProductDataFromServer("delete_product", data);

      if (response["success"] == true) {
        // Handle success, e.g., refresh product list
        _fetchProducts();
      } else {
        showErrorDialog('Failed to delete product. Please try again.');
      }
    } catch (e) {
      print('Error deleting product: $e');
      showErrorDialog('An unexpected error occurred. Please try again later.');
    }
  }

  void showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Error'),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

@override
Widget build(BuildContext context) {
  return AlertDialog(
    title: Text('Manage Product'),
    content: SizedBox(
      width: double.maxFinite,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 1,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    labelText: 'Search',
                    prefixIcon: Icon(Icons.search),
                  ),
                ),
                SizedBox(height: 10),
                Expanded(child:Scrollbar(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child:SingleChildScrollView(scrollDirection: Axis.horizontal,
                    child: DataTable(
                      columnSpacing: 20,
                      columns: [
                        DataColumn(label: Text('Update')),
                        DataColumn(label: Text('Name')),
                        DataColumn(label: Text('Price')),
                        DataColumn(label: Text('Stock')),
                        DataColumn(label: Text('Description')),
                        DataColumn(label: Text('Category ID')),
                      ],
                      rows: _filteredProducts.map<DataRow>((product) {
                        return DataRow(
                          cells: [
                            DataCell(IconButton(
                              icon: Icon(Icons.edit),
                              onPressed: () {
                                showUpdateDialog(product);
                              },
                            )),
                            DataCell(Text(product['product_name'] ?? '')),
                            DataCell(Text(product['price']?.toString() ?? '')),
                            DataCell(Text(product['stock']?.toString() ?? '')),
                            DataCell(Text(product['description'] ?? '')),
                            DataCell(Text(product['category_id']?.toString() ?? '')),
                          ],
                        );
                      }).toList(),
                    ),
                   ), ),
             ), ),
              ],
            ),
          ),
          SizedBox(width: 20),
          Expanded(
            flex: 1,
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Container(
                padding: EdgeInsets.all(16.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextFormField(
                        controller: _productNameController,
                        decoration: InputDecoration(labelText: 'Product Name'),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter a product name';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 10),
                      TextFormField(
                        controller: _priceController,
                        decoration: InputDecoration(labelText: 'Price'),
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter a price';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 10),
                      TextFormField(
                        controller: _stockController,
                        decoration: InputDecoration(labelText: 'Stock'),
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter the stock';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 10),
                      TextFormField(
                        controller: _descriptionController,
                        decoration: InputDecoration(labelText: 'Description'),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter a description';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 10),
                      TextFormField(
                        controller: _categoryIdController,
                        decoration: InputDecoration(labelText: 'Category ID'),
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter a category ID';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          ElevatedButton(
                            onPressed: insert,
                            child: Text('Save'),
                          ),
                        ],
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
    actions: [
      TextButton(
        onPressed: () {
          Navigator.of(context).pop();
        },
        child: Text('Close'),
      ),
    ],
  );
}
}
