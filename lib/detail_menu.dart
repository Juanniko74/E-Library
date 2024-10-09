import 'package:flutter/material.dart';
import 'buku.dart';
import 'package:open_file/open_file.dart';
import 'package:pdf_render/pdf_render_widgets.dart';

class DetailMenu extends StatelessWidget {
  final Buku buku;

  const DetailMenu({Key? key, required this.buku}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(height: MediaQuery.of(context).size.height * 0.4),
          SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  color: Color(0xFF38B6FF),
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
                  child: Column(
                    children: [
                      SizedBox(height: 10),
                      Row(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Container(
                              height: 100,
                              width: 70,
                              child: PdfDocumentLoader.openFile(
                                buku.pdfPath!,
                                pageNumber: 1,
                                onError: (error) => Center(child: Text("Tidak dapat memuat PDF")),
                              ),
                            ),
                          ),
                          SizedBox(width: 15),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  buku.judul,
                                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white, fontFamily: 'Montserrat'),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                SizedBox(height: 5),
                                Text(
                                  'Penerbit: ${buku.penerbit}',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 16),
                        Text('Tahun: ${buku.tahun}', style: TextStyle(fontSize: 16)),
                        SizedBox(height: 8),
                        Text('Kategori: ${buku.kategori}', style: TextStyle(fontSize: 16)),
                        SizedBox(height: 16),
                        Divider(thickness: 1, color: Colors.grey),
                        SizedBox(height: 16),
                        Text('Sinopsis', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                        SizedBox(height: 8),
                        Expanded(
                          child: SingleChildScrollView(
                            child: Text(
                              buku.sinopsis,
                              style: TextStyle(fontSize: 16),
                              textAlign: TextAlign.justify,
                            ),
                          ),
                        ),
                        SizedBox(height: 20),
                        if (buku.pdfPath != null)
                          Center(
                            child: ElevatedButton(
                              onPressed: () async {
                                final result = await OpenFile.open(buku.pdfPath!);
                                if (result.message != "Done") {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text('PDF dibuka')),
                                  );
                                }
                              },
                              child: Text('Buka PDF'),
                              style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                              ),
                            ),
                          )
                        else
                          Center(child: Text('Tidak ada file PDF')),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            top: 30,
            left: 1,
            child: IconButton(
              icon: Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
        ],
      ),
    );
  }
}
