import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
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
    fetchData();
    getPref();
  }

  Future<void> fetchData() async {
    final response = await http.get(Uri.parse('https://apkeu2023.000webhostapp.com/getUser.php?'));
    print(response.statusCode); // Periksa kode status HTTP
    //print(response.body); // Periksa respons body
    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      final user = jsonData.where((data) => data['level'] == 'admin').toList();
      setState(() {
        Data = user;
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
          Container(
            padding: EdgeInsets.all(20),
            child: Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      '$usaha',
                      //title,
                      //'${Data[0]['usaha']}',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 5),
                    Text(
                      '$alamat',
                      //subtitle,
                      //'${Data[0]['alamat']}',
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
  //List<dynamic> Data = [];
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
            // trailing: Row(
            // mainAxisSize: MainAxisSize.min,
            //   children: <Widget>[
            //     IconButton(
            //       onPressed: () {}, 
            //       icon: Icon(
            //         Icons.edit,
            //         color: Colors.black,
            //       ), 
            //     )
            //   ],
            // )
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
                            //subtitle: Text('${Data[0]['nama']}'),
                          ),
                          ListTile(
                            leading: Icon(Icons.phone),
                            title: Text("No. HP/Telp"),
                            subtitle: Text('$nohp'),
                            //subtitle: Text('${Data[0]['nohp']}'),
                          ),
                          ListTile(
                            leading: Icon(Icons.mail_outlined),
                            title: Text("Email"),
                            subtitle: Text('$email'),
                            //subtitle: Text('${Data[0]['email']}'),
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

// class ProfilHeader extends StatelessWidget {
//   final String title;
//   final String subtitle;

//   const ProfilHeader({
//     super.key, 
//     required this.title, 
//     required this.subtitle, 
//   });
  
//   @override
//   Widget build(BuildContext context) {
//     return Stack(
//       children: <Widget>[
//         Container(
//           width: double.infinity,
//           margin: EdgeInsets.only(top: 50),
//           child: Column(
//             children: <Widget>[
//               Text(
//                 title,
//                 style: TextStyle(
//                   fontSize: 20,
//                   color: Colors.black
//                 ),
//               ),
//               if (subtitle != null) ...[
//                 SizedBox(
//                   height: 5.0,
//                 ),
//                 Text(
//                   subtitle,
//                   style: Theme.of(context).textTheme.titleSmall,
//                 )
//               ]
//             ],
//           ),
//         )
//       ],
//     );
//   }



// }