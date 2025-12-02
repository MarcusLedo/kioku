# 🎨 Logo do App Kioku - Guia Rápido

## ✅ O que já foi configurado

- ✅ Pacote `flutter_launcher_icons` adicionado
- ✅ Configuração no `pubspec.yaml` pronta
- ✅ Logo SVG já está sendo usado nas telas do app

## 📋 Próximos Passos

### 1. Converter SVG para PNG

Você precisa criar dois arquivos PNG a partir do `img_vector.svg`:

**Opção Rápida (Online):**
1. Acesse: https://cloudconvert.com/svg-to-png
2. Faça upload de: `assets/images/img_vector.svg`
3. Configure: 1024x1024 pixels, fundo transparente
4. Baixe e salve como: `assets/images/app_icon.png`
5. Copie o mesmo arquivo para: `assets/images/app_icon_foreground.png`

### 2. Gerar os Ícones

Depois de criar os arquivos PNG, execute:

```bash
flutter pub run flutter_launcher_icons
```

Isso irá gerar automaticamente:
- ✅ Ícones para Android (todos os tamanhos)
- ✅ Ícones para iOS
- ✅ Adaptive icon do Android
- ✅ Ícones para web

## 📱 Onde o Logo Aparece

O logo `img_vector.svg` já está sendo usado em:
- ✅ Tela de autenticação (`authentication_screen.dart`)
- ✅ Tela de cadastro (`signup_screen.dart`)
- ✅ Header da homepage (`homepage_screen.dart`)

## 📚 Documentação Completa

Para instruções detalhadas, consulte: `LOGO_SETUP.md`

