import 'package:url_launcher/url_launcher.dart';

Future<void> launchURL({required String host, String? path}) async {
  final Uri uri = Uri(scheme: "https", host: host, path: path );
  if(!await launchUrl(
    uri,
    mode: LaunchMode.externalApplication,
  )) {
    throw "Can not launch url";
  }
}