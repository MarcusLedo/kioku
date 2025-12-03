import 'package:flutter/material.dart';

import '../../../core/app_export.dart';

class DeckCardWidget extends StatelessWidget {
  final String deckId;
  final String title;
  final int totalCards;
  final int studiedCards;
  final IconData icon;
  final VoidCallback? onTap;
  final bool isImported;

  const DeckCardWidget({
    Key? key,
    required this.deckId,
    required this.title,
    required this.totalCards,
    required this.studiedCards,
    required this.icon,
    this.onTap,
    this.isImported = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 140.h,
        height: 180.h,
        margin: EdgeInsets.only(right: 12.h),
        padding: EdgeInsets.all(16.h),
        decoration: BoxDecoration(
          color: isImported ? Colors.purple[600] : appTheme.cyan_A700,
          borderRadius: BorderRadius.circular(16.h),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Ícone no topo (centro)
            Icon(
              icon,
              size: 48.h,
              color: appTheme.white_A700,
            ),
            SizedBox(height: 8.h),
            // Título abaixo do ícone
            Text(
              title,
              style: TextStyleHelper.instance.body15RegularOpenSans.copyWith(
                fontWeight: FontWeight.w600,
                fontSize: 14.h,
                color: appTheme.white_A700,
              ),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            Spacer(),
            // Números na parte inferior
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                // Total de cards no canto inferior esquerdo
                Text(
                  '$totalCards',
                  style: TextStyleHelper.instance.body14LightOpenSans.copyWith(
                    color: appTheme.white_A700,
                    fontWeight: FontWeight.w600,
                    fontSize: 16.h,
                  ),
                ),
                // Acertos do último estudo no canto inferior direito
                Row(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      '$studiedCards',
                      style: TextStyleHelper.instance.body14LightOpenSans.copyWith(
                        color: appTheme.white_A700,
                        fontWeight: FontWeight.w600,
                        fontSize: 16.h,
                      ),
                    ),
                    SizedBox(width: 2.h),
                    Icon(
                      Icons.arrow_drop_up,
                      color: Colors.green[400],
                      size: 18.h,
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

