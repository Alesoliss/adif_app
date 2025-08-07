import 'package:flutter_cache_manager/flutter_cache_manager.dart';

class AdifCacheManager extends CacheManager {
  static const key = 'adifCache';

  AdifCacheManager()
  : super(
          Config(
            key,
            stalePeriod: const Duration(days: 7),   // se elimina tras 1 semana
            // 👉 límite por número de objetos, no por MB
            maxNrOfCacheObjects: 1_500,             // ≈100 MB si ~70 KB / img
          ),
        );

  static AdifCacheManager get instance => AdifCacheManager();
}
