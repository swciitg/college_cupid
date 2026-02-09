import 'package:college_cupid/domain/models/update_model.dart';
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
  final List<String> _tabs = ['All', 'Your Crushes', 'Match', 'Profile', 'Confession'];
  int _currentTabIndex = 0;
  bool _crushesLoaded = false;
  bool _updatesLoaded = false;
  List<String>? _crushEmails;
  bool _isLoadingCrushes = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _tabs.length, vsync: this);
    _tabController.addListener(_handleTabSelection);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fetchCrushEmails();
      _updatesLoaded = true;
      ref.read(updatesControllerProvider.notifier).fetchUpdates(filter: 'All');
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
      } else if (_currentTabIndex != 0 && !_updatesLoaded) {
        // Fetch updates only once when first switching to any updates tab
        _updatesLoaded = true;
        ref.read(updatesControllerProvider.notifier).fetchUpdates(filter: 'All');
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
    final allUpdates = ref.watch(updatesControllerProvider);

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
                    },
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
            Expanded(
              child: _currentTabIndex == 1 // Crushes tab
                  ? _buildCrushesTab()
                  : RefreshIndicator(
                      key: ValueKey(_currentTabIndex), // Rebuild when tab changes
                      color: CupidColors.primary,
                      onRefresh: () async {
                        await ref
                            .read(updatesControllerProvider.notifier)
                            .fetchUpdates(filter: 'All', isRefresh: true);
                      },
                      child: FutureBuilder(
                        key: ValueKey(_currentTabIndex), // Rebuild when tab changes
                        future: _filterUpdates(allUpdates),
                        builder: (context, snapshot) {
                          if (!snapshot.hasData) {
                            return const Center(
                              child: Padding(
                                padding: EdgeInsets.all(16),
                                child: CircularProgressIndicator(
                                  color: CupidColors.primary,
                                ),
                              ),
                            );
                          }
                          // Filter updates based on current tab
                          final filteredUpdates = snapshot.data!;

                          if (filteredUpdates.isEmpty) {
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
                            itemCount: filteredUpdates.length,
                            itemBuilder: (context, index) {
                              return Padding(
                                padding: EdgeInsets.only(top: index == 0 ? 8 : 0),
                                child: UpdateItemBuilder(update: filteredUpdates[index]),
                              );
                            },
                          );
                        },
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

  Future<List<UpdateModel>> _filterUpdates(List<UpdateModel> allUpdates) async {
    // If on "Updates" tab (index 1), show all updates
    if (_currentTabIndex == 0) {
      return allUpdates;
    }

    // Filter based on the current tab
    final filterType = _tabs[_currentTabIndex];
    print(filterType);
    return allUpdates.where((update) {
      switch (filterType) {
        case 'Profile':
          return update.type == UpdateType.profileReply ||
              update.type == UpdateType.textReply ||
              update.type == UpdateType.voiceReply;
        case 'Confession':
          return update.type == UpdateType.confessionReply;
        case 'Match':
          return update.type == UpdateType.match || update.type == UpdateType.blindDateReply;
        default:
          return true;
      }
    }).toList();
  }
}
