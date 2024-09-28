import 'dart:convert';

class Task {
  int? id;
  int? user;
  String? day;
  String? title;
  String? startTime;
  String? endTime;
  String? location;
  String? preside;
  String? note;
  String? status;
  String? approver;

  Task(
      {this.id,
      this.user,
      this.day,
      this.title,
      this.startTime,
      this.endTime,
      this.location,
      this.preside,
      this.note,
      this.status,
      this.approver});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'user': user,
      'day': day,
      'title': title,
      'startTime': startTime,
      'endTime': endTime,
      'location': location,
      'preside': preside,
      'note': note,
      'status': status,
      'approver': approver,
    };
  }

  Task.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    user = json['user'];
    day = json['day'];
    title = json['title'];
    startTime = json['startTime'];
    endTime = json['endTime'];
    location = json['location'];
    preside = json['preside'];
    note = json['note'];
    status = json['status'];
    approver = json['approver'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['user'] = user;
    data['day'] = day;
    data['title'] = title;
    data['startTime'] = startTime;
    data['endTime'] = endTime;
    data['location'] = location;
    data['preside'] = preside;
    data['note'] = note;
    data['status'] = status;
    data['approver'] = approver;
    return data;
  }

  factory Task.fromMap(Map<String, dynamic> map) {
    return Task(
        id: map['id'] ?? 0,
        user: map['user'] ?? 0,
        day: map['day'] ?? '',
        title: map['title'] ?? '',
        startTime: map['startTime'] ?? '',
        endTime: map['endTime'] ?? '',
        location: map['location'] ?? '',
        preside: map['preside'] ?? '',
        note: map['note'] ?? '',
        status: map['status'] ?? 'Tạo mới',
        approver: map['approver'] ?? '');
  }

  String toJsonSQLite() => json.encode(toMap());

  factory Task.fromJsonSQLite(String source) =>
      Task.fromMap(json.decode(source));
}
