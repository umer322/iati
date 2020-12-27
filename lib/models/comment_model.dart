class CommentModel{
  final String id;
  final String userId;
  final String comment;
  final DateTime time;
  final List<CommentModel> replies;
  final List<String> likes;
  CommentModel({this.id,this.userId,this.likes,this.time,this.comment,this.replies});
  CommentModel.fromJson(Map<String,dynamic> data,String id):
      id=id,
      userId=data['user_id'],
      comment=data['comment'],
      time=DateTime.parse(data['time']),
      replies=data['replies']??[],
      likes=data['likes']??[];
  toJson(){
    return {
      "id":id,
      "user_id":userId,
      "comment":comment,
      "time":time.toString(),
      "replies":replies,
      "likes":likes
    };
  }
}