import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class profilAdmin extends StatefulWidget {

  @override
  _profilAdminState createState() => _profilAdminState();
}

class _profilAdminState extends State<profilAdmin>{
  List<dynamic> Data = [];

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    final response = await http.get(Uri.parse('https://apkeu2023.000webhostapp.com/getprofil.php'));
    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      setState(() {
        Data = jsonData;
      });
    } else {
      throw Exception('Gagal mengambil data!');
    }
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
                            leading: Icon(Icons.person),
                            title: Text("Nama Karyawan"),
                            subtitle: Text("Arisky"),
                          ),
                          ListTile(
                            leading: Icon(Icons.mail_outlined),
                            title: Text("Email"),
                            subtitle: Text("Andray"),
                          ),
                          ListTile(
                            leading: Icon(Icons.phone),
                            title: Text("No. HP/Telp"),
                            subtitle: Text("Andray"),
                          ),
                          ListTile(
                            leading: Icon(Icons.business_rounded),
                            title: Text("Bidang Usaha"),
                            subtitle: Text("Andray"
                            ),
                          ),
                          ListTile(
                            leading: Icon(
                              Icons.format_list_numbered_sharp
                            ),
                            title: Text(
                              "NPWP Usaha"
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
          )
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
        Container(
          width: double.infinity,
          margin: EdgeInsets.only(top: 50),
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