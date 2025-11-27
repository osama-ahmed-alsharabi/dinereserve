class RestaurantSearchFilter {
  final String? searchQuery; // For name search
  final String? restaurantType; // Cuisine type
  final String? location;
  final DateTime? date;
  final String? time; // Format: "HH:mm"

  RestaurantSearchFilter({
    this.searchQuery,
    this.restaurantType,
    this.location,
    this.date,
    this.time,
  });

  bool get hasActiveFilters =>
      searchQuery != null ||
      restaurantType != null ||
      location != null ||
      date != null ||
      time != null;

  RestaurantSearchFilter copyWith({
    String? searchQuery,
    String? restaurantType,
    String? location,
    DateTime? date,
    String? time,
    bool clearSearchQuery = false,
    bool clearRestaurantType = false,
    bool clearLocation = false,
    bool clearDate = false,
    bool clearTime = false,
  }) {
    return RestaurantSearchFilter(
      searchQuery: clearSearchQuery ? null : (searchQuery ?? this.searchQuery),
      restaurantType: clearRestaurantType
          ? null
          : (restaurantType ?? this.restaurantType),
      location: clearLocation ? null : (location ?? this.location),
      date: clearDate ? null : (date ?? this.date),
      time: clearTime ? null : (time ?? this.time),
    );
  }

  RestaurantSearchFilter clear() {
    return RestaurantSearchFilter();
  }
}
