# TODO

## TestFlight Submission

### Required
- [ ] App icon (1024x1024 PNG to `assets/icon/app_icon.png`, run `dart run flutter_launcher_icons`)
- [ ] App Store screenshots (iPhone 6.7", 6.5", 5.5")
- [ ] App description and metadata in App Store Connect
- [ ] Privacy policy URL
- [ ] Set version/build number in pubspec.yaml
- [ ] Archive and upload: `flutter build ipa --release`

### Recommended Before Release
- [ ] Error handling UX for failed API calls
- [ ] Share generated images
- [ ] Delete projects from history (swipe or menu)

## Future Enhancements

### Firebase Integration
- [ ] Firebase initialization
- [ ] AuthService + AuthBloc
- [ ] Cloud backup (Storage + Firestore)

### Code Quality
- [ ] DesignStudioBloc (replace local state)
- [ ] Widget/integration tests
- [ ] Offline queue with Hive
