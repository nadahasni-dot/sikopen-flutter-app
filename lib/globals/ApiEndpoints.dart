class ApiEndpoints {
  static const String BASE_URL = 'https://dev.sabinsolusi.com/sikopen-api/';
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
}
