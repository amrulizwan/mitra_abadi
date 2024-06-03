// To parse this JSON data, do
//
//     final dataTagihan = dataTagihanFromJson(jsonString);

import 'dart:convert';

DataTagihan dataTagihanFromJson(String str) =>
    DataTagihan.fromJson(json.decode(str));

String dataTagihanToJson(DataTagihan data) => json.encode(data.toJson());

class DataTagihan {
  String message;
  List<Datum> data;

  DataTagihan({
    required this.message,
    required this.data,
  });

  factory DataTagihan.fromJson(Map<String, dynamic> json) => DataTagihan(
        message: json["message"],
        data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "message": message,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
      };
}

class Datum {
  int id;
  DateTime tanggal;
  String nomorNota;
  String kodeCustomer;
  String namaCustomer;
  String daerah;
  String tagihan;
  String antaran;
  int umur;
  String kodeSalesman;
  String namaSalesman;
  String totalNota;
  String sisaHutang;
  String sisaHutangBySales;
  String persentasePemberianBarang;
  dynamic createdAt;
  dynamic updatedAt;

  Datum({
    required this.id,
    required this.tanggal,
    required this.nomorNota,
    required this.kodeCustomer,
    required this.namaCustomer,
    required this.daerah,
    required this.tagihan,
    required this.antaran,
    required this.umur,
    required this.kodeSalesman,
    required this.namaSalesman,
    required this.totalNota,
    required this.sisaHutang,
    required this.sisaHutangBySales,
    required this.persentasePemberianBarang,
    this.createdAt,
    this.updatedAt,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["id"],
        tanggal: DateTime.parse(json["tanggal"]),
        nomorNota: json["nomor_nota"],
        kodeCustomer: json["kode_customer"],
        namaCustomer: json["nama_customer"],
        daerah: json["daerah"],
        tagihan: json["tagihan"],
        antaran: json["antaran"],
        umur: json["umur"],
        kodeSalesman: json["kode_salesman"],
        namaSalesman: json["nama_salesman"],
        totalNota: json["total_nota"],
        sisaHutang: json["sisa_hutang"],
        sisaHutangBySales: json["sisa_hutang_by_sales"],
        persentasePemberianBarang: json["persentase_pemberian_barang"],
        createdAt: json["created_at"],
        updatedAt: json["updated_at"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "tanggal":
            "${tanggal.year.toString().padLeft(4, '0')}-${tanggal.month.toString().padLeft(2, '0')}-${tanggal.day.toString().padLeft(2, '0')}",
        "nomor_nota": nomorNota,
        "kode_customer": kodeCustomer,
        "nama_customer": namaCustomer,
        "daerah": daerah,
        "tagihan": tagihan,
        "antaran": antaran,
        "umur": umur,
        "kode_salesman": kodeSalesman,
        "nama_salesman": namaSalesman,
        "total_nota": totalNota,
        "sisa_hutang": sisaHutang,
        "sisa_hutang_by_sales": sisaHutangBySales,
        "persentase_pemberian_barang": persentasePemberianBarang,
        "created_at": createdAt,
        "updated_at": updatedAt,
      };
}
