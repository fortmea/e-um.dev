import 'dart:convert';

class DNSRecord {
  final int id;
  final DateTime createdAt;
  final String owner;
  final String name;
  final int type;
  final int status;
  final String target;
  final bool proxied;
  final String? cloudflareId;

  DNSRecord({
    required this.id,
    required this.createdAt,
    required this.owner,
    required this.name,
    required this.type,
    required this.status,
    required this.target,
    required this.proxied,
    this.cloudflareId,
  });

  factory DNSRecord.fromJson(Map<String, dynamic> json) {
    return DNSRecord(
      id: json['id'],
      createdAt: DateTime.parse(json['created_at']),
      owner: json['owner'],
      name: json['name'],
      type: json['type'],
      status: json['status'],
      target: json['target'],
      proxied: json['proxied'] == 'true',
      cloudflareId: json['cloudflareId'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'created_at': createdAt.toIso8601String(),
      'owner': owner,
      'name': name,
      'type': type,
      'status': status,
      'target': target,
      'proxied': proxied.toString(),
      'cloudflareId': cloudflareId,
    };
  }

  // Method to convert a list of Records from JSON
  static List<DNSRecord> listFromJson(String source) {
    final data = json.decode(source) as List;
    return data.map((e) => DNSRecord.fromJson(e)).toList();
  }

  // Method to convert a list of Records to JSON
  static String listToJson(List<DNSRecord> records) {
    final data = records.map((record) => record.toJson()).toList();
    return json.encode(data);
  }
}
