import 'dart:convert';

DataOtlet dataOtletFromJson(String str) => DataOtlet.fromJson(json.decode(str));

String dataOtletToJson(DataOtlet data) => json.encode(data.toJson());

class DataOtlet {
  String message;
  List<Datum> data;

  DataOtlet({
    required this.message,
    required this.data,
  });

  factory DataOtlet.fromJson(Map<String, dynamic> json) => DataOtlet(
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
  String? stat;
  String? bebasBlok;
  String? kode;
  String? namaCustomer;
  String? kontak;
  String? alamat;
  String? daerah;
  String? area;
  String? telp;
  String? keterangan;
  String? ktp;
  String? npwp;
  String? gol;
  String? tglInput;
  String? setHarga;
  String? areaAntaran;
  String? areaTagihan;
  String? typeCustomer;
  String? limitKredit;
  String? limitDivisi;
  String? namaNpwp;
  String? alamatNpwp;
  DateTime? createdAt;
  DateTime? updatedAt;

  Datum({
    required this.id,
    this.stat,
    this.bebasBlok,
    this.kode,
    this.namaCustomer,
    this.kontak,
    this.alamat,
    this.daerah,
    this.area,
    this.telp,
    this.keterangan,
    this.ktp,
    this.npwp,
    this.gol,
    this.tglInput,
    this.setHarga,
    this.areaAntaran,
    this.areaTagihan,
    this.typeCustomer,
    this.limitKredit,
    this.limitDivisi,
    this.namaNpwp,
    this.alamatNpwp,
    this.createdAt,
    this.updatedAt,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["id"],
        stat: json["stat"],
        bebasBlok: json["bebas_blok"],
        kode: json["kode"],
        namaCustomer: json["nama_customer"],
        kontak: json["kontak"],
        alamat: json["alamat"],
        daerah: json["daerah"],
        area: json["area"],
        telp: json["telp"],
        keterangan: json["keterangan"],
        ktp: json["ktp"],
        npwp: json["npwp"],
        gol: json["gol"],
        tglInput: json["tgl_input"],
        setHarga: json["set_harga"],
        areaAntaran: json["area_antaran"],
        areaTagihan: json["area_tagihan"],
        typeCustomer: json["type_customer"],
        limitKredit: json["limit_kredit"],
        limitDivisi: json["limit_divisi"],
        namaNpwp: json["nama_npwp"],
        alamatNpwp: json["alamat_npwp"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "stat": stat,
        "bebas_blok": bebasBlok,
        "kode": kode,
        "nama_customer": namaCustomer,
        "kontak": kontak,
        "alamat": alamat,
        "daerah": daerah,
        "area": area,
        "telp": telp,
        "keterangan": keterangan,
        "ktp": ktp,
        "npwp": npwp,
        "gol": gol,
        "tgl_input": tglInput,
        "set_harga": setHarga,
        "area_antaran": areaAntaran,
        "area_tagihan": areaTagihan,
        "type_customer": typeCustomer,
        "limit_kredit": limitKredit,
        "limit_divisi": limitDivisi,
        "nama_npwp": namaNpwp,
        "alamat_npwp": alamatNpwp,
        "created_at": createdAt!.toIso8601String(),
        "updated_at": updatedAt!.toIso8601String(),
      };
}
