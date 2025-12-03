import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/app_export.dart';
import '../controller/homepage_controller.dart';

class StreakCalendarWidget extends GetWidget<HomepageController> {
  const StreakCalendarWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(20.h),
      decoration: BoxDecoration(
        color: appTheme.white_A700,
        borderRadius: BorderRadius.circular(24.h),
      ),
      child: Column(
        children: [
          Obx(() => _buildCalendarGrid()),
        ],
      ),
    );
  }

  Widget _buildCalendarGrid() {
    // Calculate dates for the last 35 days (5 weeks)
    final today = DateTime.now();
    final dates = List.generate(35, (index) {
      return today.subtract(Duration(days: 34 - index));
    });

    return Column(
      children: List.generate(5, (rowIndex) {
        return Padding(
          padding: EdgeInsets.only(bottom: 12.h),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: List.generate(7, (colIndex) {
              final dayIndex = rowIndex * 7 + colIndex;
              if (dayIndex >= dates.length) {
                return SizedBox(width: 28.h, height: 28.h);
              }
              
              final date = dates[dayIndex];
              final didStudy = controller.didStudyOnDate(date);
              
              Color circleColor = appTheme.grey200; // Default gray
              
              if (didStudy) {
                circleColor = Colors.green;
              }
              
              return Container(
                width: 28.h,
                height: 28.h,
                decoration: BoxDecoration(
                  color: circleColor,
                  shape: BoxShape.circle,
                ),
              );
            }),
          ),
        );
      }),
    );
  }
}
