import 'package:flutter/material.dart';
import 'package:sqlite_app/helper/db_helper.dart';
import 'package:sqlite_app/main.dart';
import 'package:sqlite_app/model/mynote_model.dart';

class NotePage extends StatefulWidget {
  final MyNote myNote;
  final bool _isNew;

  NotePage(this.myNote, this._isNew);

  @override
  _NotePageState createState() => _NotePageState();
}

class _NotePageState extends State<NotePage> {
  String title;
  bool btnSave = false;
  bool btnEdit = true;
  bool btnDelete = true;
  var now = DateTime.now();
  MyNote myNote;
  
  Future<List<MyNote>>  future;
  final cTitle = TextEditingController();
  final cNote = TextEditingController();
  String _createDate;
  bool _enableTextfield = true;
  Future addRecordData() async {
    var db = DbHelper();
    String dateNow =
        "${now.day}-${now.month}-${now.year}, ${now.hour} : ${now.minute}";
    var myNote =
        MyNote(cTitle.text, cNote.text, dateNow, dateNow, now.toString());
    await db.saveData(myNote);
    setState(() {
      future=db.getList();
    });
    print("Saved");
  }


  Future updateRecordData() async {
    var db = DbHelper();
    String dateNow =
        "${now.day}-${now.month}-${now.year}, ${now.hour} : ${now.minute}";
    var myNote =
        MyNote(cTitle.text, cNote.text, _createDate, dateNow, now.toString());
    myNote.setId(this.myNote.id);
   await db.upadteData(myNote);
   setState(() {
      future=db.getList();
    });
    print("Updateed");
  
  }

 
  void _saveData() async {
    if (widget._isNew) {
      addRecordData();
    } else {
      updateRecordData();
    }
    Navigator.pop(context, "save or update");
  }

  void _editData() {
    setState(() {
      _enableTextfield = true;
      btnSave = true;
      btnDelete = true;
      btnEdit = false;
    });
  }

  void _delete(MyNote myNote) {
    var db = DbHelper();
    db.deleteData(myNote);
    setState(() {
      future=db.getList();
    });
  }

  void _confirmDelete() {
    AlertDialog alertDialog = AlertDialog(
      backgroundColor: Color(0xFF1F1F1F),
      content: Text(
        "Are You Sure ?",
        style: TextStyle(fontSize: 16, color: Colors.white),
      ),
      actions: <Widget>[
        RaisedButton(
          color: Colors.red,
          onPressed: () async {
            Navigator.pop(context);
            _delete(myNote);
            Navigator.pop(context, "delete");
          },
          child: Text(
            "Delete",
            style: TextStyle(color: Colors.black),
          ),
        ),
        RaisedButton(
          color: Color.fromRGBO(254, 210, 52, 1),
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text("Cancel"),
        ),
      ],
    );
    showDialog(context: context, child: alertDialog);
  }

  @override
  void initState() {
    super.initState();
    if (widget.myNote != null) {
      myNote = widget.myNote;
      cTitle.text = myNote.title;
      cNote.text = myNote.note;
      title = "Update Or Delete";
      _enableTextfield = false;
      _createDate = myNote.createDate;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget._isNew) {
      title = "New note";
      btnSave = true;
      btnEdit = false;
      btnDelete = false;
    }
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(0, 0, 0, 1),
        title: Text(
          title,
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        leading: Container(
          margin: EdgeInsets.symmetric(vertical: 8, horizontal: 5),
          decoration: BoxDecoration(
              color: Color(0xFF1F1F1F), borderRadius: BorderRadius.circular(5)),
          child: Align(
            alignment: Alignment(0, 0),
            child: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: (){
                Navigator.pop(context, "back");
              },
            ),
          ),
        ),
        elevation: 0,
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              child: TextFormField(
                controller: cTitle,
                enabled: _enableTextfield,
                decoration: InputDecoration(
                    hintStyle: TextStyle(color: Colors.white),
                    hintText: "Title",
                    border: InputBorder.none),
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.white,
                ),
                maxLines: null,
                keyboardType: TextInputType.text,
              ),
            ),
            Expanded(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                child: SingleChildScrollView(
                  child: TextFormField(
                    controller: cNote,
                    enabled: _enableTextfield,
                    decoration: InputDecoration(
                        hintStyle: TextStyle(color: Colors.white),
                        hintText: "Note",
                        border: InputBorder.none),
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                    ),
                    maxLines: null,
                    keyboardType: TextInputType.text,
                    textInputAction: TextInputAction.newline,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Align(
                alignment: Alignment.bottomRight,
                child: Container(
                  width: 200,
                  decoration: BoxDecoration(
                    color: Color.fromRGBO(254, 210, 52, 1),
                    borderRadius: BorderRadius.circular(50),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      ButtonIcon(Icons.save, btnSave, ()  {
                        _saveData();
                      }),
                      ButtonIcon(Icons.edit, btnEdit, ()  {
                        
                        _editData();
                      }),
                      ButtonIcon(Icons.delete, btnDelete, ()  {
                      
                        _confirmDelete();
                      })
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ButtonIcon extends StatelessWidget {
  final IconData iconData;
  final bool enable;
  final onPress;

  ButtonIcon(this.iconData, this.enable, this.onPress);
  @override
  Widget build(BuildContext context) {
    return Container(
      child: IconButton(
          icon: Icon(
            iconData,
            color: enable ? Colors.black : Colors.grey[800],
            size: 30,
          ),
          onPressed: () {
            if (enable) {
              onPress();
            }
          }),
    );
  }
}
