class MyNote {
  int id;
  String _title;
  String _note;
  String _createDate;
  String _updateDate;
  String _sortDate;

  MyNote(this._title, this._note, this._createDate, this._updateDate,
      this._sortDate);

  MyNote.map(dynamic object) {
    this._title = object['title'];
    this._note = object['note'];
    this._createDate = object['createDate'];
    this._updateDate = object['updateDate'];
    this._sortDate = object['sortDate'];
  }

  String get title => _title;
  String get note => _note;
  String get createDate => _createDate;
  String get updateDate => _updateDate;
  String get sortDate => _sortDate;

  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();
    map['title'] = _title;
    map['note'] = _note;
    map['createDate'] = _createDate;
    map['updateDate'] = _updateDate;
    map['sortDate'] = _sortDate;

    return map;
  }

  void setId(int id) {
    this.id = id;
  }
}
