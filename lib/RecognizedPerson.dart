class RecognizedInfo {
  final String name;
  final String upiId;

  RecognizedInfo({required this.name, required this.upiId});

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is RecognizedInfo && other.upiId == upiId;
  }

  @override
  int get hashCode => upiId.hashCode;
}
