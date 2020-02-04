import 'package:firebase_remote_config/firebase_remote_config.dart';
import '../global.dart';

Future<dynamic> getApplicationConfiguration(String key) async {
  final RemoteConfig remoteConfig = await RemoteConfig.instance;

  try {
    await remoteConfig.setDefaults(remoteCofigDefaults);
    await remoteConfig.fetch(expiration: const Duration(seconds: 5));
    await remoteConfig.activateFetched();
    dynamic value =
        remoteConfig.getString(key).trim();
    return value;
  } on FetchThrottledException {
    //Get default value
    return remoteCofigDefaults[key];
  } catch (exception) {
    return remoteCofigDefaults[key];
  }
}
