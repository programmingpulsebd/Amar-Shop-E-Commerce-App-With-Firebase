import 'package:bkash/bkash.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';

class BkashPaymentService {


  // Testing Number:  01619777283 , 01877722345, 01823074817
  // OTP: 123456
  // PIN: 12121


  Future<dynamic> payWithBkash({
    required double amount,
    required String invoice,
  }) async {

    final bkash = Bkash(
      bkashCredentials: BkashCredentials(
        username: "sandboxTokenizedUser02",
        password: "sandboxTokenizedUser02@12345",
        appKey: "4f6o0cjiki2rfm34kfdadl1eqq",
        appSecret: "2is7hdktrekvrbljjh44ll3d9l1dtjo4pasmjvs5vl5qr3fug4b",
        isSandbox: true,
      ),
    );

    try {
      final response = await bkash.pay(
        context: Get.context!,

        amount: amount,
        merchantInvoiceNumber: invoice,
      );
      print(response);

      return response;
    } on BkashFailure catch (e) {
      throw e.message;
    }
  }


}