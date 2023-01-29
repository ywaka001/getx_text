import 'dart:io';

import 'package:intl/intl.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite/src/exception.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

class User {
  final int id;
  final String name;

  const User(this.id, this.name);
}

// TB_STDログイン
class LogIn {
  final String loginiD;
  final String password;
  final String name;
  final String updatedt;

  const LogIn(this.loginiD, this.password, this.name, this.updatedt);
}

// TB_STD英単語マスタ
class EnglishWord {
  final String clslarge;
  final String clsmiddle;
  final String clssmall;
  final num no;
  final String word;
  final String kind;
  final String pronunciation;
  final String mean;
  final String example;
  final String exmean;
  final DateTime updatedt;

  const EnglishWord(
      this.clslarge,
      this.clsmiddle,
      this.clssmall,
      this.no,
      this.word,
      this.kind,
      this.pronunciation,
      this.mean,
      this.example,
      this.exmean,
      this.updatedt);
}

// TB_STD英単語マスタLVIEW
class EnglishWordLVIEW {
  final String clslarge;

  const EnglishWordLVIEW(
    this.clslarge,
  );
}

// TB_STD英単語マスタMVIEW
class EnglishWordMVIEW {
  final String clslarge;
  final String clsmiddle;

  const EnglishWordMVIEW(
    this.clslarge,
    this.clsmiddle,
  );
}

// TB_STD英単語マスタSVIEW
class EnglishWordSVIEW {
  final String clslarge;
  final String clsmiddle;
  final String clssmall;

  const EnglishWordSVIEW(
    this.clslarge,
    this.clsmiddle,
    this.clssmall,
  );
}

// TB_STD生徒別学習記録
class LearningRecord {
  final String studentid;
  final String clslarge;
  final String clsmiddle;
  final String clssmall;
  final String word;
  final int stdcnt;
  final int clrcnt;
  final DateTime clrdt;
  final DateTime passdt;
  final DateTime laststddt;

  const LearningRecord(
      this.studentid,
      this.clslarge,
      this.clsmiddle,
      this.clssmall,
      this.word,
      this.stdcnt,
      this.clrcnt,
      this.clrdt,
      this.passdt,
      this.laststddt);
}

// (1) DDL操作の責務を持たせたクラス
class DatabaseFactory {
  void createTables(Database db) async {
    // [TB_STDログイン]
    await db.execute('''
      create table ${TblLgIn._tableName1} ( 
        ${TblLgIn._columnId1} text, 
        ${TblLgIn._columnPw1} text,
        ${TblLgIn._columnName1} text,
        ${TblLgIn._columnUpdt1} datetime,
        PRIMARY KEY(${TblLgIn._columnId1})
        )
    ''');
    // [TB_STD英単語マスタ]
    await db.execute('''
      create table ${TblWord._tableName2} ( 
        ${TblWord._columnClsL2} text, 
        ${TblWord._columnClsM2} text,
        ${TblWord._columnClsS2} text,
        ${TblWord._columnNo2} text,
        ${TblWord._columnWord2} text,
        ${TblWord._columnAtr2} text,
        ${TblWord._columnPrn2} text,
        ${TblWord._columnMean2} text,
        ${TblWord._columnExSnt2} text,
        ${TblWord._columnExSntMn2} text,
        ${TblWord._columnUpdt2} datetime,
        PRIMARY KEY(${TblWord._columnClsL2},${TblWord._columnClsM2},${TblWord._columnClsS2},${TblWord._columnNo2} )
        )
    ''');
    // [TB_STD生徒別学習記録]
    await db.execute('''
      create table ${TblRcd._tableName3} ( 
        ${TblRcd._columnStudentId} text,
        ${TblRcd._columnClsL3} text, 
        ${TblRcd._columnClsM3} text,
        ${TblRcd._columnClsS3} text,
        ${TblRcd._columnWord3} text,
        ${TblRcd._columnStdyCnt3} text,
        ${TblRcd._columnClrCnt3} text,
        ${TblRcd._columnClrDt3} datetime,
        ${TblRcd._columnPassDt3} datetime,
        ${TblRcd._columnLastDt3} datetime,
        PRIMARY KEY(${TblRcd._columnStudentId},${TblRcd._columnClsL3},${TblRcd._columnClsM3},${TblRcd._columnClsS3},${TblRcd._columnWord3} )
        )
    ''');

    // [TB_STD英単語マスタ]小分類
    // [TB_STD英単語マスタ]中分類
    // [TB_STD英単語マスタ]大分類
    await db.execute('''
      CREATE VIEW ${TblWord._tableName2}SVIEW AS SELECT DISTINCT 
        ${TblWord._columnClsL2} ,
        ${TblWord._columnClsM2} ,
        ${TblWord._columnClsS2} 
        FROM ${TblWord._tableName2};
      CREATE VIEW ${TblWord._tableName2}MVIEW AS SELECT DISTINCT 
        ${TblWord._columnClsL2} , 
        ${TblWord._columnClsM2} 
        FROM ${TblWord._tableName2};
      CREATE VIEW ${TblWord._tableName2}LVIEW AS SELECT DISTINCT 
        ${TblWord._columnClsL2}  
        FROM ${TblWord._tableName2};
      ''');
  }

