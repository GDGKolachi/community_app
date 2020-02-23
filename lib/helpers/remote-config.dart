import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/material.dart';
import '../global.dart';

class RemoteConfigHelper {
  final RemoteConfig remoteConfig;

  RemoteConfigHelper({@required this.remoteConfig});

  Future<dynamic> getApplicationConfiguration(String key) async {
    try {
      await remoteConfig.fetch(expiration: const Duration(seconds: 5));
      await remoteConfig.activateFetched();
      dynamic value = remoteConfig.getString(key).trim();
      return value;
    } on FetchThrottledException {
      return remoteConfigDefaults[key];
    } catch (exception) {
      return remoteConfigDefaults[key];
    }
  }
}

class RemoteConfigInitializer {
  Future<RemoteConfig> setupRemoteConfig() async {
    final RemoteConfig remoteConfig = await RemoteConfig.instance;
    // Enable developer mode to relax fetch throttling
    remoteConfig.setConfigSettings(RemoteConfigSettings(debugMode: true));
    remoteConfig.setDefaults(remoteConfigDefaults);
    return remoteConfig;
  }
}
