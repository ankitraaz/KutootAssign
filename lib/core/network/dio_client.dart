import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:math';

final dioProvider = Provider<Dio>((ref) {
  final dio = Dio();
  dio.interceptors.add(MockInterceptor());
  return dio;
});

/// Mock interceptor that simulates a paginated API and task sync endpoint.
/// Each feed item gets a unique image via picsum.photos/seed/ which
/// maps a unique seed string to a unique photo.
class MockInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    await Future.delayed(const Duration(milliseconds: 500));

    if (options.path.contains('/cyber_metrics_feed')) {
      final queryParams = options.queryParameters;
      final int page = queryParams['page'] ?? 1;
      final int limit = queryParams['limit'] ?? 10;

      final List<Map<String, dynamic>> items = List.generate(limit, (index) {
        final id = (page - 1) * limit + index;
        final rng = Random(id);

        // Unique seed per item — picsum generates a different photo for each seed
        final imageUrl = 'https://picsum.photos/seed/feed_$id/600/400';

        // Generate realistic-looking chart data
        final chartData = List.generate(12, (i) {
          return 40 + rng.nextDouble() * 60; // values between 40-100
        });

        return {
          'id': id.toString(),
          'title': _titles[id % _titles.length],
          'description': _descriptions[id % _descriptions.length],
          'imageUrl': imageUrl,
          'chartData': chartData,
        };
      });

      return handler.resolve(Response(
        requestOptions: options,
        statusCode: 200,
        data: {'data': items},
      ));
    } else if (options.path.contains('/sync_cyber_ticket')) {
      return handler.resolve(Response(
        requestOptions: options,
        statusCode: 200,
        data: {'status': 'success'},
      ));
    }

    super.onRequest(options, handler);
  }

  // Varied, natural-sounding titles
  static const _titles = [
    'Weekend Hiking Trail Report',
    'Coffee Origins — Ethiopia Yirgacheffe',
    'Building a Bookshelf from Scratch',
    'Street Photography in Tokyo',
    'Understanding Sourdough Starters',
    'Sunset at the Coast',
    'Indoor Garden Setup Guide',
    'Vintage Camera Collection',
    'Morning Yoga Routine',
    'Exploring Local Farmer\'s Markets',
    'Hand-Lettering Basics',
    'Campfire Cooking Tips',
  ];

  // Varied descriptions
  static const _descriptions = [
    'A detailed look at what makes this experience worth sharing. Practical insights and personal reflections from the field.',
    'Exploring the nuances and subtleties that often go unnoticed. Every detail tells a story worth discovering.',
    'Lessons learned along the way — what worked, what didn\'t, and what I would do differently next time.',
    'A curated collection of moments and observations. Sometimes the small things matter the most.',
    'Breaking down the process step by step. Perfect for beginners and seasoned enthusiasts alike.',
    'Capturing the essence of the moment with honest reflections and visual storytelling.',
    'From planning to execution — a behind-the-scenes look at how this all came together.',
    'Tips, tricks, and personal recommendations gathered from months of hands-on experience.',
    'Finding beauty in everyday routines. A reminder to slow down and appreciate what\'s around us.',
    'An honest review with real-world usage notes. No fluff, just practical takeaways.',
    'Community-driven knowledge sharing at its best. Contributions from enthusiasts worldwide.',
    'Balancing creativity with practicality — sometimes the simplest approach wins.',
  ];
}
