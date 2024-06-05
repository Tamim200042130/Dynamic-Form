import 'package:dynamic_form/way_1_Not_Use_API/dynamic_form_page.dart';
import 'package:dynamic_form/way_2%20-%20Use%20API/form_data.dart';
import 'package:flutter/material.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      // home: const DynamicForm(),
      home:  FormData(),
    );
  }
}
