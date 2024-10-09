import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:perpus_ebuku/main.dart';
import 'buku.dart';
import 'buku_dbhelper.dart';
import 'profile_menu.dart';

class EditNilaiData extends StatefulWidget {
  final Buku buku;

  const EditNilaiData({Key? key, required this.buku}) : super(key: key);

  @override
  _EditNilaiDataState createState() => _EditNilaiDataState();
}

class _EditNilaiDataState extends State<EditNilaiData> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController penerbitController = TextEditingController();
  final TextEditingController tahunController = TextEditingController();
  final TextEditingController sinopsisController = TextEditingController();

  String? selectedKategori;
  String? pdfPath;

  @override
  void initState() {
    super.initState();
    titleController.text = widget.buku.judul;
    penerbitController.text = widget.buku.penerbit;
    tahunController.text = widget.buku.tahun;
    sinopsisController.text = widget.buku.sinopsis;
    selectedKategori = widget.buku.kategori;
    pdfPath = widget.buku.pdfPath;
  }

  Future<void> _updateBuku() async {
    String judulBuku = titleController.text;
    String penerbitBuku = penerbitController.text;
    String tahunBuku = tahunController.text;
    String sinopsisBuku = sinopsisController.text;

    if (judulBuku.isEmpty || penerbitBuku.isEmpty || tahunBuku.isEmpty || selectedKategori == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Harap lengkapi semua kolom')),
      );
    } else {
      Buku updatedBuku = Buku(
        id: widget.buku.id,
        judul: judulBuku,
        penerbit: penerbitBuku,
        tahun: tahunBuku,
        kategori: selectedKategori!,
        sinopsis: sinopsisBuku,
        pdfPath: pdfPath ?? widget.buku.pdfPath,
      );

      await DbHelper().updateBuku(updatedBuku);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Buku "${updatedBuku.judul}" berhasil diperbarui')),
      );

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => MyHomePage()),
      );
    }
  }

  Future<void> _pickPdf() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );

    if (result != null) {
      setState(() {
        pdfPath = result.files.single.path;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('PDF berhasil dipilih: ${result.files.single.name}')),
      );
    }
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
                    child: Text(value),
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
                    onPressed: _pickPdf,
                    child: Text('Ubah File PDF'),
                  ),
                  ElevatedButton(
                    onPressed: _updateBuku,
                    child: Text('Update Buku'),
                  ),
                ],
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
