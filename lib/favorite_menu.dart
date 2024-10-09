import 'package:flutter/material.dart';
import 'buku_dbhelper.dart';
import 'buku.dart';

class FavoritMenu extends StatefulWidget {
  const FavoritMenu({Key? key}) : super(key: key);

  @override
  _FavoritMenuState createState() => _FavoritMenuState();
}

class _FavoritMenuState extends State<FavoritMenu> {
  late Future<List<Buku>> _favoriteBooks;

  @override
  void initState() {
    super.initState();
    _loadFavoriteBooks();
  }

  void _loadFavoriteBooks() {
    _favoriteBooks = DbHelper().getFavoriteBooks();
  }

  void _toggleFavorite(Buku buku) async {
    setState(() {
      buku.isFavorite = !buku.isFavorite;
    });

    await DbHelper().updateBuku(buku);
    _loadFavoriteBooks();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(buku.isFavorite ? 'Buku ditambahkan ke favorit' : 'Buku dihapus dari favorit'),
      ),
    );
  }

  void _showBukuDetails(BuildContext context, Buku buku) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(buku.judul),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Penerbit: ${buku.penerbit}'),
                Text('Tahun: ${buku.tahun}'),
                Text('Kategori: ${buku.kategori}'),
                SizedBox(height: 10),
                Text('Sinopsis:'),
                Text(buku.sinopsis),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Tutup'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: FutureBuilder<List<Buku>>(
          future: _favoriteBooks,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Center(child: Text('Tidak ada buku favorit'));
            } else {
              final favoriteBooks = snapshot.data!;
              return ListView.builder(
                itemCount: favoriteBooks.length,
                itemBuilder: (context, index) {
                  final buku = favoriteBooks[index];
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
                        icon: Icon(
                          buku.isFavorite ? Icons.favorite : Icons.favorite_border,
                          color: buku.isFavorite ? Colors.red : null,
                        ),
                        onPressed: () {
                          _toggleFavorite(buku);
                        },
                      ),
                      onTap: () {
                        _showBukuDetails(context, buku);
                      },
                    ),
                  );
                },
              );
            }
          },
        ),
      ),
    );
  }
}
