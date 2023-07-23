import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class profilKaryawan extends StatefulWidget {
  final VoidCallback onLogout;
  profilKaryawan({Key? key, required this.onLogout}) : super(key: key);
  
  @override
  _profilKaryawanState createState() => _profilKaryawanState();
}

String? nama = "", nohp = "", email = "", usaha = "", alamat = "", status = "";

class _profilKaryawanState extends State<profilKaryawan>{
  dynamic karyawan;

  getPref() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      nama = preferences.getString("nama");
      nohp = preferences.getString("nohp");
      email = preferences.getString("email");
      usaha = preferences.getString("usaha");
      alamat = preferences.getString("alamat");
      status = preferences.getString("status");
    });
  }

  void handleLogout() {
    widget.onLogout();
  }

  @override
  void initState() {
    super.initState();
    getPref();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
    extendBodyBehindAppBar: true,
    extendBody: true,
    body: SingleChildScrollView(
      child: Column(
        children: <Widget>[
          Container(
            padding: EdgeInsets.all(20),
            child: Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text('$nama',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 5),
                    Text('$alamat',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 10,),
            karyawanInfo(onLogout: handleLogout),
          ],
        ),
      ),
    );
  }
}

class karyawanInfo extends StatelessWidget {

  final VoidCallback onLogout;
  const karyawanInfo({super.key, required this.onLogout});

  void handleLogout() {
    onLogout();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      child: Column(
        children: <Widget>[
          ListTile(
            title: Text('Informasi Karyawan',
              style: TextStyle(fontSize: 16),
              textAlign: TextAlign.left,
            ),
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
                            leading: Icon(Icons.person),
                            title: Text("Nama Anggota"),
                            subtitle: Text('$nama'),
                          ),
                          ListTile(
                            leading: Icon(Icons.phone),
                            title: Text("No. HP/Telp"),
                            subtitle: Text('$nohp'),
                          ),
                          ListTile(
                            leading: Icon(Icons.mail_outlined),
                            title: Text("Email"),
                            subtitle: Text('$email'),
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
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                    child: Text('Keluar'),
                    onPressed: () {
                      handleLogout();
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