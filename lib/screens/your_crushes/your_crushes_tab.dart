import 'dart:typed_data';
import 'package:college_cupid/functions/encryption.dart';
import 'package:college_cupid/shared/endpoints.dart';
import 'package:college_cupid/shared/styles.dart';
import 'package:college_cupid/widgets/your_crushes/crush_info.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import '../../shared/colors.dart';
import 'package:encrypt/encrypt.dart' as encrypt;


class YourCrushesTab extends StatefulWidget {
  YourCrushesTab({super.key});
  @override
  State<YourCrushesTab> createState() => _YourCrushesTabState();
}

class _YourCrushesTabState extends State<YourCrushesTab> {
  List crushes = [];
  Future<List<Map<String, dynamic>>?>? crushInfo;
  bool isLoading = true;


  Future<void> getCrush() async {
    final baseurl = Endpoints.baseUrl;
    final endpoint = Endpoints.getCrush;

    final dio = Dio();
    try {
      final response = await dio.get('$baseurl$endpoint');

      if (response.statusCode == 200) {
        crushes = response.data;
        print(crushes);
      } else {
        print('Request Failed with status: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching data: $e');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }


Future<List<Map<String, dynamic>>?> getUserInfo() async {
  try {
    Dio dio = Dio();
    dio.options.baseUrl = Endpoints.baseUrl;

    List<Map<String, dynamic>> userInfoList = [];

    for (String encryptedEmail in crushes) {
      final encryptedEmailBytes = Encryption.hexadecimalToBytes(encryptedEmail);
      final decryptedEmail = Encryption.decryptAES(encryptedEmailBytes, 'key'); 
      // final decryptedEmailBytes = Uint8List.fromList(utf8.encode(decryptedEmail)); 

      // String email = utf8.decode(decryptedEmailBytes); 

      String endpoint = '/user/email/$decryptedEmail';
      Response response = await dio.get(endpoint);

      if (response.statusCode == 200) {
        Map<String, dynamic> userInfo = response.data;

        userInfoList.add(userInfo);
      } else {
        print('Request for $decryptedEmail failed with status: ${response.statusCode}');
      }
    }

    return userInfoList.isEmpty ? null : userInfoList;
  } catch (e) {
    print('Error: $e');
    return null;
  }
}



  @override
  void initState() {
    super.initState();
    getCrush().then((_) {
      setState(() {
        isLoading = false;
        crushInfo = getUserInfo();
      });
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
                  child: crushes.length > 0
                      ? ListView.builder(
                          itemCount: crushes.length,
                          itemBuilder: (BuildContext context, int index) {
                            if (crushInfo != null) {
                              return FutureBuilder<List<Map<String, dynamic>>?>(
                                future: crushInfo!,
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    return CircularProgressIndicator();
                                  } else if (snapshot.hasError) {
                                    return Text('Error: ${snapshot.error}');
                                  } else if (!snapshot.hasData) {
                                    return Text(
                                        'No Crushes as of now\nGet Rolling !!!!');
                                  } else {
                                    final info = snapshot.data![index];
                                    return CrushInfo(info);
                                  }
                                },
                              );
                            } else {
                              return SizedBox();
                            }
                          })
                      : Center(
                          child: Container(
                            width: double.maxFinite,
                            margin: EdgeInsets.all(30),
                            decoration: BoxDecoration(
                                color: Colors.yellow,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(20))),
                            height: 200,
                            padding: EdgeInsets.all(10),
                            child: Center(
                                child: Text(
                              "No crushes as of now !!!!",
                              style: TextStyle(fontSize: 20),
                            )),
                          ),
                        ),
                ),
        ],
      ),
    );
  }
}
