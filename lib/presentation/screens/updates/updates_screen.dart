import 'package:college_cupid/presentation/widgets/updates/crush_card.dart';
import 'package:college_cupid/presentation/widgets/updates/update_item_builder.dart';
import 'package:college_cupid/presentation/widgets/global/cupid_tab_bar.dart';
import 'package:college_cupid/presentation/widgets/global/custom_loader.dart';
import 'package:college_cupid/repositories/onedrive_repository.dart';
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
  final List<String> _tabs = ['Crushes', 'Updates', 'Profile', 'Confession', 'Match'];
  int _currentTabIndex = 0;
  bool _crushesLoaded = false;
  List<String>? _crushEmails;
  bool _isLoadingCrushes = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _tabs.length, vsync: this);
    _tabController.addListener(_handleTabSelection);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fetchCrushEmails();
    });
  }

  void _handleTabSelection() {
    if (!_tabController.indexIsChanging) {
      setState(() {
        _currentTabIndex = _tabController.index;
      });
      if (_currentTabIndex == 0 && !_crushesLoaded) {
        // Load crushes only once when tab is first selected
        _crushesLoaded = true;
        _fetchCrushEmails();
      } else if (_currentTabIndex != 0) {
        // Only fetch updates for non-crushes tabs
        // Map tab index to filter: Updates tab should fetch 'All'
        final filter = _currentTabIndex == 1 ? 'All' : _tabs[_currentTabIndex];
        ref.read(updatesControllerProvider.notifier).fetchUpdates(filter: filter);
      }
    }
  }

  Future<void> _fetchCrushEmails() async {
    setState(() {
      _isLoadingCrushes = true;
    });

    try {
      final emails = await OneDriveRepository.getMyCrushes();
      if (mounted) {
        setState(() {
          _crushEmails = emails;
          _isLoadingCrushes = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _crushEmails = [];
          _isLoadingCrushes = false;
        });
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
                      if (index == 0 && !_crushesLoaded) {
                        _crushesLoaded = true;
                        _fetchCrushEmails();
                      } else if (index != 0) {
                        // Map tab index to filter: Updates tab should fetch 'All'
                        final filter = index == 1 ? 'All' : _tabs[index];
                        ref.read(updatesControllerProvider.notifier).fetchUpdates(filter: filter);
                      }
                    },
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
            Expanded(
              child: _currentTabIndex == 0 // Crushes tab
                  ? _buildCrushesTab()
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

  Widget _buildCrushesTab() {
    return RefreshIndicator(
      color: CupidColors.primary,
      onRefresh: () async {
        await _fetchCrushEmails();
      },
      child: _isLoadingCrushes
          ? const Center(child: CustomLoader())
          : _crushEmails == null || _crushEmails!.isEmpty
              ? LayoutBuilder(
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
                )
              : ListView.builder(
                  itemCount: _crushEmails!.length,
                  itemBuilder: (context, index) {
                    return CrushCard(email: _crushEmails![index]);
                  },
                ),
    );
  }
}
