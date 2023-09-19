String formatNumber(int value) {
  if (value < 10) {
    return '00$value';
  } else if (value < 100) {
    return '0$value';
  } else {
    return value.toString();
  }
}
