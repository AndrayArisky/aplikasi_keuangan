import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:intl/date_symbol_data_local.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:pdf/pdf.dart';
import 'package:shared_preferences/shared_preferences.dart';

class posisiKeuangan extends StatefulWidget {
  @override
  _posisiKeuanganState createState() => _posisiKeuanganState();
}

String? usaha = "", alamat = "";

class _posisiKeuanganState extends State<posisiKeuangan>
    with SingleTickerProviderStateMixin {
  List<dynamic> dataTransaksi = [];
  List<dynamic> dataAkun = [];
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
    final responseTransaksi = await http.get(Uri.parse('http://apkeu2023.000webhostapp.com/getTransaksi.php'));
    final responseAkun = await http.get(Uri.parse('http://apkeu2023.000webhostapp.com/getAkun.php')); // API untuk mendapatkan data dari tabel akun
    if (responseTransaksi.statusCode == 200 && responseAkun.statusCode == 200) {
      setState(() {
        dataTransaksi = json.decode(responseTransaksi.body);
        dataAkun = json.decode(responseAkun.body); // Menyimpan data dari tabel akun
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

  String getNextMonthAndYear(String monthAndYear) {
  var formatBulan = DateFormat.MMM();
  DateTime date = DateFormat.yMMM().parse(monthAndYear);
  DateTime nextMonthDate = DateTime(date.year, date.month + 1);
  String nextMonthAndYear = formatBulan.format(nextMonthDate) + ' ' + DateFormat.y().format(nextMonthDate);
  return nextMonthAndYear;
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

  @override
  Widget build(BuildContext context) {
    if (distinctMonthAndYear.isEmpty) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Laporan Posisi Keuangan'),
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
            title: Text('Laporan Posisi Keuangan'),
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

                    Map<String, int> totalGrupAset = {};
                    Map<String, int> totalAsetLancar = {};
                    Map<String, int> totalAsetTetap = {};
                    Map<String, int> totalAkumulasiPenyusutan = {};

                    Map<String, int> totalGrupLiabilitas = {};
                    Map<String, int> totalJangkaPendek = {};
                    Map<String, int> totalJangkaPanjang = {};
                    Map<String, int> totalEkuitas = {};

                    transactions.forEach((transaction) {
                      String namaTransaksi = transaction['kategori'];
                      int nilaiTransaksi = int.parse(transaction['nominal'].toString());
                      String grup = transaction['grup'];

                      // TOTAL KESELURUHAN
                      if (grup.contains('Aset')) {
                        totalGrupAset[grup] = (totalGrupAset[grup] ?? 0) + nilaiTransaksi;
                      } else if (grup.contains('Liabilitas (Kewajiban)')) {
                        totalGrupLiabilitas[grup] = (totalGrupLiabilitas[grup] ?? 0) + nilaiTransaksi;
                      }

                      if (grup == 'Aset Lancar') {
                        totalAsetLancar[namaTransaksi] = (totalAsetLancar[namaTransaksi] ?? 0) + nilaiTransaksi;
                      } else if (grup == 'Aset Tetap') {
                        totalAsetTetap[namaTransaksi] = (totalAsetTetap[namaTransaksi] ?? 0) + nilaiTransaksi;
                      } else if (grup == 'Akumulasi Penyusutan') {
                        totalAkumulasiPenyusutan[namaTransaksi] = (totalAkumulasiPenyusutan[namaTransaksi] ?? 0) + nilaiTransaksi;
                      } else if (grup == 'Liabilitas Jangka Pendek') {
                        totalJangkaPendek[namaTransaksi] = (totalJangkaPendek[namaTransaksi] ?? 0) + nilaiTransaksi;
                      } else if (grup == 'Liabilitas Jangka Panjang') {
                        totalJangkaPanjang[namaTransaksi] = (totalJangkaPanjang[namaTransaksi] ?? 0) + nilaiTransaksi;
                      } else if (grup == 'Ekuitas') {
                        totalEkuitas[namaTransaksi] = (totalEkuitas[namaTransaksi] ?? 0) + nilaiTransaksi;
                      }
                    });

                    return Padding(
                      padding: EdgeInsets.all(20),
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: <Widget>[
                            //_buildJudulRow('Aset'),
                            _buildItemRow('Aset'),
                            SizedBox(height: 10.0),
                            ...totalAsetLancar.entries.map((entry) => _buildAkunRow(entry.key, '${rupiah.format(entry.value)}')).toList(),
                            ...totalAsetTetap.entries.map((entry) => _buildAkunRow(entry.key, '${rupiah.format(entry.value)}')).toList(),
                            ...totalAkumulasiPenyusutan.entries.map((entry) => _buildAkunRow(entry.key, '${rupiah.format(entry.value)}')).toList(),
                            Divider(),
                            _buildTotalRow('Total Aset Lancar', '${rupiah.format(totalAsetLancar.values.fold(0, (a, b) => a + b))}'),
                            _buildTotalRow('Total Aset Tetap', '${rupiah.format(totalAsetTetap.values.fold(0, (a, b) => a + b))}'),
                            _buildTotalRow('Total Akumulasi Penyusutan', '${rupiah.format(totalAkumulasiPenyusutan.values.fold(0, (a, b) => a + b))}'),
                            Divider(),
                            _buildTotalRow('Total Keseluruhan Aset','${rupiah.format(totalAsetLancar.values.fold(0, (a, b) => a + b) + totalAsetTetap.values.fold(0, (a, b) => a + b) + totalAkumulasiPenyusutan.values.fold(0, (a, b) => a + b))}'),
                            Divider(),
                            SizedBox(height: 30.0),

                            _buildItemRow('Liabilitas (Kewajiban)'),
                            SizedBox(height: 10.0),
                            ...totalJangkaPendek.entries.map((entry) => _buildAkunRow(entry.key, '${rupiah.format(entry.value)}')).toList(),
                            ...totalJangkaPanjang.entries.map((entry) => _buildAkunRow(entry.key, '${rupiah.format(entry.value)}')).toList(),
                            ...totalEkuitas.entries.map((entry) => _buildAkunRow(entry.key, '${rupiah.format(entry.value)}')).toList(),
                            Divider(),
                            _buildTotalRow('Total Liabilitas Jangka Pendek', '${rupiah.format(totalJangkaPendek.values.fold(0, (a, b) => a + b))}'),
                            _buildTotalRow('Total Liabilitas Jangka Panjang', '${rupiah.format(totalJangkaPanjang.values.fold(0, (a, b) => a + b))}'),
                            _buildTotalRow('Total Ekuitas', '${rupiah.format(totalEkuitas.values.fold(0, (a, b) => a + b))}'),
                            Divider(),
                            _buildTotalRow('Total Keseluruhan Liabilitas (Kewajiban)','${rupiah.format(totalJangkaPendek.values.fold(0, (a, b) => a + b) + totalJangkaPanjang.values.fold(0, (a, b) => a + b) + totalEkuitas.values.fold(0, (a, b) => a + b))}'),
                            Divider(),
                            SizedBox(height: 30.0),
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
        String monthAndYearTransaction =
            "$namaBulan ${dateTime.year.toString().substring(2)}";
        return monthAndYearTransaction == monthAndYear;
      }).toList();

      Map<String, int> totalGrupAset = {};
      Map<String, int> totalAsetLancar = {};
      Map<String, int> totalAsetTetap = {};
      Map<String, int> totalAkumulasiPenyusutan = {};

      Map<String, int> totalGrupLiabilitas = {};
      Map<String, int> totalJangkaPendek = {};
      Map<String, int> totalJangkaPanjang = {};
      Map<String, int> totalEkuitas = {};

      transactions.forEach((transaction) {
        String namaTransaksi = transaction['kategori'];
        int nilaiTransaksi = int.parse(transaction['nominal'].toString());
        String grup = transaction['grup'];

        // TOTAL KESELURUHAN
        if (grup.contains('Aset')) {
          totalGrupAset[grup] = (totalGrupAset[grup] ?? 0) + nilaiTransaksi;
        } else if (grup.contains('Liabilitas (Kewajiban)')) {
          totalGrupLiabilitas[grup] = (totalGrupLiabilitas[grup] ?? 0) + nilaiTransaksi;
        }

        if (grup == 'Aset Lancar') {
          totalAsetLancar[namaTransaksi] = (totalAsetLancar[namaTransaksi] ?? 0) + nilaiTransaksi;
        } else if (grup == 'Aset Tetap') {
          totalAsetTetap[namaTransaksi] = (totalAsetTetap[namaTransaksi] ?? 0) + nilaiTransaksi;
        } else if (grup == 'Akumulasi Penyusutan') {
          totalAkumulasiPenyusutan[namaTransaksi] = (totalAkumulasiPenyusutan[namaTransaksi] ?? 0) + nilaiTransaksi;
        } else if (grup == 'Liabilitas Jangka Pendek') {
          totalJangkaPendek[namaTransaksi] = (totalJangkaPendek[namaTransaksi] ?? 0) + nilaiTransaksi;
        } else if (grup == 'Liabilitas Jangka Panjang') {
          totalJangkaPanjang[namaTransaksi] = (totalJangkaPanjang[namaTransaksi] ?? 0) + nilaiTransaksi;
        } else if (grup == 'Ekuitas') {
          totalEkuitas[namaTransaksi] = (totalEkuitas[namaTransaksi] ?? 0) + nilaiTransaksi;
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
                    pw.TextSpan(text: 'Laporan Posisi Keuangan\n$monthAndYear\n'),
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
            final tableAset = pw.Table(
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
                ...totalAsetLancar.entries.map((entry) => pw.TableRow(children: [
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
                ...totalAsetTetap.entries.map((entry) => pw.TableRow(children: [
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
                ...totalAkumulasiPenyusutan.entries.map((entry) => pw.TableRow(children: [
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
              ],
            );

            final tableTotalAset = pw.Table(
              columnWidths: {
                0: pw.FlexColumnWidth(),
                1: pw.FlexColumnWidth(),
              },
              children: [
                pw.TableRow(
                  children: [
                    pw.Container(
                      padding: pw.EdgeInsets.only(right: 8),
                      child: pw.Text('Total Aset Lancar',
                          style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                    ),
                    pw.Container(
                      padding: pw.EdgeInsets.only(left: 8),
                      alignment: pw.Alignment.centerRight,
                      child: pw.Text(
                          rupiah.format(totalAsetLancar.values.fold(0, (a, b) => a + b)),
                          style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                    )
                  ],
                ),
                pw.TableRow(children: [
                  pw.Container(
                    padding: pw.EdgeInsets.only(right: 8),
                    child: pw.Text('Total Aset Tetap',
                        style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                  ),
                  pw.Container(
                    padding: pw.EdgeInsets.only(left: 8),
                    alignment: pw.Alignment.centerRight,
                    child: pw.Text(
                      rupiah.format(totalAsetTetap.values.fold(0, (a, b) => a + b)),
                      style: pw.TextStyle(fontWeight: pw.FontWeight.bold)
                    ),
                  )
                ]),
                pw.TableRow(children: [
                  pw.Container(
                    padding: pw.EdgeInsets.only(right: 8),
                    child: pw.Text('Total Akumulasi Penyusutan',
                        style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                  ),
                  pw.Container(
                    padding: pw.EdgeInsets.only(left: 8),
                    alignment: pw.Alignment.centerRight,
                    child: pw.Text(
                      rupiah.format(totalAkumulasiPenyusutan.values.fold(0, (a, b) => a + b)),
                      style: pw.TextStyle(fontWeight: pw.FontWeight.bold)
                    ),
                  )
                ]),
              ],
            );

            final tableSeluruhAset = pw.Table(
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
                          style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                    )
                  ],
                ),
                pw.TableRow(
                  children: [
                    pw.Container(
                      padding: pw.EdgeInsets.only(right: 8),
                      child: pw.Text('Total Keseluruhan Aset',
                          style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                    ),
                    pw.Container(
                      padding: pw.EdgeInsets.only(left: 8),
                      alignment: pw.Alignment.centerRight,
                      child: pw.Text(
                        rupiah.format(
                          totalAsetLancar.values.fold(0, (a, b) => a + b) +
                              totalAsetTetap.values.fold(0, (a, b) => a + b) +
                              totalAkumulasiPenyusutan.values.fold(0, (a, b) => a + b),
                        ),
                          style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                    )
                  ],
                ),
              ],
            );

            final tableLiabilitas= pw.Table(
              children: [
                pw.TableRow(
                  children: [
                    pw.Container(
                      padding: pw.EdgeInsets.only(right: 8),
                      child: pw.Text('Nama Akun',
                          style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                    ),
                    pw.Container(
                      padding: pw.EdgeInsets.only(left: 8),
                      alignment: pw.Alignment.centerRight,
                      child: pw.Text('Nilai',
                          style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                    )
                  ],
                ),
                ...totalJangkaPendek.entries.map((entry) => pw.TableRow(children: [
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
                ...totalJangkaPanjang.entries.map((entry) => pw.TableRow(children: [
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
                ...totalEkuitas.entries.map((entry) => pw.TableRow(children: [
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
              ],
            );

            final tableTotalLiabilitas = pw.Table(
              columnWidths: {
                0: pw.FlexColumnWidth(),
                1: pw.FlexColumnWidth(),
              },
              children: [
                pw.TableRow(children: [
                  pw.Container(
                    padding: pw.EdgeInsets.only(right: 8),
                    child: pw.Text('Total Liabilitas Jangka Pendek',
                        style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                  ),
                  pw.Container(
                    padding: pw.EdgeInsets.only(left: 8),
                    alignment: pw.Alignment.centerRight,
                    child: pw.Text(
                      rupiah.format(totalJangkaPendek.values.fold(0, (a, b) => a + b)),
                      style: pw.TextStyle(fontWeight: pw.FontWeight.bold)
                    ),
                  )
                ]),
                pw.TableRow(children: [
                  pw.Container(
                    padding: pw.EdgeInsets.only(right: 8),
                    child: pw.Text('Total Liabilitas Jangka Panjang',
                        style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                  ),
                  pw.Container(
                    padding: pw.EdgeInsets.only(left: 8),
                    alignment: pw.Alignment.centerRight,
                    child: pw.Text(
                      rupiah.format(totalJangkaPanjang.values.fold(0, (a, b) => a + b)),
                      style: pw.TextStyle(fontWeight: pw.FontWeight.bold)
                    ),
                  )
                ]),
                pw.TableRow(children: [
                  pw.Container(
                    padding: pw.EdgeInsets.only(right: 8),
                    child: pw.Text('Total Ekuitas',
                        style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                  ),
                  pw.Container(
                    padding: pw.EdgeInsets.only(left: 8),
                    alignment: pw.Alignment.centerRight,
                    child: pw.Text(
                      rupiah.format(totalEkuitas.values.fold(0, (a, b) => a + b)),
                      style: pw.TextStyle(fontWeight: pw.FontWeight.bold)
                    ),
                  )
                ]),
              ],
            );

            final tableSeluruhLiabilitas = pw.Table(
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
                          style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                    )
                  ],
                ),
                pw.TableRow(children: [
                  pw.Container(
                    padding: pw.EdgeInsets.only(right: 8),
                    child: pw.Text('Total Keseluruhan Liabilitas (Kewajiban)',
                        style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                  ),
                  pw.Container(
                    padding: pw.EdgeInsets.only(left: 8),
                    alignment: pw.Alignment.centerRight,
                    child: pw.Text(
                      rupiah.format(
                        totalJangkaPendek.values.fold(0, (a, b) => a + b) +
                            totalJangkaPanjang.values.fold(0, (a, b) => a + b) +
                            totalEkuitas.values.fold(0, (a, b) => a + b),
                      ),
                      style: pw.TextStyle(fontWeight: pw.FontWeight.bold)
                  ),
                  )
                ]), 
              ],
            );

            return <pw.Widget>[
              pw.Header(
                level: 2,
                child: pw.Text(
                  'Aset',
                  style: pw.TextStyle(
                    fontWeight: pw.FontWeight.bold, fontSize: 15
                  )
                ),
              ),
              tableAset,
              pw.Divider(),
              tableTotalAset,
              pw.Divider(),
              tableSeluruhAset,
              pw.SizedBox(height: 15),
              pw.Header(
                level: 2,
                child: pw.Text('Liabilitas (Kewajiban)',
                  style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 15)
                ),
              ),
              tableLiabilitas,
              pw.Divider(),
              tableTotalLiabilitas,
              pw.Divider(),
              tableSeluruhLiabilitas,
            ];
          },
        ),
      );
    }

    final outputDir = await getTemporaryDirectory();
      final filePath = '${outputDir.path}/laporan_posisi_keuangan.pdf';

      final pdfBytes = await pdf.save();
      final pdfFile = File(filePath);
      await pdfFile.writeAsBytes(pdfBytes);

      await Printing.sharePdf(
        bytes: await pdfFile.readAsBytes(),
        filename: 'laporan_posisi_keuangan.pdf',
      );
  }
}
