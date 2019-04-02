<h1 align="center">
  <br>
  <img src="https://raw.githubusercontent.com/moridaffy/wallpaper-ios/master/Extra/logo_wallpaperapp.png" alt="App Icon" width="300">
  <br>
  WallpaperApp
  <br>
</h1>

<h4 align="center">Simple wallpaper app for iOS created with pure code</h4>
<h5 align="center">No storyboards or XIB files</h5>

<h1 align="center">
<img src="https://raw.githubusercontent.com/moridaffy/wallpaper-ios/master/Extra/screen_1.png" alt="Featured wallpapers" width="250"> <img src="https://raw.githubusercontent.com/moridaffy/wallpaper-ios/master/Extra/screen_2.png" alt="Dynamic blur" width="250"> <img src="https://raw.githubusercontent.com/moridaffy/wallpaper-ios/master/Extra/screen_3.png" alt="Settings" width="250">
</h1>

<p align="center">
  <a href="#Features">Features</a> •
  <a href="#TODO">TODO</a> •
  <a href="#Frameworks-used">Frameworks used</a> •
  <a href="#How-to-install">How to install</a> •
  <a href="#Developer">Developer</a>
</p>

## Features
* Browse through images using <a href="https://pixabay.com/api/docs/">Pixabay public API</a>
* Save fullsized images to photo library
* Apply dynamic blur
* Preview as a wallpaper (overlay it with Springboard icons)
* Application-wide dark mode
* Full Russian and English localization
* Companion app for your Apple Watch

## TODO
- [X] watchOS app
- [X] Search through wallpapers
- [ ] Remove deprecated ```Variable```
- [ ] Add another image source (for example Unsplash)
- [ ] Marzipan support (run app on macOS)
- [ ] Upload to App Store (not 100% sure yet)

## Frameworks used
* <a href="https://github.com/ReactiveX/RxSwift">RxSwift</a> & <a href="https://github.com/RxSwiftCommunity/RxDataSources">RxDataSources</a> for data binding
* <a href="https://github.com/Alamofire/Alamofire">Alamofire</a> for networking
* <a href="https://github.com/onevcat/Kingfisher">Kingfisher</a> for asynchronous image loading and caching
* <a href="https://github.com/SnapKit/SnapKit">SnapKit</a> for creating constraints

## How to install
### iOS App
* Install pods using ```pod install```
* Open the project using ```.xcworkspace``` file
* Setup signing with your Apple ID
* Provide your own <a href="https://pixabay.com/api/docs/">Pixabay</a> API key in ```APIManager.swift``` file (line 19)
### macOS App
* Not sure yet :)

## Developer
This app was created by Maxim Skryabin as a simple portfolio project. Feel free to contact me using <a href="http://mskr.name/contact/">my website</a>.
