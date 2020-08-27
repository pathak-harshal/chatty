bool blank(final Object object) {
  return object == null ||
      false == object ||
      '' == object ||
      'null' == object ||
      (object is List && object.isEmpty);
}

bool present(final Object object) {
  return blank(object) == false;
}
