import 'package:dinereserve/core/model/booking_model.dart';
import 'package:dinereserve/core/model/restaurant_model.dart';
import 'package:dinereserve/feature/profile_restaurant/data/profile_restaurant_repo.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AiContextService {
  final GetRestaurantRepo _restaurantRepo;
  final SupabaseClient _supabase;

  AiContextService(this._restaurantRepo, this._supabase);

  Future<String> getSystemPrompt() async {
    try {
      // Fetch all restaurants
      final restaurants = await _restaurantRepo.getAllRestaurants();

      // Fetch user bookings if logged in
      final userId = _supabase.auth.currentUser?.id;
      List<BookingModel> bookings = [];

      if (userId != null) {
        final bookingsResponse = await _supabase
            .from('bookings')
            .select()
            .eq('user_id', userId)
            .order('booking_date', ascending: true);

        bookings = (bookingsResponse as List)
            .map((e) => BookingModel.fromMap(e))
            .toList();
      }

      return _buildPrompt(restaurants, bookings);
    } catch (e) {
      return _buildPrompt([], []);
    }
  }

  String _buildPrompt(
    List<RestaurantModel> restaurants,
    List<BookingModel> bookings,
  ) {
    final buffer = StringBuffer();

    buffer.writeln(
      "You are the AI Assistant for 'DineReserve', a premium restaurant booking app.",
    );
    buffer.writeln(
      "Your role is to help users find restaurants, check their bookings, and answer questions.",
    );
    buffer.writeln(
      "Always answer in English unless the user speaks another language.",
    );
    buffer.writeln("Be helpful, friendly, and professional.");

    buffer.writeln("\n--- AVAILABLE RESTAURANTS ---");
    if (restaurants.isEmpty) {
      buffer.writeln("No restaurants available currently.");
    } else {
      for (var r in restaurants) {
        buffer.writeln(
          "ID: ${r.restaurantId}, Name: ${r.restaurantName}, Type: ${r.restaurantType}, "
          "Location: ${r.location}, Rating: 4.8, Open: ${r.openingTime}-${r.closingTime}",
        );
      }
    }

    buffer.writeln("\n--- USER BOOKINGS ---");
    if (bookings.isEmpty) {
      buffer.writeln("User has no bookings.");
    } else {
      for (var b in bookings) {
        buffer.writeln(
          "Restaurant: ${b.restaurantName}, Date: ${b.bookingDate}, Time: ${b.bookingTime}, "
          "Tables: ${b.tableCount}, Status: ${b.status}",
        );
      }
    }

    buffer.writeln("\n--- INSTRUCTIONS ---");
    buffer.writeln(
      "1. If recommending a restaurant, you MUST include its ID in this format: [RES:restaurant_id]. Example: 'I recommend [RES:123] Pizza Hut'.",
    );
    buffer.writeln(
      "2. If the user asks about their bookings, list them clearly.",
    );
    buffer.writeln(
      "3. If the user wants to book, guide them to use the app's booking feature (you cannot book directly, but you can guide them).",
    );
    buffer.writeln("4. Keep responses concise and easy to read.");

    return buffer.toString();
  }
}
