import 'package:flutter/material.dart';

import '../../core/app_export.dart';
import './controller/deck_details_controller.dart';
import './widgets/card_item_widget.dart';

class DeckDetailsScreen extends GetWidget<DeckDetailsController> {
  const DeckDetailsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appTheme.cyan_A700,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(context),
            SizedBox(height: 16.h),
            _buildCardsHeader(),
            SizedBox(height: 16.h),
            Expanded(
              child: _buildCardsList(),
            ),
            _buildBottomNavigationBar(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.h, vertical: 16.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Icon(
              Icons.arrow_back,
              color: appTheme.white_A700,
              size: 28.h,
            ),
          ),
          Expanded(
            child: Text(
              controller.deckTitle.value,
              style: TextStyleHelper.instance.body18RegularOpenSans.copyWith(
                fontWeight: FontWeight.w700,
                fontSize: 24.h,
                color: appTheme.white_A700,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          GestureDetector(
            onTap: controller.onEditDeck,
            child: Icon(
              Icons.edit,
              color: appTheme.white_A700,
              size: 28.h,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCardsHeader() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.h, vertical: 12.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Cards',
                style: TextStyleHelper.instance.body18RegularOpenSans.copyWith(
                  fontWeight: FontWeight.w700,
                  fontSize: 20.h,
                  color: appTheme.white_A700,
                ),
              ),
              GestureDetector(
                onTap: controller.onAddCard,
                child: Container(
                  width: 40.h,
                  height: 40.h,
                  decoration: BoxDecoration(
                    border: Border.all(color: appTheme.white_A700, width: 2),
                    borderRadius: BorderRadius.circular(8.h),
                  ),
                  child: Icon(
                    Icons.add,
                    color: appTheme.white_A700,
                    size: 24.h,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                Obx(() {
                  // Mostra botão de exportar PDF se houver sessões de estudo
                  if (controller.hasStudySessionsFlag.value) {
                    return GestureDetector(
                      onTap: controller.exportToPDF,
                      child: Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 12.h, vertical: 8.h),
                        decoration: BoxDecoration(
                          color: appTheme.white_A700,
                          borderRadius: BorderRadius.circular(8.h),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.picture_as_pdf,
                              size: 16.h,
                              color: appTheme.cyan_A700,
                            ),
                            SizedBox(width: 4.h),
                            Text(
                              'Exportar para PDF',
                              style:
                                  TextStyleHelper.instance.body15RegularOpenSans.copyWith(
                                fontWeight: FontWeight.w600,
                                fontSize: 12.h,
                                color: appTheme.cyan_A700,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }
                  return SizedBox.shrink();
                }),
                Obx(() {
                  // Só mostra o botão de compartilhar se houver cards
                  if (controller.flashcards.isNotEmpty) {
                    return Padding(
                      padding: EdgeInsets.only(
                        left: controller.hasStudySessionsFlag.value ? 8.h : 0,
                      ),
                      child: GestureDetector(
                        onTap: controller.shareDeck,
                        child: Container(
                          padding:
                              EdgeInsets.symmetric(horizontal: 12.h, vertical: 8.h),
                          decoration: BoxDecoration(
                            color: appTheme.white_A700,
                            borderRadius: BorderRadius.circular(8.h),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.share,
                                size: 16.h,
                                color: appTheme.cyan_A700,
                              ),
                              SizedBox(width: 4.h),
                              Text(
                                'Compartilhar',
                                style:
                                    TextStyleHelper.instance.body15RegularOpenSans.copyWith(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 12.h,
                                  color: appTheme.cyan_A700,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }
                  return SizedBox.shrink();
                }),
                Obx(() {
                  // Só mostra o botão de estudar se houver cards
                  if (controller.flashcards.isNotEmpty) {
                    return Padding(
                      padding: EdgeInsets.only(left: 8.h),
                      child: GestureDetector(
                        onTap: controller.startStudySession,
                        child: Container(
                          padding:
                              EdgeInsets.symmetric(horizontal: 12.h, vertical: 8.h),
                          decoration: BoxDecoration(
                            color: appTheme.white_A700,
                            borderRadius: BorderRadius.circular(8.h),
                          ),
                          child: Text(
                            'Estudar',
                            style:
                                TextStyleHelper.instance.body15RegularOpenSans.copyWith(
                              fontWeight: FontWeight.w600,
                              fontSize: 12.h,
                              color: appTheme.cyan_A700,
                            ),
                          ),
                        ),
                      ),
                    );
                  }
                  return SizedBox.shrink();
                }),
                Obx(() {
                  // Mostra botão de resetar se houver sessões de estudo
                  if (controller.hasStudySessionsFlag.value) {
                    return Padding(
                      padding: EdgeInsets.only(left: 8.h),
                      child: GestureDetector(
                        onTap: controller.showResetConfirmationDialog,
                        child: Container(
                          padding:
                              EdgeInsets.symmetric(horizontal: 12.h, vertical: 8.h),
                          decoration: BoxDecoration(
                            color: appTheme.white_A700,
                            borderRadius: BorderRadius.circular(8.h),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.refresh,
                                size: 16.h,
                                color: Colors.orange[700],
                              ),
                              SizedBox(width: 4.h),
                              Text(
                                'Resetar',
                                style:
                                    TextStyleHelper.instance.body15RegularOpenSans.copyWith(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 12.h,
                                  color: Colors.orange[700],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }
                  return SizedBox.shrink();
                }),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCardsList() {
    return Container(
      decoration: BoxDecoration(
        color: appTheme.white_A700,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(32.h),
          topRight: Radius.circular(32.h),
        ),
      ),
      child: Padding(
        padding: EdgeInsets.all(20.h),
        child: Obx(() => ListView.separated(
              itemCount: controller.flashcards.length,
              separatorBuilder: (context, index) => SizedBox(height: 12.h),
              itemBuilder: (context, index) {
                final card = controller.flashcards[index];
                return CardItemWidget(
                  cardNumber: index + 1,
                  question: card['front_text'] as String? ?? 'Card sem texto',
                  onDelete: () => controller.onDeleteCard(card['id'] as String),
                  onEdit: () => controller.onEditCard(
                    card['id'] as String,
                    card['front_text'] as String? ?? '',
                    card['back_text'] as String? ?? '',
                  ),
                );
              },
            )),
      ),
    );
  }

  Widget _buildBottomNavigationBar() {
    return Container(
      height: 70.h,
      decoration: BoxDecoration(
        color: appTheme.white_A700,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(26),
            blurRadius: 10.h,
            offset: Offset(0, -2.h),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildNavItem(Icons.home, 0),
          _buildNavItem(Icons.psychology, 1),
          _buildNavItem(Icons.person, 2),
        ],
      ),
    );
  }

  Widget _buildNavItem(IconData icon, int index) {
    return GestureDetector(
      onTap: () => controller.onBottomNavTap(index),
      child: Obx(() => Icon(
            icon,
            size: 32.h,
            color: controller.selectedIndex.value == index
                ? appTheme.cyan_A700
                : appTheme.greyCustom,
          )),
    );
  }
}