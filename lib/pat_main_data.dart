import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'main.utils/pat_db_helper.dart';
import './pat_forms.dart';
import 'package:flutter_calendar/flutter_calendar.dart';
import 'package:intl/intl.dart';

enum ConfirmAction { CANCEL, ACCEPT }

class MainDataRoot extends StatefulWidget{
  const MainDataRoot({Key key, this.screen}) : super(key:key);

  final String screen;

  @override
  State<StatefulWidget> createState() {
    return MainDataPage();
  }
}



class MainDataPage extends State<MainDataRoot>{
  DatabaseHelper databaseHelper = DatabaseHelper();
  String pickeddate;
  List<Map<String, dynamic>> salaryList;
  int count = 0;
  TextStyle descStyle =  TextStyle(fontWeight: FontWeight.w500);

  //Global Variables
  String screen_page;
  Color globalcolor;

  pages(String page) async{
    var res = await Navigator.of(context).push(new MaterialPageRoute(builder: (BuildContext context)=> new MainFormRoot(screen: page)));
    // setState(() {
    //   this.screen_page = res;
    // });
    //  updateListView(this.screen_page);
  }

  cashtype(String type){
    if(type == 'Card'){
      return 0;
    }
    if(type == 'Cash'){
      return 1;
    }
  }

  returnAmount(String amo){
    if(double.parse(amo) >= 1000000){
      var ss = double.parse(amo)/1000000;
      return ss.toString() + ' ' + 'M';
    }
    return amo.toString();
  }


    static const List<Image> icons = const [ 
    Image(width: 60, image: AssetImage("assets/card.png")),
    Image(width: 60, image: AssetImage("assets/cash.png")),
   
  ];

  

