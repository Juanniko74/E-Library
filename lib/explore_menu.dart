import 'package:flutter/material.dart';
import 'package:pdf_render/pdf_render_widgets.dart';
import 'buku_dbhelper.dart';
import 'buku.dart';
import 'detail_menu.dart';

class ExploreMenu extends StatefulWidget {
  const ExploreMenu({Key? key}) : super(key: key);

  @override
  _ExploreMenuState createState() => _ExploreMenuState();
}

class _ExploreMenuState extends State<ExploreMenu> {
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

  void _toggleFavorite(Buku buku) async {
    setState(() {
      buku.isFavorite = !buku.isFavorite;
    });
    await DbHelper().updateBuku(buku);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(buku.isFavorite ? 'Buku ditambahkan ke favorit' : 'Buku dihapus dari favorit'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: isLoading
            ? Center(child: CircularProgressIndicator())
            : bukuList.isEmpty
            ? Center(
          child: Text(
            'Belum ada buku yang ditambahkan',
            style: TextStyle(fontSize: 18),
          ),
        )
            : Padding(
          padding: const EdgeInsets.all(8.0),
          child: GridView.builder(
            itemCount: bukuList.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              childAspectRatio: 0.7,
            ),
            itemBuilder: (context, index) {
              Buku buku = bukuList[index];
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DetailMenu(buku: buku),
                    ),
                  );
                },
                child: Card(
                  elevation: 4,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Expanded(
                        child: buku.pdfPath != null
                            ? PdfDocumentLoader.openFile(
                          buku.pdfPath!,
                          pageNumber: 1,
                          onError: (error) {
                            print('Error loading PDF: $error');
                          },
                        )
                            : Container(
                          color: Colors.grey[300],
                          child: Icon(Icons.book, size: 60),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              buku.judul,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Align(
                              alignment: Alignment.centerRight,
                              child: IconButton(
                                icon: Icon(
                                  buku.isFavorite ? Icons.favorite : Icons.favorite_border,
                                  color: buku.isFavorite ? Colors.red : null,
                                ),
                                onPressed: () {
                                  _toggleFavorite(buku);
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
