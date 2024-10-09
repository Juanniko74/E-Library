import 'package:flutter/material.dart';
import 'buku_dbhelper.dart';
import 'buku.dart';
import 'edit_nilai_data.dart';

class EditBuku extends StatefulWidget {
  const EditBuku({Key? key}) : super(key: key);

  @override
  _EditBukuState createState() => _EditBukuState();
}

class _EditBukuState extends State<EditBuku> {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Edit Buku',
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
          'Tidak ada buku yang dapat diedit',
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
                icon: Icon(Icons.edit, color: Colors.blue),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => EditNilaiData(buku: buku),
                    ),
                  );
                },
              ),
            ),
          );
        },
      ),
    );
  }
}
