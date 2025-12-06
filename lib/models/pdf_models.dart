class PdfAsset {
  const PdfAsset({
    required this.labelBuilder,
    required this.localFileName,
    required this.downloadUrl,
  });

  final String Function(dynamic) labelBuilder;
  final String localFileName;
  final String downloadUrl;

  String label(dynamic strings) => labelBuilder(strings);
}