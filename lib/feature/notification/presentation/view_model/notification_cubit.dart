import 'dart:async';
import 'package:dinereserve/core/model/notification_model.dart';
import 'package:dinereserve/feature/notification/data/notification_repo.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

abstract class NotificationState {}

class NotificationInitial extends NotificationState {}

class NotificationLoading extends NotificationState {}

class NotificationLoaded extends NotificationState {
  final List<NotificationModel> notifications;
  final int unreadCount;

  NotificationLoaded({required this.notifications, required this.unreadCount});

  NotificationLoaded copyWith({
    List<NotificationModel>? notifications,
    int? unreadCount,
  }) {
    return NotificationLoaded(
      notifications: notifications ?? this.notifications,
      unreadCount: unreadCount ?? this.unreadCount,
    );
  }
}

class NotificationError extends NotificationState {
  final String message;
  NotificationError(this.message);
}

class NotificationCubit extends Cubit<NotificationState> {
  final NotificationRepo _repo;
  StreamSubscription? _notificationSubscription;
  Timer? _refreshTimer;

  NotificationCubit(this._repo) : super(NotificationInitial());

  /// Initialize with real-time subscription
  Future<void> initialize() async {
    emit(NotificationLoading());
    try {
      // Subscribe to real-time updates
      _notificationSubscription = _repo.subscribeToNotifications().listen(
        (notifications) {
          final unreadCount = notifications.where((n) => !n.isRead).length;
          emit(
            NotificationLoaded(
              notifications: notifications,
              unreadCount: unreadCount,
            ),
          );
        },
        onError: (error) {
          emit(NotificationError(error.toString()));
        },
      );

      // Also set up periodic refresh as backup (every 30 seconds)
      _refreshTimer = Timer.periodic(const Duration(seconds: 30), (_) {
        fetchNotifications();
      });
    } catch (e) {
      emit(NotificationError(e.toString()));
    }
  }

  /// Manual fetch (for pull-to-refresh)
  Future<void> fetchNotifications() async {
    try {
      final notifications = await _repo.getNotifications();
      final unreadCount = await _repo.getUnreadCount();
      emit(
        NotificationLoaded(
          notifications: notifications,
          unreadCount: unreadCount,
        ),
      );
    } catch (e) {
      emit(NotificationError(e.toString()));
    }
  }

  /// Mark single notification as read
  Future<void> markAsRead(String notificationId) async {
    final currentState = state;
    if (currentState is NotificationLoaded) {
      try {
        await _repo.markAsRead(notificationId);

        // Update local state immediately
        final updatedNotifications = currentState.notifications.map((n) {
          if (n.id == notificationId) {
            return n.copyWith(isRead: true);
          }
          return n;
        }).toList();

        final newUnreadCount = updatedNotifications
            .where((n) => !n.isRead)
            .length;

        emit(
          currentState.copyWith(
            notifications: updatedNotifications,
            unreadCount: newUnreadCount,
          ),
        );
      } catch (e) {
        // Silently fail, real-time will update anyway
      }
    }
  }

  /// Mark all notifications as read
  Future<void> markAllAsRead() async {
    final currentState = state;
    if (currentState is NotificationLoaded) {
      try {
        await _repo.markAllAsRead();

        // Update local state immediately
        final updatedNotifications = currentState.notifications
            .map((n) => n.copyWith(isRead: true))
            .toList();

        emit(
          currentState.copyWith(
            notifications: updatedNotifications,
            unreadCount: 0,
          ),
        );
      } catch (e) {
        emit(NotificationError(e.toString()));
      }
    }
  }

  @override
  Future<void> close() {
    _notificationSubscription?.cancel();
    _refreshTimer?.cancel();
    _repo.dispose();
    return super.close();
  }
}
