part of 'search_cubit.dart';

class SearchState {
  final List<EventModel> results;
  final bool isLoading;
  final bool hasSearched;
  final String? error;
  final String? selectedClassificationId;
  final String query;

  const SearchState({
    required this.results,
    required this.isLoading,
    required this.hasSearched,
    this.error,
    this.selectedClassificationId,
    required this.query,
  });

  factory SearchState.initial() {
    return const SearchState(
      results: [],
      isLoading: false,
      hasSearched: false,
      query: '',
    );
  }

  SearchState copyWith({
    List<EventModel>? results,
    bool? isLoading,
    bool? hasSearched,
    String? error,
    String? selectedClassificationId,
    String? query,
  }) {
    return SearchState(
      results: results ?? this.results,
      isLoading: isLoading ?? this.isLoading,
      hasSearched: hasSearched ?? this.hasSearched,
      error: error,
      selectedClassificationId: selectedClassificationId ?? this.selectedClassificationId,
      query: query ?? this.query,
    );
  }
}
