# App Icon Assets

Place the following icon files in this directory:

1. **app_icon.png** (1024x1024px)
   - Main app icon used for both iOS and Android
   - Should have transparent or solid background
   - Simple, recognizable design that works at small sizes

2. **app_icon_foreground.png** (1024x1024px, optional)
   - Android adaptive icon foreground layer
   - Should have transparent background
   - Icon content should be centered in the safe zone (inner 66%)

## Generating Icons

After adding your icon images, run:

```bash
flutter pub get
dart run flutter_launcher_icons
```

This will generate all required icon sizes for iOS and Android.

## Icon Design Suggestions

Consider:
- Minimalist geometric design
- Cyan accent (#38bdf8) on dark background (#13161c)
- Abstract representation of interior design
- Could incorporate: room outline, furniture silhouette, or design sparkle
