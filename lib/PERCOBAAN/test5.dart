import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class YourWidget extends StatefulWidget {
  @override
  _YourWidgetState createState() => _YourWidgetState();
}

class _YourWidgetState extends State<YourWidget> {
  List<Map<String, dynamic>> data = [];
  String selectedTipe = '';

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    final response = await http.get(Uri.parse('https://apkeu2023.000webhostapp.com/getdata.php'));
    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      setState(() {
        data = List<Map<String, dynamic>>.from(jsonData);
      });
    } else {
      throw Exception('Gagal mengambil data!');
    }
  }

  List<Map<String, dynamic>> filterData(String tipe) {
    if (tipe == 'pm' || tipe == 'pr') {
      return data.where((item) => item['tipe'] == tipe).toList();
    } else {
      return data;
    }
  }

  void selectTipe(String tipe) {
    setState(() {
      selectedTipe = tipe;
    });
  }

  @override
  Widget build(BuildContext context) {
    List<Map<String, dynamic>> filteredData = filterData(selectedTipe);

    return Scaffold(
      appBar: AppBar(
        title: Text('Your Widget'),
      ),
      body: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                onPressed: () {
                  selectTipe('pm');
                },
                child: Text('Pemasukan'),
              ),
              ElevatedButton(
                onPressed: () {
                  selectTipe('pr');
                },
                child: Text('Pengeluaran'),
              ),
            ],
          ),
          Expanded(
            child: ListView.builder(
              itemCount: filteredData.length,
              itemBuilder: (context, index) {
                final item = filteredData[index];
                return ListTile(
                  title: Text(item['nm_akun']),
                  subtitle: Text(item['nm_akun']),
                  onTap: () {
                    showModalBottomSheet(
                      context: context,
                      builder: (BuildContext context) {
                        return Container(
                          padding: EdgeInsets.all(20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Detail Transaksi',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 16),
                              ListTile(
                                leading: Icon(Icons.date_range),
                                title: Text(item['nm_akun']),
                                subtitle: Text(item['grup']),
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
