class TimeLineModel {
  String title;
  String time;
  TimeLineModel({required this.title, required this.time});
}

List<TimeLineModel> timeLineList = [
  TimeLineModel(title: 'Check In', time: '09:00 AM'),
  TimeLineModel(title: 'Tea Break', time: '10:00 AM'),
  TimeLineModel(title: 'Lunch', time: '12:00 PM'),
  TimeLineModel(title: 'Break', time: '02:00 PM'),
  TimeLineModel(title: 'Break', time: '04:00 PM'),
  TimeLineModel(title: 'Check Out', time: '05:00 PM'),
];

class HistoryModel {
  String category;
  String time;
  String date;
  HistoryModel(
      {required this.category, required this.time, required this.date});
}

List<HistoryModel> historyList = [
  HistoryModel(category: 'Check In', time: '09:00 AM', date: '12/12/2020'),
  HistoryModel(category: 'Break', time: '02:00 PM', date: '12/12/2020'),
  HistoryModel(category: 'Lunch', time: '12:00 PM', date: '12/12/2020'),
  HistoryModel(category: 'Tea Break', time: '10:00 AM', date: '12/12/2020'),
  HistoryModel(category: 'Check Out', time: '05:00 PM', date: '12/12/2020'),
];
