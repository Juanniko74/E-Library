import 'package:flutter/material.dart';
import 'buku.dart';
import 'detail_menu.dart';

class HasilSearch extends StatelessWidget {
  final List<Buku> hasilPencarian;

  const HasilSearch({Key? key, required this.hasilPencarian}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Hasil Pencarian',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
              fontFamily: 'Montserrat'
          ),
        ),
        backgroundColor: Color(0xFF38B6FF),
        iconTheme: IconThemeData(
          color: Colors.white,
        ),
      ),
      body: Container(
        child: hasilPencarian.isEmpty
            ? Center(child: Text('Tidak ada hasil ditemukan'))
            : ListView.builder(
          itemCount: hasilPencarian.length,
          itemBuilder: (context, index) {
            Buku buku = hasilPencarian[index];
            return Card(
              margin: EdgeInsets.all(8.0),
              child: ListTile(
                title: Text(buku.judul),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Penerbit: ${buku.penerbit}'),
                    Text('Tahun: ${buku.tahun}'),
                    Text('Kategori: ${buku.kategori}'),
                  ],
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DetailMenu(buku: buku),
                    ),
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }
}
