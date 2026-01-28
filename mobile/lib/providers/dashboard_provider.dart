import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile/services/api_service.dart';

final dashboardProvider = StateNotifierProvider<DashboardNotifier, AsyncValue<Map<String, dynamic>>>((ref) {
  return DashboardNotifier();
});

class DashboardNotifier extends StateNotifier<AsyncValue<Map<String, dynamic>>> {
  DashboardNotifier() : super(const AsyncValue.loading()) {
    fetchStats();
  }

  final ApiService _apiService = ApiService();

  Future<void> fetchStats() async {
    state = const AsyncValue.loading();
    try {
      final stats = await _apiService.getDashboardStats();
      state = AsyncValue.data(stats);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  Future<void> refreshStats() async {
    // Refresh without setting loading state to avoid flicker if desired, or set loading.
    // For now, let's keep it simple and just re-fetch.
    try {
       final stats = await _apiService.getDashboardStats();
       state = AsyncValue.data(stats);
    } catch (e) {
      // If refresh fails, keep old state or show error? 
      // Silently fail or update error depending on UX preference.
      // We will keep current state if it exists.
    }
  }
}
