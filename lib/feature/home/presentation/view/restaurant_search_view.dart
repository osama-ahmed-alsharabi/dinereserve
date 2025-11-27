import 'package:dinereserve/core/model/restaurant_model.dart';
import 'package:dinereserve/core/model/restaurant_search_filter.dart';
import 'package:dinereserve/core/utils/app_colors.dart';
import 'package:dinereserve/feature/home/presentation/view/widgets/restaurant_card_widget.dart';
import 'package:dinereserve/feature/home/presentation/view_model/restaurant_search_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class RestaurantSearchView extends StatefulWidget {
  const RestaurantSearchView({super.key});

  @override
  State<RestaurantSearchView> createState() => _RestaurantSearchViewState();
}

class _RestaurantSearchViewState extends State<RestaurantSearchView> {
  final TextEditingController _searchController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();

  String? selectedType;
  DateTime? selectedDate;
  String? selectedTime;

  bool showFilters = false;

  final List<String> restaurantTypes = [
    "Restaurant",
    "Cafe",
    "Sweets Shop",
    "Fast Food",
    "Bakery",
    "Grill",
    "Breakfast House",
    "Juice Shop",
  ];

  final List<String> timeSlots = [
    '12:00',
    '12:30',
    '13:00',
    '13:30',
    '14:00',
    '14:30',
    '18:00',
    '18:30',
    '19:00',
    '19:30',
    '20:00',
    '20:30',
    '21:00',
    '21:30',
    '22:00',
  ];

