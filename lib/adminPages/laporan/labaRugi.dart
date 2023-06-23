import 'package:flutter/material.dart';

class labaRugi extends StatefulWidget {

  @override
  labaRugiState createState() => labaRugiState();
}

class labaRugiState extends State<labaRugi> {
  // List of available months
  List<String> months = [
    'Januari',
    'Februari',
    'Maret',
    'April',
    'Mei',
    'Juni',
    'Juli',
    'Agustus',
    'September',
    'Oktober',
    'November',
    'Desember',
  ];

  String selectedMonth = 'Januari'; // Default selected month

  // Method to handle month selection
  void _onMonthSelected(String month) {
    setState(() {
      selectedMonth = month;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Laporan Laba Rugi'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Pilih Bulan',
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(height: 10),
            DropdownButton<String>(
              value: selectedMonth,
              onChanged: (String? newValue) {
                setState(() {
                  selectedMonth = newValue!;
                });
              },
              items: months.map((String month) {
                return DropdownMenuItem<String>(
                  value: month,
                  child: Text(month),
                );
              }).toList(),
            ),
            SizedBox(height: 20),
            Text(
              'Laporan Laba Rugi untuk $selectedMonth',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            // Add your profit and loss report widgets here based on the selected month
          ],
        ),
      ),
    );
  }
}