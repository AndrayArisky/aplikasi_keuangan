import 'package:flutter/material.dart';


class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Input Data'),
      ),
      body: Center(
        child: TextFieldWithModal(),
      ),
    );
  }
}

class TextFieldWithModal extends StatefulWidget {
  @override
  _TextFieldWithModalState createState() => _TextFieldWithModalState();
}

class _TextFieldWithModalState extends State<TextFieldWithModal> {
  String category = '';
  TextEditingController categoryController = TextEditingController();

  void openModal() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return InputDataModal(
          onCategorySelected: (String selectedCategory) {
            setState(() {
              category = selectedCategory;
              categoryController.text = selectedCategory;
            });
            Navigator.pop(context);
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.0),
      child: Column(
        children: [
          TextField(
            controller: categoryController,
            decoration: InputDecoration(
              labelText: 'Kategori',
              suffixIcon: IconButton(
                icon: Icon(Icons.edit),
                onPressed: openModal,
              ),
            ),
          ),
          SizedBox(height: 16.0),
          Text(
            'Kategori: $category',
            style: TextStyle(fontSize: 18.0),
          ),
        ],
      ),
    );
  }
}

class InputDataModal extends StatelessWidget {
  final Function(String) onCategorySelected;

  InputDataModal({required this.onCategorySelected});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('Pilih Kategori'),
          SizedBox(height: 16.0),
          ElevatedButton(
            onPressed: () => onCategorySelected('Pemasukan'),
       
            child: Text('Pemasukan'),
          ),
          ElevatedButton(
            onPressed: () => onCategorySelected('Pengeluaran'),
            
            child: Text('Pengeluaran'),
          ),
        ],
      ),
    );
  }
}
