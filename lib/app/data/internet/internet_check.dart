import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:get/get.dart';

import '../../common/widgets/app_snackbar.dart';

class ConnectivityService extends GetxService {
  final Connectivity _connectivity = Connectivity();

  @override
  void onInit() {
    super.onInit();
    _connectivity.onConnectivityChanged.listen((List<ConnectivityResult> results) {
      if (results.isNotEmpty) {
        _updateConnectionStatus(results.first);
      }
    });
  }

  void _updateConnectionStatus(ConnectivityResult result) {
    if (result == ConnectivityResult.none) {
      if (!Get.isSnackbarOpen) {
        customSnackBar(
          title: "Connection Lost",
          message: "Please check your internet connection",
          isError: true,
        );
      }
    } else {
      if (Get.isSnackbarOpen) {
        Get.closeCurrentSnackbar();
        customSnackBar(
          title: "Connected",
          message: "You are back online",
          isError: false,
        );
      }
    }
  }

  Future<bool> hasInternet() async {
    var results = await _connectivity.checkConnectivity();
    return results.isNotEmpty && results.first != ConnectivityResult.none;
  }
}