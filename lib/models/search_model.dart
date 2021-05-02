class SearchModel{
  bool status;
  SearchModelData data;
  SearchModel.fromJson(Map<String,dynamic>json){
    status = json['status'];
    data = SearchModelData.fromJson(json['data']);
  }
}

class SearchModelData{
  int currentPage;
  List<SearchPrducts> items = [];
  SearchModelData.fromJson(Map<String,dynamic>json){
    currentPage = json['current_page'];
    json['data'].forEach((element){
      items.add(SearchPrducts.fromJson(element));
    });
  }
}

class SearchPrducts{
  int id;
  dynamic price;
  String image;
  String name;
  String description;
  SearchPrducts.fromJson(Map<String,dynamic>json){
    id = json['id'];
    price = json['price'];
    image = json['image'];
    name = json['name'];
    description = json['description'];
  }
}