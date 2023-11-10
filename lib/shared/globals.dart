import 'package:flutter_cache_manager/flutter_cache_manager.dart';

final customCacheManager = CacheManager(Config('customKey',
    stalePeriod: const Duration(days: 10), maxNrOfCacheObjects: 50));
