class Buku {
  int? id;
  String judul;
  String penerbit;
  String tahun;
  String kategori;
  String sinopsis;
  String pdfPath;
  bool isFavorite;

  Buku({
    this.id,
    required this.judul,
    required this.penerbit,
    required this.tahun,
    required this.kategori,
    required this.sinopsis,
    required this.pdfPath,
    this.isFavorite = false,
  });

  factory Buku.fromMap(Map<String, dynamic> map) {
    return Buku(
      id: map['id'],
      judul: map['judul'],
      penerbit: map['penerbit'],
      tahun: map['tahun'],
      kategori: map['kategori'],
      sinopsis: map['sinopsis'],
      pdfPath: map['pdfPath'],
      isFavorite: map['isFavorite'] == 1,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'judul': judul,
      'penerbit': penerbit,
      'tahun': tahun,
      'kategori': kategori,
      'sinopsis': sinopsis,
      'pdfPath': pdfPath,
      'isFavorite': isFavorite ? 1 : 0,
    };
  }
}
