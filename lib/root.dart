import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:pie_chart/pie_chart.dart';
import 'main.utils/pat_db_helper.dart';
import 'main.utils/month_year_picker.dart';
import 'package:intl/intl.dart';
import './pat_main_data.dart';


class RootPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return Root();
  }
}

class Root extends State<RootPage> with TickerProviderStateMixin {

  final DateFormat dateFormat = new DateFormat('MMMM yyyy');
  DatabaseHelper databaseHelper = DatabaseHelper();
  List<Map<String, dynamic>> incomeList;
  DateTime selectedMonth;
  String pickedmonth;
  DateTime initialDate = DateTime.now();

  bool toggle = false;
  Map<String, double> dataMap = Map();
  List<Color> colorList = [
    Color.fromRGBO(142, 154, 247, 1),
    Colors.lightGreenAccent,
    Colors.lightBlueAccent,
    Colors.yellowAccent,
  ];

  int currentPage = 0;

 GlobalKey bottomNavigationKey = GlobalKey();

  double _lowerValue = 20.0;
  double _upperValue = 40.0;
  int start = 0;
  int end = 60;
  
  int counter = 0;


  //Piechart Variables
  int income_amount = 0;
  int expense_amount;

  List<Color> gradientColors = [
    const Color(0xff23b6e6),
    const Color(0xff02d39a),
  ];

  bool showAvg = false;
  int selectedPos = 0;

  // final List<charts.Series> seriesList = ;
  final bool animate = true;

 

  List<Widget> _tiles = const <Widget>[

    const _Example01Tile(Colors.green, Icons.widgets),
    const _Example01Tile(Colors.lightBlue, Icons.wifi),

  ];

  final ThemeData somTheme = new ThemeData(
          primaryColor: Colors.blue,
          accentColor: Colors.black,
          backgroundColor: Colors.grey
  );



  

  int touchedIndex;

  AnimationController _controller;

  final fromDate = DateTime(2019, 05, 22);
  final toDate = DateTime.now();

  final date1 = DateTime.now().subtract(Duration(days: 2));
  final date2 = DateTime.now().subtract(Duration(days: 3));

  static const List<Image> icons = const [ 
    Image(width: 50, image: AssetImage("assets/income.png")),
    Image(width: 50, image: AssetImage("assets/profit.png")),
    Image(width: 50, image: AssetImage("assets/borrow_lend.png"))
  ];



bool _dialVisible = true;