  Future<Database> create() async {
    print('db=>>create');
    dynamic db;
    String? path;
    if (Platform.isAndroid) {
      var databasesPath = await getDatabasesPath();
      // (2) joinメソッドはpathパッケージのもの
      path = join(databasesPath, 'std_db.db');
      // (3) データベースが作成されていない場合にonCreate関数が呼ばれる
      db = await openDatabase(path, version: 1, onCreate: (
        Database db,
        int version,
      ) async {
        createTables(db);
      });
    } else if (Platform.isWindows) {
      print('db==>>windows');
      sqfliteFfiInit();
      var databaseFactory = databaseFactoryFfi;
      var databasesPath = await databaseFactory.getDatabasesPath();
      path = join(databasesPath, "std_db.db");

      db = await databaseFactory.openDatabase(
        path,
        options: OpenDatabaseOptions(
          version: 1,
          onCreate: (Database db, int version) async {
            createTables(db);
            print('TABLE CREATED');
          },
        ),
      );
    }

    print('db==>>$path');
    return db;
  }
}

class TblLgIn {
  static const _tableName1 = 'TB_STDログイン';
  static const _columnId1 = 'ログインID';
  static const _columnPw1 = 'パスワード';
  static const _columnName1 = '名前';
  static const _columnUpdt1 = '更新日時';
}

class TblWord {
  static const _tableName2 = 'TB_STD英単語マスタ';
  static const _columnClsL2 = '大分類';
  static const _columnClsM2 = '中分類';
  static const _columnClsS2 = '小分類';
  static const _columnNo2 = 'No';
  static const _columnWord2 = '単語';
  static const _columnAtr2 = '属性';
  static const _columnPrn2 = '発音格納先';
  static const _columnMean2 = '意味';
  static const _columnExSnt2 = '例文';
  static const _columnExSntMn2 = '例文意味';
  static const _columnUpdt2 = '更新日時';
}

class TblLarge {
  static const _tableName2 = 'TB_STD英単語マスタLVIEW';
  static const _columnClsL2 = '大分類';
}

class TblMiddle {
  static const _tableName2 = 'TB_STD英単語マスタMVIEW';
  static const _columnClsL2 = '大分類';
  static const _columnClsM2 = '中分類';
}

class TblSmall {
  static const _tableName2 = 'TB_STD英単語マスタSVIEW';
  static const _columnClsL2 = '大分類';
  static const _columnClsM2 = '中分類';
  static const _columnClsS2 = '小分類';
}

class TblRcd {
  static const _tableName3 = 'TB_STD生徒別学習記録';
  static const _columnStudentId = '生徒ID';
  static const _columnClsL3 = '大分類';
  static const _columnClsM3 = '中分類';
  static const _columnClsS3 = '小分類';
  static const _columnWord3 = '単語';
  static const _columnStdyCnt3 = '学習回数';
  static const _columnClrCnt3 = 'クリア回数';
  static const _columnClrDt3 = 'クリア日';
  static const _columnPassDt3 = 'テスト合格日時';
  static const _columnLastDt3 = '最終学習日';
}

// (4) データの取得・追加・更新・削除の責務を持たせたクラス
class StudyDaoHelper {
  static const _tableName = 'ユーザ';
  static const _columnId = 'ＩＤ';
  static const _columnName = '名前';

