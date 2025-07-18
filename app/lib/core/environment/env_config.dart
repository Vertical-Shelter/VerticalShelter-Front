import 'base_env_config.dart';
import 'restapidoc_env_config.dart';

enum Environment { restAPIDOC }

class EnvConfig {
  late BaseEnvConfig config;

  initConfig({Environment? environment}) {
    config = _getConfig(environment ?? null);
  }

  _getConfig([Environment? environment]) {
    switch (environment) {
      case Environment.restAPIDOC:
        return RestAPIDOCEnvConfig();
      default:
        return RestAPIDOCEnvConfig();
    }
  }
}
