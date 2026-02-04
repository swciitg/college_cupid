import 'package:college_cupid/presentation/widgets/updates/update_item_builder.dart';
import 'package:college_cupid/presentation/widgets/global/cupid_tab_bar.dart';
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

class _UpdatesScreenState extends ConsumerState<UpdatesScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final List<String> _tabs = ['All', 'Profile', 'Confession', 'Match'];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _tabs.length, vsync: this);
    _tabController.addListener(_handleTabSelection);
  }

  void _handleTabSelection() {
    if (_tabController.indexIsChanging) {
      ref
          .read(updatesControllerProvider.notifier)
          .fetchUpdates(filter: _tabs[_tabController.index]);
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
      backgroundColor: CupidColors.backgroundColor,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.fromLTRB(20, 16, 20, 0),
              child: Text(
                'Updates',
                style: CupidTextStyles.brandTitle1,
              ),
            ),
            SizedBox(
              height: 50,
              child: CupidTabBar(
                controller: _tabController,
                tabs: _tabs,
                onTap: (index) {
                  ref
                      .read(updatesControllerProvider.notifier)
                      .fetchUpdates(filter: _tabs[index]);
                },
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: RefreshIndicator(
                onRefresh: () async {
                  await ref
                      .read(updatesControllerProvider.notifier)
                      .fetchUpdates(
                          filter: _tabs[_tabController.index], isRefresh: true);
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
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      itemCount: updates.length,
                      itemBuilder: (context, index) {
                        return UpdateItemBuilder(update: updates[index]);
                      },
                    );
                  },
                  loading: () =>
                      const Center(child: CircularProgressIndicator()),
                  error: (e, s) => Center(child: Text('Error: $e')),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
