// Script para gerar ícones do app a partir do SVG
// Execute: dart scripts/generate_icon.dart

import 'dart:io';
import 'package:path/path.dart' as path;

void main() {
  print('⚠️  Este script requer que você converta manualmente o SVG para PNG.');
  print('');
  print('Instruções:');
  print('1. Abra o arquivo: assets/images/img_vector.svg');
  print('2. Use uma ferramenta online (https://cloudconvert.com/svg-to-png)');
  print('3. Configure: 1024x1024 pixels, fundo transparente');
  print('4. Salve como: assets/images/app_icon.png');
  print('5. Copie o mesmo arquivo para: assets/images/app_icon_foreground.png');
  print('');
  print('Depois execute:');
  print('  flutter pub get');
  print('  flutter pub run flutter_launcher_icons');
  print('');
  
  // Verificar se os arquivos já existem
  final iconPath = path.join('assets', 'images', 'app_icon.png');
  final foregroundPath = path.join('assets', 'images', 'app_icon_foreground.png');
  
  if (File(iconPath).existsSync() && File(foregroundPath).existsSync()) {
    print('✅ Arquivos PNG encontrados!');
    print('Execute: flutter pub run flutter_launcher_icons');
  } else {
    print('❌ Arquivos PNG não encontrados.');
    print('Por favor, crie os arquivos conforme as instruções acima.');
  }
}

