part of 'filter_cubit.dart';

class FilterState {
  final int selectedCategory;
  final int selectedTime;
  final RangeValues priceRange;
  final List<CategoryModel> categories;
  final bool isLoadingCategories;

  const FilterState({
    required this.selectedCategory,
    required this.selectedTime,
    required this.priceRange,
    required this.categories,
    required this.isLoadingCategories,
  });

  factory FilterState.initial() {
    return const FilterState(
      selectedCategory: -1,
      selectedTime: 1, // Default was 1 in the old state
      priceRange: RangeValues(20, 120),
      categories: [],
      isLoadingCategories: true,
    );
  }

  FilterState copyWith({
    int? selectedCategory,
    int? selectedTime,
    RangeValues? priceRange,
    List<CategoryModel>? categories,
    bool? isLoadingCategories,
  }) {
    return FilterState(
      selectedCategory: selectedCategory ?? this.selectedCategory,
      selectedTime: selectedTime ?? this.selectedTime,
      priceRange: priceRange ?? this.priceRange,
      categories: categories ?? this.categories,
      isLoadingCategories: isLoadingCategories ?? this.isLoadingCategories,
    );
  }
}
