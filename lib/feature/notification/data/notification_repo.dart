import 'dart:async';
import 'package:dinereserve/core/model/notification_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class NotificationRepo {
  final SupabaseClient _supabase;
  StreamSubscription? _notificationSubscription;

  NotificationRepo(this._supabase);

  /// Get all notifications for the current user
  Future<List<NotificationModel>> getNotifications() async {
    try {
      final userId = _supabase.auth.currentUser?.id;
      if (userId == null) return [];

      final response = await _supabase
          .from('notifications')
          .select()
          .eq('user_id', userId)
          .order('created_at', ascending: false);

      return (response as List)
          .map((e) => NotificationModel.fromMap(e))
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch notifications: $e');
    }
  }

  /// Get unread notifications count
  Future<int> getUnreadCount() async {
    try {
      final userId = _supabase.auth.currentUser?.id;
      if (userId == null) return 0;

      final response = await _supabase
          .from('notifications')
          .select()
          .eq('user_id', userId)
          .eq('is_read', false);

      return (response as List).length;
    } catch (e) {
      return 0;
    }
  }

  /// Mark a single notification as read
  Future<void> markAsRead(String notificationId) async {
    try {
      await _supabase
          .from('notifications')
          .update({
            'is_read': true,
            'updated_at': DateTime.now().toIso8601String(),
          })
          .eq('id', notificationId);
    } catch (e) {
      throw Exception('Failed to mark notification as read: $e');
    }
  }

  /// Mark all notifications as read
  Future<void> markAllAsRead() async {
    try {
      final userId = _supabase.auth.currentUser?.id;
      if (userId == null) return;

      await _supabase
          .from('notifications')
          .update({
            'is_read': true,
            'updated_at': DateTime.now().toIso8601String(),
          })
          .eq('user_id', userId)
          .eq('is_read', false);
    } catch (e) {
      throw Exception('Failed to mark all notifications as read: $e');
    }
  }

  /// Subscribe to real-time notification updates
  Stream<List<NotificationModel>> subscribeToNotifications() {
    final userId = _supabase.auth.currentUser?.id;
    if (userId == null) {
      return Stream.value([]);
    }

    final controller = StreamController<List<NotificationModel>>();

    // Initial fetch
    getNotifications().then((notifications) {
      if (!controller.isClosed) {
        controller.add(notifications);
      }
    });

    // Subscribe to changes
    _notificationSubscription = _supabase
        .from('notifications')
        .stream(primaryKey: ['id'])
        .eq('user_id', userId)
        .order('created_at', ascending: false)
        .listen((data) {
          if (!controller.isClosed) {
            final notifications = (data as List)
                .map((e) => NotificationModel.fromMap(e))
                .toList();
            controller.add(notifications);
          }
        });

    return controller.stream;
  }

  /// Clean up subscriptions
  void dispose() {
    _notificationSubscription?.cancel();
  }
}
