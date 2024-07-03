import 'package:http/http.dart' as http;
import 'dart:convert';

Future<Map<String, dynamic>> postDataToServer(String action, Map<String, String> data) async {
  String uri = "http://127.0.0.1/User_table/User.php";
  var body = {"action": action, ...data}; // Combines action with additional data

  var res = await http.post(Uri.parse(uri), body: body);
  return jsonDecode(res.body);
}

Future<Map<String, dynamic>> CatagoryDataFromServer(String action, Map<String, String> data) async {
  String uri = "http://127.0.0.1/User_table/catagory.php";
  var body = {"action": action, ...data}; // Combines action with additional data

  var res = await http.post(Uri.parse(uri), body: body);
  return jsonDecode(res.body);
}

Future<Map<String, dynamic>> ProductDataFromServer(String action, Map<String, String> data) async {
  String uri = "http://127.0.0.1/User_table/product.php";
  var body = {"action": action, ...data}; // Combines action with additional data

  var res = await http.post(Uri.parse(uri), body: body);
  return jsonDecode(res.body);
}