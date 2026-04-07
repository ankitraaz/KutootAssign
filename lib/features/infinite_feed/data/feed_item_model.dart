import 'dart:isolate';

class FeedItemModel {
  final String id;
  final String title;
  final String description;
  final String imageUrl;
  final List<double> chartData;

  const FeedItemModel({
    required this.id,
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.chartData,
  });

  factory FeedItemModel.fromJson(Map<String, dynamic> json) {
    return FeedItemModel(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      imageUrl: json['imageUrl'] as String,
      chartData: (json['chartData'] as List<dynamic>).map((e) => (e as num).toDouble()).toList(),
    );
  }

  // Use background isolate to parse a list of JSON items
  // to avoid jank when fetching new paginated data.
  static Future<List<FeedItemModel>> parseListBackground(List<dynamic> data) async {
    return await Isolate.run(() {
      return data.map((e) => FeedItemModel.fromJson(e as Map<String, dynamic>)).toList();
    });
  }
}
