import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'io_file_system.dart';

class RespectHealthCacheManager {
  static const key = 'respect_health';
  static CacheManager instance = CacheManager(
    Config(
      key,
      stalePeriod: const Duration(days: 731),
      maxNrOfCacheObjects: 1000,
      repo: JsonCacheInfoRepository(databaseName: key),
      fileSystem: IOFileSystem(key),
      fileService: HttpFileService(),
    ),
  );
}
