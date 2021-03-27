class DropdownIjin {
  String id;
  String nama;
  bool is_aktif;

  String get ijinId {
    return id;
  }

  String get ijinNama {
    return nama;
  }

  bool get ijinAktif {
    return is_aktif;
  }

  factory DropdownIjin.fromJson(Map<String, dynamic> json) {  
    return DropdownIjin(
        id: json['id'], nama: json['nama'], is_aktif: json['is_aktif']);
  }

  DropdownIjin({this.id, this.nama, this.is_aktif});

  @override
  String toString() {
    // TODO: implement toString
    return "id: " + id + ", nama: " + nama + ", is_aktif: " + is_aktif.toString();
  }
}
