import 'package:flutter/material.dart';

class labaRugi extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Laporan Laba Rugi'),
      ),
      body: Padding(
        padding: EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Bulan: September 2023',
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20.0),
            _buildItemRow('Pendapatan'),
            SizedBox(height: 10.0),
            _buildAkunRow('Pendapatan Jasa', 'Rp.100.000.000'),
            _buildAkunRow('Pendapatan GiveAway', 'Rp.50.000.000'),
            _buildAkunRow('Dapat Dari Baim Wong', 'Rp.5.000.000'),
            Divider(),
            _buildTotalRow('Total Pendapatan', 'Rp 155.000.000'),
            Divider(),

            SizedBox(height: 20.0),
            _buildItemRow('Biaya/Beban'),
            SizedBox(height: 10.0),
            _buildAkunRow('Harga Pokok Penjualan', 'Pengeluaran'),
            _buildAkunRow('Beban Perlengkapan/ATK', 'Pengeluaran'),
            _buildAkunRow('Beban Gaji Karyawan', 'Pengeluaran'),
            _buildAkunRow('Beban Sewa', 'Pengeluaran'),
            _buildAkunRow('Beban Listrik', 'Pengeluaran'),
            _buildAkunRow('Beban Air', 'Pengeluaran'),
            _buildAkunRow('Beban Lain-lain', 'Pengeluaran'),
            Divider(),
            _buildTotalRow('Total Biaya/Beban', 'Rp 50.000.000'),
            Divider(),

            SizedBox(height: 40.0),
            _buildTotalRow('Total Laba/Rugi', 'Rp 155.000.000'),
            _buildTotalRow('Total Beban Biaya', 'Rp 155.000.000'),
            _buildTotalRow('Total Beban Pajak', 'Rp 155.000.000'),
          ],
        ),
      ),
    );
  }

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
}


