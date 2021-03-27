class Ketidakhadiran {
  int tdkhadir_id;
  String fk_tidak_hadir;
  String tglAwal;
  String tglAkhir;
  String keterangan;
  int acc_status;

  Ketidakhadiran(
      {this.tdkhadir_id,
      this.fk_tidak_hadir,
      this.tglAwal,
      this.tglAkhir,
      this.keterangan,
      this.acc_status});

  factory Ketidakhadiran.fromJson(Map<String, dynamic> json) {
    var fk = 'Sakit';

    if (json['fk_tidak_hadir'] == 'I') {
      fk = 'Ijin';
    }

    if (json['fk_tidak_hadir'] == 'CT') {
      fk = 'Cuti Tahunan';
    }

    return Ketidakhadiran(
        fk_tidak_hadir: fk,
        tdkhadir_id: json['tdkhadir_id'],
        tglAwal: json['mulai'],
        tglAkhir: json['akhir'],
        keterangan: json['keterangan'],
        acc_status: json['acc_status']);
  }
}