  @override
  void dispose() {
    _searchController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  void _performSearch() {
    final filter = RestaurantSearchFilter(
      searchQuery: _searchController.text.trim().isEmpty
          ? null
          : _searchController.text.trim(),
      restaurantType: selectedType,
      location: _locationController.text.trim().isEmpty
          ? null
          : _locationController.text.trim(),
      date: selectedDate,
      time: selectedTime,
    );

    context.read<RestaurantSearchCubit>().searchRestaurants(filter);
  }

  void _clearFilters() {
    setState(() {
      _searchController.clear();
      _locationController.clear();
      selectedType = null;
      selectedDate = null;
      selectedTime = null;
    });
    context.read<RestaurantSearchCubit>().clearFilters();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Search',
          style: TextStyle(
            color: Colors.black87,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(
              showFilters ? Icons.filter_list_off : Icons.filter_list,
              color: AppColors.primaryColor,
            ),
            onPressed: () {
              setState(() {
                showFilters = !showFilters;
              });
            },
          ),
        ],
      ),
      body: Column(
        children: [
          _buildSearchBar(),
          if (showFilters) _buildFiltersSection(),
          Expanded(child: _buildSearchResults()),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(13),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                prefixIcon: const Icon(
                  Icons.search,
                  color: AppColors.primaryColor,
                ),
                hintText: 'Search by restaurant name...',
                fillColor: AppColors.thirdColor,
                filled: true,
                border: _border(),
                enabledBorder: _border(),
                focusedBorder: _border(focused: true),
              ),
              onSubmitted: (_) => _performSearch(),
            ),
          ),
          const SizedBox(width: 12),
          ElevatedButton(
            onPressed: _performSearch,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryColor,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text(
              'Search',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFiltersSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        border: Border(bottom: BorderSide(color: Colors.grey[200]!)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Filters',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              TextButton.icon(
                onPressed: _clearFilters,
                icon: const Icon(Icons.clear_all, size: 18),
                label: const Text('Clear All'),
                style: TextButton.styleFrom(
                  foregroundColor: AppColors.primaryColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Location Filter
          TextField(
            controller: _locationController,
            decoration: InputDecoration(
              prefixIcon: const Icon(
                Icons.location_on,
                color: AppColors.primaryColor,
              ),
              hintText: 'Location',
              fillColor: Colors.white,
              filled: true,
              border: _border(),
              enabledBorder: _border(),
              focusedBorder: _border(focused: true),
            ),
          ),
          const SizedBox(height: 12),

          // Restaurant Type Filter
          DropdownButtonFormField<String>(
            value: selectedType,
            decoration: InputDecoration(
              prefixIcon: const Icon(
                Icons.restaurant,
                color: AppColors.primaryColor,
              ),
              hintText: 'Cuisine Type',
              fillColor: Colors.white,
              filled: true,
              border: _border(),
              enabledBorder: _border(),
              focusedBorder: _border(focused: true),
            ),
            items: restaurantTypes.map((type) {
              return DropdownMenuItem(value: type, child: Text(type));
            }).toList(),
            onChanged: (value) {
              setState(() {
                selectedType = value;
              });
            },
          ),
          const SizedBox(height: 12),

          // Date and Time Filters
          Row(
            children: [
              Expanded(
                child: InkWell(
                  onTap: () async {
                    final date = await showDatePicker(
                      context: context,
                      initialDate: selectedDate ?? DateTime.now(),
                      firstDate: DateTime.now(),
                      lastDate: DateTime.now().add(const Duration(days: 90)),
                      builder: (context, child) {
                        return Theme(
                          data: Theme.of(context).copyWith(
                            colorScheme: const ColorScheme.light(
                              primary: AppColors.primaryColor,
                            ),
                          ),
                          child: child!,
                        );
                      },
                    );
                    if (date != null) {
                      setState(() {
                        selectedDate = date;
                      });
                    }
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 16,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey[300]!),
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.calendar_today,
                          color: AppColors.primaryColor,
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          selectedDate == null
                              ? 'Select Date'
                              : DateFormat(
                                  'MMM dd, yyyy',
                                ).format(selectedDate!),
                          style: TextStyle(
                            color: selectedDate == null
                                ? Colors.grey[600]
                                : Colors.black87,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: DropdownButtonFormField<String>(
                  value: selectedTime,
                  decoration: InputDecoration(
                    prefixIcon: const Icon(
                      Icons.access_time,
                      color: AppColors.primaryColor,
                    ),
                    hintText: 'Time',
                    fillColor: Colors.white,
                    filled: true,
                    border: _border(),
                    enabledBorder: _border(),
                    focusedBorder: _border(focused: true),
                  ),
                  items: timeSlots.map((time) {
                    return DropdownMenuItem(value: time, child: Text(time));
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedTime = value;
                    });
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSearchResults() {
    return BlocBuilder<RestaurantSearchCubit, RestaurantSearchState>(
      builder: (context, state) {
        if (state is RestaurantSearchInitial) {
          return _buildEmptyState(
            icon: Icons.search,
            title: 'Start Searching',
            message:
                'Enter a restaurant name or use filters to find restaurants',
          );
        } else if (state is RestaurantSearchLoading) {
          return const Center(
            child: CircularProgressIndicator(color: AppColors.primaryColor),
          );
        } else if (state is RestaurantSearchSuccess) {
          return _buildRestaurantList(state.restaurants);
        } else if (state is RestaurantSearchEmpty) {
          return _buildEmptyState(
            icon: Icons.search_off,
            title: 'No Results Found',
            message: 'Try adjusting your search criteria',
          );
        } else if (state is RestaurantSearchError) {
          return _buildEmptyState(
            icon: Icons.error_outline,
            title: 'Error',
            message: (state).message,
          );
        }
        return const SizedBox();
      },
    );
  }

  Widget _buildRestaurantList(List<RestaurantModel> restaurants) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: restaurants.length,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: SizedBox(
            height: 240,
            child: RestaurantCardWidget(restaurant: restaurants[index]),
          ),
        );
      },
    );
  }

  Widget _buildEmptyState({
    required IconData icon,
    required String title,
    required String message,
  }) {
    return SingleChildScrollView(
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 80, color: Colors.grey[400]),
              const SizedBox(height: 16),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                message,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 14, color: Colors.grey[600]),
              ),
            ],
          ),
        ),
      ),
    );
  }

  OutlineInputBorder _border({bool focused = false}) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(
        color: focused ? AppColors.primaryColor : Colors.grey[300]!,
        width: focused ? 2 : 1,
      ),
    );
  }
}
