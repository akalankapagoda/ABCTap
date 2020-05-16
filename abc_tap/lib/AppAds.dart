
import 'package:flutter/material.dart';
import 'dart:io' show Platform;
import 'package:ads/ads.dart';
import 'package:firebase_admob/firebase_admob.dart';

class AppAds {
  static Ads _ads;

  static final String _appId = Platform.isAndroid
      ? 'ca-app-pub-5371284972684009~2684475411'
      : 'ca-app-pub-5371284972684009~2684475411';

  static final String _bannerUnitId = Platform.isAndroid
      ? 'ca-app-pub-5371284972684009/2278362879'
      : 'ca-app-pub-7138758578654885/5541088522';

  /// Assign a listener.
  static MobileAdListener _eventListener = (MobileAdEvent event) {
    if (event == MobileAdEvent.clicked) {
      print("_eventListener: The opened ad is clicked on.");
    }
  };

  static void showBanner(
      {String adUnitId,
        AdSize size,
        List<String> keywords,
        String contentUrl,
        bool childDirected,
        List<String> testDevices,
        bool testing,
        MobileAdListener listener,
        State state,
        double anchorOffset,
        AnchorType anchorType}) =>
      _ads?.showBannerAd(
          adUnitId: adUnitId,
          size: size,
          keywords: keywords,
          contentUrl: contentUrl,
          childDirected: childDirected,
          testDevices: testDevices,
          testing: testing,
          listener: listener,
          state: state,
          anchorOffset: anchorOffset,
          anchorType: anchorType);

  static void hideBanner() => _ads?.closeBannerAd();

  /// Call this static function in your State object's initState() function.
  static void init() => _ads ??= Ads(
//    "",
    _appId,
    bannerUnitId: _bannerUnitId,
    keywords: <String>['baby', 'ABC', 'tap', 'alphabet', 'learn'],
    childDirected: true,
//    testing: true,
    anchorType: AnchorType.top,
    listener: _eventListener,
  );

  /// Remember to call this in the State object's dispose() function.
  static void dispose() => _ads?.dispose();
}