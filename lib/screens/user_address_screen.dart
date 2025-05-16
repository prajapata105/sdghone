import 'package:flutter/material.dart';
import 'package:ssda/app_colors.dart' show AppColors;
import 'package:ssda/constants.dart';
import '../UI/Widgets/Atoms/card_add_address.dart';
import '../UI/Widgets/Atoms/card_address_screen.dart';

class UserAddressScreen extends StatelessWidget {
  const UserAddressScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.greyWhiteColor,
      appBar: AppBar(
        title: const Text('My Addresses'),
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        child: const Column(
          children: [
            AddNewAddressCard(),
            // Address List

            // Address List
            AddressCard(),
          ],
        ),
      ),
    );
  }
}
