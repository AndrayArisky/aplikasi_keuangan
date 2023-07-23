import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:intl/date_symbol_data_local.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

class labaRugi extends StatefulWidget {
  @override
  _labaRugiState createState() => _labaRugiState();
}

class _labaRugiState extends State<labaRugi> with SingleTickerProviderStateMixin {
  List<dynamic> dataTransaksi = [];
  List<dynamic> sortedDates = [];
  List<String> distinctMonthAndYear = [];

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
            title: Text('Laporan Laba Rugi'),
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
                      borderSide: BorderSide(color: Colors.blue, width: 4)
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
                    Map<String, int> totalBeban = {};

                    transactions.forEach((transaction) {
                      String namaTransaksi = transaction['kategori'];
                      int nilaiTransaksi = int.parse(transaction['nominal'].toString());
                      String grup = transaction['grup'];
                      if (grup == 'Pendapatan') {
                        totalPendapatan[namaTransaksi] = (totalPendapatan[namaTransaksi] ?? 0) + nilaiTransaksi;
                      } else if (grup == 'Beban') {
                        totalBeban[namaTransaksi] =(totalBeban[namaTransaksi] ?? 0) + nilaiTransaksi;
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
                            _buildItemRow('Beban'),
                            SizedBox(height: 10.0),
                            ...totalBeban.entries.map((entry) => _buildAkunRow(entry.key, entry.value.toString())).toList(),
                            Divider(),
                            _buildTotalRow('Total Beban', '${rupiah.format(totalBeban.values.fold(0, (a, b) => a + b))}'),
                            Divider(),
                            SizedBox(height: 40.0),
                            _buildTotalRow('Total Laba(Rugi) Sebelum Pajak', '${rupiah.format(totalPendapatan.values.fold(0, (a, b) => a + b) - totalBeban.values.fold(0, (a, b) => a + b))}'),
                            _buildTotalRow('Biaya Pajak Penghasilan', '${rupiah.format(0.005 * (totalPendapatan.values.fold(0, (a, b) => a + b) - totalBeban.values.fold(0, (a, b) => a + b)))}'),
                            _buildTotalRow('Total Laba(Rugi) Setelah Pajak', '${rupiah.format((totalPendapatan.values.fold(0, (a, b) => a + b) - totalBeban.values.fold(0, (a, b) => a + b)) - (0.005 * (totalPendapatan.values.fold(0, (a, b) => a + b) - totalBeban.values.fold(0, (a, b) => a + b))))}'),
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

  Future<void> cetakPdf() async {
    final pdf = pw.Document();
    for (var monthAndYear in distinctMonthAndYear) {
      List<dynamic> transactions = dataTransaksi.where((transaction) {
        DateTime dateTime = DateTime.parse(transaction['tgl_transaksi']);
        var formatBulan = DateFormat.MMM();
        String namaBulan = formatBulan.format(dateTime);
        String monthAndYearTransaction = "$namaBulan ${dateTime.year.toString().substring(2)}";
        return monthAndYearTransaction == monthAndYear;
      }).toList();

      Map<String, int> totalPendapatan = {};
      Map<String, int> totalBeban = {};

      transactions.forEach((transaction) {
        String namaTransaksi = transaction['kategori'];
        int nilaiTransaksi = int.parse(transaction['nominal'].toString());
        String grup = transaction['grup'];
        if (grup == 'Pendapatan') {
          totalPendapatan[namaTransaksi] = (totalPendapatan[namaTransaksi] ?? 0) + nilaiTransaksi;
        } else if (grup == 'Beban') {
          totalBeban[namaTransaksi] = (totalBeban[namaTransaksi] ?? 0) + nilaiTransaksi;
        }
      });

      pdf.addPage(
        pw.MultiPage(
          header: (pw.Context context) {
            return pw.Header(
              level: 0,
              child: pw.Text(
                'Laporan Laba Rugi\n$monthAndYear',
                style: pw.TextStyle(
                  fontSize: 20, 
                  fontWeight: pw.FontWeight.bold
                ),
              ),
            );
          },
          build: (pw.Context context) {
            final tablePendapatan = pw.Table(
              children: [
                pw.TableRow(
                  children: [
                    pw.Container(
                      padding: pw.EdgeInsets.only(right: 8),
                      child: pw.Text('Nama Akun',
                        style: pw.TextStyle(fontWeight: pw.FontWeight.bold)
                      ),
                    ),
                    pw.Container(
                      padding: pw.EdgeInsets.only(left: 8),
                      alignment: pw.Alignment.centerRight,
                      child: pw.Text('Nilai',
                        style: pw.TextStyle(fontWeight: pw.FontWeight.bold)
                      ),
                    )
                  ],
                ),
                ...totalPendapatan.entries.map((entry) => pw.TableRow(children: [
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
                    child: pw.Text('Total Pendapatan',
                      style: pw.TextStyle(fontWeight: pw.FontWeight.bold)
                    ),
                  ),
                  pw.Container(
                    padding: pw.EdgeInsets.only(left: 8),
                    alignment: pw.Alignment.centerRight,
                    child: pw.Text(rupiah.format(totalPendapatan.values.fold(0, (a, b) => a + b)),
                      style: pw.TextStyle(fontWeight: pw.FontWeight.bold)
                    ),
                  )
                ]),
              ],
            );

            final tableBeban = pw.Table(
              children: [
                pw.TableRow(
                  children: [
                    pw.Container(
                      padding: pw.EdgeInsets.only(right: 8),
                      child: pw.Text('Nama Akun',
                        style: pw.TextStyle(fontWeight: pw.FontWeight.bold)
                      ),
                    ),
                    pw.Container(
                      padding: pw.EdgeInsets.only(left: 8),
                      alignment: pw.Alignment.centerRight,
                      child: pw.Text('Nilai',
                        style: pw.TextStyle(fontWeight: pw.FontWeight.bold)
                      ),
                    )
                  ],
                ),
                ...totalBeban.entries.map((entry) => pw.TableRow(
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
                )),
                pw.TableRow(
                  children: [
                    pw.Container(
                      padding: pw.EdgeInsets.only(right: 8),
                      child: pw.Text('Total Beban',
                        style: pw.TextStyle(fontWeight: pw.FontWeight.bold)
                      ),
                    ),
                    pw.Container(
                      padding: pw.EdgeInsets.only(left: 8),
                      alignment: pw.Alignment.centerRight,
                      child: pw.Text(rupiah.format(totalBeban.values.fold(0, (a, b) => a + b)),
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
                      child: pw.Text('Nilai',
                        style: pw.TextStyle(fontWeight: pw.FontWeight.bold)
                      ),
                    )
                  ],
                ),
                pw.TableRow(
                  children: [
                    pw.Container(
                      padding: pw.EdgeInsets.only(right: 8),
                      child: pw.Text('Total Laba (Rugi) Sebelum Pajak',
                        style: pw.TextStyle(fontWeight: pw.FontWeight.bold)
                      ),
                    ),
                    pw.Container(
                      padding: pw.EdgeInsets.only(left: 8),
                      alignment: pw.Alignment.centerRight,
                      child: pw.Text(rupiah.format(totalPendapatan.values.fold(0, (a, b) => a + b) - totalBeban.values.fold(0, (a, b) => a + b)),
                        style: pw.TextStyle(fontWeight: pw.FontWeight.bold)
                      ),
                    )
                  ],
                ),
                pw.TableRow(
                  children: [
                    pw.Container(
                      padding: pw.EdgeInsets.only(right: 8),
                      child: pw.Text('Biaya Pajak Penghasilan',
                        style: pw.TextStyle(fontWeight: pw.FontWeight.bold)
                      ),
                    ),
                    pw.Container(
                      padding: pw.EdgeInsets.only(left: 8),
                      alignment: pw.Alignment.centerRight,
                      child: pw.Text(rupiah.format(0.005 * (totalPendapatan.values.fold(0, (a, b) => a + b) - totalBeban.values.fold(0, (a, b) => a + b))),
                        style: pw.TextStyle(fontWeight: pw.FontWeight.bold)
                      ),
                    )
                  ],
                ),
                pw.TableRow(
                  children: [
                    pw.Container(
                      padding: pw.EdgeInsets.only(right: 8),
                      child: pw.Text('Total Laba (Rugi) Setelah Pajak',
                        style: pw.TextStyle(fontWeight: pw.FontWeight.bold)
                      ),
                    ),
                    pw.Container(
                      padding: pw.EdgeInsets.only(left: 8),
                      alignment: pw.Alignment.centerRight,
                      child: pw.Text(rupiah.format((totalPendapatan.values.fold(0, (a, b) => a + b) - totalBeban.values.fold(0, (a, b) => a + b)) - (0.005 * (totalPendapatan.values.fold(0, (a, b) => a + b) - totalBeban.values.fold(0, (a, b) => a + b)))),
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
                child: pw.Text('Pendapatan',
                  style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 15)
                ),
              ),
              tablePendapatan,
              pw.SizedBox(height: 15),
              pw.Header(
                level: 2,
                child: pw.Text('Beban',
                  style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 15)
                ),
              ),
              tableBeban,
              pw.SizedBox(height: 15),
              tableTotalLabaRugi,
            ];
          },
        ),
      );
    }

    final outputDir = await getTemporaryDirectory();
    final filePath = '${outputDir.path}/laporan_laba_rugi.pdf';
    final pdfBytes = await pdf.save();
    final pdfFile = File(filePath);
    await pdfFile.writeAsBytes(pdfBytes);
    await Printing.sharePdf(
      bytes: await pdfFile.readAsBytes(),
      filename: 'laporan_laba_rugi.pdf',
    );
  }
}

