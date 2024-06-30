// import 'dart:html';
import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';


class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        alignment: Alignment.centerLeft, // Align content to the left
        padding: EdgeInsets.all(16.0), // Add padding around the content
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Welcome to Healthcare System!',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            ButtonWithIcon(
              label: 'User',
              icon: Icons.person,
              onPressed: ()  {
                // Show UserManagementBox when "User" button is pressed
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return UserManagementBox();
                  },
              );},),
            ButtonWithIcon(
              label: 'Category',
              icon: Icons.category,
              onPressed: () {
                // Add your navigation logic here
              },
            ),
            ButtonWithIcon(
              label: 'Product',
              icon: Icons.local_offer,
              onPressed: () {
                // Add your navigation logic here
              },
            ),
            ButtonWithIcon(
              label: 'Order',
              icon: Icons.shopping_cart,
              onPressed: () {
                // Add your navigation logic here
              },
            ),
            ButtonWithIcon(
              label: 'View Order',
              icon: Icons.view_list,
              onPressed: () {
                // Add your navigation logic here
              },
            ),
            ButtonWithIcon(
              label: 'Customer',
              icon: Icons.people,
              onPressed: () {
                // Add your navigation logic here
              },
            ),
            ButtonWithIcon(
              label: 'Logout',
              icon: Icons.logout,
              onPressed: () {
                Navigator.pop(context); // Navigate back to login screen
              },
            ),
          ],
        ),
      ),
    );
  }
}

class ButtonWithIcon extends StatelessWidget {
  final String label;
  final IconData icon;
  final VoidCallback onPressed;

  const ButtonWithIcon({
    Key? key,
    required this.label,
    required this.icon,
    required this.onPressed,
  }) : super(key: key);

  
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: ElevatedButton.icon(
        onPressed: onPressed,
        icon: Icon(icon, size: 24),
        label: Text(label),
        style: ElevatedButton.styleFrom(
          minimumSize: Size(250, 50), // Square button size
          padding: EdgeInsets.all(16.0),
          textStyle: TextStyle(fontSize: 18),
          
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(0), // Square shape
          ),
        ),
      ),
    );
  }
}



class UserManagementBox extends StatefulWidget {
  @override
  _UserManagementBoxState createState() => _UserManagementBoxState();
}

class _UserManagementBoxState extends State<UserManagementBox> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _addressController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneNumberController = TextEditingController();
  final _loginIdController = TextEditingController();
  final _passwordController = TextEditingController();
  String _status = 'Active';

  List<dynamic> _users = [];
  

  @override
  void initState() {
    super.initState();
    _fetchUsers();
  }

  Future<void> _fetchUsers() async {
    String uri = "http://127.0.0.1/User_table/User.php";
    var res = await http.post(Uri.parse(uri), body: {
      "action": "fetch_data",
    });
    var response = jsonDecode(res.body);
    if (response["success"] == true) {
      setState(() {
        _users = response["data"];
      });
    } else {
      print('Failed to load users');
    }
  }

 
      




