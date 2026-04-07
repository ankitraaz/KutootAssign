import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/network/dio_client.dart';
import 'feed_item_model.dart';

final feedRepositoryProvider = Provider<FeedRepository>((ref) {
  return FeedRepository(ref.watch(dioProvider));
});

class FeedRepository {
  final Dio _dio;

  FeedRepository(this._dio);

  Future<List<FeedItemModel>> fetchFeed({required int page, required int limit, CancelToken? cancelToken}) async {
    try {
      final response = await _dio.get(
        '/cyber_metrics_feed', // Unique endpoint name
        queryParameters: {'page': page, 'limit': limit},
        cancelToken: cancelToken,
      );

      final data = response.data['data'] as List<dynamic>;
      // parse in background
      return await FeedItemModel.parseListBackground(data);
    } on DioException catch (e) {
      if (CancelToken.isCancel(e)) {
        rethrow;
      }
      throw Exception('Failed to fetch telemetry feed: $e');
    } catch (e) {
      throw Exception('Failed to fetch telemetry feed: $e');
    }
  }
}
