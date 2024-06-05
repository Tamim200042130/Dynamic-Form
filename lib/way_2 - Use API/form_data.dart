import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

class FormData extends StatefulWidget {
  const FormData({super.key});

  @override
  _FormDataState createState() => _FormDataState();
}

class _FormDataState extends State<FormData> {
  int ids = -1;
  List<dynamic> selectData = [];
  List<dynamic> radioData = [];
  List<dynamic> checkboxData = [];
  Map<String, dynamic> formData = {};
  var url = Uri.parse(
      'https://stoplight.io/mocks/khurramsoftware/data/20414976/getdata');

  // get API data
  Future ApiRequest() async {
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final responseBody = json.decode(response.body);
      return responseBody;
    } else {
      print(response.reasonPhrase);
    }
  }

  // dynamic row
  Widget _row(int index, String name, String fieldType, String id,
      List<dynamic>? fieldData) {
    Object? mySelection;
    if (fieldType == "select" && fieldData != null) selectData = fieldData;
    if (fieldType == "radio" && fieldData != null) radioData = fieldData;
    if (fieldType == "checkbox" && fieldData != null) checkboxData = fieldData;

    if (fieldType == "select") {
      return Container(
        padding: const EdgeInsets.fromLTRB(28, 15, 28, 28),
        child: InputDecorator(
          decoration: InputDecoration(
            labelText: name,
            focusColor: Colors.blue,
            enabledBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: Colors.deepOrangeAccent),
              borderRadius: BorderRadius.circular(10.0),
            ),
            border: OutlineInputBorder(
              borderSide: const BorderSide(color: Colors.deepOrangeAccent),
              borderRadius: BorderRadius.circular(10.0),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: Colors.deepOrangeAccent),
              borderRadius: BorderRadius.circular(20.0),
            ),
          ),
          child: Center(
            child: DropdownButton(
              style: const TextStyle(color: Colors.deepOrangeAccent),
              autofocus: true,
              hint: Text("Select $name"),
              items: selectData.map((t) {
                return DropdownMenuItem(
                  value: t["value"],
                  child: Text(t["text"]),
                );
              }).toList(),
              onChanged: (newVal) {
                setState(() {
                  mySelection = newVal;
                  formData[id] = [mySelection];
                });
              },
              value: mySelection,
            ),
          ),
        ),
      );
    } else if (fieldType == "radio") {
      return Container(
        padding: const EdgeInsets.fromLTRB(28, 15, 28, 28),
        child: InputDecorator(
          decoration: InputDecoration(
            labelText: name,
            fillColor: Colors.blue,
            enabledBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: Colors.deepOrangeAccent),
              borderRadius: BorderRadius.circular(10.0),
            ),
            border: OutlineInputBorder(
              borderSide: const BorderSide(color: Colors.deepOrangeAccent),
              borderRadius: BorderRadius.circular(20.0),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: Colors.deepOrangeAccent),
              borderRadius: BorderRadius.circular(20.0),
            ),
          ),
          child: Column(
            children: radioData.map((data) {
              var index = radioData.indexOf(data);
              return RadioListTile(
                title: Text("${data["text"]}"),
                groupValue: ids,
                activeColor: Colors.lightBlue,
                autofocus: true,
                value: index,
                onChanged: (val) {
                  setState(() {
                    ids = index;
                    formData[id] = [data["value"]];
                  });
                },
              );
            }).toList(),
          ),
        ),
      );
    } else if (fieldType == "checkbox") {
      return Container(
        padding: const EdgeInsets.fromLTRB(28, 15, 28, 28),
        child: InputDecorator(
          decoration: InputDecoration(
            labelText: name,
            fillColor: Colors.blue,
            enabledBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: Colors.deepOrangeAccent),
              borderRadius: BorderRadius.circular(10.0),
            ),
            border: OutlineInputBorder(
              borderSide: const BorderSide(color: Colors.deepOrangeAccent),
              borderRadius: BorderRadius.circular(20.0),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: Colors.deepOrangeAccent),
              borderRadius: BorderRadius.circular(20.0),
            ),
          ),
          child: Column(
            children: checkboxData.map((data) {
              return CheckboxListTile(
                title: Text("${data["text"]}"),
                value: formData[id]?.contains(data["value"]) ?? false,
                onChanged: (val) {
                  setState(() {
                    if (val == true) {
                      formData[id] = (formData[id] ?? [])..add(data["value"]);
                    } else {
                      formData[id]?.remove(data["value"]);
                    }
                  });
                },
              );
            }).toList(),
          ),
        ),
      );
    } else {
      return Padding(
        padding: const EdgeInsets.fromLTRB(28, 15, 28, 28),
        child: TextFormField(
          keyboardType: fieldType == "number" && id == "amount"
              ? const TextInputType.numberWithOptions(decimal: true)
              : fieldType == "text"
                  ? TextInputType.text
                  : TextInputType.phone,
          inputFormatters: [
            fieldType == "number" && id == "amount"
                ? FilteringTextInputFormatter.allow(RegExp("[. 0-9]"))
                : fieldType == "text"
                    ? FilteringTextInputFormatter.allow(
                        RegExp("[a-z A-Z á-ú Á-Ú 0-9]"))
                    : FilteringTextInputFormatter.digitsOnly,
          ],
          decoration: InputDecoration(
            labelText: name,
            enabledBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: Colors.deepOrangeAccent),
              borderRadius: BorderRadius.circular(10.0),
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
              borderSide: const BorderSide(color: Colors.deepOrangeAccent),
            ),
          ),
          onChanged: (val) {
            setState(() {
              formData[id] = [val];
            });
          },
        ),
      );
    }
  }

  // Post data
  Future<void> postData() async {
    var postUrl = Uri.parse(
        'https://stoplight.io/mocks/khurramsoftware/data/20414976/postdata');
    var response = await http.post(
      postUrl,
      headers: {"Content-Type": "application/json"},
      body: json.encode(formData),
    );

    if (response.statusCode == 200) {
      print('Data posted successfully');
    } else {
      print('Failed to post data: ${response.statusCode} - ${response.body}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dynamic Form'),
      ),
      body: SingleChildScrollView(
        physics: const ScrollPhysics(),
        child: FutureBuilder(
          future: ApiRequest(),
          builder: (context, AsyncSnapshot snapshot) {
            if (snapshot.hasError) {
              return Container(
                child: const Text('error'),
              );
            }
            if (snapshot.data != null) {
              return Column(
                children: [
                  const SizedBox(
                    height: 40,
                  ),
                  Container(
                    height: 120,
                    child: CircleAvatar(
                      radius: 80,
                      backgroundImage: NetworkImage(snapshot.data['image_url']),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Text(snapshot.data['service_name']),
                  const SizedBox(
                    height: 5,
                  ),
                  ListView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: snapshot.data!['fields'].length,
                    itemBuilder: (context, index) {
                      return _row(
                        index,
                        snapshot.data!['fields'][index]["name"],
                        snapshot.data!['fields'][index]["type"],
                        snapshot.data!['fields'][index]["id"],
                        snapshot.data!['fields'][index]["options"],
                      );
                    },
                  ),
                  ElevatedButton(
                    onPressed: postData,
                    child: const Text('Submit'),
                  ),
                ],
              );
            }
            return Padding(
              padding: const EdgeInsets.all(20.0),
              child: Container(child: const CircularProgressIndicator()),
            );
          },
        ),
      ),
    );
  }
}
