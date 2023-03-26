abstract class RemoteServer {
  String url = '';
  int timeOut = 30000;
  int cacheForSeconds = 150;
  String? scheme;
}

class TestServer implements RemoteServer {
  @override
  int cacheForSeconds = 86400;

  @override
  String? scheme = 'http';

  @override
  int timeOut = 30000;

  @override
  String url = '192.168.1.78:8000/api/';
}

class LocalServer implements RemoteServer {
  @override
  int cacheForSeconds = 86400;

  @override
  String? scheme = 'http';

  @override
  int timeOut = 30000;

  @override
  String url = '192.168.1.72:8000/api/';
}

class LiveServer implements RemoteServer {
  @override
  int cacheForSeconds = 86400;

  @override
  String? scheme = 'https';

  @override
  int timeOut = 30000;

  @override
  String url = 'liveserver.com';
}
