import 'package:aplikasi_keuangan/transaksiPage/loginPage.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class profilKaryawan extends StatefulWidget {

  @override
  _profilKaryawanState createState() => _profilKaryawanState();
}

class _profilKaryawanState extends State<profilKaryawan>{

  Future<void> clearLoginData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      extendBody: true,
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            ProfilHeader(
              title: "Nama Usaha",
              subtitle: "Alamat Usaha",
            ),
            SizedBox(height: 10,),
            karyawanInfo(),
          ],
        ),
      ),
    );
  }
}

class karyawanInfo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      child: Column(
        children: <Widget>[
          ListTile(
            title: Text(
              'Informasi Karyawan',
              style: TextStyle(
                fontSize: 16,
              ),
              textAlign: TextAlign.left,
            ),
            trailing: Row(
            mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                IconButton(
                  onPressed: () {}, 
                  icon: Icon(
                    Icons.edit,
                    color: Colors.black,
                  ), 
                )
              ],
            )
          ),
          Card(
            child: Container(
              alignment: Alignment.topLeft,
              padding: EdgeInsets.all(15),
              child: Column(
                children: <Widget>[
                  Column(
                    children: <Widget>[
                      ...ListTile.divideTiles(
                        color: Colors.blue,
                        tiles: [
                          ListTile(
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 4
                            ),
                            leading: Icon(
                              Icons.local_activity
                            ),
                            title: Text(
                              "Nama Karyawan"
                            ),
                            subtitle: Text(
                              "Arisky"
                            ),
                          ),
                          ListTile(
                            leading: Icon(
                              Icons.local_activity
                            ),
                            title: Text(
                              "Nama Admin"
                            ),
                            subtitle: Text(
                              "Andray"
                            ),
                          ),
                          ListTile(
                            leading: Icon(
                              Icons.local_activity
                            ),
                            title: Text(
                              "Nama Admin"
                            ),
                            subtitle: Text(
                              "Andray"
                            ),
                          )
                        ]
                      )
                    ],
                  )
                ],
              ),
            ),
          ),
          SizedBox(height: 30,),
            Row(
              children: <Widget>[
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(4, 15, 4, 15),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue
                      ),
                      child: Text('Keluar'),
                      onPressed: () {
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(builder: (context) => loginPage()),
                          (Route<dynamic> route) => false,
                        );
                      }, 
                    ),
                  )
                )
              ],
            ),
        ],
      ),
    );
  }

}

class ProfilHeader extends StatelessWidget {
  final String title;
  final String subtitle;
  final List<Widget>? action;

  const ProfilHeader({
    super.key, 
    required this.title, 
    required this.subtitle, 
    this.action
  });
  
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        if (action != null)
        Container(
          width: double.infinity,
          height: 100,
          padding: EdgeInsets.only(bottom: 0, right: 0),
          alignment: Alignment.bottomRight,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: action!,
          ),
        ),
        Container(
          width: double.infinity,
          margin: EdgeInsets.only(top: 100),
          child: Column(
            children: <Widget>[
              Text(
                title,
                style: Theme.of(context).textTheme.titleLarge,
              ),
              if (subtitle != null) ...[
                SizedBox(
                  height: 5.0,
                ),
                Text(
                  subtitle,
                  style: Theme.of(context).textTheme.titleSmall,
                )
              ]
            ],
          ),
        )
      ],
    );
  }
}