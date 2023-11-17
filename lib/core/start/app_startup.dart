import 'package:flutter/foundation.dart' show kDebugMode;
import 'package:fresh_base_package/fresh_base_package.dart'
    show PlatformChecker;
import 'package:path_provider/path_provider.dart'
    show getApplicationDocumentsDirectory;

import '../../logic/auth/auth_service.dart';
import '../../logic/native/image/s_image_picker.dart';
import '../log/logger.dart';
import '../services/s_app.dart';
import 'packages/firebase.dart';
import 'packages/hydrated_bloc.dart';

class AppStartup extends AppService {
  factory AppStartup.getInstance() => _instance;
  AppStartup._();

  static final _instance = AppStartup._();

  final _services = <AppService>[
    HydratedBlocService(),
    FirebaseService.getInstance(),
    AuthService.getInstance(),
    ImagePickerService.getInstance(),
  ];

  @override
  Future<void> initialize() async {
    for (final service in _services) {
      await service.initialize();
    }
    if (kDebugMode && !PlatformChecker.defaultLogic().isWeb()) {
      final dir = await getApplicationDocumentsDirectory();
      dir.list().listen((event) {
        AppLogger.log(event.toString());
      });
    }
  }

  @override
  Future<void> deInitialize() async {
    for (final service in _services) {
      await service.deInitialize();
    }
  }

  @override
  bool get isInitialized {
    final anyServiceIsNotInitialized =
        _services.any((service) => !service.isInitialized);
    return !anyServiceIsNotInitialized;
  }
}
