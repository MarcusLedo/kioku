import 'package:flutter/material.dart';

import '../../core/app_export.dart';
import './controller/deck_listing_controller.dart';
import './widgets/deck_grid_card_widget.dart';

class DeckListingScreen extends GetWidget<DeckListingController> {
  const DeckListingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appTheme.cyan_A700,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(context),
            SizedBox(height: 20.h),
            _buildSearchBar(),
            SizedBox(height: 24.h),
            Expanded(
              child: _buildDeckGrid(),
            ),
            _buildBottomNavigationBar(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    // Verifica se pode voltar (se há uma rota anterior na pilha)
    final canPop = Navigator.canPop(context);
    
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.h, vertical: 16.h),
      child: Row(
        children: [
          // Só mostra o botão de voltar se houver uma rota anterior
          if (canPop) ...[
            GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Icon(
                Icons.arrow_back,
                color: appTheme.white_A700,
                size: 28.h,
              ),
            ),
            SizedBox(width: 12.h),
          ],
          Text(
            'Decks',
            style: TextStyleHelper.instance.body18RegularOpenSans.copyWith(
              fontWeight: FontWeight.w700,
              fontSize: 24.h,
            ),
          ),
          Spacer(),
          GestureDetector(
            onTap: controller.importDeck,
            child: Container(
              padding: EdgeInsets.all(8.h),
              decoration: BoxDecoration(
                color: appTheme.white_A700.withOpacity(0.2),
                borderRadius: BorderRadius.circular(8.h),
              ),
              child: Icon(
                Icons.upload_file,
                color: appTheme.white_A700,
                size: 24.h,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20.h),
      padding: EdgeInsets.symmetric(horizontal: 16.h, vertical: 12.h),
      decoration: BoxDecoration(
        border: Border.all(color: appTheme.white_A700, width: 2),
        borderRadius: BorderRadius.circular(12.h),
      ),
      child: Row(
        children: [
          Icon(
            Icons.search,
            color: appTheme.white_A700,
            size: 24.h,
          ),
          SizedBox(width: 12.h),
          Expanded(
            child: TextField(
              controller: controller.searchController,
              style: TextStyleHelper.instance.body15RegularOpenSans.copyWith(
                color: appTheme.white_A700,
              ),
              decoration: InputDecoration(
                hintText: 'Pesquisar por deck...',
                hintStyle:
                    TextStyleHelper.instance.body15RegularOpenSans.copyWith(
                  color: appTheme.white_A700.withAlpha(179),
                ),
                border: InputBorder.none,
                isDense: true,
                contentPadding: EdgeInsets.zero,
              ),
            ),
          ),
          SizedBox(width: 12.h),
          GestureDetector(
            onTap: () => controller.showCreateDeckDialog(),
            child: Container(
              width: 36.h,
              height: 36.h,
              decoration: BoxDecoration(
                color: appTheme.white_A700,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.add,
                color: appTheme.cyan_A700,
                size: 24.h,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDeckGrid() {
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
        child: Obx(() {
          // Usa os decks filtrados em vez dos decks originais
          final decksToShow = controller.filteredDecks;
          
          if (decksToShow.isEmpty && controller.searchController.text.isNotEmpty) {
            // Mostra mensagem quando não há resultados na busca
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.search_off,
                    size: 64.h,
                    color: appTheme.greyCustom,
                  ),
                  SizedBox(height: 16.h),
                  Text(
                    'Nenhum deck encontrado',
                    style: TextStyleHelper.instance.body15RegularOpenSans.copyWith(
                      color: appTheme.greyCustom,
                      fontSize: 16.h,
                    ),
                  ),
                ],
              ),
            );
          }
          
          return GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 16.h,
              mainAxisSpacing: 16.h,
              childAspectRatio: 0.75,
            ),
            itemCount: decksToShow.length,
            itemBuilder: (context, index) {
              final deck = decksToShow[index];
              
              // Converte icon_name para IconData
              IconData iconData = Icons.book; // padrão
              final iconName = deck['icon_name'] as String? ?? 'book';
              iconData = _getIconFromName(iconName);
              
              return DeckGridCardWidget(
                deckId: deck['id'] as String? ?? '',
                title: deck['title'] as String? ?? 'Deck sem título',
                totalCards: (deck['total_cards'] as int?) ?? 0,
                studiedCards: (deck['last_study_correct_answers'] as int?) ?? 0,
                icon: iconData,
                isImported: (deck['is_imported'] as bool?) ?? false,
              );
            },
          );
        }),
      ),
    );
  }

  IconData _getIconFromName(String iconName) {
    switch (iconName) {
      case 'psychology':
        return Icons.psychology;
      case 'school':
        return Icons.school;
      case 'book':
        return Icons.book;
      case 'lightbulb':
        return Icons.lightbulb;
      case 'science':
        return Icons.science;
      case 'calculate':
        return Icons.calculate;
      case 'language':
        return Icons.language;
      case 'history':
        return Icons.history;
      case 'public':
        return Icons.public;
      case 'code':
        return Icons.code;
      case 'medical_services':
        return Icons.medical_services;
      case 'business':
        return Icons.business;
      default:
        return Icons.book;
    }
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