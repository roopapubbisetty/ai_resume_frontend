import 'screening_model.dart';

class ScreeningHistoryModel {
  final List<ScreeningModel> items;
  final int totalCount;

  ScreeningHistoryModel({
    required this.items,
    required this.totalCount,
  });

  factory ScreeningHistoryModel.fromJson(Map<String, dynamic> json) {
    var rawItems = json['items'] as List? ?? [];
    List<ScreeningModel> list = rawItems
        .map((e) => ScreeningModel.fromJson(e as Map<String, dynamic>))
        .toList();
    return ScreeningHistoryModel(
      items: list,
      totalCount: json['totalCount'] ?? json['total_count'] ?? list.length,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'items': items.map((e) => e.toJson()).toList(),
      'totalCount': totalCount,
    };
  }
}
