# Gerar Ícone do App a partir do SVG

Para aplicar o logo `img_vector.svg` como ícone do app, você precisa converter o SVG para PNG primeiro.

## Opção 1: Usando ferramentas online

1. Acesse https://cloudconvert.com/svg-to-png ou https://convertio.co/svg-png/
2. Faça upload do arquivo `assets/images/img_vector.svg`
3. Configure o tamanho para 1024x1024 pixels (ou maior)
4. Baixe o PNG gerado
5. Salve como `assets/images/app_icon.png`
6. Salve também uma versão com fundo transparente como `assets/images/app_icon_foreground.png`

## Opção 2: Usando Inkscape (linha de comando)

```bash
# Instalar Inkscape (se não tiver)
# macOS: brew install inkscape
# Linux: sudo apt-get install inkscape
# Windows: baixe de https://inkscape.org/

# Converter SVG para PNG 1024x1024
inkscape assets/images/img_vector.svg --export-filename=assets/images/app_icon.png --export-width=1024 --export-height=1024

# Criar versão com fundo transparente para adaptive icon
inkscape assets/images/img_vector.svg --export-filename=assets/images/app_icon_foreground.png --export-width=1024 --export-height=1024 --export-background-opacity=0
```

## Opção 3: Usando ImageMagick

```bash
# Instalar ImageMagick (se não tiver)
# macOS: brew install imagemagick
# Linux: sudo apt-get install imagemagick

# Converter SVG para PNG
convert -background none -resize 1024x1024 assets/images/img_vector.svg assets/images/app_icon.png
cp assets/images/app_icon.png assets/images/app_icon_foreground.png
```

## Após gerar os arquivos PNG

1. Execute `flutter pub get` para instalar o flutter_launcher_icons
2. Execute `flutter pub run flutter_launcher_icons` para gerar os ícones
3. Os ícones serão gerados automaticamente para Android e iOS

## Nota

O arquivo `app_icon.png` deve ter:
- Tamanho mínimo: 1024x1024 pixels
- Formato: PNG
- Fundo: Pode ter fundo ou transparente (recomendado transparente)

O arquivo `app_icon_foreground.png` deve ter:
- Tamanho: 1024x1024 pixels
- Formato: PNG
- Fundo: Transparente (obrigatório para adaptive icon do Android)

