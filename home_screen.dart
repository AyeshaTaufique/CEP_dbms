import 'package:flutter/material.dart';
import 'manage_User.dart';
import 'manage_catagory.dart';
import 'manage_prod.dart';


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
              onPressed: ()  {
                // Show UserManagementBox when "User" button is pressed
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return CatagoryManagementBox();
                  },
              );},
            ),
            ButtonWithIcon(
              label: 'Product',
              icon: Icons.local_offer,
              onPressed: () {
                // Show UserManagementBox when "User" button is pressed
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return ProductManagementBox();
                  },
              );},
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
            borderRadius: BorderRadius.circular(0),
             // Square shape
          ),
        ),
      ),
    );
  }
}


