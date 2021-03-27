class ApiEndpoints {
  static const String BASE_URL = 'https://live.sabinsolusi.com/sikopen-api/';
  static const String POST_CHANGE_PASSWORD = BASE_URL + 'changepassword';
  static const String POST_LOGIN = BASE_URL + 'auth';
  static const String POST_PRESENCE = BASE_URL + 'presence/check-clock';
  static const String POST_KETIDAKHADIRAN = BASE_URL + 'tdkhadir';
  static const String GET_DATA_KETIDAKHADIRAN =
      BASE_URL + 'tdkhadir/get?pegawai_id=';
  static const String DELETE_KETIDAKHADIRAN = BASE_URL + 'tdkhadir/delete/';
  static const String POST_KIRIM_KETIDAKHADIRAN = BASE_URL + 'tdkhadir/kirim/';
  static const String GET_DATA_KETIDAKHADIRAN_PEGAWAI =
      BASE_URL + 'tdkhadir/get/';
  static const String POST_UBAH_DATA_KETIDAKHADIRAN_PEGAWAI =
      BASE_URL + 'tdkhadir';
  static const String GET_MESIN_POINT = BASE_URL + 'points/get';
  static const String GET_DATA_ABSENSI_BULANAN =
      BASE_URL + 'laporanabsensibulanan/get/';
  static const String GET_DATA_ABSENSI_PERIODIK =
      BASE_URL + 'laporanabsensiperiodik/get/';
  static const String GET_UID_ACTIVATION_STATUS =
      BASE_URL + 'registrasi-uid/uid?employee_id=';
  static const String POST_UID_REGISTRATION = BASE_URL + 'registrasi-uid';

  static const String GET_SHIFT = BASE_URL + "pilihanabsen/get?";
  
  static const String GET_DROPDOWN_IJIN = BASE_URL + "tdkhadir/get-masterpresensi";
}
