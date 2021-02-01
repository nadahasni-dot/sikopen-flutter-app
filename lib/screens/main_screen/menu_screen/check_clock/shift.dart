class Shift {
  int value;
  String nama_cc;

  Shift({this.value, this.nama_cc});

  factory Shift.setShift(int val, String cc) {
    return Shift(value: val, nama_cc: cc);
  }
}
