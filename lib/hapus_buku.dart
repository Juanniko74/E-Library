import 'package:flutter/material.dart';
import 'buku_dbhelper.dart';
import 'buku.dart';

class HapusBuku extends StatefulWidget {
  const HapusBuku({Key? key}) : super(key: key);

  @override
  _HapusBukuState createState() => _HapusBukuState();
}

class _HapusBukuState extends State<HapusBuku> {
  List<Buku> bukuList = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadBukuList();
  }

  Future<void> _loadBukuList() async {
    setState(() {
      isLoading = true;
    });

    final List<Buku> list = await DbHelper().getBukuList();

    setState(() {
      bukuList = list;
      isLoading = false;
    });
  }

  void _showDeleteConfirmation(BuildContext context, Buku buku) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Konfirmasi Hapus'),
          content: Text('Apakah anda yakin ingin menghapus buku "${buku.judul}" ini?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Tidak'),
            ),
            TextButton(
              onPressed: () async {
                if (buku.id != null) {
                  await DbHelper().deleteBuku(buku.id!);
                  Navigator.of(context).pop();
                  _loadBukuList();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Buku "${buku.judul}" telah dihapus')),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('ID buku tidak valid')),
                  );
                }
              },
              child: Text('Iya'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Hapus Buku',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Color(0xFF38B6FF),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : bukuList.isEmpty
          ? Center(
        child: Text(
          'Tidak ada buku yang dapat dihapus',
          style: TextStyle(fontSize: 18),
        ),
      )
          : ListView.builder(
        itemCount: bukuList.length,
        itemBuilder: (context, index) {
          Buku buku = bukuList[index];
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
              trailing: IconButton(
                icon: Icon(Icons.delete, color: Colors.red),
                onPressed: () {
                  _showDeleteConfirmation(context, buku);
                },
              ),
            ),
          );
        },
      ),
    );
  }
}
