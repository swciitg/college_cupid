import 'package:college_cupid/domain/models/confession.dart';
import 'package:college_cupid/presentation/screens/confessions/create_confession_screen.dart';
import 'package:college_cupid/presentation/widgets/confessions/confession_card.dart';
import 'package:college_cupid/presentation/widgets/confessions/reply_bottom_sheet.dart';
import 'package:college_cupid/presentation/widgets/global/custom_loader.dart';
// Drawer widget import removed

import 'package:college_cupid/stores/confessions_controller.dart';
import 'package:college_cupid/shared/colors.dart';
import 'package:college_cupid/shared/styles.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ConfessionsScreen extends ConsumerStatefulWidget {
  const ConfessionsScreen({super.key});

  @override
  ConsumerState<ConfessionsScreen> createState() => _ConfessionsScreenState();
}

class _ConfessionsScreenState extends ConsumerState<ConfessionsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final List<ConfessionCategory> _tabs = [
    ConfessionCategory.all,
    ConfessionCategory.spottedInCampus,
    ConfessionCategory.gossip,
    ConfessionCategory.byYou,
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _tabs.length, vsync: this);
    _tabController.addListener(() {
      if (!_tabController.indexIsChanging) {
        ref
            .read(confessionsProvider.notifier)
            .setCategory(_tabs[_tabController.index]);
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

    return Scaffold(
      backgroundColor: CupidColors.backgroundColor,
      appBar: AppBar(
        backgroundColor: CupidColors.backgroundColor,
        elevation: 0,
        centerTitle: false,
        automaticallyImplyLeading: false,
        title: Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: Text(
            'Confessions',
            style: CupidStyles.headingStyle,
          ),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: Container(
            height: 50,
            alignment: Alignment.centerLeft,
            child: TabBar(
              controller: _tabController,
              isScrollable: true,
              indicatorColor: Colors.transparent,
              dividerColor: Colors.transparent,
              labelPadding: const EdgeInsets.symmetric(horizontal: 4),
              padding: const EdgeInsets.symmetric(horizontal: 16),
              tabAlignment: TabAlignment.start,
              onTap: (index) {
                ref
                    .read(confessionsProvider.notifier)
                    .setCategory(_tabs[index]);
              },
              tabs: _tabs.map((category) {
                final isSelected = state.selectedCategory == category;
                return Tab(
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? const Color(0xFF8B5CF6) // Purple from SS
                          : Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: isSelected
                            ? Colors.transparent
                            : CupidColors.greyColor.withOpacity(0.2),
                      ),
                    ),
                    child: Text(
                      category.displayName,
                      style: CupidStyles.normalTextStyle.copyWith(
                        color: isSelected ? Colors.white : Colors.black,
                        fontWeight:
                            isSelected ? FontWeight.bold : FontWeight.normal,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ),
      ),
      body: state.isLoading
          ? const Center(child: CustomLoader())
          : state.confessions == null || state.confessions!.isEmpty
              ? Center(
                  child: Text(
                    'No confessions found!',
                    style: CupidStyles.normalTextStyle,
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.only(bottom: 100),
                  itemCount: state.confessions!.length,
                  itemBuilder: (context, index) {
                    final confession = state.confessions![index];
                    return ConfessionCard(
                      confession: confession,
                      onReact: (reaction) {
                        ref
                            .read(confessionsProvider.notifier)
                            .reactToConfession(confession.id, reaction);
                      },
                      onReply: () {
                        showModalBottomSheet(
                          context: context,
                          isScrollControlled: true,
                          backgroundColor: Colors.transparent,
                          builder: (context) => ReplyBottomSheet(
                            confessionId: confession.id,
                          ),
                        );
                      },
                    );
                  },
                ),
      floatingActionButton: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => const CreateConfessionScreen()),
          );
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          decoration: BoxDecoration(
            color: const Color(0xFF8B5CF6),
            borderRadius: BorderRadius.circular(30),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF8B5CF6).withOpacity(0.4),
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
                style: CupidStyles.normalTextStyle.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              const SizedBox(width: 8),
              const Icon(FluentIcons.edit_24_filled,
                  color: Colors.white, size: 20),
            ],
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
