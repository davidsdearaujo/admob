library admob;
import 'package:firebase_admob/firebase_admob.dart';

class Admob {
  String _appID;
  String _bannerID;
  String _interstitialID;
  bool isTest = true;

  static Admob _instance;
  factory Admob.instance() {
    if (_instance == null) _instance = Admob();
    return _instance;
  }
  Admob();

  Admob settings({
    String appID,
    String bannerID,
    String interstitialID,
    bool isTest = true,
  }) {
    _appID = appID ?? _appID;
    _bannerID = bannerID ?? _bannerID;
    _interstitialID = interstitialID ?? _interstitialID;
    this.isTest = isTest ?? this.isTest; 
    
    _bannerAd = _buildBanner()..load();
    _interstitialAd = _buildInterstitial()..load();

    return this;
  }

  MobileAdTargetingInfo get _targetingInfo => MobileAdTargetingInfo(
    testDevices: _appID != null ? [_appID] : null,
    keywords: ['Cultura'],
  );
  BannerAd _bannerAd;
  InterstitialAd _interstitialAd;

  void disposeAds() {
    _bannerAd?.dispose();
    _interstitialAd?.dispose();
  }

  BannerAd _buildBanner() {
    return BannerAd(
      adUnitId: isTest ? BannerAd.testAdUnitId : _bannerID,
      size: AdSize.banner,
      // listener: (MobileAdEvent event) {
      //   print(event);
      // },
    );
  }

  InterstitialAd _buildInterstitial() {
    return InterstitialAd(
      adUnitId: isTest ? InterstitialAd.testAdUnitId : _interstitialID,
      targetingInfo: _targetingInfo,
      listener: (MobileAdEvent event) {
        if (event == MobileAdEvent.failedToLoad) {
          _interstitialAd..load();
        } else if (event == MobileAdEvent.closed) {
          _interstitialAd = _buildInterstitial()..load();
        }
        // print(event);
      },
    );
  }

  Future<bool> showInterstitialAd() async {
    if (_interstitialAd == null) settings();

    _interstitialAd.load();
    return _interstitialAd.show();
  }

  Future<bool> showBannerAd() async {
    if (_bannerAd == null) settings();

    _bannerAd.load();
    return _bannerAd.show();
  }
}
