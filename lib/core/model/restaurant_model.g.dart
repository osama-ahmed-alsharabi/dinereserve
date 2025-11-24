// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'restaurant_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class RestaurantModelAdapter extends TypeAdapter<RestaurantModel> {
  @override
  final int typeId = 2;

  @override
  RestaurantModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return RestaurantModel(
      restaurantId: fields[0] as String?,
      restaurantName: fields[1] as String,
      restaurantPhone: fields[2] as String,
      restaurantType: fields[3] as String,
      openingTime: fields[4] as String,
      closingTime: fields[5] as String,
      location: fields[6] as String,
      tablesCount: fields[7] as int,
      fakeEmail: fields[8] as String?,
      password: fields[9] as String?,
      ownerId: fields[10] as String?,
      images: (fields[11] as List).cast<String>(),
      features: (fields[12] as List).cast<String>(),
      menu: (fields[13] as List).cast<String>(),
    );
  }

  @override
  void write(BinaryWriter writer, RestaurantModel obj) {
    writer
      ..writeByte(14)
      ..writeByte(0)
      ..write(obj.restaurantId)
      ..writeByte(1)
      ..write(obj.restaurantName)
      ..writeByte(2)
      ..write(obj.restaurantPhone)
      ..writeByte(3)
      ..write(obj.restaurantType)
      ..writeByte(4)
      ..write(obj.openingTime)
      ..writeByte(5)
      ..write(obj.closingTime)
      ..writeByte(6)
      ..write(obj.location)
      ..writeByte(7)
      ..write(obj.tablesCount)
      ..writeByte(8)
      ..write(obj.fakeEmail)
      ..writeByte(9)
      ..write(obj.password)
      ..writeByte(10)
      ..write(obj.ownerId)
      ..writeByte(11)
      ..write(obj.images)
      ..writeByte(12)
      ..write(obj.features)
      ..writeByte(13)
      ..write(obj.menu);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RestaurantModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
