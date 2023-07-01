import 'dart:convert';
import 'package:aplikasi_keuangan/adminPages/adminPage.dart';
import 'package:aplikasi_keuangan/adminPages/inputAdmin.dart';
import 'package:aplikasi_keuangan/PERCOBAAN/inputFake.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;

class posisiKeuangan extends StatefulWidget {
  @override
  _posisiKeuanganState createState() => _posisiKeuanganState();
}

class _posisiKeuanganState extends State<posisiKeuangan> {
  List<dynamic> dataTransaksi = [];
  List<dynamic> sortedDates = [];
  List<String> distinctMonthAndYear = [];

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  void fetchData() async {
    final response = await http.get(Uri.parse('http://apkeu2023.000webhostapp.com/getTransaksi.php?'));
    if (response.statusCode == 200) {
      setState(() {
        dataTransaksi = json.decode(response.body);
        sortedDates = [];
        for (var i = 0; i < dataTransaksi.length; i++) {
          String tglTransaksi = dataTransaksi[i]['tgl_transaksi'];
          DateTime dateTime = DateTime.parse(tglTransaksi);
          sortedDates.add(dateTime);
          print('sortedDates : $sortedDates');
        }
        sortedDates.sort((a, b) => a.compareTo(b));
        if (sortedDates != null && sortedDates.isNotEmpty) {
          distinctMonthAndYear = _getDistinctMonthAndYear();
          print('distinctMonthAndYear : $distinctMonthAndYear');
        }
      });
    } else {
      throw Exception('Failed to load data');
    }
  }

  List<String> _getDistinctMonthAndYear() {
    List<String> distinctMonthAndYear = [];
    initializeDateFormatting('id_ID');
    DateTime now = DateTime.now();
    var formatBulan = DateFormat.MMM();
    String namaBulan = formatBulan.format(now);
    var formatTahun = DateFormat('yy');
    String tahun = formatTahun.format(now);
    String monthAndYear = "$namaBulan $tahun";
    for (var i = 0; i < sortedDates.length; i++) {
      DateTime dateTime = sortedDates[i];
      var formatBulan = DateFormat.MMM();
      String namaBulan = formatBulan.format(dateTime);
      String monthAndYear =
          "$namaBulan ${dateTime.year.toString().substring(2)}";
      if (!distinctMonthAndYear.contains(monthAndYear)) {
        bool bulanPunyaData = false;
        for (var j = 0; j < dataTransaksi.length; j++) {
          String tglTransaksi = dataTransaksi[j]['tgl_transaksi'];
          DateTime dateTime = DateTime.parse(tglTransaksi);
          var formatBulan = DateFormat.MMM();
          String namaBulan = formatBulan.format(dateTime);
          String monthAndYearTransaction =
              "$namaBulan ${dateTime.year.toString().substring(2)}";
          if (monthAndYearTransaction == monthAndYear) {
            bulanPunyaData = true;
            break;
          }
        }
        if (bulanPunyaData) {
          distinctMonthAndYear.add(monthAndYear);
        }
      }
    }
    return distinctMonthAndYear;
  }

  var rupiah = NumberFormat.currency(
    locale: 'id_ID', 
    symbol: 'Rp. ', 
    decimalDigits: 0
  );

  Widget _buildItemRow(String title) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 16.0,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildAkunRow(String title, String amount) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 14.0,
          ),
        ),
        Text(
          amount,
          style: TextStyle(
            fontSize: 14.0,
          ),
        ),
      ],
    );
  }

  Widget _buildTotalRow(String title, String amount) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 16.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          amount,
          style: TextStyle(
            fontSize: 16.0,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    if (distinctMonthAndYear.isEmpty) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Posisi Keuangan'),
        ),
        body: Center(
          child: Text(
            'Membaca laporan posisi keuangan',
            textAlign: TextAlign.center
          ),
        ),
      );
    } else {
      int initialIndex = DateTime.now().month + 1;
      if (initialIndex >= distinctMonthAndYear.length) {
        initialIndex = distinctMonthAndYear.length - 1;
      }
      return DefaultTabController(
        length: distinctMonthAndYear.length,
        initialIndex: initialIndex,
        child: Scaffold(
          appBar: AppBar(
            title: Text('Laporan Posisi Keuangan'),
          ),
          body: Column(
            children: [
              Container(
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: TabBar(
                    isScrollable: true,
                    labelColor: Colors.blue,
                    tabs: distinctMonthAndYear.map((monthAndYear) {
                      return Tab(
                        child: Text(
                          monthAndYear,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      );
                    }).toList(),
                    indicator: UnderlineTabIndicator(
                      borderSide: BorderSide(color: Colors.blue, width: 4)
                    ),
                  ),
                )
              ),
              Expanded(
                child: TabBarView(
                  children: distinctMonthAndYear.map((monthAndYear) {
                    List<dynamic> transactions = dataTransaksi.where((transaction) {
                      DateTime dateTime = DateTime.parse(transaction['tgl_transaksi']);
                      var formatBulan = DateFormat.MMM();
                      String namaBulan = formatBulan.format(dateTime);
                      String monthAndYearTransaction = "$namaBulan ${dateTime.year.toString().substring(2)}";
                      return monthAndYearTransaction == monthAndYear;
                    }).toList();
                    
                    int PemasukanTotal = 0;
                    int PengeluaranTotal = 0;
                    transactions.forEach((transaction) {
                      String nilaiTransaksiString = transaction['nominal'].toString();
                      if (nilaiTransaksiString.isNotEmpty) {
                        try {
                          int nilaiTransaksi = int.parse(nilaiTransaksiString);
                          if (transaction['status'] == 'Pemasukan') {
                            PemasukanTotal += nilaiTransaksi;
                          } else {
                            PengeluaranTotal += nilaiTransaksi;
                          }
                        } catch (e) {
                          print('Error parsing nilai_transaksi: $e');
                        }
                      }
                    });

                    return Padding(
                      padding: EdgeInsets.all(20),
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: <Widget>[
                            _buildItemRow('Pendapatan'),
                            SizedBox(height: 10.0),
                            ...transactions
                              .where((transaction) => transaction['status'] == 'Pemasukan')
                              .map((transaction) => _buildAkunRow(transaction['kategori'], transaction['nominal']))
                              .toList(),
                            Divider(),
                            _buildTotalRow('Total Pendapatan', '${rupiah.format(PemasukanTotal)}'),
                            Divider(),
                            SizedBox(height: 20.0),
                            _buildItemRow('Biaya/Beban'),
                            SizedBox(height: 10.0),
                            ...transactions
                              .where((transaction) => transaction['status'] == 'Pengeluaran')
                              .map((transaction) => _buildAkunRow(transaction['kategori'], transaction['nominal']))
                              .toList(),
                            Divider(),
                            _buildTotalRow('Total Biaya/Beban', '${rupiah.format(PengeluaranTotal)}'),
                            Divider(),
                            SizedBox(height: 40.0),
                            _buildTotalRow('Total Laba/Rugi', '${rupiah.format(PemasukanTotal - PengeluaranTotal)}'),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
        ),
      );
    }
  }
}
