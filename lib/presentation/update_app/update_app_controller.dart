import 'package:get/get.dart';
import 'package:store_redirect/store_redirect.dart';

class UpdateAppController extends GetxController {
  Future<void> redirectToStore() async {
    await StoreRedirect.redirect(
      androidAppId: "com.lira.albatros",
      iOSAppId: "6473798901",
    );
  }
}
