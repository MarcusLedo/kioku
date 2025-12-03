import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:get/get.dart';
import 'package:file_picker/file_picker.dart';
import '../models/deck_listing_model.dart';
import '../../../services/supabase_deck_service.dart';
import '../../../services/supabase_auth_service.dart';
import '../../../services/supabase_flashcard_service.dart';
import '../../../core/app_export.dart';

class DeckListingController extends GetxController {
  Rx<DeckListingModel> deckListingModelObj = DeckListingModel().obs;

  final SupabaseDeckService _deckService = SupabaseDeckService();
  final SupabaseAuthService _authService = SupabaseAuthService();
  final SupabaseFlashcardService _flashcardService = SupabaseFlashcardService();

  var selectedIndex = 1.obs;
  var isLoading = true.obs;
  var errorMessage = ''.obs;
  var decks = <Map<String, dynamic>>[].obs;
  var filteredDecks = <Map<String, dynamic>>[].obs;
  
  final searchController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    _loadDecks();
    
    // Listener para filtrar os decks quando o texto de busca mudar
    searchController.addListener(_filterDecks);
  }

  @override
  void onReady() {
    super.onReady();
    // Recarrega os decks quando a tela volta ao foco
    _loadDecks();
  }

  Future<void> _loadDecks() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      // Verify authentication
      final user = _authService.currentUser;
      if (user == null) {
        // Usa postFrameCallback para evitar navegação durante build
        SchedulerBinding.instance.addPostFrameCallback((_) {
          Get.offAllNamed('/authentication-screen');
        });
        return;
      }

      // Load user decks
      decks.value = await _deckService.getUserDecks();
      
      // Aplica o filtro após carregar os decks
      _filterDecks();
    } catch (e) {
      errorMessage.value = 'Erro ao carregar decks: ${e.toString()}';
    } finally {
      isLoading.value = false;
    }
  }
  
  void _filterDecks() {
    final query = searchController.text.toLowerCase().trim();
    
    if (query.isEmpty) {
      // Se não há busca, mostra todos os decks
      filteredDecks.value = decks;
    } else {
      // Filtra os decks pelo título
      filteredDecks.value = decks.where((deck) {
        final title = (deck['title'] as String? ?? '').toLowerCase();
        return title.contains(query);
      }).toList();
    }
  }

  Future<void> refreshDecks() async {
    await _loadDecks();
  }

  Future<void> createNewDeck(String title, String iconName) async {
    try {
      isLoading.value = true;

      final user = _authService.currentUser;
      if (user == null) {
        // Usa postFrameCallback para evitar navegação durante build
        SchedulerBinding.instance.addPostFrameCallback((_) {
          Get.offAllNamed('/authentication-screen');
        });
        return;
      }

      // Verifica se já existe um deck com o mesmo nome (case-insensitive)
      final normalizedTitle = title.trim();
      final exists = await _deckService.deckExistsWithTitle(normalizedTitle);
      if (exists) {
        Get.snackbar(
          'Erro',
          'Já existe um deck com o nome "$normalizedTitle"',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red[100],
          colorText: Colors.red[900],
          duration: Duration(seconds: 3),
        );
        isLoading.value = false;
        return;
      }

      await _deckService.createDeck(
        title: title,
        iconName: iconName,
      );

      await _loadDecks();

      Get.snackbar(
        'Sucesso',
        'Deck criado com sucesso!',
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      final errorMessage = e.toString();
      // Verifica se a mensagem de erro já contém informação sobre deck existente
      if (errorMessage.contains('Já existe um deck')) {
        Get.snackbar(
          'Erro',
          errorMessage.replaceAll('Exception: ', ''),
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red[100],
          colorText: Colors.red[900],
        );
      } else {
        Get.snackbar(
          'Erro',
          'Não foi possível criar o deck: ${e.toString()}',
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> deleteDeck(String deckId) async {
    try {
      isLoading.value = true;

      await _deckService.deleteDeck(deckId);
      await _loadDecks();

      Get.snackbar(
        'Sucesso',
        'Deck excluído com sucesso!',
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      Get.snackbar(
        'Erro',
        'Não foi possível excluir o deck: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  void onDeckTap(String deckId, String title) {
    Get.toNamed(
      '/deck-details-screen',
      arguments: {
        'deckId': deckId,
        'title': title,
      },
    );
  }

  void onBottomNavTap(int index) {
    // Evita navegação se já estiver no índice selecionado
    if (selectedIndex.value == index && index == 1) {
      return;
    }
    
    selectedIndex.value = index;
    
    // Usa postFrameCallback para garantir que a navegação aconteça após o frame
    SchedulerBinding.instance.addPostFrameCallback((_) {
      if (index == 0) {
        Get.offNamed('/homepage-screen');
      } else if (index == 2) {
        Get.offNamed('/account-screen');
      }
    });
  }

  void showCreateDeckDialog() {
    final titleController = TextEditingController();
    final filePathController = TextEditingController();
    int selectedIconIndex = 0;
    String selectedIconName = 'psychology';
    String? selectedFilePath;
    Map<String, dynamic>? importedDeckData;

    // Lista de ícones disponíveis
    final List<Map<String, dynamic>> availableIcons = [
      {'icon': Icons.psychology, 'name': 'psychology'},
      {'icon': Icons.school, 'name': 'school'},
      {'icon': Icons.book, 'name': 'book'},
      {'icon': Icons.lightbulb, 'name': 'lightbulb'},
      {'icon': Icons.science, 'name': 'science'},
      {'icon': Icons.calculate, 'name': 'calculate'},
      {'icon': Icons.language, 'name': 'language'},
      {'icon': Icons.history, 'name': 'history'},
      {'icon': Icons.public, 'name': 'public'},
      {'icon': Icons.code, 'name': 'code'},
      {'icon': Icons.medical_services, 'name': 'medical_services'},
      {'icon': Icons.business, 'name': 'business'},
    ];

    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24.h),
        ),
        child: StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return Container(
              padding: EdgeInsets.all(24.h),
              width: 400.h,
              constraints: BoxConstraints(
                maxHeight: MediaQuery.of(context).size.height * 0.85,
              ),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Novo Deck',
                          style: TextStyleHelper.instance.title20BoldOpenSans,
                        ),
                        IconButton(
                          icon: Icon(Icons.close),
                          onPressed: () => Get.back(),
                          color: appTheme.greyCustom,
                        ),
                      ],
                    ),
                    SizedBox(height: 20.h),
                    // Campo de importar arquivo
                    Text(
                      'Importar arquivo',
                      style: TextStyleHelper.instance.body15RegularOpenSans.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 8.h),
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: filePathController,
                            readOnly: true,
                            decoration: InputDecoration(
                              hintText: 'Extensão .pdf, .csv ou .txt',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12.h),
                                borderSide: BorderSide(color: appTheme.cyan_A700),
                              ),
                              contentPadding: EdgeInsets.symmetric(
                                horizontal: 16.h,
                                vertical: 12.h,
                              ),
                              suffixIcon: selectedFilePath != null
                                  ? IconButton(
                                      icon: Icon(Icons.close, size: 20.h),
                                      onPressed: () {
                                        setState(() {
                                          selectedFilePath = null;
                                          filePathController.clear();
                                          importedDeckData = null;
                                          titleController.clear();
                                          selectedIconIndex = 0;
                                          selectedIconName = 'psychology';
                                        });
                                      },
                                    )
                                  : null,
                            ),
                          ),
                        ),
                        SizedBox(width: 8.h),
                        ElevatedButton.icon(
                          onPressed: () async {
                            FilePickerResult? result = await FilePicker.platform.pickFiles(
                              type: FileType.custom,
                              allowedExtensions: ['csv'],
                            );

                            if (result != null && result.files.single.path != null) {
                              try {
                                final filePath = result.files.single.path!;
                                final file = await File(filePath).readAsString();
                                
                                // Parseia o CSV
                                final deckData = _parseDeckCSV(file);
                                
                                if (deckData != null) {
                                  setState(() {
                                    selectedFilePath = filePath;
                                    filePathController.text = result.files.single.name;
                                    importedDeckData = deckData;
                                    titleController.text = deckData['title'] as String;
                                    
                                    // Encontra o índice do ícone
                                    final iconName = deckData['icon_name'] as String;
                                    for (int i = 0; i < availableIcons.length; i++) {
                                      if (availableIcons[i]['name'] == iconName) {
                                        selectedIconIndex = i;
                                        selectedIconName = iconName;
                                        break;
                                      }
                                    }
                                  });
                                  
                                  Get.snackbar(
                                    'Sucesso',
                                    'Arquivo importado! Título e ícone preenchidos automaticamente.',
                                    snackPosition: SnackPosition.BOTTOM,
                                    backgroundColor: Colors.green[100],
                                    colorText: Colors.green[900],
                                    duration: Duration(seconds: 2),
                                  );
                                } else {
                                  Get.snackbar(
                                    'Erro',
                                    'Formato de arquivo inválido',
                                    snackPosition: SnackPosition.BOTTOM,
                                    backgroundColor: Colors.red[100],
                                    colorText: Colors.red[900],
                                  );
                                }
                              } catch (e) {
                                Get.snackbar(
                                  'Erro',
                                  'Não foi possível ler o arquivo: ${e.toString()}',
                                  snackPosition: SnackPosition.BOTTOM,
                                  backgroundColor: Colors.red[100],
                                  colorText: Colors.red[900],
                                );
                              }
                            }
                          },
                          icon: Icon(Icons.upload_file, size: 18.h),
                          label: Text('Selecionar'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: appTheme.cyan_A700,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12.h),
                            ),
                            padding: EdgeInsets.symmetric(
                              horizontal: 16.h,
                              vertical: 12.h,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 20.h),
                    Text(
                      'Nome',
                      style: TextStyleHelper.instance.body15RegularOpenSans.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 8.h),
                    TextField(
                      controller: titleController,
                      decoration: InputDecoration(
                        hintText: 'Digite o título do deck',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.h),
                          borderSide: BorderSide(color: appTheme.cyan_A700),
                        ),
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 16.h,
                          vertical: 12.h,
                        ),
                      ),
                    ),
                    SizedBox(height: 20.h),
                    Text(
                      'Ícone',
                      style: TextStyleHelper.instance.body15RegularOpenSans.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 12.h),
                    Container(
                      height: 120.h,
                      child: GridView.builder(
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 4,
                          crossAxisSpacing: 8.h,
                          mainAxisSpacing: 8.h,
                        ),
                        itemCount: availableIcons.length,
                        itemBuilder: (context, index) {
                          final iconData = availableIcons[index]['icon'] as IconData;
                          final iconName = availableIcons[index]['name'] as String;
                          final isSelected = selectedIconIndex == index;

                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                selectedIconIndex = index;
                                selectedIconName = iconName;
                              });
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? appTheme.cyan_A700
                                    : appTheme.gray_50,
                                borderRadius: BorderRadius.circular(12.h),
                                border: Border.all(
                                  color: isSelected
                                      ? appTheme.cyan_A700
                                      : appTheme.greyCustom,
                                  width: isSelected ? 2 : 1,
                                ),
                              ),
                              child: Icon(
                                iconData,
                                color: isSelected
                                    ? appTheme.white_A700
                                    : appTheme.cyan_A700,
                                size: 28.h,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    SizedBox(height: 24.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                          onPressed: () => Get.back(),
                          child: Text(
                            'Cancelar',
                            style: TextStyleHelper.instance.body15RegularOpenSans
                                .copyWith(color: appTheme.greyCustom),
                          ),
                        ),
                        SizedBox(width: 12.h),
                        ElevatedButton(
                          onPressed: () async {
                            if (titleController.text.trim().isEmpty) {
                              Get.snackbar(
                                'Erro',
                                'Por favor, insira um título para o deck',
                                snackPosition: SnackPosition.BOTTOM,
                              );
                              return;
                            }
                            
                            Get.back();
                            
                            // Se há dados importados, cria o deck com os cards
                            if (importedDeckData != null) {
                              await _createDeckFromImport(
                                titleController.text.trim(),
                                selectedIconName,
                                importedDeckData!,
                              );
                            } else {
                              // Cria deck normalmente sem cards
                              await createNewDeck(
                                titleController.text.trim(),
                                selectedIconName,
                              );
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: appTheme.cyan_A700,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12.h),
                            ),
                            padding: EdgeInsets.symmetric(
                              horizontal: 24.h,
                              vertical: 12.h,
                            ),
                          ),
                          child: Text(
                            'Salvar',
                            style: TextStyleHelper.instance.body15RegularOpenSans
                                .copyWith(color: appTheme.white_A700),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Future<void> _createDeckFromImport(
    String title,
    String iconName,
    Map<String, dynamic> deckData,
  ) async {
    try {
      isLoading.value = true;

      final user = _authService.currentUser;
      if (user == null) {
        SchedulerBinding.instance.addPostFrameCallback((_) {
          Get.offAllNamed('/authentication-screen');
        });
        return;
      }

      // Verifica se já existe um deck com o mesmo nome
      final exists = await _deckService.deckExistsWithTitle(title);
      if (exists) {
        Get.snackbar(
          'Erro',
          'Já existe um deck com o nome "$title"',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red[100],
          colorText: Colors.red[900],
        );
        return;
      }

      // Cria o deck marcando como importado
      final deck = await _deckService.createDeck(
        title: title,
        iconName: iconName,
        isImported: true,
      );

      final deckId = deck['id'] as String;

      // Cria os flashcards do CSV importado
      for (var cardData in deckData['cards']) {
        final frontText = cardData['front_text'] as String;
        final alternatives = cardData['alternatives'] as List<String>;
        final correctIndex = cardData['correct_index'] as int;

        // Cria o JSON com alternativas
        final backTextJson = jsonEncode({
          'alternatives': alternatives,
          'correct_index': correctIndex,
        });

        await _flashcardService.createFlashcard(
          deckId: deckId,
          frontText: frontText,
          backText: backTextJson,
        );
      }

      // Recarrega a lista de decks
      await _loadDecks();

      Get.snackbar(
        'Sucesso',
        'Deck criado com ${deckData['cards'].length} cards importados!',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green[100],
        colorText: Colors.green[900],
      );
    } catch (e) {
      Get.snackbar(
        'Erro',
        'Não foi possível criar o deck: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red[100],
        colorText: Colors.red[900],
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> importDeck() async {
    try {
      // Permite selecionar um arquivo CSV
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['csv'],
      );

      if (result == null || result.files.single.path == null) {
        return; // Usuário cancelou
      }

      isLoading.value = true;

      // Lê o arquivo
      final filePath = result.files.single.path!;
      final file = await File(filePath).readAsString();

      // Parseia o CSV
      final deckData = _parseDeckCSV(file);

      if (deckData == null) {
        Get.snackbar(
          'Erro',
          'Formato de arquivo inválido',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red[100],
          colorText: Colors.red[900],
        );
        return;
      }

      // Verifica se já existe um deck com o mesmo nome
      final exists = await _deckService.deckExistsWithTitle(deckData['title']);
      if (exists) {
        Get.snackbar(
          'Erro',
          'Já existe um deck com o nome "${deckData['title']}"',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red[100],
          colorText: Colors.red[900],
        );
        return;
      }

      // Cria o deck marcando como importado
      final deck = await _deckService.createDeck(
        title: deckData['title'],
        iconName: deckData['icon_name'],
        isImported: true,
      );

      final deckId = deck['id'] as String;

      // Cria os flashcards
      for (var cardData in deckData['cards']) {
        final frontText = cardData['front_text'] as String;
        final alternatives = cardData['alternatives'] as List<String>;
        final correctIndex = cardData['correct_index'] as int;

        // Cria o JSON com alternativas
        final backTextJson = jsonEncode({
          'alternatives': alternatives,
          'correct_index': correctIndex,
        });

        await _flashcardService.createFlashcard(
          deckId: deckId,
          frontText: frontText,
          backText: backTextJson,
        );
      }

      // Recarrega a lista de decks
      await _loadDecks();

      Get.snackbar(
        'Sucesso',
        'Deck importado com sucesso!',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green[100],
        colorText: Colors.green[900],
      );
    } catch (e) {
      Get.snackbar(
        'Erro',
        'Não foi possível importar o deck: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red[100],
        colorText: Colors.red[900],
      );
    } finally {
      isLoading.value = false;
    }
  }

  Map<String, dynamic>? _parseDeckCSV(String csvContent) {
    try {
      final lines = csvContent.split('\n').where((line) => line.trim().isNotEmpty).toList();
      
      if (lines.isEmpty) return null;

      String? deckTitle;
      String? iconName;
      List<Map<String, dynamic>> cards = [];
      bool inCardsSection = false;

      for (var line in lines) {
        line = line.trim();
        
        if (line == 'DECK_INFO') {
          continue;
        }
        
        if (line == 'CARDS') {
          inCardsSection = true;
          continue;
        }

        if (line.startsWith('title,icon_name')) {
          continue; // Pula o cabeçalho
        }

        if (!inCardsSection && line.contains(',')) {
          // Linha de informações do deck
          final parts = _parseCSVLine(line);
          if (parts.length >= 2) {
            deckTitle = parts[0];
            iconName = parts[1];
          }
        } else if (inCardsSection) {
          if (line.startsWith('front_text,alternatives,correct_index')) {
            continue; // Pula o cabeçalho
          }
          
          // Linha de card
          final parts = _parseCSVLine(line);
          if (parts.length >= 3) {
            final frontText = parts[0];
            final alternativesStr = parts[1];
            final correctIndex = int.tryParse(parts[2]) ?? 0;
            
            // Separa as alternativas (separadas por |)
            final alternatives = alternativesStr.split('|').where((alt) => alt.isNotEmpty).toList();
            
            if (alternatives.isEmpty) {
              // Se não houver alternativas, usa o texto como única alternativa
              alternatives.add(alternativesStr);
            }
            
            cards.add({
              'front_text': frontText,
              'alternatives': alternatives,
              'correct_index': correctIndex,
            });
          }
        }
      }

      if (deckTitle == null || iconName == null) {
        return null;
      }

      return {
        'title': deckTitle,
        'icon_name': iconName,
        'cards': cards,
      };
    } catch (e) {
      print('Erro ao parsear CSV: $e');
      return null;
    }
  }

  List<String> _parseCSVLine(String line) {
    final result = <String>[];
    var current = StringBuffer();
    var inQuotes = false;

    for (var i = 0; i < line.length; i++) {
      final char = line[i];
      
      if (char == '"') {
        if (inQuotes && i + 1 < line.length && line[i + 1] == '"') {
          // Aspas duplas escapadas
          current.write('"');
          i++; // Pula a próxima aspas
        } else {
          // Toggle quotes
          inQuotes = !inQuotes;
        }
      } else if (char == ',' && !inQuotes) {
        // Fim do campo
        result.add(current.toString());
        current.clear();
      } else {
        current.write(char);
      }
    }
    
    // Adiciona o último campo
    result.add(current.toString());
    
    return result;
  }

  @override
  void onClose() {
    searchController.dispose();
    super.onClose();
  }
}