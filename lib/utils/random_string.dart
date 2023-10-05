import 'dart:math';

String generateRandomString(int length) {
  const String chars =
      'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
  final Random random = Random();
  final StringBuffer buffer = StringBuffer();

  for (int i = 0; i < length; i++) {
    final int randIndex = random.nextInt(chars.length);
    buffer.write(chars[randIndex]);
  }

  return buffer.toString();
}
