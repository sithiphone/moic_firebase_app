class Category{
  var docid, name, created_at;
  Category({this.docid, this.name, this.created_at});

  @override
  String toString() {
    return "DocID: $docid, Name: $name, Created_at: $created_at";
  }
}