class Mesin {
  String mesin_nama;
  String mesin_port;
  int mesin_id;
  String mesin_ip;
  bool mesin_aktif;
  String mesin_longitude;
  String mesin_latitude;
  String mesin_rad;

  Mesin(
      {this.mesin_nama,
      this.mesin_port,
      this.mesin_id,
      this.mesin_ip,
      this.mesin_aktif,
      this.mesin_longitude,
      this.mesin_latitude,
      this.mesin_rad});

  factory Mesin.fromJson(Map<String, dynamic> json) {
    return Mesin(
        mesin_nama: json['mesin_nama'],
        mesin_port: json['mesin_port'],
        mesin_id: json['mesin_id'],
        mesin_ip: json['mesin_ip'],
        mesin_aktif: json['mesin_aktif'],
        mesin_longitude: json['mesin_longitude'],
        mesin_latitude: json['mesin_latitude'],
        mesin_rad: json['mesin_rad']);
  }
}
