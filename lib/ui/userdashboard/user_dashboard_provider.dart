// Provider handling multiple API calls
import 'package:flutter/material.dart';
import 'package:visaamigo/ui/userdashboard/user_items.dart';

import '../base/base_provider.dart';

class UserDashboardProvider extends BaseProvider<dynamic> {
  static const String userKey = 'user';
  static const String postsKey = 'posts';

  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _ageController = TextEditingController();

  Future<void> loadUserDashboard(int userId) async {
    // Fetch user details
    await getData(
      endpoint: '/users/$userId',
      fromJson: Users.fromJson,
      responseKey: userKey,
    );

    // Fetch user's posts with pagination
    await getData(
      endpoint: '/users',
      fromJson: Users.fromJson,
      responseKey: postsKey,
      isPaginated: true,
      queryParameters: {'page': '1', 'limit': '10'},
    );
  }

  Future<void> loadMorePosts(int userId) async {
    final currentPage = getResponse(postsKey).paginatedData?.currentPage ?? 0;
    await loadMore(
        endpoint: '/users',
        fromJson: Users.fromJson,
        responseKey: postsKey,
        nextPage: currentPage + 1,
        itemsKey: "messages");
  }

  UserDashboardProvider() {
    loadUserDashboard(1);
  }
}
