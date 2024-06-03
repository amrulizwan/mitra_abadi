// ignore_for_file: constant_identifier_names, duplicate_ignore

class DataBarang {
  int id;
  String? kodeBarang;
  String namaBarang;
  String? jenisBarang;
  String? divisi;
  String? stock;
  Satuan? satuan;
  String? keteranganIsi1;
  String? keteranganIsi2;
  String? hargaDalamKota;
  dynamic createdAt;
  dynamic updatedAt;

  DataBarang({
    required this.id,
    this.kodeBarang,
    required this.namaBarang,
    this.jenisBarang,
    this.divisi,
    this.stock,
    this.satuan,
    this.keteranganIsi1,
    this.keteranganIsi2,
    this.hargaDalamKota,
    this.createdAt,
    this.updatedAt,
  });

  factory DataBarang.fromJson(Map<String, dynamic> json) => DataBarang(
        id: json["id"],
        kodeBarang: json["kode_barang"],
        namaBarang: json["nama_barang"],
        jenisBarang: json["jenis_barang"],
        divisi: json["divisi"],
        stock: json["stock"],
        satuan: json["satuan"] != null ? satuanValues.map[json["satuan"]] : null,
        keteranganIsi1: json["keterangan_isi_1"],
        keteranganIsi2: json["keterangan_isi_2"],
        hargaDalamKota: json["harga_dalam_kota"],
        createdAt: json["created_at"],
        updatedAt: json["updated_at"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "kode_barang": kodeBarang,
        "nama_barang": namaBarang,
        "jenis_barang": jenisBarang,
        "divisi": divisi,
        "stock": stock,
        "satuan": satuan != null ? satuanValues.reverse[satuan!] : null,
        "keterangan_isi_1": keteranganIsi1,
        "keterangan_isi_2": keteranganIsi2,
        "harga_dalam_kota": hargaDalamKota,
        "created_at": createdAt,
        "updated_at": updatedAt,
      };
}


enum Satuan {
  // ignore: constant_identifier_names
  BALL,
  // ignore: constant_identifier_names
  BOX,
  // ignore: constant_identifier_names
  CRT,
  EMBER,
  GENTONG,
  IKAT,
  KRG,
  LS,
  PAK,
  PCS,
  RAK,
  SATUAN
}

final satuanValues = EnumValues({
  "Ball": Satuan.BALL,
  "Box": Satuan.BOX,
  "crt": Satuan.CRT,
  "EMBER": Satuan.EMBER,
  "GENTONG": Satuan.GENTONG,
  "Ikat": Satuan.IKAT,
  "Krg": Satuan.KRG,
  "Ls": Satuan.LS,
  "Pak": Satuan.PAK,
  "Pcs": Satuan.PCS,
  "Rak": Satuan.RAK,
  "Satuan": Satuan.SATUAN
});

class EnumValues<T> {
  Map<String, T> map;
  late Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    reverseMap = map.map((k, v) => MapEntry(v, k));
    return reverseMap;
  }
}
