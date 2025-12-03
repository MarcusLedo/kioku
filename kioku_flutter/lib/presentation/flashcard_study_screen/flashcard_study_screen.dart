import 'package:flutter/material.dart';

import '../../core/app_export.dart';
import './controller/flashcard_study_controller.dart';
import './widgets/answer_button_widget.dart';

class FlashcardStudyScreen extends GetWidget<FlashcardStudyController> {
  const FlashcardStudyScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appTheme.cyan_A700,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(context),
            Expanded(
              child: Center(
                child: _buildFlashcardContent(),
              ),
            ),
            _buildBottomNavigationBar(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.h, vertical: 16.h),
      child: Align(
        alignment: Alignment.centerLeft,
        child: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Icon(
            Icons.arrow_back,
            color: appTheme.white_A700,
            size: 28.h,
          ),
        ),
      ),
    );
  }

  Widget _buildFlashcardContent() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.h),
      child: Container(
        constraints: BoxConstraints(
          maxHeight: 550.h,
          minHeight: 450.h,
        ),
        decoration: BoxDecoration(
          color: appTheme.white_A700,
          borderRadius: BorderRadius.circular(24.h),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildQuestionHeader(),
            Expanded(
              child: _buildAnswersSection(),
            ),
            Obx(() {
              if (controller.isAnswerRevealed.value) {
                return _buildDifficultyButtons();
              }
              return SizedBox.shrink();
            }),
            SizedBox(height: 20.h),
          ],
        ),
      ),
    );
  }

  Widget _buildQuestionHeader() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 24.h, vertical: 20.h),
      decoration: BoxDecoration(
        color: appTheme.cyan_A700,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24.h),
          topRight: Radius.circular(24.h),
        ),
      ),
      child: Center(
        child: Obx(() => Text(
              controller.currentQuestion,
              style: TextStyleHelper.instance.body18RegularOpenSans.copyWith(
                fontWeight: FontWeight.w600,
                fontSize: 20.h,
                color: appTheme.white_A700,
              ),
              textAlign: TextAlign.center,
            )),
      ),
    );
  }

  Widget _buildAnswersSection() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24.h, vertical: 32.h),
      child: Obx(() {
        final alternatives = controller.currentAlternatives;
        final selectedIndex = controller.selectedAnswerIndex.value;
        
        if (alternatives.isEmpty) {
          return Center(
            child: Text(
              'Nenhuma alternativa disponível',
              style: TextStyleHelper.instance.body15RegularOpenSans,
            ),
          );
        }

        // Organiza as alternativas em uma grade
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Primeira linha (até 2 alternativas)
            if (alternatives.length > 0)
              Row(
                children: [
                  Expanded(
                    child: AnswerButtonWidget(
                      text: alternatives[0],
                      onTap: () => controller.onSelectAnswer(0),
                      isCorrect: controller.isAnswerRevealed.value &&
                          controller.correctAnswerIndex == 0,
                      isRevealed: controller.isAnswerRevealed.value,
                      isSelected: selectedIndex == 0,
                    ),
                  ),
                  if (alternatives.length > 1) ...[
                    SizedBox(width: 12.h),
                    Expanded(
                      child: AnswerButtonWidget(
                        text: alternatives[1],
                        onTap: () => controller.onSelectAnswer(1),
                        isCorrect: controller.isAnswerRevealed.value &&
                            controller.correctAnswerIndex == 1,
                        isRevealed: controller.isAnswerRevealed.value,
                        isSelected: selectedIndex == 1,
                      ),
                    ),
                  ],
                ],
              ),
            if (alternatives.length > 2) SizedBox(height: 16.h),
            // Segunda linha (alternativas 3 e 4)
            if (alternatives.length > 2)
              Row(
                children: [
                  Expanded(
                    child: AnswerButtonWidget(
                      text: alternatives[2],
                      onTap: () => controller.onSelectAnswer(2),
                      isCorrect: controller.isAnswerRevealed.value &&
                          controller.correctAnswerIndex == 2,
                      isRevealed: controller.isAnswerRevealed.value,
                      isSelected: selectedIndex == 2,
                    ),
                  ),
                  if (alternatives.length > 3) ...[
                    SizedBox(width: 12.h),
                    Expanded(
                      child: AnswerButtonWidget(
                        text: alternatives[3],
                        onTap: () => controller.onSelectAnswer(3),
                        isCorrect: controller.isAnswerRevealed.value &&
                            controller.correctAnswerIndex == 3,
                        isRevealed: controller.isAnswerRevealed.value,
                        isSelected: selectedIndex == 3,
                      ),
                    ),
                  ],
                ],
              ),
          ],
        );
      }),
    );
  }

  Widget _buildDifficultyButtons() {
    return Obx(() {
      final selectedDifficulty = controller.selectedDifficulty.value;
      
      return Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.h, vertical: 16.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Como foi a dificuldade desta pergunta?',
              style: TextStyleHelper.instance.body15RegularOpenSans.copyWith(
                fontWeight: FontWeight.w600,
                color: appTheme.cyan_A700,
              ),
            ),
            SizedBox(height: 12.h),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => controller.updateDifficulty('easy'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: selectedDifficulty == 'easy' 
                          ? Colors.green[700] 
                          : Colors.green,
                      padding: EdgeInsets.symmetric(vertical: 12.h),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.h),
                        side: BorderSide(
                          color: selectedDifficulty == 'easy' 
                              ? Colors.green[900]! 
                              : Colors.transparent,
                          width: 2,
                        ),
                      ),
                    ),
                    child: Text(
                      'Fácil',
                      style: TextStyleHelper.instance.body15RegularOpenSans.copyWith(
                        color: appTheme.white_A700,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 12.h),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => controller.updateDifficulty('medium'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: selectedDifficulty == 'medium' 
                          ? Colors.orange[700] 
                          : Colors.orange,
                      padding: EdgeInsets.symmetric(vertical: 12.h),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.h),
                        side: BorderSide(
                          color: selectedDifficulty == 'medium' 
                              ? Colors.orange[900]! 
                              : Colors.transparent,
                          width: 2,
                        ),
                      ),
                    ),
                    child: Text(
                      'Médio',
                      style: TextStyleHelper.instance.body15RegularOpenSans.copyWith(
                        color: appTheme.white_A700,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 12.h),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => controller.updateDifficulty('hard'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: selectedDifficulty == 'hard' 
                          ? Colors.red[700] 
                          : Colors.red,
                      padding: EdgeInsets.symmetric(vertical: 12.h),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.h),
                        side: BorderSide(
                          color: selectedDifficulty == 'hard' 
                              ? Colors.red[900]! 
                              : Colors.transparent,
                          width: 2,
                        ),
                      ),
                    ),
                    child: Text(
                      'Difícil',
                      style: TextStyleHelper.instance.body15RegularOpenSans.copyWith(
                        color: appTheme.white_A700,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    });
  }

  Widget _buildRevealAnswerButton() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24.h),
      child: Obx(() {
        // Se já revelou, mostra botão para próxima pergunta
        if (controller.isAnswerRevealed.value) {
          final hasSelectedDifficulty = controller.selectedDifficulty.value.isNotEmpty;
          
          return GestureDetector(
            onTap: hasSelectedDifficulty ? controller.onRevealAnswer : null,
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(vertical: 14.h),
              decoration: BoxDecoration(
                color: hasSelectedDifficulty 
                    ? appTheme.cyan_A700 
                    : appTheme.greyCustom,
                borderRadius: BorderRadius.circular(12.h),
              ),
              child: Center(
                child: Text(
                  controller.hasMoreCards ? 'Próxima Pergunta' : 'Finalizar',
                  style: TextStyleHelper.instance.body18RegularOpenSans.copyWith(
                    fontWeight: FontWeight.w600,
                    fontSize: 16.h,
                    color: appTheme.white_A700,
                  ),
                ),
              ),
            ),
          );
        }
        
        // Se não revelou, mostra botão de revelar (mas não é necessário se já selecionou)
        return SizedBox.shrink();
      }),
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