Future<void> update() async {
    String name = _nameController.text;
    String address = _addressController.text;
    String email = _emailController.text;
    String ph_num = _phoneNumberController.text;
    String login_ID = _loginIdController.text; 
    String password = _passwordController.text;
    final status = _status;

    String uri = "http://127.0.0.1/User_table/User.php";
    var res = await http.post(Uri.parse(uri), body: {
      "action": "update_user",
      "login_ID": login_ID,
      "password": password,
      "email": email,
      "ph_num": ph_num,
      "status": status,
      "address": address,
      "name": name
    });
    var response = jsonDecode(res.body);
    if (response["success"] == true) {
      _saveUser();
      _fetchUsers();
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Error'),
            content: Text('Failed to update user. Please try again.'),
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






  void _saveUser() {
    if (_formKey.currentState!.validate()) {
      _nameController.clear();
      _addressController.clear();
      _emailController.clear();
      _phoneNumberController.clear();
      _loginIdController.clear();
      _passwordController.clear();
      setState(() {
        _status = 'Active';
      });
    }
  }

  Future<void> insert() async {
    String name = _nameController.text;
    String address = _addressController.text;
    String email = _emailController.text;
    String ph_num = _phoneNumberController.text;
    String login_ID = _loginIdController.text;
    String password = _passwordController.text;
    final status = _status;
  
   if (name.isEmpty ||
      address.isEmpty ||
      login_ID.isEmpty ||
      email.isEmpty ||
      password.isEmpty)
       {showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Error'),
            content: Text('Failed to add user. Please try again.'),
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
      );return;
    }
  


    String uri = "http://127.0.0.1/User_table/User.php";
    var res = await http.post(Uri.parse(uri), body: {
      "action": "add_user",
      "login_ID": login_ID,
      "password": password,
      "email": email,
      "ph_num": ph_num,
      "status": status,
      "address": address,
      "name": name
    });
    var response = jsonDecode(res.body);
    if (response["success"] == true) {
      _saveUser();
      _fetchUsers();
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Error'),
            content: Text('Failed to add user. Please try again.'),
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
   Future<void> delete() async {
  String login_ID = _loginIdController.text;
  String password = _passwordController.text;

  if (login_ID.isNotEmpty && password.isNotEmpty) {
    try {
      String uri = "http://127.0.0.1/User_table/User.php";
      var res = await http.post(Uri.parse(uri), body: {
        "action": "delete",
        "login_ID": login_ID,
        "password": password,
      });

      print("Response body: ${res.body}"); // Print raw response for debugging

      if (res.statusCode == 200) {
        var response = jsonDecode(res.body);

        if (response["success"] == true) {
          print("Deleted successfully");
          _saveUser();
          _fetchUsers();
          ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text("User deleted successfully"),
                duration: Duration(seconds: 2),
              ),
            );

            // Clear text fields after 2 seconds
            Future.delayed(Duration(seconds: 2), () {
              _loginIdController.clear();
              _passwordController.clear();
            });
        } else {
          print("Delete failed: ${response['message'] ?? 'Unknown error'}");
          // Show error message to user
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text('Error'),
                content: Text('Failed to delete user. Please try again.'),
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
      } else {
        print("Server error: ${res.statusCode}");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Server error: ${res.statusCode}")),
        );
      }
    } catch (e) {
      print("Error occurred: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error occurred: $e")),
      );
    }
  } else {
    print("Login ID and password cannot be empty");
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Login ID and password cannot be empty")),
    );
  }
}
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Manage User'),
      content: SizedBox(
        width: double.maxFinite,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: SingleChildScrollView(
  scrollDirection: Axis.horizontal,
  child: DataTable(
    columns: [
      DataColumn(label: Text('Name')),
      DataColumn(label: Text('User_ID')),
      DataColumn(label: Text('Email')),
      DataColumn(label: Text('Phone Number')),
      DataColumn(label: Text('Status')),
      DataColumn(label: Text('Address')),
    ],
    rows: _users.map<DataRow>((user) {
      return DataRow(
        cells: [
          DataCell(Text(user['Name'] ?? '')),
          DataCell(Text(user['login_ID'] ?? '')),
          DataCell(Text(user['Email'] ?? '')),
          DataCell(Text(user['ph_num'] ?? '')),
          DataCell(Text(user['Status'] ?? '')),
          DataCell(Text(user['Address'] ?? '')),
          
        ],
      );
    }).toList(),
  ),
),),

            SizedBox(width: 20),
            Expanded(
              child: SingleChildScrollView(
                child: Container(
                  padding: EdgeInsets.all(16.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextFormField(
                          controller: _nameController,
                          decoration: InputDecoration(labelText: 'Name'),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter a name';
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 10),
                        TextFormField(
                          controller: _addressController,
                          decoration: InputDecoration(labelText: 'Address'),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter an address';
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 10),
                        TextFormField(
                          controller: _emailController,
                          decoration: InputDecoration(labelText: 'Email'),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter an email';
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 10),
                        TextFormField(
                          controller: _phoneNumberController,
                          decoration:
                              InputDecoration(labelText: 'Phone Number'),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter a phone number';
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 10),
                        TextFormField(
                          controller: _loginIdController,
                          decoration: InputDecoration(labelText: 'Login ID'),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter a login ID';
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 10),
                        TextFormField(
                          controller: _passwordController,
                          decoration: InputDecoration(labelText: 'Password'),
                          obscureText: true,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter a password';
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 10),
                        DropdownButtonFormField<String>(
                          value: _status,
                          items: ['Active', 'Inactive']
                              .map((value) => DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(value),
                                  ))
                              .toList(),
                          onChanged: (value) {
                            setState(() {
                              _status = value!;
                            });
                          },
                          decoration: InputDecoration(
                            labelText: 'Status',
                            border: OutlineInputBorder(),
                          ),
                        ),
                        SizedBox(height: 10),
                        Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButton(
                  onPressed: insert,
                  child: Text('Save'),
                ),
                SizedBox(width: 10), // Adjust the width as needed
                ElevatedButton(
                  onPressed:update,
                  child: Text('Update'),
                ), SizedBox(width: 10), // Adjust the width as needed
                ElevatedButton(
                  onPressed:delete,
                  child: Text('Delete'),
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
            Navigator.of(context).pop(); // Close the dialog
          },
          child: Text('Close'),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _addressController.dispose();
    _emailController.dispose();
    _phoneNumberController.dispose();
    _loginIdController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
