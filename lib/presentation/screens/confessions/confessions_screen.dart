import 'package:college_cupid/functions/snackbar.dart';
import 'package:go_router/go_router.dart';
import 'package:college_cupid/routing/app_router.dart';
import 'package:college_cupid/presentation/widgets/confessions/confession_card.dart';
import 'package:college_cupid/presentation/widgets/confessions/reply_bottom_sheet.dart';
import 'package:college_cupid/presentation/widgets/confessions/report_confession_dialog.dart';
import 'package:college_cupid/presentation/widgets/global/cupid_tab_bar.dart';
import 'package:college_cupid/presentation/widgets/global/custom_loader.dart';
import 'package:college_cupid/stores/confessions_controller.dart';
import 'package:college_cupid/stores/login_store.dart';
import 'package:college_cupid/shared/colors.dart';
import 'package:college_cupid/shared/styles.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:college_cupid/domain/models/confession.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ConfessionsScreen extends ConsumerStatefulWidget {
  const ConfessionsScreen({super.key});

  @override
  ConsumerState<ConfessionsScreen> createState() => _ConfessionsScreenState();
}

class _ConfessionsScreenState extends ConsumerState<ConfessionsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final List<ConfessionsFilter> _tabs = [
    ConfessionsFilter.all,
    ConfessionsFilter.spottedInCampus,
    ConfessionsFilter.gossip,
    ConfessionsFilter.byYou,
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _tabs.length, vsync: this);
    _tabController.addListener(() {
      if (!_tabController.indexIsChanging) {
        ref.read(confessionsProvider.notifier).setFilter(_tabs[_tabController.index]);
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(confessionsProvider);
    debugPrint('DEBUG UI: Build. Filter: ${state.selectedFilter}, Loading: ${state.isLoading}');
    debugPrint('DEBUG UI: Confessions count: ${state.confessions?.length}');

    ref.listen<ConfessionsState>(confessionsProvider, (previous, next) {
      if (next.errorMessage != null && next.errorMessage != previous?.errorMessage) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(next.errorMessage!)),
        );
      }
    });

    return Scaffold(
      backgroundColor: CupidColors.backgroundColor,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.fromLTRB(20, 16, 20, 0),
              child: Text(
                'Confessions',
                style: CupidTextStyles.brandTitle1,
              ),
            ),
            const SizedBox(height: 16),
            CupidTabBar(
              controller: _tabController,
              tabs: _tabs.map((e) => e.displayName).toList(),
              onTap: (index) {
                ref.read(confessionsProvider.notifier).setFilter(_tabs[index]);
              },
            ),
            const SizedBox(height: 16),
            Expanded(
              child: state.isLoading && (state.confessions == null || state.confessions!.isEmpty)
                  ? const Center(child: CustomLoader())
                  : state.confessions == null || state.confessions!.isEmpty
                      ? const Center(
                          child: Text(
                            'No confessions found!',
                            style: CupidTextStyles.brandTitle2,
                          ),
                        )
                      : RefreshIndicator(
                          color: CupidColors.primary,
                          onRefresh: () async {
                            await ref.read(confessionsProvider.notifier).refresh();
                          },
                          child: NotificationListener<ScrollNotification>(
                            onNotification: (ScrollNotification scrollInfo) {
                              if (!state.isLoading &&
                                  scrollInfo.metrics.pixels >=
                                      scrollInfo.metrics.maxScrollExtent - 200) {
                                ref.read(confessionsProvider.notifier).loadMore();
                              }
                              return false;
                            },
                            child: ListView.builder(
                              key: PageStorageKey(state.selectedFilter.name),
                              padding: const EdgeInsets.only(bottom: 100),
                              itemCount: state.confessions!.length + 1, // +1 for loader
                              itemBuilder: (context, index) {
                                if (index == state.confessions!.length) {
                                  return state.isLoading
                                      ? const Center(
                                          child: Padding(
                                            padding: EdgeInsets.all(16.0),
                                            child: CircularProgressIndicator(),
                                          ),
                                        )
                                      : const SizedBox.shrink();
                                }
                                final confession = state.confessions![index];
                                final myReaction = confession.reactions.firstWhere((r) {
                                  return r.user == LoginStore.userId;
                                }, orElse: () => Reaction(reaction: '', user: '')).reaction;
                                final isMine = state.selectedFilter == ConfessionsFilter.byYou ||
                                    state.myConfessionIds.contains(confession.id);
                                debugPrint('DEBUG UI: isMine: $isMine');
                                return ConfessionCard(
                                  confession: confession,
                                  myReaction: myReaction.isNotEmpty ? myReaction : null,
                                  isMine: isMine,
                                  onDelete: () async {
                                    final success = await ref
                                        .read(confessionsProvider.notifier)
                                        .deleteConfession(confession.id);
                                    if (success && context.mounted) {
                                      showSnackBar('Confession Deleted Successfully');
                                    }
                                  },
                                  onReport: () {
                                    showModalBottomSheet(
                                      context: context,
                                      backgroundColor: Colors.transparent,
                                      builder: (context) => ReportConfessionDialog(
                                        onReport: (category) {
                                          ref
                                              .read(confessionsProvider.notifier)
                                              .reportConfession(confession.id, category);
                                          showSnackBar('Confession Reported Successfully');
                                        },
                                      ),
                                    );
                                  },
                                  onReact: (reaction) {
                                    final myReaction = confession.reactions
                                        .firstWhere(
                                          (r) => r.user == LoginStore.userId,
                                          orElse: () => Reaction(reaction: '', user: ''),
                                        )
                                        .reaction;

                                    if (myReaction == reaction) {
                                      ref
                                          .read(confessionsProvider.notifier)
                                          .removeReaction(confession.id);
                                    } else {
                                      ref
                                          .read(confessionsProvider.notifier)
                                          .reactToConfession(confession.id, reaction);
                                    }
                                  },
                                  onReply: () {
                                    showModalBottomSheet(
                                      context: context,
                                      isScrollControlled: true,
                                      backgroundColor: Colors.transparent,
                                      builder: (context) => ReplyBottomSheet(
                                        confessionId: confession.id,
                                        title: 'Reply to Confession',
                                        onSend: (message) {
                                          ref
                                              .read(confessionsProvider.notifier)
                                              .replyToConfession(confession.id, message);
                                          showSnackBar('Reply Sent Successfully');
                                        },
                                      ),
                                    );
                                  },
                                );
                              },
                            ),
                          ),
                        ),
            ),
          ],
        ),
      ),
      floatingActionButton: GestureDetector(
        onTap: () {
          context.pushNamed(AppRoutes.createConfession.name);
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          decoration: BoxDecoration(
            color: CupidColors.primary,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: CupidColors.primary.withValues(alpha: 0.4),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Confess',
                style: CupidTextStyles.body2.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              const SizedBox(width: 8),
              const Icon(FluentIcons.edit_24_filled, color: Colors.white, size: 20),
            ],
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
