# Configuração do Logo do App Kioku

Este guia explica como aplicar o logo `img_vector.svg` como ícone do aplicativo.

## Passo 1: Converter SVG para PNG

O Flutter requer arquivos PNG para os ícones do app. Você precisa converter o SVG para PNG.

### Opção A: Usando ferramenta online (Recomendado)

1. Acesse: https://cloudconvert.com/svg-to-png
2. Faça upload do arquivo: `assets/images/img_vector.svg`
3. Configure as opções:
   - **Width**: 1024
   - **Height**: 1024
   - **Background**: Transparente (se disponível)
4. Clique em "Convert"
5. Baixe o arquivo PNG
6. Salve como: `assets/images/app_icon.png`
7. Copie o mesmo arquivo para: `assets/images/app_icon_foreground.png`

### Opção B: Usando Inkscape (linha de comando)

```bash
# Instalar Inkscape
# macOS: brew install inkscape
# Linux: sudo apt-get install inkscape

# Converter para PNG 1024x1024
inkscape assets/images/img_vector.svg \
  --export-filename=assets/images/app_icon.png \
  --export-width=1024 \
  --export-height=1024 \
  --export-background-opacity=0

# Copiar para foreground
cp assets/images/app_icon.png assets/images/app_icon_foreground.png
```

### Opção C: Usando ImageMagick

```bash
# Instalar ImageMagick
# macOS: brew install imagemagick
# Linux: sudo apt-get install imagemagick

# Converter SVG para PNG
convert -background none -resize 1024x1024 \
  assets/images/img_vector.svg \
  assets/images/app_icon.png

# Copiar para foreground
cp assets/images/app_icon.png assets/images/app_icon_foreground.png
```

## Passo 2: Gerar os Ícones do App

Após criar os arquivos PNG, execute:

```bash
# Instalar dependências
flutter pub get

# Gerar ícones para Android e iOS
flutter pub run flutter_launcher_icons
```

Isso irá:
- ✅ Gerar ícones em todos os tamanhos necessários para Android
- ✅ Gerar ícones para iOS
- ✅ Configurar o adaptive icon do Android
- ✅ Gerar ícones para web

## Passo 3: Verificar

### Android
Os ícones serão gerados em:
- `android/app/src/main/res/mipmap-*/ic_launcher.png`

### iOS
Os ícones serão gerados em:
- `ios/Runner/Assets.xcassets/AppIcon.appiconset/`

### Web
Os ícones serão atualizados em:
- `web/icons/`

## Notas Importantes

- O arquivo `app_icon.png` deve ter pelo menos 1024x1024 pixels
- O arquivo `app_icon_foreground.png` deve ter fundo transparente
- A cor de fundo do adaptive icon está configurada como `#00B4CC` (cyan_A700)
- Após gerar os ícones, você pode precisar fazer um rebuild completo do app

## Troubleshooting

Se os ícones não aparecerem:

1. **Limpe o build:**
   ```bash
   flutter clean
   flutter pub get
   ```

2. **Rebuild completo:**
   ```bash
   flutter build apk --debug  # Para Android
   flutter build ios --debug  # Para iOS
   ```

3. **Verifique se os arquivos PNG existem:**
   ```bash
   ls -la assets/images/app_icon*.png
   ```

## Estrutura de Arquivos Esperada

```
assets/images/
├── img_vector.svg              # SVG original
├── app_icon.png                # PNG 1024x1024 (você precisa criar)
└── app_icon_foreground.png     # PNG 1024x1024 transparente (você precisa criar)
```

