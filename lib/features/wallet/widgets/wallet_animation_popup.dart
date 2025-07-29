import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:visaamigo/core/theme/theme.dart';
import 'package:visaamigo/features/wallet/widgets/wallet_animation_provider.dart';
import 'package:visaamigo/features/wallet/widgets/wallet_card_animation.dart';

// POC Class not in use
class WalletAnimationPopUp extends StatefulWidget {
  const WalletAnimationPopUp({super.key});

  @override
  State<WalletAnimationPopUp> createState() => _WalletAnimationPopUpState();
}

class _WalletAnimationPopUpState extends State<WalletAnimationPopUp> {
  @override
  Widget build(BuildContext context) {
    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
      child: Scaffold(
          backgroundColor: VisaColors.transparent,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            leading: const SizedBox(),
            actions: [
              InkWell(
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                  child: Icon(Icons.close)),
              SizedBox(
                width: 24.w,
              )
            ],
          ),
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                VisaAnimatedWidget(
                  delay: const Duration(milliseconds: 100),
                  child: Card3DRotateOnDrag(),
                ),
                SizedBox(
                  height: 24.h,
                ),
                VisaAnimatedWidget(
                  child: visaWidget(),
                  delay: const Duration(milliseconds: 500),
                ),
                SizedBox(
                  height: 24.h,
                ),
                VisaAnimatedWidget(
                  child: visaWidget(),
                  delay: const Duration(milliseconds: 400),
                ),
                SizedBox(
                  height: 24.h,
                ),
                VisaAnimatedWidget(
                  child: visaWidget(),
                  delay: const Duration(milliseconds: 300),
                ),
                SizedBox(
                  height: 24.h,
                ),
                VisaAnimatedWidget(
                  child: visaWidget(),
                ),
              ],
            ),
          )),
    );
  }

  visaWidget() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          width: 250.w,
          height: 80.h,
          padding: const EdgeInsets.all(16).r,
          decoration: BoxDecoration(
            color: Colors.white.withAlpha(38), // Glass tint
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: Colors.white.withAlpha(51),
            ),
          ),
          child: Center(
            child: Text(
              'Glassy Container',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
