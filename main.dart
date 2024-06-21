import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'home_screen.dart';

void main() {
  runApp(HealthCareInventoryApp());
}

class HealthCareInventoryApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Health Care Inventory System',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: LoginScreen(),
    );
  }
}

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController login_ID = TextEditingController();
  final TextEditingController password = TextEditingController();

  Future<void> login() async {
    print("yes5 here we are");
    String loginId = login_ID.text;
    String pass = password.text;

    if (loginId.isNotEmpty && pass.isNotEmpty) {
      try {
        String uri = "http://127.0.0.1/User_table/User.php";
        var res = await http.post(Uri.parse(uri), body: {
          "action":"login",
          "login_ID": loginId,
          "password": pass,
        });
        var response = jsonDecode(res.body);
        print(response);
        if (response["success"] == true) {
          print("login successfully");
           login_ID.clear();
          password.clear();
           Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => HomeScreen()),
          );
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
      } catch (e) {
        print(e);
      }
    } else {
      print("Please fill all fields!");
    }
  }

 

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Padding(
          padding: const EdgeInsets.only(top: 10.0),
          child: Text(
            'Health Care Inventory System',
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              fontStyle: FontStyle.normal,
            ),
          ),
        ),
        centerTitle: true,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: MediaQuery.of(context).size.width * 0.5,
                height: MediaQuery.of(context).size.width * 0.3,
                color: Colors.grey[300],
                child: Image.network(
                  'https://th.bing.com/th/id/OIP.KLKgGkyDWRfPfmedrxbhBgHaEK?w=1280&h=720&rs=1&pid=ImgDetMain',
                  fit: BoxFit.cover,
                ),
              ),
              SizedBox(width: 20),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Welcome',
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 20),
                    TextField(
                      controller: login_ID,
                      decoration: InputDecoration(
                        labelText: 'Login ID',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    SizedBox(height: 20),
                    TextField(
                      controller: password,
                      obscureText: true,
                      decoration: InputDecoration(
                        labelText: 'Password',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: login,
                      child: Text('Login'),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
