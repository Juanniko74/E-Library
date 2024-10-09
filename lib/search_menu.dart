import 'package:flutter/material.dart';
import 'buku_dbhelper.dart';
import 'hasil_search.dart';
import 'buku.dart';

class SearchMenu extends StatefulWidget {
  const SearchMenu({Key? key}) : super(key: key);

  @override
  _SearchMenuState createState() => _SearchMenuState();
}

class _SearchMenuState extends State<SearchMenu> {
  final TextEditingController judulController = TextEditingController();
  final TextEditingController penerbitController = TextEditingController();
  final TextEditingController tahunController = TextEditingController();
  String? selectedKategori;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: judulController,
              decoration: InputDecoration(
                labelText: 'Judul Buku',
                border: OutlineInputBorder(),
                fillColor: Colors.white,
                filled: true,
              ),
            ),
            SizedBox(height: 16),

            TextField(
              controller: penerbitController,
              decoration: InputDecoration(
                labelText: 'Penerbit',
                border: OutlineInputBorder(),
                fillColor: Colors.white,
                filled: true,
              ),
            ),
            SizedBox(height: 16),

            TextField(
              controller: tahunController,
              decoration: InputDecoration(
                labelText: 'Tahun Buku',
                border: OutlineInputBorder(),
                fillColor: Colors.white,
                filled: true,
              ),
            ),
            SizedBox(height: 16),

            DropdownButtonFormField<String>(
              decoration: InputDecoration(
                labelText: 'Pilih Kategori',
                border: OutlineInputBorder(),
                fillColor: Colors.white,
                filled: true,
              ),
              value: selectedKategori,
              onChanged: (String? newValue) {
                setState(() {
                  selectedKategori = newValue;
                });
              },
              items: ['Fiksi', 'Pengetahuan Alam', 'Matematika']
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
            SizedBox(height: 16),

            ElevatedButton(
              onPressed: () async {
                List<Buku> hasilPencarian = await DbHelper().searchBuku(
                  judul: judulController.text,
                  penerbit: penerbitController.text,
                  tahun: tahunController.text,
                  kategori: selectedKategori,
                );

                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => HasilSearch(hasilPencarian: hasilPencarian),
                  ),
                );
              },
              child: Text('Cari Buku'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    judulController.dispose();
    penerbitController.dispose();
    tahunController.dispose();
    super.dispose();
  }
}
