import 'dart:io';
import 'package:edu_app/services/CacheManager.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:path_provider/path_provider.dart';
import 'package:workmanager/workmanager.dart';
Future<void> clearAllAppCache() async {
  // 1) Vacía el CacheManager
  await AdifCacheManager.instance.emptyCache();

  // 2) Borra la carpeta /cache (archivos temporales)
  final tmpDir = await getTemporaryDirectory();
  if (await tmpDir.exists()) {
    await tmpDir.delete(recursive: true);
    debugPrint('🧹 /cache/ eliminado');
  }

  // 3) Limpia caché de imágenes en RAM (opcional)
  PaintingBinding.instance.imageCache.clear();
  PaintingBinding.instance.imageCache.clearLiveImages();
}


const cleanTask = 'cleanAdifCache';

void callbackDispatcher() {
  Workmanager().executeTask((task, input) async {
    if (task == cleanTask) {
      await clearAllAppCache(); // ← la función del paso 3
      debugPrint('✅ Caché limpia (job semanal)');
    }
    return Future.value(true);   // éxito
  });
}
