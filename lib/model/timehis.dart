class TimeHis {
  TimeHis(
      {required this.Uid,
      required this.Day_post,
      required this.In_time,
      required this.Out_time,
      required this.Comment});
  late final String Uid;
  late final String Day_post;
  late final String In_time;
  late final String Out_time;
  late final String Comment;

  TimeHis.fromJson(Map<String, dynamic> json) {
    Uid = json['U_id'];
    Day_post = json['Day_post'];
    In_time = json['In_Time'];
    Out_time = json['Out_Time'];
    Comment = json['Comment'];
  }
  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['Uid'] = Uid;
    _data['Day_post'] = Day_post;
    _data['In_time'] = In_time;
    _data['Out_time'] = Out_time;
    _data['Comment'] = Comment;
    return _data;
  }
}