  @override
  void initState() {

    dataMap.putIfAbsent("Income", () => 0);
    dataMap.putIfAbsent("Expense", () => 0);
    dataMap.putIfAbsent("Lend", () => 0);
    dataMap.putIfAbsent("Barrow", () => 0);
    
    _controller = new AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 10),
    );

    selectedMonth = new DateTime(initialDate.year, initialDate.month);
    this.pickedmonth = DateFormat("MM-yyyy").format(selectedMonth);
    

    getmonthyearIncomeData();

  }

  pages(String page){
    
    Navigator.of(context).push(new MaterialPageRoute(builder: (BuildContext context)=> new MainDataRoot(screen: page)));
  }

  Widget build(BuildContext context) {

    return new WillPopScope(
      onWillPop: () async {
        Future.value(false);
        await this.getmonthyearIncomeData();
      },
      child: new Scaffold(
      appBar: new AppBar(title: new Text('Personal Account Tracker'),
      backgroundColor: Color.fromRGBO(107, 99, 255, 1),
      automaticallyImplyLeading: false,
      ),
      body: new ListView(
        children: <Widget>[
          new Column(
            children: <Widget>[
              new MonthStrip(
              format: 'MMM yyyy',
              from: new DateTime(1990, 1),
              to: new DateTime(2200, 12),
              initialMonth: selectedMonth,
              height: 48.0,
              viewportFraction: 0.25,
              onMonthChanged: (v) {
                print(v);
                setState(() {
                  selectedMonth = v;
                  this.pickedmonth = DateFormat("MM-yyyy").format(selectedMonth);
                  getmonthyearIncomeData();
                });
              },
            )
            ],
          ),
          new Column(
            children: <Widget>[
              Container(
                width: 400.0,
                height: 200.0,
                child: new PieChart(
                  dataMap: dataMap,
                  colorList: this.colorList,
                ) ,
              )
            ],
          ),
          new Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              new InkWell(
                child: new Container(
                margin: EdgeInsets.only(left: 20.0, right: 20.0),
                child: SizedBox(
                  width: 150.0,
                  height: 100.0,
                  child:  Card(
                    color: Color.fromRGBO(142, 154, 247, 1),
                    elevation: 3.0,
                    child: Center(
                      child: Text(this.moneyConvertor(this.dataMap['Income']),
                    style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
              ),
              textAlign: TextAlign.center,
              ),
                    ),
              ),
            
                ),
              ),
              onTap: () => pages("Income"),
              ),
              new InkWell(
                child: new Container(
                // margin: EdgeInsets.only(left: 20.0, right: 10.0),
                child: SizedBox(
                  width: 150.0,
                  height: 100.0,
                  child:  Card(
                    elevation: 3.0,
                    color: Colors.lightBlueAccent,
                    child: Center(
                      child: Text(this.moneyConvertor(this.dataMap['Expense']),
                    style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
              ),
              textAlign: TextAlign.center,
              ),
                    ),
              ),
                ),
              ),
              onTap: () =>  pages("Expense"),
              )


            ],
          
          ),
          new Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              new InkWell(
                child:  new Container(
                margin: EdgeInsets.only(left: 20.0, right: 20.0),
                child: SizedBox(
                  width: 150.0,
                  height: 100.0,
                  child:  Card(
                    color: Colors.lightGreenAccent,
                    elevation: 3.0,
                    child: Center(
                      child: Text(this.moneyConvertor(this.dataMap['Lend']),
                    style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
              ),
              textAlign: TextAlign.center,
              ),
                    ),
              ),
                ),
              ),
              onTap: () =>  pages("Lend"),
              ),
              new InkWell(
                child: new Container(
                // margin: EdgeInsets.only(left: 20.0, right: 10.0),
                child: SizedBox(
                  width: 150.0,
                  height: 100.0,
                  child:  Card(
                    color: Colors.yellowAccent,
                    elevation: 3.0,
                    child: Center(
                      child: Text(this.moneyConvertor(this.dataMap['Barrow']),
                    style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
              ),
              textAlign: TextAlign.center,
              ),
                    ),
              ),
                ),
              ),
              onTap: () =>  pages("Barrow"),
              )


            ],
          
          )

          
        //  
        ],
      ),
      backgroundColor: Colors.white,
    ),
    );

  }

 Future<List<Map<String,dynamic>>> getmonthyearIncomeData() async{
    
    final Future<Database> dbFuture = databaseHelper.initializeDatabase();
    dbFuture.then((database) {
      Future<List<Map<String, dynamic>>> noteListFuture = databaseHelper.getMonthyearIncomeData(this.pickedmonth);
        noteListFuture.then((noteList) {
          double x = 0;
          for(int i=0;i<noteList.length;i++){
              x +=  double.tryParse(noteList[i]['amount']); 
          }
          setState(() {
            dataMap['Income'] = x;
          
          });
      });
    });

    dbFuture.then((database) {
      Future<List<Map<String, dynamic>>> noteListExpense = databaseHelper.getMonthyearExpenseData(this.pickedmonth);
        noteListExpense.then((noteList) {
          double y = 0;
          for(int i=0;i<noteList.length;i++){
              y +=  double.tryParse(noteList[i]['amount']); 
          }
          setState(() {
            dataMap['Expense'] = y;
          });
      });
    });

    dbFuture.then((database) {
      Future<List<Map<String, dynamic>>> noteListBarrow = databaseHelper.getMonthyearBarrowData(this.pickedmonth);
        noteListBarrow.then((noteList) {
          double z = 0;
          for(int i=0;i<noteList.length;i++){
              z +=  double.tryParse(noteList[i]['amount']); 
          }
          setState(() {
            dataMap['Barrow'] = z;
          });
      });
    });

    dbFuture.then((database) {
      Future<List<Map<String, dynamic>>> noteListLend = databaseHelper.getMonthyearLendData(this.pickedmonth);
        noteListLend.then((noteList) {
          double t = 0;
          for(int i=0;i<noteList.length;i++){
              t +=  double.tryParse(noteList[i]['amount']); 
          }
          setState(() {
            dataMap['Lend'] = t;
          });
      });
    });
 }

  dynamic moneyConvertor(double money){
    if(money >= 1000 && money <= 1000000){
      return (money.toInt()/1000).toString() + ' ' + 'K';
    }
    if(money >= 1000000){
      return (money.toInt()/1000000).toString() + ' ' + 'M';
    }

    return money.toInt().toString();
  }
}


class _Example01Tile extends StatelessWidget {
  const _Example01Tile(this.backgroundColor, this.iconData);

  final Color backgroundColor;
  final IconData iconData;

  @override
  Widget build(BuildContext context) {
    return new Card(
      color: backgroundColor,
      child: new InkWell(
        onTap: () {},
        child: new Center(
          child: new Padding(
            padding: const EdgeInsets.all(4.0),
            child: new Icon(
              iconData,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}