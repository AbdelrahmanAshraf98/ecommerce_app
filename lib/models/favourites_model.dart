class ChangeFavouritesModel{
  bool status;
  String msg;
  ChangeFavouritesModel.fromJson(Map<String,dynamic>json){
    status = json['status'];
    msg = json['message'];
  }
}

class FavouritesModel{
  bool status;
  FavouritesModelData data;
  FavouritesModel.fromJson(Map<String,dynamic>json){
    status = json['status'];
    data = FavouritesModelData.fromJson(json['data']);
  }
}

class FavouritesModelData{
  int currentPage;
  List<FavouritesModelItem> items=[];
  FavouritesModelData.fromJson(Map<String,dynamic>json){
    currentPage = json['current_page'];
    json['data'].forEach((element){
      items.add(FavouritesModelItem.fromJson(element));
    });
  }
}

class FavouritesModelItem{
  int id;
  FavProductItem product;
  FavouritesModelItem.fromJson(Map<String,dynamic>json){
    id = json['id'];
    product = FavProductItem.fromJson(json['product']);
  }
}

class FavProductItem{
  int id;
  dynamic price;
  dynamic oldPrice;
  dynamic discount;
  String image;
  String name;
  String description;
  FavProductItem.fromJson(Map<String,dynamic>json){
    id = json['id'];
    price = json['price'];
    oldPrice = json['old_price'];
    discount = json['discount'];
    image = json['image'];
    name = json['name'];
    description = json['description'];
  }
}