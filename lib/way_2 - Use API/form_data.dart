import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'models/api_response.dart';

class FormData extends StatefulWidget {
  const FormData({Key? key}) : super(key: key);

  @override
  _FormDataState createState() => _FormDataState();
}

class _FormDataState extends State<FormData> {
  Map<String, dynamic> formData = {};
  ApiResponse? apiResponse;

  final url = Uri.parse('https://ukm.justrack.com.my/api/v2/feedback_get');

  @override
  void initState() {
    super.initState();
    fetchApiData();
  }

  Future<void> fetchApiData() async {
    final response = await http.post(
      url,
      headers: {
        'Authx': '86823db5a7c429c873e5b66b4eccaf1f63c813e0',
        'Content-Type': 'application/json'
      },
      body: json.encode({'user': 'ukmbus'}),
    );

    if (response.statusCode == 200) {
      setState(() {
        apiResponse = ApiResponse.fromJson(json.decode(response.body));
      });
    } else {
      print(response.reasonPhrase);
    }
  }

  Widget _row(int index, FeedbackField field) {
    if (field.type == "checkbox") {
      return Container(
        padding: const EdgeInsets.fromLTRB(28, 15, 28, 28),
        child: InputDecorator(
          decoration: InputDecoration(
            labelText: field.field,
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
            children: field.values.map((data) {
              return CheckboxListTile(
                title: Text(data),
                value: formData[field.field]?.contains(data) ?? false,
                onChanged: (val) {
                  setState(() {
                    if (val == true) {
                      formData[field.field] = (formData[field.field] ?? [])
                        ..add(data);
                    } else {
                      formData[field.field]?.remove(data);
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
          keyboardType: field.type == "number"
              ? TextInputType.number
              : TextInputType.text,
          inputFormatters: [
            field.type == "number"
                ? FilteringTextInputFormatter.allow(RegExp("[. 0-9]"))
                : FilteringTextInputFormatter.allow(
                    RegExp("[a-z A-Z á-ú Á-Ú 0-9]")),
          ],
          decoration: InputDecoration(
            labelText: field.field,
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
              formData[field.field] = val;
            });
          },
        ),
      );
    }
  }

  Future<void> postData() async {
    var postUrl = Uri.parse('https://ukm.justrack.com.my/api/v2/feedback_post');
    var response = await http.post(
      postUrl,
      headers: {
        'Authx': '86823db5a7c429c873e5b66b4eccaf1f63c813e0',
        'Content-Type': 'application/json',
        'Authorization': 'Bearer eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9'
      },
      body: json.encode({
        'user': 'ukmbus',
        'response': formData.entries.map((e) {
          return {'key': e.key, 'value': e.value};
        }).toList()
      }),
    );

    if (response.statusCode == 200) {
      print(
          'Data posted successfully ${response.body} - ${response.statusCode} - ${response.reasonPhrase} - ${response.request} - ${response.headers}');
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
        child: apiResponse == null
            ? Padding(
                padding: const EdgeInsets.all(20.0),
                child: Container(child: const CircularProgressIndicator()),
              )
            : Column(
                children: [
                  const SizedBox(
                    height: 40,
                  ),
                  ListView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: apiResponse!.responseData.feedbackFields.length,
                    itemBuilder: (context, index) {
                      final field =
                          apiResponse!.responseData.feedbackFields[index];
                      return _row(
                        index,
                        field,
                      );
                    },
                  ),
                  Padding(
                    padding: const EdgeInsets.all(28.0),
                    child: SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          postData();
                        },
                        child: const Text('Submit'),
                      ),
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
