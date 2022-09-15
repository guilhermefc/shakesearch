import 'package:shake_search/data/datasources/datasource.dart';

class LocalDatasource extends Datasource {
  @override
  Future<String> getSearch(String query, int page) {
    return Future.value(
      '[" DUKE OF CLARENCE, his son\r\n  RICHARD, afterwards DUKE OF GLOUCESTER, his son\r\n  DUKE OF NORFOLK                    MARQUIS OF MONTAGUE\r\n  EARL OF WARWICK                    EARL OF PEMBROKE\r\n  LORD HASTINGS                      LORD STAFFORD\r\n  SIR JOHN MORTIMER, uncle to the Duke of York\r\n  SIR HUGH MORTIMER, uncle to the Duke of York\r\n  HENRY, EARL OF RICHMOND, a youth\r\n  LORD RIVERS, brother to Lady Grey\r\n  SIR WILLIAM STANLEY                SIR JOHN MONTGOMERY\r\n  SIR JOHN SOMERVILLE        "]',
    );
  }
}
