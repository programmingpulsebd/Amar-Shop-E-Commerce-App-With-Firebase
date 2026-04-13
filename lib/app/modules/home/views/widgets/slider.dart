import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import '../../controllers/home_controller.dart';
import '../shimmer/slider_shimmer.dart';

class CarouselSliderBanners extends StatelessWidget {
  const CarouselSliderBanners({super.key});

  @override
  Widget build(BuildContext context) {

    final controller = Get.put(HomeController());
    return Obx(() {

      if (controller.isLoading.value) {
        return SliderShimmer();
      }

      if (controller.allBanners.isEmpty) {
        return SliderShimmer();
      }

      return CarouselSlider.builder(
        itemCount: controller.allBanners.length,
        itemBuilder: (context, index, realIndex) {
          final banner = controller.allBanners[index];
          return Container(
            decoration: BoxDecoration(
              color: Colors.grey.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(15),
              image: DecorationImage(
                image: NetworkImage(banner.image),
                fit: BoxFit.cover,
              ),


            ),
          );
        },
        options: CarouselOptions(
          height: 140,
          aspectRatio: 16 / 9,
          viewportFraction: 0.96,
          autoPlay: true,
          enlargeCenterPage: true,
          enlargeFactor: 0.2,
          autoPlayInterval: const Duration(seconds: 3),
          autoPlayCurve: Curves.fastOutSlowIn,
        ),
      );
    });
  }
}
