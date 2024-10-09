import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:perpus_ebuku/main.dart';
import 'buku_dbhelper.dart';
import 'buku.dart';

class TambahBuku extends StatefulWidget {
  const TambahBuku({Key? key}) : super(key: key);

  @override
  _TambahBukuState createState() => _TambahBukuState();
}

class _TambahBukuState extends State<TambahBuku> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController penerbitController = TextEditingController();
  final TextEditingController tahunController = TextEditingController();
  final TextEditingController sinopsisController = TextEditingController();

  String? selectedKategori;
  String? _pdfPath;

  final DbHelper _dbHelper = DbHelper();

  void _uploadPDF() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );

    if (result != null) {
      String? filePath = result.files.single.path;
      setState(() {
        _pdfPath = filePath;
      });
      print('File path: $filePath');
    } else {
      print('File tidak dipilih');
    }
  }

  void _tambahBuku(BuildContext context) async {
    String judulBuku = titleController.text;
    String penerbitBuku = penerbitController.text;
    String tahunBuku = tahunController.text;
    String sinopsisBuku = sinopsisController.text;

    if (judulBuku.isEmpty ||
        penerbitBuku.isEmpty ||
        tahunBuku.isEmpty ||
        selectedKategori == null ||
        _pdfPath == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Anda belum melengkapi kolom atau belum mengupload pdf!')),
      );
    } else {
      Buku bukuBaru = Buku(
        judul: judulBuku,
        penerbit: penerbitBuku,
        tahun: tahunBuku,
        kategori: selectedKategori!,
        sinopsis: sinopsisBuku,
        pdfPath: _pdfPath!,
      );

      await DbHelper().insertBuku(bukuBaru);

      titleController.clear();
      penerbitController.clear();
      tahunController.clear();
      sinopsisController.clear();
      setState(() {
        selectedKategori = null;
        _pdfPath = null;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Buku berhasil ditambahkan')),
      );

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => MyHomePage()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Tambah Buku',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Color(0xFF38B6FF),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                controller: titleController,
                decoration: InputDecoration(
                  labelText: 'Judul Buku',
                  border: OutlineInputBorder(),
                  filled: true,
                  fillColor: Colors.white,
                ),
              ),
              SizedBox(height: 16),

              TextField(
                controller: penerbitController,
                decoration: InputDecoration(
                  labelText: 'Nama Penerbit',
                  border: OutlineInputBorder(),
                  filled: true,
                  fillColor: Colors.white,
                ),
              ),
              SizedBox(height: 16),

              TextField(
                controller: tahunController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Tahun Buku',
                  border: OutlineInputBorder(),
                  filled: true,
                  fillColor: Colors.white,
                ),
              ),
              SizedBox(height: 16),

              DropdownButtonFormField<String>(
                decoration: InputDecoration(
                  labelText: 'Pilih Kategori',
                  border: OutlineInputBorder(),
                  filled: true,
                  fillColor: Colors.white,
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
                    child: Container(
                      color: Colors.white,
                      child: Text(value),
                    ),
                  );
                }).toList(),
              ),
              SizedBox(height: 16),

              TextField(
                controller: sinopsisController,
                maxLines: 4,
                decoration: InputDecoration(
                  labelText: 'Sinopsis',
                  border: OutlineInputBorder(),
                  filled: true,
                  fillColor: Colors.white,
                ),
              ),
              SizedBox(height: 16),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                    onPressed: _uploadPDF,
                    child: Text('Upload PDF'),
                  ),
                  ElevatedButton(
                    onPressed: () => _tambahBuku(context),
                    child: Text('Tambah Buku'),
                  ),
                ],
              ),
              SizedBox(height: 8),

              _pdfPath != null
                  ? Text(
                'PDF berhasil di-upload!',
                style: TextStyle(color: Colors.green),
              )
                  : Text(
                'Belum ada file PDF yang dipilih',
                style: TextStyle(color: Colors.red),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    titleController.dispose();
    penerbitController.dispose();
    tahunController.dispose();
    sinopsisController.dispose();
    super.dispose();
  }
}
