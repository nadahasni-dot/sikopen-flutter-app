class Shift2 {
  int id;
  int groupId;
  int pilihanId;
  String nama;
  int tipe;
  bool isActive;

  Shift2(
      {this.id,
      this.groupId,
      this.pilihanId,
      this.nama,
      this.tipe,
      this.isActive});

  factory Shift2.fromJson(Map<String, dynamic> json) {
    return Shift2(
        id: json['id'],
        groupId: json['group_id'],
        pilihanId: json['pilihan_id'],
        nama: json['nama'],
        tipe: json['tipe'],
        isActive: json['is_active']);
  }
}
