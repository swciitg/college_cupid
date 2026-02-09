import 'dart:async';
import 'package:college_cupid/domain/models/user_profile.dart';
import 'package:college_cupid/functions/snackbar.dart';
import 'package:college_cupid/repositories/user_profile_repository.dart';
import 'package:college_cupid/routing/app_router.dart';
import 'package:college_cupid/shared/colors.dart';
import 'package:college_cupid/shared/enums.dart';
import 'package:college_cupid/shared/styles.dart';
import 'package:college_cupid/stores/home_tab_provider.dart';
import 'package:college_cupid/stores/page_view_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:go_router/go_router.dart';
import 'package:college_cupid/presentation/widgets/global/custom_loader.dart';

class SearchProfilesScreen extends ConsumerStatefulWidget {
  const SearchProfilesScreen({super.key});

  @override
  ConsumerState<SearchProfilesScreen> createState() => _SearchProfilesScreenState();
}

class _SearchProfilesScreenState extends ConsumerState<SearchProfilesScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<Map<String, dynamic>> _searchResults = [];
  bool _isLoading = false;
  Timer? _debounceTimer;

  @override
  void dispose() {
    _searchController.dispose();
    _debounceTimer?.cancel();
    super.dispose();
  }

  void _onSearchChanged(String query) {
    // Cancel previous timer
    _debounceTimer?.cancel();

    if (query.trim().isEmpty) {
      setState(() {
        _searchResults = [];
        _isLoading = false;
      });
      return;
    }

    // Start loading
    setState(() {
      _isLoading = true;
    });

    // Create new timer with 500ms delay
    _debounceTimer = Timer(const Duration(milliseconds: 500), () async {
      await _performSearch(query);
    });
  }

  Future<void> _performSearch(String query) async {
    try {
      final results = await ref.read(userProfileRepoProvider).searchProfilesRaw(query);
      if (mounted) {
        setState(() {
          _searchResults = results;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _searchResults = [];
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _onProfileTap(String email) async {
    try {
      // Show loading
      if (!mounted) return;
      showSnackBar('Loading profile...');

      // Fetch full profile details
      final profileData = await ref.read(userProfileRepoProvider).getUserProfile(email);
      if (profileData == null) {
        if (!mounted) return;
        showSnackBar('Failed to load profile');
        return;
      }

      final profile = UserProfile.fromJson(profileData);

      // Insert profile at the start of home tab
      ref.read(pageViewProvider.notifier).insertProfileAtStart(profile);

      // Set home tab index to 0 (Explore tab)
      ref.read(homeTabIndexProvider.notifier).state = 0;

      // Navigate back to home
      if (!mounted) return;
      context.goNamed(AppRoutes.home.name);
    } catch (e) {
      if (!mounted) return;
      showSnackBar('Error loading profile');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CupidColors.surfaceS2,
      appBar: AppBar(
        backgroundColor: CupidColors.whitePrimary,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(FluentIcons.chevron_left_24_regular, color: CupidColors.blackColor),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'Search Profiles',
          style: CupidTextStyles.brandTitle2,
        ),
        scrolledUnderElevation: 0,
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Search Field
            Container(
              color: CupidColors.whitePrimary,
              padding: const EdgeInsets.all(8),
              child: TextField(
                controller: _searchController,
                onChanged: _onSearchChanged,
                autofocus: true,
                decoration: InputDecoration(
                  hintText: 'Search by name...',
                  hintStyle: CupidTextStyles.body2.copyWith(
                    color: Colors.grey.shade400,
                  ),
                  prefixIcon: const Icon(
                    FluentIcons.search_24_regular,
                    color: CupidColors.primary,
                  ),
                  suffixIcon: _searchController.text.isNotEmpty
                      ? IconButton(
                          icon: const Icon(
                            FluentIcons.dismiss_24_regular,
                            color: Colors.grey,
                          ),
                          onPressed: () {
                            _searchController.clear();
                            _onSearchChanged('');
                          },
                        )
                      : null,
                  filled: true,
                  fillColor: CupidColors.surfaceS2,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 8),
            // Results
            Expanded(
              child: _buildResultsSection(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildResultsSection() {
    if (_isLoading) {
      return const Center(child: CustomLoader());
    }

    if (_searchController.text.trim().isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              FluentIcons.search_24_regular,
              size: 64,
              color: Colors.grey.shade300,
            ),
            const SizedBox(height: 16),
            Text(
              'Search for profiles',
              style: CupidTextStyles.body1.copyWith(
                color: Colors.grey.shade500,
              ),
            ),
          ],
        ),
      );
    }

    if (_searchResults.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              FluentIcons.person_search_24_regular,
              size: 64,
              color: Colors.grey.shade300,
            ),
            const SizedBox(height: 16),
            Text(
              'No profiles found',
              style: CupidTextStyles.body1.copyWith(
                color: Colors.grey.shade500,
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      itemCount: _searchResults.length,
      itemBuilder: (context, index) {
        final profileData = _searchResults[index];
        return _buildProfileTile(profileData);
      },
    );
  }

  Widget _buildProfileTile(Map<String, dynamic> profileData) {
    final name = profileData['name'] as String? ?? 'Unknown';
    final age = profileData['age'];
    final email = profileData['email'] as String? ?? '';
    final gender = profileData['gender'] as String?;
    final profilePicUrls = profileData['profilePicUrls'] as List?;

    String? imageUrl;
    if (profilePicUrls != null && profilePicUrls.isNotEmpty) {
      final firstImage = profilePicUrls[0];
      if (firstImage is Map<String, dynamic>) {
        imageUrl = firstImage['Url'] as String?;
      }
    }

    // Build display name with age if available
    String displayName = name;
    if (age != null) {
      displayName = '$name, $age';
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: CupidColors.whitePrimary,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 8,
        ),
        leading: CircleAvatar(
          radius: 28,
          backgroundColor: CupidColors.surfaceS2,
          backgroundImage: imageUrl != null ? NetworkImage(imageUrl) : null,
          child: imageUrl == null
              ? const Icon(
                  FluentIcons.person_24_regular,
                  color: CupidColors.primary,
                )
              : null,
        ),
        title: Text(
          displayName,
          style: CupidTextStyles.label1.copyWith(
            fontWeight: FontWeight.w600,
            color: CupidColors.blackColor,
          ),
        ),
        subtitle: gender != null
            ? Text(
                Gender.fromDatabaseString(gender).displayString,
                style: CupidTextStyles.label2.copyWith(
                  color: Colors.grey.shade600,
                  fontSize: 12,
                ),
              )
            : null,
        trailing: const Icon(
          FluentIcons.chevron_right_24_regular,
          color: CupidColors.primary,
        ),
        onTap: () => _onProfileTap(email),
      ),
    );
  }
}
