class Barrow{
  int _id;
  String _category;
  double _amount;
  String _date;
  String _desc;
  String _type;
  String _monthyr;

  //default Constructor
  Barrow(this._category,this._amount,[this._date, this._desc, this._type, this._monthyr]);

  //Named Constructor
  Barrow.withId(this._id,this._category,this._amount,[this._date, this._desc,  this._type, this._monthyr]);

  //Getters
  int get id => _id;
  String get category => _category;
  double get amount => _amount;
  String get date => _date;
  String get desc => _desc;
  String get type => _type;
  String get monthyr => _monthyr;

  //Setters
  set category(String category){
    if(category.length <= 25){
      this._category = category;
    }
  }

  set amount(double amount){
    this._amount = amount;
  }

  set date(String date){
    this._date = date;
  }

  set desc(String desc){
    if(desc.length <= 30){
      this._desc = desc;
    }
  }

  set type(String type){
    this._type = type;
  }

  set monthyr(String monthyr){
    this._monthyr = monthyr;
  }


  //Convert the input data to Map objects
  Map<String,dynamic> toMap(){
    var map = Map<String,dynamic>();
    if(_id != null){
      map['id'] = _id;
    }
    map['amount'] = _amount;
    map['date'] = _date;
    map['description'] = _desc;
    map['type'] = _type;
    map['monthyear'] = _monthyr;
    map['category'] = _category;

    return map;
  }
}