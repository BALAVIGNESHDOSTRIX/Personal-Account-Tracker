import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'main.utils/pat_db_helper.dart';
import 'models/income_model.dart';
import 'models/expense_model.dart';
import 'models/lender_model.dart';
import 'models/barrow_model.dart';
import 'root.dart';
import 'package:intl/intl.dart';

class MainFormRoot extends StatefulWidget {
  const MainFormRoot({Key key, this.screen}) : super(key:key);


  final String screen;
  @override
  State<StatefulWidget> createState() {
    return MainFormDataPage();
  }
}

class MainFormDataPage extends State<MainFormRoot> {
  //global variables
  DatabaseHelper databaseHelper = DatabaseHelper();
  String screen_page;
  String moneytype = 'Cash';
  dynamic models;
  dynamic listdata;
  
  String pickeddate = DateFormat("dd-MM-yyyy").format(DateTime.now());
  String monthyr = DateFormat("MM-yyyy").format(DateTime.now());

  //TextControllers
  TextEditingController moneycontroller = TextEditingController();
  TextEditingController descontroller = TextEditingController();
  List<String> ioslist;
  String globkeyselect;
  String category;
  
  

  void screen_stuff(String page){
    print(page);
      if(page == 'Income'){
        print("income success");
        this.models = Income('', 0, '', '', '', '');
        this.ioslist = ['Employement', 'Pensions', 'Invesement', 'Business','Other Income'];
        this.globkeyselect = 'Employement';
        this.category = this.globkeyselect;
      }
      if(page == 'Expense'){
        this.models = Expense('',0, '', '', '', '');
        this.ioslist = ['Housing', 'Utilities', 'Food', 'Transportation','Health','Insurance','Personal','Recreation','Saving', 'Others'];
        this.globkeyselect = 'Food';
        this.category = this.globkeyselect;
      }
      if(page == 'Lend'){
        this.models = Lend('',0, '', '', '', '');
        this.ioslist = ['Friends','Family', 'Others'];
        this.globkeyselect = 'Friends';
        this.category = this.globkeyselect;
      }
      if(page == 'Barrow'){
        this.models = Barrow('',0, '', '', '', '');
        this.ioslist = ['Housing', 'Utilities', 'Food', 'Transportation','Health','Insurance','Personal','Recreation','Saving', 'Others'];
        this.globkeyselect = 'Health';
        this.category = this.globkeyselect;
      }

  }




  var data;
  bool autoValidate = true;
  bool readOnly = false;
  bool showSegmentedControl = true;
  final GlobalKey<FormBuilderState> _fbKey = GlobalKey<FormBuilderState>();
  

  ValueChanged _onChanged = (val) => print(val);
  

  @override
  void initState(){
    this.screen_page = widget.screen;
    this.screen_stuff(widget.screen);
    // this.dropdownList(this.screen_page);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: new Text('Personal Account Tracker'),
        backgroundColor: Color.fromRGBO(107, 99, 255, 1),
        automaticallyImplyLeading: false,
      ),
      
      resizeToAvoidBottomInset: false,
      body: Padding(
        padding: EdgeInsets.all(5.0 * 2),
        child: ListView(
          children: <Widget>[
            FormBuilder(
                key : _fbKey,
                initialValue:{
                  'date':DateTime.now(),
                  'accept_terms':false,
                },
                autovalidate:true,
                child: Column(
                  children: <Widget>[
                    FormBuilderTextField(
            attribute: "Amount",
            decoration: InputDecoration(labelText: "Amount"),
            keyboardType: TextInputType.number,
            controller: moneycontroller,
            initialValue: '0',
            validators: [
              FormBuilderValidators.numeric(),
              FormBuilderValidators.requiredTrue(),
            ],
          ),
          FormBuilderTextField(
            attribute: "Description",
            decoration: InputDecoration(labelText: "Description"),
            keyboardType: TextInputType.text,
            controller: descontroller,
            validators: [
              FormBuilderValidators.requiredTrue(),
              FormBuilderValidators.maxLength(25)
            ],
          ),
          FormBuilderDropdown(
            attribute: "Category",
            decoration: InputDecoration(labelText: "Category"),
            initialValue: this.globkeyselect,
            hint: Text('Select Category'),
            validators: [FormBuilderValidators.required()],
            onChanged: (dynamic value){
              print(value);
              setState(() {
                this.category = value;
              });
            },
            items: this.ioslist.map((gender) => DropdownMenuItem(
                 value: gender,
                 child: Text("$gender")
            )).toList(),
          ),
          FormBuilderDateTimePicker(
            attribute: "date",
            inputType: InputType.date,
            format: DateFormat("dd-MM-yyyy"),
            firstDate: DateTime(1900),
            lastDate: DateTime(2100),
            initialDate: DateTime.now(),
            onChanged: (date){
              print(date);
              setState(() {
                this.pickeddate = DateFormat("dd-MM-yyyy").format(date);
                this.monthyr = DateFormat("MM-yyyy").format(date);
              });
            },
            decoration:
                InputDecoration(labelText: "Date"),
          ),
          FormBuilderDropdown(
            attribute: "Cash Type",
            decoration: InputDecoration(labelText: "Cash Type"),
            initialValue: 'Cash',
            hint: Text("Cash Type"),
            validators: [FormBuilderValidators.required()],
            onChanged: (dynamic value){
              setState(() {
                this.moneytype = value;
              });
            },
            items: ['Cash', 'Card']
              .map((gender) => DropdownMenuItem(
                 value: gender,
                 child: Text("$gender")
            )).toList(),
          ),
          Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        MaterialButton(
          child: Text("Save"),
          color: Color.fromRGBO(107, 99, 255, 1),
          textColor: Colors.white,
          onPressed: () {
            getFormValues();
            if (_fbKey.currentState.saveAndValidate()) {
              print("Cool");
            }
          },
        ),
        MaterialButton(
          child: Text("Reset"),
          color: Color.fromRGBO(107, 99, 255, 1),
          textColor: Colors.white,
          onPressed: () {
            _fbKey.currentState.reset();
            resetFormValues();
          },
        ),
      ],
    )
  ],
  )
        )
          ],
        ),
      ),
    );
  }

  dynamic InsertDataValues(String page, dynamic data) async{
    dynamic result;
    if(page == 'Income'){
       result = await databaseHelper.insertIncome(data);
    
      }
      if(page == 'Expense'){
        print("bellow");
       result = await databaseHelper.insertExpense(data);
      }
      if(page == 'Lend'){
         result = await databaseHelper.insertLendBarrow(data);
         print(result);
      }
      if(page == 'Barrow'){
        result = await databaseHelper.insertBarrow(data);
      }

      if(result != 0){
        print(this.screen_page);
        // Navigator.pop(context, this.screen_page);
        Navigator.of(context).push(new MaterialPageRoute(builder: (BuildContext context)=> new RootPage()));
      }else{
        print('Not Saved.');
      }
  }

  void resetFormValues() async {
    this.moneycontroller.text = '';
    this.pickeddate = DateFormat("dd-MM-yyyy").format(DateTime.now());
    this.moneytype = 'Cash';
    this.category = this.globkeyselect;
    this.descontroller.text = '';
    this.monthyr = DateFormat("MM-yyyy").format(DateTime.now());
  }

  void getFormValues() async{
    double money = num.tryParse(moneycontroller.text).toDouble();
    models.amount = money;
    models.desc = descontroller.text;
    models.category = this.category;
    models.type = this.moneytype;
    models.date = this.pickeddate;
    models.monthyr = this.monthyr;
    this.InsertDataValues(this.screen_page, models);
  }

}

