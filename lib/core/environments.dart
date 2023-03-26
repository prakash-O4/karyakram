class EnvironmentConfig {
  EnvironmentConfig._();
  static const String server =
      String.fromEnvironment("SERVER", defaultValue: "prod");
}
