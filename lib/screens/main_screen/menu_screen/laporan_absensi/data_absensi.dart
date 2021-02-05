class DataAbsensi {
  String tgl;
  String hari;
  String shift;
  String jmasuk;
  String jpulang;
  String amasuk;
  String apulang;
  int terlambat;
  String jefektif;

  DataAbsensi(
      {this.tgl,
      this.hari,
      this.shift,
      this.jmasuk,
      this.jpulang,
      this.amasuk,
      this.apulang,
      this.terlambat,
      this.jefektif});

  factory DataAbsensi.fromJson(Map<String, dynamic> json) {
    return DataAbsensi(
        tgl: json['tanggal'],
        hari: json['hari'],
        shift: json['shift'],
        jmasuk: json['jk_in'],
        jpulang: json['jk_out'],
        amasuk: json['absen_in'],
        apulang: json['absen_out'],
        terlambat: json['terlambat'],
        jefektif: json['jam_efektif']);
  }
}
