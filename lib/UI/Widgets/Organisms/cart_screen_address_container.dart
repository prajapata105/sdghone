import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ssda/controller/AddressController.dart'; // Controller को इम्पोर्ट करें
import 'package:ssda/models/address_model.dart'; // Model को इम्पोर्ट करें
import '../../../app_colors.dart';

class CartScreenAddressContainer extends StatelessWidget {
  const CartScreenAddressContainer({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    // AddressController का इंस्टेंस प्राप्त करें
    final addressCtrl = Get.find<AddressController>();

    // Obx विजेट से लपेटा गया ताकि यह एड्रेस में होने वाले बदलावों को सुन सके
    return Obx(() {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20.0),
            topRight: Radius.circular(20.0),
          ),
        ),
        width: MediaQuery.of(context).size.width,
        height: 70,
        child: _buildChild(context, addressCtrl), // UI बनाने के लिए Helper फंक्शन
      );
    });
  }

  // यह फंक्शन कंट्रोलर की स्थिति के आधार पर सही UI दिखाता है
  Widget _buildChild(BuildContext context, AddressController addressCtrl) {
    // 1. लोडिंग स्टेट
    if (addressCtrl.isLoading.value) {
      return const Center(child: CircularProgressIndicator());
    }

    final address = addressCtrl.shippingAddress.value;

    // 2. कोई पता न होने पर स्टेट
    if (address == null || address.isEmpty) {
      return _buildAddAddressPrompt(context);
    }
    // 3. पता मौजूद होने पर स्टेट (आपका मूल UI)
    else {
      return _buildAddressDetails(context, address);
    }
  }

  // आपका मूल UI, अब डायनामिक डेटा के साथ
  Widget _buildAddressDetails(BuildContext context, Address address) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            const Icon(
              Icons.home_filled,
              color: Colors.orangeAccent,
            ),
            const SizedBox(
              width: 15,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // 👇 **डायनामिक डेटा** 👇
                Text(
                  "Delivering to: ${address.name}", // स्टैटिक "Home" की जगह डायनामिक नाम
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                // 👇 **डायनामिक डेटा** 👇
                Text(
                  // पूरा पता दिखाने के बजाय, संक्षिप्त पता
                  "${address.house}, ${address.city}",
                  style: const TextStyle(fontWeight: FontWeight.w300),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            )
          ],
        ),
        GestureDetector(
          onTap: () {
            // GetX का उपयोग करके सही राउट पर नेविगेट करें
            Get.toNamed('/user/address');
          },
          child: const Text(
            "Change",
            style: TextStyle(
              // 👇 **आपके कस्टम कलर का उपयोग** 👇
              color: AppColors.primaryGreenColor,
            ),
          ),
        )
      ],
    );
  }

  // पता न होने पर दिखाया जाने वाला UI
  Widget _buildAddAddressPrompt(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          "Please add a delivery address",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primaryGreenColor,
            foregroundColor: Colors.white,
          ),
          onPressed: () {
            Get.toNamed('/user/address');
          },
          child: const Text("Add"),
        ),
      ],
    );
  }
}