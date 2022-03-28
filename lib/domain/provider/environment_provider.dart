enum EnviromentFlavor {
  dev,
  stg,
  prod,
}

abstract class EnviromentProvider {
  EnviromentFlavor getCurrentFlavor();
  Future<void> preLoadPlatformInfo();
}
