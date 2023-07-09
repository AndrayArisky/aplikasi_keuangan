import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class MyWidget extends StatefulWidget {
  @override
  MyWidgetState createState() => MyWidgetState();
}

class MyWidgetState extends State<MyWidget> {

// TextEditingController
TextEditingController namaController = TextEditingController();
TextEditingController emailController = TextEditingController();

// Fungsi untuk mengambil data dari API
Future<List<Map<String, dynamic>>> fetchData() async {
  final response = await http.get(Uri.parse('https://apkeu2023.000webhostapp.com/getUser.php'));

  if (response.statusCode == 200) {
    List<dynamic> data = json.decode(response.body);
    return data.cast<Map<String, dynamic>>();
  } else {
    throw Exception('Failed to fetch data from API');
  }
}

// Fungsi untuk menambah data ke API
Future<bool> addData(String nama, String email) async {
  final response = await http.post(
    Uri.parse('https://apkeu2023.000webhostapp.com/addUser.php'),
    body: {
      'nama': nama,
      'email': email,
    },
  );

  if (response.statusCode == 200) {
    dynamic responseData = json.decode(response.body);
    return responseData['success'] == 1;
  } else {
    throw Exception('Failed to add data to API');
  }
}

// Fungsi untuk mengedit data di API
Future<bool> editData(int id, String nama, String email) async {
  final response = await http.post(
    Uri.parse('https://apkeu2023.000webhostapp.com/editUser.php'),
    body: {
      'id': id.toString(),
      'nama': nama,
      'email': email,
    },
  );

  if (response.statusCode == 200) {
    dynamic responseData = json.decode(response.body);
    return responseData['success'] == 1;
  } else {
    throw Exception('Failed to edit data in API');
  }
}


  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(
          controller: namaController,
          decoration: InputDecoration(
            labelText: 'nama',
          ),
        ),
        TextField(
          controller: emailController,
          decoration: InputDecoration(
            labelText: 'Email',
          ),
        ),
        ElevatedButton(
          onPressed: () {
            String nama = namaController.text;
            String email = emailController.text;
            addData(nama, email).then((success) {
              if (success) {
                // Berhasil menambahkan data
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Data berhasil ditambahkan')),
                );
              } else {
                // Gagal menambahkan data
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Gagal menambahkan data')),
                );
              }
            });
          },
          child: Text('Tambah Data'),
        ),
        ElevatedButton(
          onPressed: () {
            int id = 1; // Ganti dengan ID yang ingin diedit
            String nama = namaController.text;
            String email = emailController.text;
            editData(id, nama, email).then((success) {
              if (success) {
                // Berhasil mengedit data
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Data berhasil diubah')),
                );
              } else {
                // Gagal mengedit data
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Gagal mengedit data')),
                );
              }
            });
          },
          child: Text('Edit Data'),
        ),
      ],
    );
  }
}
