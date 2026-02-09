import 'package:college_cupid/presentation/controllers/crushes_controller.dart';
import 'package:college_cupid/presentation/widgets/updates/crush_card.dart';
import 'package:college_cupid/presentation/widgets/updates/update_item_builder.dart';
import 'package:college_cupid/presentation/widgets/global/cupid_tab_bar.dart';
import 'package:college_cupid/presentation/widgets/global/custom_loader.dart';
import 'package:college_cupid/shared/colors.dart';
import 'package:college_cupid/shared/styles.dart';
import 'package:college_cupid/stores/updates_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class UpdatesScreen extends ConsumerStatefulWidget {
  const UpdatesScreen({super.key});

  @override
  ConsumerState<UpdatesScreen> createState() => _UpdatesScreenState();
}

class _UpdatesScreenState extends ConsumerState<UpdatesScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final List<String> _tabs = ['All', 'Crushes', 'Profile', 'Confession', 'Match'];
  int _currentTabIndex = 0;
  bool _crushesLoaded = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _tabs.length, vsync: this);
    _tabController.addListener(_handleTabSelection);
  }

  void _handleTabSelection() {
    if (!_tabController.indexIsChanging) {
      setState(() {
        _currentTabIndex = _tabController.index;
      });
      if (_currentTabIndex == 1 && !_crushesLoaded) {
        // Load crushes only once when tab is first selected
        _crushesLoaded = true;
        ref.read(crushesControllerProvider.notifier).getCrushProfiles();
      } else if (_currentTabIndex != 1) {
        // Only fetch updates for non-crushes tabs
        ref
            .read(updatesControllerProvider.notifier)
            .fetchUpdates(filter: _tabs[_tabController.index]);
      }
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final updatesState = ref.watch(updatesControllerProvider);
    final crushesState = ref.watch(crushesControllerProvider);

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              decoration: const BoxDecoration(color: Colors.transparent),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.fromLTRB(20, 16, 20, 0),
                    child: Row(
                      children: [
                        Text(
                          'Updates',
                          style: CupidTextStyles.brandTitle1,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  CupidTabBar(
                    controller: _tabController,
                    tabs: _tabs,
                    onTap: (index) {
                      setState(() {
                        _currentTabIndex = index;
                      });
                      if (index == 1 && !_crushesLoaded) {
                        _crushesLoaded = true;
                        ref.read(crushesControllerProvider.notifier).getCrushProfiles();
                      } else if (index != 1) {
                        ref
                            .read(updatesControllerProvider.notifier)
                            .fetchUpdates(filter: _tabs[index]);
                      }
                    },
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
            Expanded(
              child: _currentTabIndex == 1 // Crushes tab
                  ? _buildCrushesTab(crushesState)
                  : RefreshIndicator(
                      color: CupidColors.primary,
                      onRefresh: () async {
                        await ref
                            .read(updatesControllerProvider.notifier)
                            .fetchUpdates(filter: _tabs[_tabController.index], isRefresh: true);
                      },
                      child: updatesState.when(
                        data: (updates) {
                          if (updates.isEmpty) {
                            return LayoutBuilder(
                              builder: (context, constraints) {
                                return SingleChildScrollView(
                                  physics: const AlwaysScrollableScrollPhysics(),
                                  child: ConstrainedBox(
                                    constraints: BoxConstraints(
                                      minHeight: constraints.maxHeight,
                                    ),
                                    child: const Center(
                                      child: Text(
                                        'No updates found',
                                        style: CupidTextStyles.body1,
                                      ),
                                    ),
                                  ),
                                );
                              },
                            );
                          }
                          return ListView.builder(
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                            itemCount: updates.length,
                            itemBuilder: (context, index) {
                              return Padding(
                                padding: EdgeInsets.only(top: index == 0 ? 8 : 0),
                                child: UpdateItemBuilder(update: updates[index]),
                              );
                            },
                          );
                        },
                        loading: () => const Center(child: CircularProgressIndicator()),
                        error: (e, s) => Center(child: Text('Error: $e')),
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCrushesTab(AsyncValue crushesState) {
    return RefreshIndicator(
      color: CupidColors.primary,
      onRefresh: () async {
        await ref.read(crushesControllerProvider.notifier).getCrushProfiles();
      },
      child: crushesState.when(
        data: (crushes) {
          if (crushes.isEmpty) {
            return LayoutBuilder(
              builder: (context, constraints) {
                return SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minHeight: constraints.maxHeight,
                    ),
                    child: const Center(
                      child: Text(
                        'No crushes yet',
                        style: CupidTextStyles.body1,
                      ),
                    ),
                  ),
                );
              },
            );
          }
          return ListView.builder(
            itemCount: crushes.length,
            itemBuilder: (context, index) {
              return CrushCard(profile: crushes[index]);
            },
          );
        },
        loading: () => const Center(child: CustomLoader()),
        error: (e, s) => const Center(
          child: Text(
            'Error loading crushes',
            style: CupidTextStyles.body1,
          ),
        ),
      ),
    );
  }
}