  final DatabaseFactory _factory;
  Database? _db;

  StudyDaoHelper(this._factory);

  Future<void> open() async {
    _db = await _factory.create();
  }

  // TB_STDログイン fetch
  Future<LogIn?> loginFetch(String id) async {
    // (5) 取得操作、必ずListで返却される

    print('fetch');
    List<Map> maps = await _db!.query(TblLgIn._tableName1,
        columns: [
          TblLgIn._columnId1,
          TblLgIn._columnPw1,
          TblLgIn._columnName1,
          TblLgIn._columnUpdt1
        ],
        where: '${TblLgIn._columnId1} = ?',
        whereArgs: [id]);
    print('fetch>>$maps');
    if (maps.isNotEmpty) {
      return LogIn(
          maps.first[TblLgIn._columnId1],
          maps.first[TblLgIn._columnPw1],
          maps.first[TblLgIn._columnName1],
          maps.first[TblLgIn._columnUpdt1]);
    }
    return null;
  }

  // TB_STD英単語マスタ fetch
  Future<List<Map>?> englishWordFetch(
      String strLarge, String strMiddle, String strSmall) async {
    // (5) 取得操作、必ずListで返却される

    print('fetch==>>$strLarge >> $strMiddle >> $strSmall');
    List<Map> maps = await _db!.query(TblWord._tableName2,
        columns: [
          TblWord._columnClsL2,
          TblWord._columnClsM2,
          TblWord._columnClsS2,
          TblWord._columnNo2,
          TblWord._columnWord2,
          TblWord._columnAtr2,
          TblWord._columnPrn2,
          TblWord._columnMean2,
          TblWord._columnExSnt2,
          TblWord._columnExSntMn2,
          TblWord._columnUpdt2
        ],
        where:
            '${TblWord._columnClsL2} = ? and ${TblWord._columnClsM2} = ? and ${TblWord._columnClsS2} = ? ',
        whereArgs: [strLarge, strMiddle, strSmall]);
    print('fetch>>EnglishWordFetch');

    if (maps.isNotEmpty) {
      return maps;
    }
    return null;
  }

  // TB_STD英単語マスタLVIEW fetch
  Future<List<Map>?> largeFetch() async {
    // (5) 取得操作、必ずListで返却される
    List<Map> maps = await _db!.query(
      TblLarge._tableName2,
      columns: [
        TblLarge._columnClsL2,
      ],
    );
    print('fetch>>clsLargeFetch');
    if (maps.isNotEmpty) {
      return maps;
    }
    return null;
  }

  // TB_STD英単語マスタMVIEW fetch
  Future<List<Map>?> middleFetch(String strLarge) async {
    // (5) 取得操作、必ずListで返却される
    List<Map> maps = await _db!.query(TblMiddle._tableName2,
        columns: [
          TblMiddle._columnClsL2,
          TblMiddle._columnClsM2,
        ],
        where: '${TblWord._columnClsL2} = ? ',
        whereArgs: [strLarge]);
    print('fetch>>clsLargeFetch');
    if (maps.isNotEmpty) {
      return maps;
    }
    return null;
  }

  // TB_STD英単語マスタSVIEW fetch
  Future<List<Map>?> smallFetch(String strLarge, String strMiddle) async {
    // (5) 取得操作、必ずListで返却される
    List<Map> maps = await _db!.query(TblSmall._tableName2,
        columns: [
          TblSmall._columnClsL2,
          TblSmall._columnClsM2,
          TblSmall._columnClsS2,
        ],
        where: '${TblWord._columnClsL2} = ? and ${TblWord._columnClsM2} = ? ',
        whereArgs: [strLarge, strMiddle]);
    print('fetch>>clsLargeFetch');
    if (maps.isNotEmpty) {
      return maps;
    }
    return null;
  }

