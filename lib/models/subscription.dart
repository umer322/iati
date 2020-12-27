class Subscription{
    String id;
    String title;
    String description;
    double price;
    bool limited;
    int limit;
    bool requireShippingAddress;
    bool requirePhoneNumber;
    List<String> subscribers;
    Subscription({this.id,this.subscribers,this.requirePhoneNumber,this.requireShippingAddress,this.limit,this.limited,this.price,this.description,this.title});

    Subscription.fromJson(Map<String,dynamic> data):
        id=data['id'],
        title=data['title'],
        description=data['description'],
        price=data['price'],
        limited=data['limited'],
        limit=data['limit'],
        requireShippingAddress=data['require_address'],
        requirePhoneNumber=data['require_phone'],
        subscribers=getSubscribers(data['subscribers']??[]);
    static List<String> getSubscribers(List data){
        return data.map((e) => e.toString()).toList();
    }
    toMap(){
        return {
            "title":title,
            "description":description,
            "price":price,
            "limited":limited??false,
            "limit":limit,
            "require_address":requireShippingAddress??false,
            "require_phone":requirePhoneNumber??false,
            "subscribers":subscribers??[]
        };
    }
}