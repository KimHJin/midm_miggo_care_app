

import 'package:intl/intl.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class BloodPressure {
  final int? id;
  final int systolic;
  final int diastolic;
  final int pulse;
  final DateTime measuredAt;

  BloodPressure({
    this.id,
    required this.systolic,
    required this.diastolic,
    required this.pulse,
    required this.measuredAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'systolic': systolic,
      'diastolic': diastolic,
      'pulse': pulse,
      'measuredAt': measuredAt.toIso8601String(),
    };
  }

  static BloodPressure fromMap(Map<String, dynamic> map) {
    return BloodPressure(
      id: map['id'],
      systolic: map['systolic'],
      diastolic: map['diastolic'],
      pulse: map['pulse'],
      measuredAt: DateTime.parse(map['measuredAt']),
    );
  }

  static Future<Database> openDb() async {
    return await openDatabase(
      join(await getDatabasesPath(), 'blood_pressure.db'),
      version: 1,
      onCreate: (Database db, int version) async {
        await db.execute('''
        CREATE TABLE blood_pressure (
          id INTEGER PRIMARY KEY,
          systolic INTEGER,
          diastolic INTEGER,
          pulse INTEGER,
          measuredAt TEXT
        )
      ''');
      },
    );
  }

  static Future<void> insertBloodPressure(BloodPressure bloodPressure) async {
    final db = await openDb();

    await db.insert(
      'blood_pressure',
      bloodPressure.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  static Future<List<BloodPressure>> getBloodPressures() async {
    final db = await openDb();

    final List<Map<String, dynamic>> maps = await db.query('blood_pressure');

    return List.generate(maps.length, (i) {
      return BloodPressure.fromMap(maps[i]);
    });
  }

  static Future<List<BloodPressure>> getBloodPressuresByDay(int year, int month, int day) async {
    final db = await openDb();
    final start = DateTime(year, month, day, 0, 0, 0);
    final end = DateTime(year, month, day, 23,59,59);
    final List<Map<String, dynamic>> maps = await db.query(
      'blood_pressure',
      where: 'measuredAt BETWEEN ? AND ?',
      whereArgs: [start.toIso8601String(), end.toIso8601String()],
    );

    return List.generate(maps.length, (i) {
      return BloodPressure(
        id: maps[i]['id'],
        systolic: maps[i]['systolic'],
        diastolic: maps[i]['diastolic'],
        pulse: maps[i]['pulse'],
        measuredAt: DateTime.parse(maps[i]['measuredAt']),
      );
    });
  }

  static Future<List<BloodPressure>> getBloodPressuresByMonth(int year, int month) async {
    final db = await openDb();
    final start = DateTime(year, month, 1, 0, 0, 1);
    final end = DateTime(year, month+1, 0, 24, 00, 00);
    final List<Map<String, dynamic>> maps = await db.query(
      'blood_pressure',
      where: 'measuredAt BETWEEN ? AND ?',
      whereArgs: [start.toIso8601String(), end.toIso8601String()],
    );

    return List.generate(maps.length, (i) {
      return BloodPressure(
        id: maps[i]['id'],
        systolic: maps[i]['systolic'],
        diastolic: maps[i]['diastolic'],
        pulse: maps[i]['pulse'],
        measuredAt: DateTime.parse(maps[i]['measuredAt']),
      );
    });
  }

  static Future<List<BloodPressure>> getBloodPressuresByYear(int year) async {
    final db = await openDb();
    final start = DateTime(year, 1, 1, 0, 0, 1);
    final end = DateTime(year, 12+1,0, 24, 00, 00);
    final List<Map<String, dynamic>> maps = await db.query(
      'blood_pressure',
      where: 'measuredAt BETWEEN ? AND ?',
      whereArgs: [start.toIso8601String(), end.toIso8601String()],
    );

    return List.generate(maps.length, (i) {
      return BloodPressure(
        id: maps[i]['id'],
        systolic: maps[i]['systolic'],
        diastolic: maps[i]['diastolic'],
        pulse: maps[i]['pulse'],
        measuredAt: DateTime.parse(maps[i]['measuredAt']),
      );
    });
  }

  static Future<Map<String, double?>> getAverageBloodPressureByDay(int year, int month, int day) async {
    final List<BloodPressure> pressures = await getBloodPressuresByDay(year, month, day);

    if (pressures.isEmpty) {
      return {'avgSystolic': 0, 'avgDiastolic': 0, 'avgPulse': 0};
    }

    double totalSystolic = 0;
    double totalDiastolic = 0;
    double totalPulse = 0;

    for (var pressure in pressures) {
      totalSystolic += pressure.systolic;
      totalDiastolic += pressure.diastolic;
      totalPulse += pressure.pulse;
    }

    final avgSystolic = totalSystolic / pressures.length;
    final avgDiastolic = totalDiastolic / pressures.length;
    final avgPulse = totalPulse / pressures.length;

    return {'avgSystolic': avgSystolic, 'avgDiastolic': avgDiastolic, 'avgPulse': avgPulse};
  }

}