  // TB_STD生徒別学習記録 fetch / insert / update
  Future<List<Map>?> recordFetch(String strSdtId, String strLarge,
      String strMiddle, String strSmall, String strWord) async {
    print(
        'recordFetch>>>> $strSdtId : $strLarge : $strMiddle : $strSmall : $strWord');
    // (5) 取得操作、必ずListで返却される
    List<Map> maps = await _db!.query(TblRcd._tableName3,
        columns: [
          TblRcd._columnStudentId,
          TblRcd._columnClsL3,
          TblRcd._columnClsM3,
          TblRcd._columnClsS3,
          TblRcd._columnWord3,
          TblRcd._columnStdyCnt3,
          TblRcd._columnClrCnt3,
          TblRcd._columnClrDt3,
          TblRcd._columnPassDt3,
          TblRcd._columnLastDt3,
        ],
        where: '${TblRcd._columnStudentId} = ? '
            'and ${TblRcd._columnClsL3} = ? '
            'and ${TblRcd._columnClsM3} = ? '
            'and ${TblRcd._columnClsS3} = ? '
            'and ${TblRcd._columnWord3} like ? ',
        whereArgs: [strSdtId, strLarge, strMiddle, strSmall, strWord]);
    print('recordFetch>>$maps');
    if (maps.isNotEmpty) {
      return maps;
    }
    return null;
  }

  // insert
  Future<void> recordInsert(
      String strStudentId,
      String strClsL3,
      String strClsM3,
      String strClsS3,
      String strWord3,
      int intStdyCnt3,
      int intClrCnt3,
      String dtClrDt3,
      String dtPassDt3,
      String dtLastDt3) async {
    // (6) 挿入処理
    print('==insert== $strWord3');
    await _db!.insert(TblRcd._tableName3, {
      TblRcd._columnStudentId: strStudentId,
      TblRcd._columnClsL3: strClsL3,
      TblRcd._columnClsM3: strClsM3,
      TblRcd._columnClsS3: strClsS3,
      TblRcd._columnWord3: strWord3,
      TblRcd._columnStdyCnt3: intStdyCnt3,
      TblRcd._columnClrCnt3: intClrCnt3,
      TblRcd._columnClrDt3: dtClrDt3,
      TblRcd._columnPassDt3: dtPassDt3,
      TblRcd._columnLastDt3: dtLastDt3
    });
  }

  Future<void> recordUpdate(
      String strSdtId,
      String strLarge,
      String strMiddle,
      String strSmall,
      int intStdyCnt,
      int intClrCnt,
      String dtClrDt3,
      String dtPassDt,
      String dtLastDt) async {
    // (8) 更新処理

    print('==update==');
    await _db!.update(
        TblRcd._tableName3,
        {
          TblRcd._columnStudentId: strSdtId,
          TblRcd._columnClsL3: strLarge,
          TblRcd._columnClsM3: strMiddle,
          TblRcd._columnClsS3: strSmall,
          if (intStdyCnt < 0) TblRcd._columnStdyCnt3: intStdyCnt,
          if (intClrCnt < 0) TblRcd._columnClrCnt3: intClrCnt,
          if (dtClrDt3.isNotEmpty) TblRcd._columnClrDt3: dtClrDt3,
          if (dtPassDt.isNotEmpty) TblRcd._columnPassDt3: dtPassDt,
          TblRcd._columnLastDt3: dtLastDt
        },
        where: '${TblRcd._columnStudentId} = ? '
            'and ${TblRcd._columnClsL3} = ? '
            'and ${TblRcd._columnClsM3} = ? '
            'and ${TblRcd._columnClsS3} = ? ',
        whereArgs: [strSdtId, strLarge, strMiddle, strSmall]);
  }

  //
  //
  Future<User?> fetch(int id) async {
    // (5) 取得操作、必ずListで返却される
    print('fetch==>>userfetch==$id');
    List<Map> maps = await _db!.query(_tableName,
        columns: [
          _columnId,
          _columnName,
        ],
        where: '$_columnId = ?',
        whereArgs: [id]);
    print('fetch>>$maps');
    if (maps.isNotEmpty) {
      return User(
        maps.first[_columnId],
        maps.first[_columnName],
      );
    }
    return null;
  }
  //
  // Future<void> insert(int id, String name) async {
  //   // (6) 挿入処理
  //   print('==insert==');
  //   await _db!.insert(_tableName, {
  //     _columnId: id,
  //     _columnName: name,
  //   });
  // }
  //
  // Future<void> delete(int id) async {
  //   // (7) 削除処理
  //   print('==delete==');
  //   await _db!.delete(
  //     _tableName,
  //     where: '$_columnId = ?',
  //     whereArgs: [id],
  //   );
  // }
  //
  // Future<void> update(int id, String name) async {
  //   // (8) 更新処理
  //   print('==update==');
  //   await _db!.update(
  //       _tableName,
  //       {
  //         _columnId: id,
  //         _columnName: name,
  //       },
  //       where: '$_columnId = ?',
  //       whereArgs: [id]);
  // }

