import 'package:aplikasi_keuangan/akunPages/aset.dart';
import 'package:aplikasi_keuangan/akunPages/beban.dart';
import 'package:aplikasi_keuangan/akunPages/liabilitas.dart';
import 'package:aplikasi_keuangan/akunPages/pendapatan.dart';
import 'package:flutter/material.dart';

class tabBarAkun extends StatefulWidget {
  @override
  _tabBarAkunState createState() => _tabBarAkunState();
}

class _tabBarAkunState extends State<tabBarAkun>
    with SingleTickerProviderStateMixin {
  late TabController tabController;

  @override
  void initState() {
    tabController = TabController(
      length: 4,
      vsync: this,
    );
    super.initState();
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Daftar Nama Akun')),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.fromLTRB(16, 16, 16, 2),
              child: Text(
                'R/L or Neraca:',
                style: TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.fromLTRB(16, 2, 16, 16),
              child: Container(
                height: MediaQuery.of(context).size.height,
                child: Column(
                  children: [
                    Container(
                        // height: 50,
                        width: MediaQuery.of(context).size.height,
                        decoration: BoxDecoration(
                          color: Colors.blue,
                        ),
                        child: Column(
                          children: [
                            Padding(
                              padding: EdgeInsets.all(5),
                              child: TabBar(
                                unselectedLabelColor: Colors.white,
                                labelColor: Colors.black,
                                indicatorColor: Colors.white,
                                indicatorWeight: 2,
                                indicator: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                controller: tabController,
                                tabs: [
                                  Tab(text: 'Aset'),
                                  Tab(text: 'Liabilitas'),
                                  Tab(text: 'Pendapatan'),
                                  Tab(text: 'Beban'),
                                ],
                              ),
                            ),
                          ],
                        )),
                    Expanded(
                      child: TabBarView(
                        controller: tabController,
                        children: [
                          aset(),
                          liabilitas(),
                          pendapatan(),
                          beban(),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