   @override
  void initState(){
    super.initState();
    this.pickeddate = DateFormat("dd-MM-yyyy").format(DateTime.now());
    this.screen_page = widget.screen;
    if(this.screen_page == 'Income'){
       setState(() {
         this.globalcolor = Color.fromRGBO(142, 154, 247, 1);
       });
      }
      if(this.screen_page == 'Expense'){
       setState(() {
         this.globalcolor = Colors.lightBlueAccent;
       });
      }
      if(this.screen_page == 'Lend'){
       setState(() {
         this.globalcolor = Colors.lightGreenAccent;
       });
      }
      if(this.screen_page == 'Barrow'){
       setState(() {
         this.globalcolor = Colors.yellowAccent;
       });
    }

    updateListView(widget.screen);
  }



  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
        title: new Text('Personal Account Tracker'),
        backgroundColor: Color.fromRGBO(107, 99, 255, 1),
        automaticallyImplyLeading: false,
        actions: <Widget>[
          Container(
            width: 30.0,
            height: 30.0,
            margin: const EdgeInsets.only(left: 20.0, right: 20.0),
            decoration: new BoxDecoration(
              shape: BoxShape.circle,
              color: this.globalcolor,
            )
          )
        ],
        ),
        body: new Column(
          children: <Widget>[
              ExpansionTile(
                title: Text(
          this.pickeddate,
          style: new TextStyle(),
          textAlign: TextAlign.center,
        ),
                children: <Widget>[
               new Calendar(
                initialCalendarDateOverride: DateTime.now(),
                onDateSelected:((day) {
                  this.pickeddate = null;
                  this.pickeddate = DateFormat("dd-MM-yyyy").format(day);
                  updateListView(this.screen_page);
                }),
              ),
            // ), 
                ],
              ),
             
              new Expanded(
                child: ListView.builder(
                shrinkWrap: true,
                padding: EdgeInsets.all(12),
			          itemCount: count,
                itemBuilder: (BuildContext context, int position) {
                  return Card(
                      shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50.0),
                      ),
                      color: Colors.white,
					            elevation: 5.0,  
                      child: Column(
                        children: <Widget>[
                          ListTile(
                            leading: CircleAvatar(
              child: icons[this.cashtype(this.salaryList[position]['type'])],
							backgroundColor: Colors.white,
						),
						title: Text(this.salaryList[position]['category'].toUpperCase(), style: TextStyle(fontWeight: FontWeight.bold),),
          

						subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
    
              children: <Widget>[
                Text(this.salaryList[position]['description'], style: descStyle,)
              ],
            ),
						trailing: Column(
              children: <Widget>[
                Chip(
                  label: Text(this.returnAmount(this.salaryList[position]['amount'])),
                  // avatar:  Image(
                  //     width: 50,
                  //     image: AssetImage("assets/rupees.png"),
                  //   ),
                  backgroundColor: Color.fromRGBO(255, 213, 0, 1)
                ),

              ],
            ),
              onLongPress: () async {
                await _asyncConfirmDialog(context, this.salaryList[position]['id']);
              },
                          ),
                        //  new  Text(this.salaryList[position]['description'].toUpperCase() , textAlign: TextAlign.center),
                        ],
                      ),
                  );
                }
              ),
              ),
              
          ],
        ),
        floatingActionButton: new FloatingActionButton(
	      elevation: 0.0,
	      child: Image(
	        width: 81,
	        image: AssetImage("assets/inc_pen.png"),
	      ),
	      backgroundColor: Colors.transparent,
	      onPressed: () async{
	        pages(this.screen_page);
	      }
	    ),
      backgroundColor: Colors.white,
      resizeToAvoidBottomPadding: false,
    );
  }

  Future<List<Map<String, dynamic>>> updateListView(String page) async {

    final Future<Database> dbFuture = databaseHelper.initializeDatabase();
    dynamic data_method;
    if(page == 'Income'){
      print("text");
        data_method = databaseHelper.getDateIncomeList(this.pickeddate);
      }
      if(page == 'Expense'){
        data_method = databaseHelper.getDateExpenseList(this.pickeddate);
      }
      if(page == 'Lend'){
        data_method = databaseHelper.getDateLendList(this.pickeddate);
      }
      if(page == 'Barrow'){
        data_method = databaseHelper.getDateBarrowList(this.pickeddate);
      }
    
      
      dbFuture.then((database) {
        Future<List<Map<String, dynamic>>> noteListFuture = data_method;
          noteListFuture.then((noteList) {
            print(noteList);
              setState(() {
                 this.salaryList = noteList;
                this.count = salaryList.length;
              });
        });
      });
  }

  void _showSnackBar(BuildContext context, String message) {

		final snackBar = SnackBar(content: Text(message));
		Scaffold.of(context).showSnackBar(snackBar);
	}

 
  Future<ConfirmAction> _asyncConfirmDialog(BuildContext context, id) async {
    return showDialog<ConfirmAction>(
      context: context,
      barrierDismissible: false, // user must tap button for close dialog!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirm Dialog'),
          content: const Text(
              'Do you want to delete ?'),
          actions: <Widget>[
            FlatButton(
              child: const Text('CANCEL'),
              onPressed: () {
                Navigator.of(context).pop(ConfirmAction.CANCEL);
              },
            ),
            FlatButton(
              child: const Text('ACCEPT'),
              onPressed: () {
                _delete(context, id);
                Navigator.of(context).pop(ConfirmAction.ACCEPT);
              },
            )
          ],
        );
      },
    );
  }

   void _delete(BuildContext context, int id) async {
     dynamic result;

     if(this.screen_page == 'Income'){
        result = await databaseHelper.deleteIncome(id);
      }
      if(this.screen_page == 'Expense'){
       result = await databaseHelper.deleteExpense(id);
      }
      if(this.screen_page == 'Lend'){
       result = await databaseHelper.deleteLendBarrow(id);
      }
      if(this.screen_page == 'Barrow'){
       result = await databaseHelper.deleteBarrow(id);
      }

		
		if (result != 0) {
			updateListView(this.screen_page);
		}
	}
}