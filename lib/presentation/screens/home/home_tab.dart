import 'dart:async';

import 'package:college_cupid/presentation/widgets/global/custom_loader.dart';
import 'package:college_cupid/presentation/widgets/home/filter_bottom_sheet.dart';
import 'package:college_cupid/presentation/widgets/home/profile_view.dart';
import 'package:college_cupid/shared/colors.dart';
import 'package:college_cupid/stores/filter_store.dart';
import 'package:college_cupid/stores/page_view_controller.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

class HomeTab extends ConsumerStatefulWidget {
  const HomeTab({super.key});

  @override
  ConsumerState<HomeTab> createState() => _HomeTabState();
}

class _HomeTabState extends ConsumerState<HomeTab> {
  final TextEditingController _searchController = TextEditingController();
  Timer? timer;
  late FilterStore filterStore;

  @override
  void dispose() {
    _searchController.dispose();
    filterStore.resetStore();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    filterStore = context.read<FilterStore>();
    final pageViewState = ref.watch(pageViewProvider);
    return Column(
      children: [
        _buildSearchField(),
        const SizedBox(height: 12),
        Expanded(
          child: pageViewState.loading
              ? const CustomLoader()
              : ProfileView(userProfiles: pageViewState.homeTabProfileList),
        ),
      ],
    );
  }

  Widget _filters(BuildContext context) {
    return GestureDetector(
      child: const SizedBox(
        height: 36,
        width: 36,
        child: Center(
          child: Icon(
            FluentIcons.filter_20_filled,
            size: 24,
            color: CupidColors.blackColor,
          ),
        ),
      ),
      onTap: () {
        showModalBottomSheet(
          backgroundColor: Colors.white,
          context: context,
          builder: (_) {
            return const FilterBottomSheet();
          },
        );
      },
    );
  }

  Padding _buildSearchField() {
    final pageViewController = ref.read(pageViewProvider.notifier);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 0)
          .copyWith(top: 8),
      child: Row(
        children: [
          SvgPicture.asset(
            'assets/icons/cupid_logo.svg',
            height: 36,
            width: 36,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: DecoratedBox(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.16),
                    blurRadius: 8.4,
                    spreadRadius: 0,
                  )
                ],
              ),
              child: TextFormField(
                controller: _searchController,
                textInputAction: TextInputAction.search,
                onFieldSubmitted: (value) {
                  filterStore.setName(value);
                  pageViewController.getInitialProfiles(context);
                },
                onChanged: (value) {
                  if (timer != null) timer!.cancel();
                  timer = Timer(const Duration(seconds: 1), () {
                    filterStore.setName(value);
                    pageViewController.getInitialProfiles(context);
                    if (value.isEmpty) {
                      FocusScope.of(context).unfocus();
                    }
                  });
                },
                decoration: InputDecoration(
                  fillColor: Colors.white,
                  filled: true,
                  contentPadding: EdgeInsets.zero,
                  hintText: 'Search',
                  prefixIcon: const Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.transparent),
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.transparent),
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.transparent),
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.clear),
                    onPressed: () {
                      _searchController.clear();
                      filterStore.setName('');
                      pageViewController.getInitialProfiles(context);
                    },
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          _filters(context)
        ],
      ),
    );
  }
}
