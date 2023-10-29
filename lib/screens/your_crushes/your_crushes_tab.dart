import 'package:college_cupid/services/api.dart';
import 'package:college_cupid/shared/styles.dart';
import 'package:college_cupid/widgets/your_crushes/crush_info.dart';
import 'package:flutter/material.dart';
import '../../shared/colors.dart';

class YourCrushesTab extends StatefulWidget {
  YourCrushesTab({super.key});
  @override
  State<YourCrushesTab> createState() => _YourCrushesTabState();
}

class _YourCrushesTabState extends State<YourCrushesTab> {
  late List<dynamic> crushes;
  Future<List<Map<String, dynamic>>?>? crushInfo;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadCrushes();
  }

  Future<void> loadCrushes() async {
    final crushData = await APIService().getCrush();
    setState(() {
      crushes = crushData;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 30, right: 30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.only(top: 11),
            child: Text('Your Crushes',
                style: CupidStyles.headingStyle
                    .copyWith(color: CupidColors.titleColor)),
          ),
          Container(
            margin: const EdgeInsets.only(top: 10),
            child: const Text(
                'You can select a maximum of 5 crushes at a time.',
                style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    height: 1.5,
                    color: CupidColors.grayColor,
                    fontFamily: 'Sk-Modernist')),
          ),
          isLoading
              ? Center(child: CircularProgressIndicator())
              : Expanded(
                  child: FutureBuilder(
                          future: APIService().getUserInfo(crushes),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return CircularProgressIndicator();
                            } else if (snapshot.hasError) {
                              return Text('Error: ${snapshot.error}');
                            } else if (!snapshot.hasData) {
                              return Container(
                                child: Center(
                                  child: Text(
                                      'No Crushes as of now\nGet Rolling !!!!'),
                                ),
                              );
                            } else {
                              return ListView.builder(
                                  itemCount: crushes.length,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    final info = snapshot.data![index];
                                    return CrushInfo(info);
                                      });
                            }
                          },
                        )
                ),
        ],
      ),
    );
  }
}
