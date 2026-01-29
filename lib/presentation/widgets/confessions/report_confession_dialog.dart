import 'package:college_cupid/domain/models/confession.dart';
import 'package:college_cupid/shared/styles.dart';
import 'package:flutter/material.dart';

class ReportConfessionDialog extends StatelessWidget {
  final Function(ConfessionReportCategory) onReport;

  const ReportConfessionDialog({super.key, required this.onReport});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Report Confession',
            style: CupidTextStyles.brandTitle2.copyWith(fontSize: 20),
          ),
          const SizedBox(height: 8),
          Text(
            'Why are you reporting this confession?',
            style: CupidTextStyles.body1,
          ),
          const SizedBox(height: 20),
          ...ConfessionReportCategory.values.map((category) => ListTile(
                title: Text(
                  category.displayName,
                  style: CupidTextStyles.body1,
                ),
                onTap: () {
                  onReport(category);
                  Navigator.pop(context);
                },
                contentPadding: EdgeInsets.zero,
                trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              )),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