  Future<void> close() async => _db!.close();
}

// (9) Facade的な責務
class StudyDao {
  final DatabaseFactory factory;

  const StudyDao(this.factory);

  Future<void> save(
      String strStudentId,
      String strClsL3,
      String strClsM3,
      String strClsS3,
      String strWord3,
      int intStdyCnt3,
      int intClrCnt3,
      String dtClrDt3,
      String dtPassDt3,
      [String dtLastDt3 = '']) async {
    print('==save==');
    if (dtLastDt3.isEmpty) {
      dtLastDt3 = DateFormat('yyyy/MM/dd hh:mm:ss').format(DateTime.now());
    }
    var helper = StudyDaoHelper(factory);
    try {
      // (10) 必ず最初にopenする
      await helper.open();
      final result = await helper.recordFetch(
          strStudentId, strClsL3, strClsM3, strClsS3, strWord3); // 存在チェック
      if (result == null) {
        // ない
        await helper.recordInsert(strStudentId, strClsL3, strClsM3, strClsS3,
            strWord3, intStdyCnt3, intClrCnt3, dtClrDt3, dtPassDt3, dtLastDt3);
      } else {
        // ある
        await helper.recordUpdate(strStudentId, strClsL3, strClsM3, strClsS3,
            intStdyCnt3, intClrCnt3, dtClrDt3, dtPassDt3, dtLastDt3);
      }
    } on SqfliteDatabaseException catch (e) {
      print(e.message);
    } finally {
      // (11) 必ず最後にcloseする
      await helper.close();
    }
  }

  // Login
  Future<LogIn?> lginFetch(String strLogInID) async {
    var helper = StudyDaoHelper(factory);
    try {
      await helper.open();
      return await helper.loginFetch(strLogInID);
    } on SqfliteDatabaseException catch (e) {
      print(e.message);
      return null;
    } finally {
      await helper.close();
    }
  }

// 英単語
  Future<List<Map>?> enWordFetch(
      String strLarge, String strMiddle, String strSmall) async {
    var helper = StudyDaoHelper(factory);
    try {
      await helper.open();
      return await helper.englishWordFetch(strLarge, strMiddle, strSmall);
    } on SqfliteDatabaseException catch (e) {
      print(e.message);
      return null;
    } finally {
      await helper.close();
    }
  }

// 大中小分類
  Future<List<Map>?> clsLMSFetch(int intKind,
      [String strLarge = '', String strMiddle = '']) async {
    var helper = StudyDaoHelper(factory);
    try {
      await helper.open();
      if (intKind == 1) {
        return await helper.largeFetch();
      } else if (intKind == 2) {
        return await helper.middleFetch(strLarge);
      } else {
        return await helper.smallFetch(strLarge, strMiddle);
      }
    } on SqfliteDatabaseException catch (e) {
      print(e.message);
      return null;
    } finally {
      await helper.close();
    }
  }

  // 生徒記録
  Future<List<Map>?> stdRcdFetch(
      String strStdID, String strLarge, String strMiddle, String strSmall,
      [String strWord = '%']) async {
    var helper = StudyDaoHelper(factory);
    try {
      await helper.open();
      return await helper.recordFetch(
          strStdID, strLarge, strMiddle, strSmall, strWord);
    } on SqfliteDatabaseException catch (e) {
      print(e.message);
      return null;
    } finally {
      await helper.close();
    }
  }

  // Future<User?> fetch(int id) async {
  //   var helper = StudyDaoHelper(factory);
  //   try {
  //     await helper.open();
  //     return await helper.fetch(id);
  //   } on SqfliteDatabaseException catch (e) {
  //     print(e.message);
  //     return null;
  //   } finally {
  //     await helper.close();
  //   }
  // }

  // Future<void> delete(int id) async {
  //   var helper = StudyDaoHelper(factory);
  //   try {
  //     await helper.open();
  //     await helper.delete(id);
  //   } on SqfliteDatabaseException catch (e) {
  //     print(e.message);
  //   } finally {
  //     await helper.close();
  //   }
  // }
}
