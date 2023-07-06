import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:intl/date_symbol_data_local.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart'; 
import 'package:printing/printing.dart';


class LR extends StatefulWidget {
  @override
  _LRState createState() => _LRState();
}

class _LRState extends State<LR> {
  List<dynamic> dataTransaksi = [];
  List<dynamic> sortedDates = [];
  List<String> distinctMonthAndYear = [];

    Future<void> _generatePdf() async {
    final transaksiByMonthYear = getTransaksiByMonthYear(_selectedMonthYear);
    final doc = pw.Document();
    doc.addPage(
      pw.MultiPage(
        build: (pw.Context context) {
          return [
            pw.Container(
              alignment: pw.Alignment.center,
              child: pw.Text(
                'LAPORAN TRANSAKSI $_selectedMonthYear'.toUpperCase(),
                style: pw.TextStyle(
                  fontSize: 18,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
            ),
            pw.SizedBox(height: 10),
            pw.Table.fromTextArray(
              context: context,
              data: [
                ['No.', 'Tanggal', 'Keterangan', 'Nilai Transaksi', 'Status'],
                ...transaksiByMonthYear.map((transaksi) => [
                  transaksiByMonthYear.indexOf(transaksi) + 1,
                  transaksi.getFormatted_Tgl_ddMMMyyyy(),
                  transaksi.keterangan.toString(),
                  transaksi.nilaiTransaksi.toString(),
                  transaksi.status,
                ]),
              ],
            ),
          ];
        },
      ),
    ); 
    final output = await getTemporaryDirectory();
    final filePath = '${output.path}/transaksi.pdf';
    final file = File(filePath);
    await file.writeAsBytes(await doc.save());
    await Printing.sharePdf(
      bytes: await file.readAsBytes(),
      filename: 'transaksi.pdf',
    );
  } 

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  void fetchData() async {
    final response = await http.get(Uri.parse('http://apkeu2023.000webhostapp.com/getTransaksi.php'));
    if (response.statusCode == 200) {
      setState(() {
        dataTransaksi = json.decode(response.body);
        sortedDates = [];
        for (var i = 0; i < dataTransaksi.length; i++) {
          String tglTransaksi = dataTransaksi[i]['tgl_transaksi'];
          DateTime dateTime = DateTime.parse(tglTransaksi);
          sortedDates.add(dateTime);
        }
        sortedDates.sort((a, b) => a.compareTo(b));
        if (sortedDates != null && sortedDates.isNotEmpty) {
          distinctMonthAndYear = _getDistinctMonthAndYear();
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
      String monthAndYear = "$namaBulan ${dateTime.year.toString().substring(2)}";
      if (!distinctMonthAndYear.contains(monthAndYear)) {
        bool bulanPunyaData = false;
        for (var j = 0; j < dataTransaksi.length; j++) {
          String tglTransaksi = dataTransaksi[j]['tgl_transaksi'];
          DateTime dateTime = DateTime.parse(tglTransaksi);
          var formatBulan = DateFormat.MMM();
          String namaBulan = formatBulan.format(dateTime);
          String monthAndYearTransaction = "$namaBulan ${dateTime.year.toString().substring(2)}";
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
    decimalDigits: 0,
  );

  Map<String, int> totalTransactions = {};

  @override
  Widget build(BuildContext context) {
    if (distinctMonthAndYear.isEmpty) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Laporan Laba Rugi'),
          actions: [
            IconButton(
              icon: Icon(
                Icons.picture_as_pdf_rounded,
                color: Colors.black,
              ),
              onPressed: () {
                //createPDF();
              },
            ),
          ],
        ),
        body: Center(
          child: Text(
            'Membaca laporan Laba Rugi',
            textAlign: TextAlign.center,
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
            title: Text('Laporan Laba Rugi'),
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
                      borderSide: BorderSide(
                        color: Colors.blue, 
                        width: 4
                      )
                    ),
                  ),
                ),
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

                    Map<String, int> totalPendapatan = {};
                    Map<String, int> totalPengeluaran = {};

                    transactions.forEach((transaction) {
                      String namaTransaksi = transaction['kategori'];
                      int nilaiTransaksi = int.parse(transaction['nominal'].toString());
                      String status = transaction['status'];
                      if (status == 'Pemasukan') {
                        totalPendapatan[namaTransaksi] = (totalPendapatan[namaTransaksi] ?? 0) + nilaiTransaksi;
                      } else if (status == 'Pengeluaran') {
                        totalPengeluaran[namaTransaksi] = (totalPengeluaran[namaTransaksi] ?? 0) + nilaiTransaksi;
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
                            ...totalPendapatan.entries.map((entry) => _buildAkunRow(entry.key, entry.value.toString())).toList(),
                            Divider(),
                            _buildTotalRow('Total Pendapatan', '${rupiah.format(totalPendapatan.values.fold(0, (a, b) => a + b))}'),
                            Divider(),
                            SizedBox(height: 20.0),
                            _buildItemRow('Biaya/Beban'),
                            SizedBox(height: 10.0),
                            ...totalPengeluaran.entries.map((entry) => _buildAkunRow(entry.key, entry.value.toString())).toList(),
                            Divider(),
                            _buildTotalRow('Total Biaya/Beban', '${rupiah.format(totalPengeluaran.values.fold(0, (a, b) => a + b))}'),
                            Divider(),
                            SizedBox(height: 40.0),
                            _buildTotalRow('Total Laba(Rugi) Sebelum Pajak', '${rupiah.format(totalPendapatan.values.fold(0, (a, b) => a + b) - totalPengeluaran.values.fold(0, (a, b) => a + b))}'),
                            _buildTotalRow('Biaya Pajak Penghasilan', '${rupiah.format(0.04 * (totalPendapatan.values.fold(0, (a, b) => a + b) - totalPengeluaran.values.fold(0, (a, b) => a + b)))}'),
                            _buildTotalRow('Total Laba(Rugi) Setelah Pajak', '${rupiah.format((totalPendapatan.values.fold(0, (a, b) => a + b) - totalPengeluaran.values.fold(0, (a, b) => a + b)) - (0.04 * (totalPendapatan.values.fold(0, (a, b) => a + b) - totalPengeluaran.values.fold(0, (a, b) => a + b))))}'),
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

  Widget _buildItemRow(String title) {
    return Text(
      title,
      style: TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 15.0,
      ),
    );
  }

  Widget _buildAkunRow(String namaAkun, String nilai) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(namaAkun),
        Text(
          nilai,
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildTotalRow(String title, String nilai) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 15.0,
          ),
        ),
        Text(
          nilai,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 15.0,
          ),
        ),
      ],
    );
  }
}

