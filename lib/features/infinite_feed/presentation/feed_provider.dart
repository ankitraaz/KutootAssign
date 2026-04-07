import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/feed_item_model.dart';
import '../data/feed_repository.dart';

/// Immutable state class for the feed.
class FeedState {
  final List<FeedItemModel> items;
  final bool isLoading;
  final bool hasReachedMax;
  final int page;
  final String? error;

  const FeedState({
    this.items = const [],
    this.isLoading = false,
    this.hasReachedMax = false,
    this.page = 1,
    this.error,
  });

  FeedState copyWith({
    List<FeedItemModel>? items,
    bool? isLoading,
    bool? hasReachedMax,
    int? page,
    String? error,
  }) {
    return FeedState(
      items: items ?? this.items,
      isLoading: isLoading ?? this.isLoading,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      page: page ?? this.page,
      error: error ?? this.error,
    );
  }
}

/// Uses modern Riverpod Notifier (not the deprecated StateNotifier).
/// Manages paginated feed state with cancel-token support.
class FeedNotifier extends Notifier<FeedState> {
  CancelToken? _cancelToken;

  @override
  FeedState build() {
    // Auto-dispose cancel token when provider is disposed
    ref.onDispose(() {
      _cancelToken?.cancel('Provider disposed');
    });

    // Kick off initial fetch
    Future.microtask(() => fetchInitial());
    return const FeedState();
  }

  FeedRepository get _repository => ref.read(feedRepositoryProvider);

  Future<void> fetchInitial() async {
    if (state.isLoading) return;
    state = state.copyWith(isLoading: true, error: null);

    _cancelToken?.cancel('New fetch');
    _cancelToken = CancelToken();

    try {
      final items = await _repository.fetchFeed(
        page: 1,
        limit: 10,
        cancelToken: _cancelToken,
      );
      state = state.copyWith(
        items: items,
        isLoading: false,
        page: 2,
        hasReachedMax: items.isEmpty,
      );
    } on DioException catch (e) {
      if (CancelToken.isCancel(e)) return;
      state = state.copyWith(isLoading: false, error: e.message);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<void> fetchMore() async {
    if (state.isLoading || state.hasReachedMax) return;

    state = state.copyWith(isLoading: true, error: null);
    _cancelToken = CancelToken();

    try {
      final items = await _repository.fetchFeed(
        page: state.page,
        limit: 10,
        cancelToken: _cancelToken,
      );
      state = state.copyWith(
        items: [...state.items, ...items],
        isLoading: false,
        page: state.page + 1,
        hasReachedMax: items.isEmpty,
      );
    } on DioException catch (e) {
      if (CancelToken.isCancel(e)) return;
      state = state.copyWith(isLoading: false, error: e.message);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<void> refresh() async {
    _cancelToken?.cancel('Refresh triggered');
    _cancelToken = null;
    state = const FeedState();
    await fetchInitial();
  }
}

final feedProvider = NotifierProvider<FeedNotifier, FeedState>(
  FeedNotifier.new,
);
