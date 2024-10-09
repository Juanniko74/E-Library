import 'package:flutter/material.dart';
import 'tambah_buku.dart';
import 'edit_buku.dart';
import 'hapus_buku.dart';

class ProfileMenu extends StatelessWidget {
  const ProfileMenu({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Card(
              child: ListTile(
                leading: Icon(Icons.add),
                title: Text('Tambah Buku'),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => TambahBuku()),
                  );
                },
              ),
            ),
            SizedBox(height: 16),

            Card(
              child: ListTile(
                leading: Icon(Icons.edit),
                title: Text('Edit Buku'),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => EditBuku()),
                  );
                },
              ),
            ),
            SizedBox(height: 16),

            Card(
              child: ListTile(
                leading: Icon(Icons.delete),
                title: Text('Hapus Buku'),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => HapusBuku()),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
