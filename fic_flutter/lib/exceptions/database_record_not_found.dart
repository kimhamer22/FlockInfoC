class DatabaseRecordNotFound implements Exception {
  String cause;
  DatabaseRecordNotFound(this.cause);
}