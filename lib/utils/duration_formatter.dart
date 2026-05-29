// utils/duration_formatter.dart

class DurationFormatter {
  static String format(Duration duration) {
    final minutes = duration.inMinutes.remainder(60).toString().padLeft(2, '0');
    final seconds = duration.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }
}

String surahColorHex(int surahNumber) {
  const colors = [
    '1B4332', '1D3557', '6D3B47', '3D405B',
    '2D6A4F', '5C3317', '264653', '4A1942',
  ];
  return colors[surahNumber % colors.length];
}