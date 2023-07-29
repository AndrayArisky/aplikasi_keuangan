import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:intl/date_symbol_data_local.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:shared_preferences/shared_preferences.dart';

class arusKas extends StatefulWidget {
  @override
  _arusKasState createState() => _arusKasState();
}

String? usaha = "", alamat = "";

class _arusKasState extends State<arusKas> with SingleTickerProviderStateMixin {
  List<dynamic> dataTransaksi = [];
  List<dynamic> sortedDates = [];
  List<String> distinctMonthAndYear = [];

  getPref() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      usaha = preferences.getString("usaha");
      alamat = preferences.getString("alamat");
    });
  }

  @override
  void initState() {
    super.initState();
    fetchData();
    getPref();
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
          title: Text('Laporan Arus Kas'),
        ),
        body: Center(
          child: CircularProgressIndicator(),
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
            title: Text('Laporan Arus Kas'),
            actions: [
              IconButton(
                icon: Icon(Icons.picture_as_pdf_rounded),
                onPressed: () {
                  cetakPdf();
                },
              ),
            ],
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
                      borderSide: BorderSide(color: Colors.blue, width: 4)),
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

                    Map<String, int> totalPemasukan = {};
                    Map<String, int> totalPengeluaran = {};

                    transactions.forEach((transaction) {
                      String namaTransaksi = transaction['kategori'];
                      int nilaiTransaksi = int.parse(transaction['nominal'].toString());
                      String status = transaction['status'];
                      if (status == 'Pemasukan') {
                        totalPemasukan[namaTransaksi] = (totalPemasukan[namaTransaksi] ?? 0) + nilaiTransaksi;
                      } else if (status == 'Pengeluaran') {
                        totalPengeluaran[namaTransaksi] =(totalPengeluaran[namaTransaksi] ?? 0) + nilaiTransaksi;
                      }
                    });

                    return Padding(
                      padding: EdgeInsets.all(20),
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: <Widget>[
                            _buildItemRow('Pemasukan'),
                            SizedBox(height: 10.0),
                            ...totalPemasukan.entries.map((entry) => _buildAkunRow(entry.key, '${rupiah.format(entry.value)}')).toList(),
                            Divider(),
                            _buildTotalRow('Total Pemasukan', '${rupiah.format(totalPemasukan.values.fold(0, (a, b) => a + b))}'),
                            Divider(),
                            SizedBox(height: 20.0),
                            _buildItemRow('Pengeluaran'),
                            SizedBox(height: 10.0),
                            ...totalPengeluaran.entries.map((entry) => _buildAkunRow(entry.key, '${rupiah.format(entry.value)}')).toList(),
                            Divider(),
                            _buildTotalRow('Total Pengeluaran', '${rupiah.format(totalPengeluaran.values.fold(0, (a, b) => a + b))}'),
                            Divider(),
                            SizedBox(height: 40.0),
                            _buildTotalRow('Total Arus Kas', '${rupiah.format(totalPemasukan.values.fold(0, (a, b) => a + b) - totalPengeluaran.values.fold(0, (a, b) => a + b))}'),
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
        fontSize: 14.0,
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
          style: TextStyle(fontWeight: FontWeight.bold,),
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
            fontSize: 14.0,
          ),
        ),
        Text(
          nilai,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 14.0,
          ),
        ),
      ],
    );
  }

  Future <void> cetakPdf() async {
    final pdf = pw.Document();

    for (var monthAndYear in distinctMonthAndYear) {
      List<dynamic> transactions = dataTransaksi.where((transaction) {
        DateTime dateTime = DateTime.parse(transaction['tgl_transaksi']);
        var formatBulan = DateFormat.MMM();
        String namaBulan = formatBulan.format(dateTime);
        String monthAndYearTransaction = "$namaBulan ${dateTime.year.toString().substring(2)}";
        return monthAndYearTransaction == monthAndYear;
      }).toList();

      Map<String, int> totalPemasukan = {};
      Map<String, int> totalPengeluaran = {};

      transactions.forEach((transaction) {
        String namaTransaksi = transaction['kategori'];
        int nilaiTransaksi = int.parse(transaction['nominal'].toString());
        String status = transaction['status'];
        if (status == 'Pemasukan') {
          totalPemasukan[namaTransaksi] = (totalPemasukan[namaTransaksi] ?? 0) + nilaiTransaksi;
        } else if (status == 'Pengeluaran') {
          totalPengeluaran[namaTransaksi] = (totalPengeluaran[namaTransaksi] ?? 0) + nilaiTransaksi;
        }
      });

      pdf.addPage(
        pw.MultiPage(
          header: (pw.Context context) {
            return pw.Header(
              level: 0,
              child: pw.RichText(
                text: pw.TextSpan(
                  style: pw.TextStyle(
                    fontSize: 20,
                    fontWeight: pw.FontWeight.bold,
                  ),
                  children: [
                    pw.TextSpan(text: 'Laporan Arus Kas\n$monthAndYear\n'),
                    pw.TextSpan(
                      text: '$usaha - $alamat',
                      style: pw.TextStyle(
                        fontSize: 16,
                        fontWeight: pw.FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
          build: (pw.Context context) {
            final tablePemasukan = pw.Table(
              children: [
                pw.TableRow(
                  children: [
                    pw.Container(
                      padding: pw.EdgeInsets.only(right: 8),
                      child: pw.Text(
                        'Nama Akun',
                        style: pw.TextStyle(fontWeight: pw.FontWeight.bold)
                      ),
                    ),
                    pw.Container(
                      padding: pw.EdgeInsets.only(left: 8),
                      alignment: pw.Alignment.centerRight,
                      child: pw.Text(
                        'Nilai',
                        style: pw.TextStyle(fontWeight: pw.FontWeight.bold)
                      ),
                    )
                  ],
                ),
                ...totalPemasukan.entries.map((entry) => pw.TableRow(children: [
                  pw.Container(
                    padding: pw.EdgeInsets.only(right: 8),
                    child: pw.Text(entry.key),
                  ),
                  pw.Container(
                    padding: pw.EdgeInsets.only(left: 8),
                    alignment: pw.Alignment.centerRight,
                    child: pw.Text(rupiah.format(entry.value)),
                  ),
                ])),
                pw.TableRow(children: [
                  pw.Container(
                    padding: pw.EdgeInsets.only(right: 8),
                    child: pw.Text(
                      'Total Pemasukan',
                        style: pw.TextStyle(fontWeight: pw.FontWeight.bold)
                    ),
                  ),
                  pw.Container(
                    padding: pw.EdgeInsets.only(left: 8),
                    alignment: pw.Alignment.centerRight,
                    child: pw.Text(
                      rupiah.format(totalPemasukan.values.fold(0, (a, b) => a + b)),
                      style: pw.TextStyle(fontWeight: pw.FontWeight.bold)
                    ),
                  )
                ]),
              ],
            );

            final tablePengeluaran = pw.Table(
              children: [
                pw.TableRow(
                  children: [
                    pw.Container(
                      padding: pw.EdgeInsets.only(right: 8),
                      child: pw.Text(
                        'Nama Akun',
                        style: pw.TextStyle(fontWeight: pw.FontWeight.bold)
                      ),
                    ),
                    pw.Container(
                      padding: pw.EdgeInsets.only(left: 8),
                      alignment: pw.Alignment.centerRight,
                      child: pw.Text(
                        'Nilai',
                        style: pw.TextStyle(fontWeight: pw.FontWeight.bold)
                      ),
                    )
                  ],
                ),
                ...totalPengeluaran.entries.map((entry) => pw.TableRow(
                  children: [
                    pw.Container(
                      padding: pw.EdgeInsets.only(right: 8),
                      child: pw.Text(entry.key),
                    ),
                    pw.Container(
                      padding: pw.EdgeInsets.only(left: 8),
                      alignment: pw.Alignment.centerRight,
                      child: pw.Text(rupiah.format(entry.value)),
                    )
                  ],
                  )
                ),
                pw.TableRow(
                  children: [
                    pw.Container(
                      padding: pw.EdgeInsets.only(right: 8),
                      child: pw.Text(
                        'Total Pengeluaran',
                        style: pw.TextStyle(fontWeight: pw.FontWeight.bold)
                      ),
                    ),
                    pw.Container(
                      padding: pw.EdgeInsets.only(left: 8),
                      alignment: pw.Alignment.centerRight,
                      child: pw.Text(
                        rupiah.format(totalPengeluaran.values.fold(0, (a, b) => a + b)),
                        style: pw.TextStyle(fontWeight: pw.FontWeight.bold)
                      ),
                    )
                  ],
                ),
              ],
            );

            final tableTotalLabaRugi = pw.Table(
              columnWidths: {
                0: pw.FlexColumnWidth(),
                1: pw.FlexColumnWidth(),
              },
              children: [
                pw.TableRow(
                  children: [
                    pw.Container(
                      padding: pw.EdgeInsets.only(right: 8),
                      child: pw.Text(''),
                    ),
                    pw.Container(
                      padding: pw.EdgeInsets.only(left: 8),
                      alignment: pw.Alignment.centerRight,
                      child: pw.Text(
                        'Nilai',
                        style: pw.TextStyle(fontWeight: pw.FontWeight.bold)
                      ),
                    )
                  ],
                ),
                pw.TableRow(
                  children: [
                    pw.Container(
                      padding: pw.EdgeInsets.only(right: 8),
                      child: pw.Text(
                        'Arus Kas',
                        style: pw.TextStyle(fontWeight: pw.FontWeight.bold)
                      ),
                    ),
                    pw.Container(
                      padding: pw.EdgeInsets.only(left: 8),
                      alignment: pw.Alignment.centerRight,
                      child: pw.Text(
                        rupiah.format(totalPemasukan.values.fold(0, (a, b) => a + b) - totalPengeluaran.values.fold(0, (a, b) => a + b)),
                        style: pw.TextStyle(fontWeight: pw.FontWeight.bold)
                      ),
                    )
                  ],
                ),
              ],
            );

            return <pw.Widget>[
              pw.Header(
                level: 2,
                child: pw.Text(
                  'Pemasukan',
                  style: pw.TextStyle(
                    fontWeight: pw.FontWeight.bold, 
                    fontSize: 15
                  )
                ),
              ),
              tablePemasukan,
              pw.SizedBox(height: 15),
              pw.Header(
                level: 2,
                child: pw.Text(
                  'Pengeluaran',
                  style: pw.TextStyle(
                    fontWeight: pw.FontWeight.bold, 
                    fontSize: 15
                  )
                ),
              ),
              tablePengeluaran,
              pw.SizedBox(height: 15),
              tableTotalLabaRugi,
            ];
          },
        ),
      );
    }

    final outputDir = await getTemporaryDirectory();
    final filePath = '${outputDir.path}/laporan_arus_kas.pdf';
    final pdfBytes = await pdf.save();
    final pdfFile = File(filePath);
    await pdfFile.writeAsBytes(pdfBytes);
    await Printing.sharePdf(
      bytes: await pdfFile.readAsBytes(),
      filename: 'laporan_arus_kas.pdf',
    );
  }
}

