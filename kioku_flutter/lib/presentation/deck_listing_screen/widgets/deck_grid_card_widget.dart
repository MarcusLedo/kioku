import 'package:flutter/material.dart';

import '../../../core/app_export.dart';

class DeckGridCardWidget extends StatelessWidget {
  final String deckId;
  final String title;
  final int totalCards;
  final int studiedCards;
  final IconData icon;
  final bool isImported;

  const DeckGridCardWidget({
    Key? key,
    required this.deckId,
    required this.title,
    required this.totalCards,
    required this.studiedCards,
    required this.icon,
    this.isImported = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Get.toNamed('/deck-details-screen', arguments: {
          'deckId': deckId,
          'title': title,
        });
      },
      child: Container(
        padding: EdgeInsets.all(20.h),
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
              size: 56.h,
              color: appTheme.white_A700,
            ),
            SizedBox(height: 12.h),
            // Título abaixo do ícone
            Text(
              title,
              style: TextStyleHelper.instance.body15RegularOpenSans.copyWith(
                fontWeight: FontWeight.w600,
                fontSize: 16.h,
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
                  style: TextStyleHelper.instance.body15RegularOpenSans.copyWith(
                    color: appTheme.white_A700,
                    fontWeight: FontWeight.w600,
                    fontSize: 18.h,
                  ),
                ),
                // Acertos do último estudo no canto inferior direito
                Row(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      '$studiedCards',
                      style: TextStyleHelper.instance.body15RegularOpenSans.copyWith(
                        color: appTheme.white_A700,
                        fontWeight: FontWeight.w600,
                        fontSize: 18.h,
                      ),
                    ),
                    SizedBox(width: 4.h),
                    Icon(
                      Icons.arrow_drop_up,
                      color: Colors.green[400],
                      size: 20.h,
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
