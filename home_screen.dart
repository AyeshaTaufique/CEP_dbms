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
  String _status='Active';

  void _saveUser() {
    if (_formKey.currentState!.validate()) {
      // All fields are valid
      // Add your save logic here, e.g., save to database

      // Clear all fields
      _nameController.clear();
      _addressController.clear();
      _emailController.clear();
      _phoneNumberController.clear();
      _loginIdController.clear();
      _passwordController.clear();
      setState(() {
        _status= 'Active' ;
      });
    }
  }

 


  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Manage User'),
      content: Container(
        width: double.maxFinite,
        child: SingleChildScrollView(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Container(
                  color: Colors.grey[200],
                  padding: EdgeInsets.all(16.0),
                  child: Center(
                    child: Text('Display Records from Database'),
                  ),
                ),
              ),
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
                            decoration: InputDecoration(labelText: 'Phone Number'),
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
                          ElevatedButton(
                            onPressed: insert,
                            child: Text('Save'),
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
  


  Future<void> insert() async {
    print("yes5 here we are inserting");

    
  String name= _nameController.text ;
  String address= _addressController.text ;
  String email= _emailController.text ;
  String ph_num=_phoneNumberController.text ;
  String login_ID =_loginIdController.text ;
  String password= _passwordController.text ;
   final status = _status ?? 'Active';

  String uri = "http://127.0.0.1/User_table/User.php";
  var res = await http.post(Uri.parse(uri), body: {
  "action":"add_user",
  "login_ID": login_ID,
  "password": password,
  "email":email,
  "ph_num":ph_num,
  "status":status,
  "address":address,
  "name":name
        });
        var response = jsonDecode(res.body);
        print(response);
        print("youuhooo");
        if (response["success"] == true) {
          print("successfully inserted");
          _saveUser();
        } else {
          // Show an error message
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text('Error'),
                content: Text('Wrong credentials. Please try again.'),
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
}