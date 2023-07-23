import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class profilAdmin extends StatefulWidget {
  @override
  _profilAdminState createState() => _profilAdminState();
}

String? nama = "", nohp = "", email = "", usaha = "", alamat = "";

class _profilAdminState extends State<profilAdmin>{
  List<String> Data = [];

  getPref() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      nama = preferences.getString("nama");
      nohp = preferences.getString("nohp");
      email = preferences.getString("email");
      usaha = preferences.getString("usaha");
      alamat = preferences.getString("alamat");
    });
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
                    Text('$usaha',
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
            adminInfo(),
          ],
        ),
      ),
    );
  }
}

class adminInfo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      child: Column(
        children: <Widget>[
          ListTile(
            title: Text(
              'Informasi Admin',
              style: TextStyle(fontSize: 16),
              textAlign: TextAlign.left,
            ),
          ),

          Card(
            child: Container(
              alignment: Alignment.topLeft,
              padding: EdgeInsets.all(20),
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
                            title: Text("Nama Pemilik Usaha"),
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
                          ), 
                        ]
                      )
                    ],
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}