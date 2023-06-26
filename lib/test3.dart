// import 'package:flutter/material.dart';



// class MyHomePage extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Input Data'),
//       ),
//       body: Center(
//         child: InputDataForm(),
//       ),
//     );
//   }
// }

// class InputDataForm extends StatefulWidget {
//   @override
//   _InputDataFormState createState() => _InputDataFormState();
// }

// class _InputDataFormState extends State<InputDataForm> {
//   String category = '';
//   TextEditingController textFieldController = TextEditingController();

//   void addIncome() {
//     setState(() {
//       category = 'Pemasukan';
//       textFieldController.clear();
//     });
//   }

//   void addExpense() {
//     setState(() {
//       category = 'Pengeluaran';
//       textFieldController.clear();
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: EdgeInsets.all(16.0),
//       child: Column(
//         children: [
//           Text('Kategori: $category', style: TextStyle(fontSize: 18.0)),
//           SizedBox(height: 16.0),
//           ElevatedButton(
//             onPressed: addIncome,
            
//             child: Text('Pemasukan'),
//           ),
//           ElevatedButton(
//             onPressed: addExpense,
     
//             child: Text('Pengeluaran'),
//           ),
//           SizedBox(height: 16.0),
//           if (category.isNotEmpty)
//             TextField(
//               controller: textFieldController,
//               decoration: InputDecoration(
//                 labelText: 'Nominal $category',
//               ),
//             ),
//         ],
//       ),
//     );
//   }
// }
