class beanCMS {
  late String message, title, description, slug, image;
  late int status;

  beanCMS.fromJsonfail(Map json)
      : status = json['status'],
        message = json['message'];

  beanCMS.fromJsonCMS(Map json)
      : status = json['status'],
        slug = json['slug'],
        image = json['image'],
        title = json['title'],
        description = json['description'];

  beanCMS.fromJsonStatus(Map json) : status = json['status'];

  Map toJson() {
    return {'status': status, 'message': message};
  }
}
