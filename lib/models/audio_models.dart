import '../constants/localized_strings.dart';

class AudioCollection {
  const AudioCollection({
    required this.id,
    required this.label,
    required this.manifestAsset,
    required this.subtitleBuilder,
  });

  final String id;
  final String label;
  final String manifestAsset;
  final String Function(AppStrings) subtitleBuilder;

  String subtitle(AppStrings strings) => subtitleBuilder(strings);
}

class SurahAudio {
  const SurahAudio({
    required this.title,
    required this.url,
    this.localPath,
  });

  final String title;
  final String url;
  final String? localPath;

  SurahAudio withLocalPath(String path) {
    return SurahAudio(
      title: title,
      url: url,
      localPath: path,
    );
  }
}