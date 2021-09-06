class PrintImgRes {
  late Data data;

  PrintImgRes({ required this.data});

    PrintImgRes.fromJson(Map<String, dynamic> json) {
    data = (json['data'] != null ? new Data.fromJson(json['data']) : null)!;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['data'] = this.data.toJson();
    return data;
  }
}

class Data {
  late List<String> url;

  Data({required this.url});

  Data.fromJson(Map<String, dynamic> json) {
    url = json['url'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['url'] = this.url;
    return data;
  }
}