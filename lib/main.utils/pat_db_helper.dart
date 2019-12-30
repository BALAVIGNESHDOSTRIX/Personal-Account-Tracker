import '../models/income_model.dart';
import '../models/expense_model.dart';
import '../models/lender_model.dart';
import '../models/barrow_model.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:async';
import 'dart:io';

class DatabaseHelper{
  static DatabaseHelper _databaseHelper; //Singleton DatabaseHelper
  static Database _database; //Singleton Database

  //Table Properties
  String incometable = 'income_table';
  String expensetable = 'expense_table';
  String lendbarrowtable = 'lend_table';
  String barrowtable = 'barrow_table';


  //Table column details
  String colId = 'id';
  String colAmount = 'amount';
  String colDate = 'date';
  String colDescription = 'description';
  String colType = 'type';
  String colmonthyr = 'monthyear';
  String colcategory = 'category';



  //Named Constructor
  DatabaseHelper._createInstance(); //Create a instance of DatabaseHelper

  factory DatabaseHelper(){
    if(_databaseHelper == null){
      _databaseHelper = DatabaseHelper._createInstance(); //this is executed Only once
    }
    return _databaseHelper;
  }

  //Getter for database instance
  Future<Database> get database async{
    if(_database == null){
      _database = await initializeDatabase();
    }
    return _database;
  }

  //get the database path
  Future<Database> initializeDatabase() async{
    Directory dir = await getApplicationDocumentsDirectory();
    String path = dir.path + 'pat.db';

    //open or create the database with given path
    var salarydb = await openDatabase(path,version:1,onCreate:_createdb);
    return salarydb;
  }

  void _createdb(Database db,int newVersion) async{
    //create salarytable
    await db.execute('CREATE TABLE $incometable($colId INTEGER PRIMARY KEY AUTOINCREMENT, $colAmount TEXT, $colDate TEXT, $colDescription TEXT, $colType TEXT,$colcategory TEXT ,$colmonthyr TEXT)');
    
    //create expense table
    await db.execute('CREATE TABLE $expensetable($colId INTEGER PRIMARY KEY AUTOINCREMENT, $colAmount TEXT, $colDate TEXT, $colDescription TEXT, $colType TEXT,$colcategory TEXT ,$colmonthyr TEXT)');

    //create leandbarrow table
    await db.execute('CREATE TABLE $lendbarrowtable($colId INTEGER PRIMARY KEY AUTOINCREMENT, $colAmount TEXT, $colDate TEXT, $colDescription TEXT, $colType TEXT,$colcategory TEXT ,$colmonthyr TEXT)');

    //create barrow table
    await db.execute('CREATE TABLE $barrowtable($colId INTEGER PRIMARY KEY AUTOINCREMENT, $colAmount TEXT, $colDate TEXT, $colDescription TEXT, $colType TEXT,$colcategory TEXT ,$colmonthyr TEXT)');
  
  }

  
 
  //Insert operation 
  Future<dynamic> insertIncome(Income salary) async{
    Database db = await this.database;
    var result = await db.insert(incometable, salary.toMap());
    return result;
  }

 

  //DELETE salary table data
  Future<dynamic> deleteIncome(int id) async{
      Database db = await this.database;
      var result = await db.rawDelete('DELETE FROM $incometable where $colId = $id');
      return result;
  }

 
  //get datewise IcomeList
  Future<List<Map<String, dynamic>>> getDateIncomeList(String date) async {
      Database db = await this.database;
      var result = db.rawQuery("SELECT * FROM $incometable where $colDate = ?", [date]);
      return result;
  }

  //get monthyear IncomeList
  Future<List<Map<String,dynamic>>> getMonthyearIncomeData(String monthyr) async{
    Database db = await this.database;
    var result = db.rawQuery("SELECT amount FROM $incometable where $colmonthyr = ?", [monthyr]);
    return result;
  }

  
  //Insert the Expense data
  Future<dynamic> insertExpense(Expense expense) async{
    Database db = await this.database;
    var result = await db.insert(expensetable, expense.toMap());
    return result;
  }


  //DELETE the Expense Data
  Future<dynamic> deleteExpense(int id) async{
      Database db = await this.database;
      var result = await db.rawDelete('DELETE FROM $expensetable where $colId = $id');
      return result;
  }

   //get datewise ExpenseList
  Future<List<Map<String, dynamic>>> getDateExpenseList(String date) async {
      Database db = await this.database;
      var result = db.rawQuery("SELECT * FROM $expensetable where $colDate = ?", [date]);
      return result;
  }


  //get monthyear IncomeList
  Future<List<Map<String,dynamic>>> getMonthyearExpenseData(String monthyr) async{
    Database db = await this.database;
    var result = db.rawQuery("SELECT amount FROM $expensetable where $colmonthyr = ?", [monthyr]);
    return result;
  }


  //Insert the LendBarrow data
  Future<dynamic> insertLendBarrow(Lend lendbarrow) async{
    Database db = await this.database;
    var result = await db.insert(lendbarrowtable, lendbarrow.toMap());
    return result;
  }

  //DELETE the Lend Data
  Future<dynamic> deleteLendBarrow(int id) async{
    Database db = await this.database;
    var result = await db.rawDelete('DELETE FROM $lendbarrowtable where $colId = $id');
    return result;
  }

  //datewise lend Data
  Future<List<Map<String, dynamic>>> getDateLendList(String date) async {
      Database db = await this.database;
      var result = db.rawQuery("SELECT * FROM $lendbarrowtable where $colDate = ?", [date]);
      return result;
  }

  Future<List<Map<String,dynamic>>> getMonthyearLendData(String monthyr) async{
    Database db = await this.database;
    var result = db.rawQuery("SELECT amount FROM $lendbarrowtable where $colmonthyr = ?", [monthyr]);
    return result;
  }


// //

//Insert the Barrow data
  Future<dynamic> insertBarrow(Barrow barrow) async{
    Database db = await this.database;
    var result = await db.insert(barrowtable, barrow.toMap());
    return result;
  }

  //DELETE the Lend Data
  Future<dynamic> deleteBarrow(int id) async{
    Database db = await this.database;
    var result = await db.rawDelete('DELETE FROM $barrowtable where $colId = $id');
    return result;
  }

  //datewise lend Data
  Future<List<Map<String, dynamic>>> getDateBarrowList(String date) async {
      Database db = await this.database;
      var result = db.rawQuery("SELECT * FROM $barrowtable where $colDate = ?", [date]);
      return result;
  }

  Future<List<Map<String,dynamic>>> getMonthyearBarrowData(String monthyr) async{
    Database db = await this.database;
    var result = db.rawQuery("SELECT amount FROM $barrowtable where $colmonthyr = ?", [monthyr]);
    return result;
  }

}