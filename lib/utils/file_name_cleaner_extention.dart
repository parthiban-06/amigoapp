extension FileNameCleaner on String {
  String get cleanedFileName {
    // Define common image extensions
    const formats = [
      '.svg',
      '.png',
      '.jpeg',
      '.jpg',
      '.webp',
      '.gif',
      '.bmp',
      '.ico'
    ];

    String fileName = split("/").last;

    for (final format in formats) {
      if (fileName.toLowerCase().endsWith(format)) {
        fileName = fileName.substring(0, fileName.length - format.length);
        break;
      }
    }

    return fileName.replaceAll("_", " ");
  }
}
