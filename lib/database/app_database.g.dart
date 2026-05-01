// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $ClientsTable extends Clients with TableInfo<$ClientsTable, Client> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ClientsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _themeColorMeta =
      const VerificationMeta('themeColor');
  @override
  late final GeneratedColumn<String> themeColor = GeneratedColumn<String>(
      'theme_color', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [id, name, themeColor];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'clients';
  @override
  VerificationContext validateIntegrity(Insertable<Client> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('theme_color')) {
      context.handle(
          _themeColorMeta,
          themeColor.isAcceptableOrUnknown(
              data['theme_color']!, _themeColorMeta));
    } else if (isInserting) {
      context.missing(_themeColorMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Client map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Client(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      themeColor: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}theme_color'])!,
    );
  }

  @override
  $ClientsTable createAlias(String alias) {
    return $ClientsTable(attachedDatabase, alias);
  }
}

class Client extends DataClass implements Insertable<Client> {
  final int id;
  final String name;
  final String themeColor;
  const Client(
      {required this.id, required this.name, required this.themeColor});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    map['theme_color'] = Variable<String>(themeColor);
    return map;
  }

  ClientsCompanion toCompanion(bool nullToAbsent) {
    return ClientsCompanion(
      id: Value(id),
      name: Value(name),
      themeColor: Value(themeColor),
    );
  }

  factory Client.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Client(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      themeColor: serializer.fromJson<String>(json['themeColor']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'themeColor': serializer.toJson<String>(themeColor),
    };
  }

  Client copyWith({int? id, String? name, String? themeColor}) => Client(
        id: id ?? this.id,
        name: name ?? this.name,
        themeColor: themeColor ?? this.themeColor,
      );
  Client copyWithCompanion(ClientsCompanion data) {
    return Client(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      themeColor:
          data.themeColor.present ? data.themeColor.value : this.themeColor,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Client(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('themeColor: $themeColor')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, themeColor);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Client &&
          other.id == this.id &&
          other.name == this.name &&
          other.themeColor == this.themeColor);
}

class ClientsCompanion extends UpdateCompanion<Client> {
  final Value<int> id;
  final Value<String> name;
  final Value<String> themeColor;
  const ClientsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.themeColor = const Value.absent(),
  });
  ClientsCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    required String themeColor,
  })  : name = Value(name),
        themeColor = Value(themeColor);
  static Insertable<Client> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<String>? themeColor,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (themeColor != null) 'theme_color': themeColor,
    });
  }

  ClientsCompanion copyWith(
      {Value<int>? id, Value<String>? name, Value<String>? themeColor}) {
    return ClientsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      themeColor: themeColor ?? this.themeColor,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (themeColor.present) {
      map['theme_color'] = Variable<String>(themeColor.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ClientsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('themeColor: $themeColor')
          ..write(')'))
        .toString();
  }
}

class $SitesTable extends Sites with TableInfo<$SitesTable, Site> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SitesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _clientIdMeta =
      const VerificationMeta('clientId');
  @override
  late final GeneratedColumn<int> clientId = GeneratedColumn<int>(
      'client_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES clients (id)'));
  static const VerificationMeta _branchNameMeta =
      const VerificationMeta('branchName');
  @override
  late final GeneratedColumn<String> branchName = GeneratedColumn<String>(
      'branch_name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _addressMeta =
      const VerificationMeta('address');
  @override
  late final GeneratedColumn<String> address = GeneratedColumn<String>(
      'address', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _latitudeMeta =
      const VerificationMeta('latitude');
  @override
  late final GeneratedColumn<double> latitude = GeneratedColumn<double>(
      'latitude', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _longitudeMeta =
      const VerificationMeta('longitude');
  @override
  late final GeneratedColumn<double> longitude = GeneratedColumn<double>(
      'longitude', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _regionMeta = const VerificationMeta('region');
  @override
  late final GeneratedColumn<String> region = GeneratedColumn<String>(
      'region', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns =>
      [id, clientId, branchName, address, latitude, longitude, region];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'sites';
  @override
  VerificationContext validateIntegrity(Insertable<Site> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('client_id')) {
      context.handle(_clientIdMeta,
          clientId.isAcceptableOrUnknown(data['client_id']!, _clientIdMeta));
    } else if (isInserting) {
      context.missing(_clientIdMeta);
    }
    if (data.containsKey('branch_name')) {
      context.handle(
          _branchNameMeta,
          branchName.isAcceptableOrUnknown(
              data['branch_name']!, _branchNameMeta));
    } else if (isInserting) {
      context.missing(_branchNameMeta);
    }
    if (data.containsKey('address')) {
      context.handle(_addressMeta,
          address.isAcceptableOrUnknown(data['address']!, _addressMeta));
    } else if (isInserting) {
      context.missing(_addressMeta);
    }
    if (data.containsKey('latitude')) {
      context.handle(_latitudeMeta,
          latitude.isAcceptableOrUnknown(data['latitude']!, _latitudeMeta));
    } else if (isInserting) {
      context.missing(_latitudeMeta);
    }
    if (data.containsKey('longitude')) {
      context.handle(_longitudeMeta,
          longitude.isAcceptableOrUnknown(data['longitude']!, _longitudeMeta));
    } else if (isInserting) {
      context.missing(_longitudeMeta);
    }
    if (data.containsKey('region')) {
      context.handle(_regionMeta,
          region.isAcceptableOrUnknown(data['region']!, _regionMeta));
    } else if (isInserting) {
      context.missing(_regionMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Site map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Site(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      clientId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}client_id'])!,
      branchName: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}branch_name'])!,
      address: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}address'])!,
      latitude: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}latitude'])!,
      longitude: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}longitude'])!,
      region: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}region'])!,
    );
  }

  @override
  $SitesTable createAlias(String alias) {
    return $SitesTable(attachedDatabase, alias);
  }
}

class Site extends DataClass implements Insertable<Site> {
  final int id;
  final int clientId;
  final String branchName;
  final String address;
  final double latitude;
  final double longitude;
  final String region;
  const Site(
      {required this.id,
      required this.clientId,
      required this.branchName,
      required this.address,
      required this.latitude,
      required this.longitude,
      required this.region});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['client_id'] = Variable<int>(clientId);
    map['branch_name'] = Variable<String>(branchName);
    map['address'] = Variable<String>(address);
    map['latitude'] = Variable<double>(latitude);
    map['longitude'] = Variable<double>(longitude);
    map['region'] = Variable<String>(region);
    return map;
  }

  SitesCompanion toCompanion(bool nullToAbsent) {
    return SitesCompanion(
      id: Value(id),
      clientId: Value(clientId),
      branchName: Value(branchName),
      address: Value(address),
      latitude: Value(latitude),
      longitude: Value(longitude),
      region: Value(region),
    );
  }

  factory Site.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Site(
      id: serializer.fromJson<int>(json['id']),
      clientId: serializer.fromJson<int>(json['clientId']),
      branchName: serializer.fromJson<String>(json['branchName']),
      address: serializer.fromJson<String>(json['address']),
      latitude: serializer.fromJson<double>(json['latitude']),
      longitude: serializer.fromJson<double>(json['longitude']),
      region: serializer.fromJson<String>(json['region']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'clientId': serializer.toJson<int>(clientId),
      'branchName': serializer.toJson<String>(branchName),
      'address': serializer.toJson<String>(address),
      'latitude': serializer.toJson<double>(latitude),
      'longitude': serializer.toJson<double>(longitude),
      'region': serializer.toJson<String>(region),
    };
  }

  Site copyWith(
          {int? id,
          int? clientId,
          String? branchName,
          String? address,
          double? latitude,
          double? longitude,
          String? region}) =>
      Site(
        id: id ?? this.id,
        clientId: clientId ?? this.clientId,
        branchName: branchName ?? this.branchName,
        address: address ?? this.address,
        latitude: latitude ?? this.latitude,
        longitude: longitude ?? this.longitude,
        region: region ?? this.region,
      );
  Site copyWithCompanion(SitesCompanion data) {
    return Site(
      id: data.id.present ? data.id.value : this.id,
      clientId: data.clientId.present ? data.clientId.value : this.clientId,
      branchName:
          data.branchName.present ? data.branchName.value : this.branchName,
      address: data.address.present ? data.address.value : this.address,
      latitude: data.latitude.present ? data.latitude.value : this.latitude,
      longitude: data.longitude.present ? data.longitude.value : this.longitude,
      region: data.region.present ? data.region.value : this.region,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Site(')
          ..write('id: $id, ')
          ..write('clientId: $clientId, ')
          ..write('branchName: $branchName, ')
          ..write('address: $address, ')
          ..write('latitude: $latitude, ')
          ..write('longitude: $longitude, ')
          ..write('region: $region')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id, clientId, branchName, address, latitude, longitude, region);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Site &&
          other.id == this.id &&
          other.clientId == this.clientId &&
          other.branchName == this.branchName &&
          other.address == this.address &&
          other.latitude == this.latitude &&
          other.longitude == this.longitude &&
          other.region == this.region);
}

class SitesCompanion extends UpdateCompanion<Site> {
  final Value<int> id;
  final Value<int> clientId;
  final Value<String> branchName;
  final Value<String> address;
  final Value<double> latitude;
  final Value<double> longitude;
  final Value<String> region;
  const SitesCompanion({
    this.id = const Value.absent(),
    this.clientId = const Value.absent(),
    this.branchName = const Value.absent(),
    this.address = const Value.absent(),
    this.latitude = const Value.absent(),
    this.longitude = const Value.absent(),
    this.region = const Value.absent(),
  });
  SitesCompanion.insert({
    this.id = const Value.absent(),
    required int clientId,
    required String branchName,
    required String address,
    required double latitude,
    required double longitude,
    required String region,
  })  : clientId = Value(clientId),
        branchName = Value(branchName),
        address = Value(address),
        latitude = Value(latitude),
        longitude = Value(longitude),
        region = Value(region);
  static Insertable<Site> custom({
    Expression<int>? id,
    Expression<int>? clientId,
    Expression<String>? branchName,
    Expression<String>? address,
    Expression<double>? latitude,
    Expression<double>? longitude,
    Expression<String>? region,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (clientId != null) 'client_id': clientId,
      if (branchName != null) 'branch_name': branchName,
      if (address != null) 'address': address,
      if (latitude != null) 'latitude': latitude,
      if (longitude != null) 'longitude': longitude,
      if (region != null) 'region': region,
    });
  }

  SitesCompanion copyWith(
      {Value<int>? id,
      Value<int>? clientId,
      Value<String>? branchName,
      Value<String>? address,
      Value<double>? latitude,
      Value<double>? longitude,
      Value<String>? region}) {
    return SitesCompanion(
      id: id ?? this.id,
      clientId: clientId ?? this.clientId,
      branchName: branchName ?? this.branchName,
      address: address ?? this.address,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      region: region ?? this.region,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (clientId.present) {
      map['client_id'] = Variable<int>(clientId.value);
    }
    if (branchName.present) {
      map['branch_name'] = Variable<String>(branchName.value);
    }
    if (address.present) {
      map['address'] = Variable<String>(address.value);
    }
    if (latitude.present) {
      map['latitude'] = Variable<double>(latitude.value);
    }
    if (longitude.present) {
      map['longitude'] = Variable<double>(longitude.value);
    }
    if (region.present) {
      map['region'] = Variable<String>(region.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SitesCompanion(')
          ..write('id: $id, ')
          ..write('clientId: $clientId, ')
          ..write('branchName: $branchName, ')
          ..write('address: $address, ')
          ..write('latitude: $latitude, ')
          ..write('longitude: $longitude, ')
          ..write('region: $region')
          ..write(')'))
        .toString();
  }
}

class $StartingPointsTable extends StartingPoints
    with TableInfo<$StartingPointsTable, StartingPoint> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $StartingPointsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _latitudeMeta =
      const VerificationMeta('latitude');
  @override
  late final GeneratedColumn<double> latitude = GeneratedColumn<double>(
      'latitude', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _longitudeMeta =
      const VerificationMeta('longitude');
  @override
  late final GeneratedColumn<double> longitude = GeneratedColumn<double>(
      'longitude', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [id, name, latitude, longitude];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'starting_points';
  @override
  VerificationContext validateIntegrity(Insertable<StartingPoint> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('latitude')) {
      context.handle(_latitudeMeta,
          latitude.isAcceptableOrUnknown(data['latitude']!, _latitudeMeta));
    } else if (isInserting) {
      context.missing(_latitudeMeta);
    }
    if (data.containsKey('longitude')) {
      context.handle(_longitudeMeta,
          longitude.isAcceptableOrUnknown(data['longitude']!, _longitudeMeta));
    } else if (isInserting) {
      context.missing(_longitudeMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  StartingPoint map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return StartingPoint(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      latitude: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}latitude'])!,
      longitude: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}longitude'])!,
    );
  }

  @override
  $StartingPointsTable createAlias(String alias) {
    return $StartingPointsTable(attachedDatabase, alias);
  }
}

class StartingPoint extends DataClass implements Insertable<StartingPoint> {
  final int id;
  final String name;
  final double latitude;
  final double longitude;
  const StartingPoint(
      {required this.id,
      required this.name,
      required this.latitude,
      required this.longitude});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    map['latitude'] = Variable<double>(latitude);
    map['longitude'] = Variable<double>(longitude);
    return map;
  }

  StartingPointsCompanion toCompanion(bool nullToAbsent) {
    return StartingPointsCompanion(
      id: Value(id),
      name: Value(name),
      latitude: Value(latitude),
      longitude: Value(longitude),
    );
  }

  factory StartingPoint.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return StartingPoint(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      latitude: serializer.fromJson<double>(json['latitude']),
      longitude: serializer.fromJson<double>(json['longitude']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'latitude': serializer.toJson<double>(latitude),
      'longitude': serializer.toJson<double>(longitude),
    };
  }

  StartingPoint copyWith(
          {int? id, String? name, double? latitude, double? longitude}) =>
      StartingPoint(
        id: id ?? this.id,
        name: name ?? this.name,
        latitude: latitude ?? this.latitude,
        longitude: longitude ?? this.longitude,
      );
  StartingPoint copyWithCompanion(StartingPointsCompanion data) {
    return StartingPoint(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      latitude: data.latitude.present ? data.latitude.value : this.latitude,
      longitude: data.longitude.present ? data.longitude.value : this.longitude,
    );
  }

  @override
  String toString() {
    return (StringBuffer('StartingPoint(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('latitude: $latitude, ')
          ..write('longitude: $longitude')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, latitude, longitude);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is StartingPoint &&
          other.id == this.id &&
          other.name == this.name &&
          other.latitude == this.latitude &&
          other.longitude == this.longitude);
}

class StartingPointsCompanion extends UpdateCompanion<StartingPoint> {
  final Value<int> id;
  final Value<String> name;
  final Value<double> latitude;
  final Value<double> longitude;
  const StartingPointsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.latitude = const Value.absent(),
    this.longitude = const Value.absent(),
  });
  StartingPointsCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    required double latitude,
    required double longitude,
  })  : name = Value(name),
        latitude = Value(latitude),
        longitude = Value(longitude);
  static Insertable<StartingPoint> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<double>? latitude,
    Expression<double>? longitude,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (latitude != null) 'latitude': latitude,
      if (longitude != null) 'longitude': longitude,
    });
  }

  StartingPointsCompanion copyWith(
      {Value<int>? id,
      Value<String>? name,
      Value<double>? latitude,
      Value<double>? longitude}) {
    return StartingPointsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (latitude.present) {
      map['latitude'] = Variable<double>(latitude.value);
    }
    if (longitude.present) {
      map['longitude'] = Variable<double>(longitude.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('StartingPointsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('latitude: $latitude, ')
          ..write('longitude: $longitude')
          ..write(')'))
        .toString();
  }
}

class $UsersTable extends Users with TableInfo<$UsersTable, User> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $UsersTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _usernameMeta =
      const VerificationMeta('username');
  @override
  late final GeneratedColumn<String> username = GeneratedColumn<String>(
      'username', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'));
  static const VerificationMeta _fullNameMeta =
      const VerificationMeta('fullName');
  @override
  late final GeneratedColumn<String> fullName = GeneratedColumn<String>(
      'full_name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _emailMeta = const VerificationMeta('email');
  @override
  late final GeneratedColumn<String> email = GeneratedColumn<String>(
      'email', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _roleMeta = const VerificationMeta('role');
  @override
  late final GeneratedColumn<String> role = GeneratedColumn<String>(
      'role', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _passwordMeta =
      const VerificationMeta('password');
  @override
  late final GeneratedColumn<String> password = GeneratedColumn<String>(
      'password', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant(''));
  static const VerificationMeta _dateOfBirthMeta =
      const VerificationMeta('dateOfBirth');
  @override
  late final GeneratedColumn<DateTime> dateOfBirth = GeneratedColumn<DateTime>(
      'date_of_birth', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _locationMeta =
      const VerificationMeta('location');
  @override
  late final GeneratedColumn<String> location = GeneratedColumn<String>(
      'location', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _phoneNumberMeta =
      const VerificationMeta('phoneNumber');
  @override
  late final GeneratedColumn<String> phoneNumber = GeneratedColumn<String>(
      'phone_number', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _bioMeta = const VerificationMeta('bio');
  @override
  late final GeneratedColumn<String> bio = GeneratedColumn<String>(
      'bio', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  static const VerificationMeta _windowsSidMeta =
      const VerificationMeta('windowsSid');
  @override
  late final GeneratedColumn<String> windowsSid = GeneratedColumn<String>(
      'windows_sid', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _lastLoginAtMeta =
      const VerificationMeta('lastLoginAt');
  @override
  late final GeneratedColumn<DateTime> lastLoginAt = GeneratedColumn<DateTime>(
      'last_login_at', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _loginCountMeta =
      const VerificationMeta('loginCount');
  @override
  late final GeneratedColumn<int> loginCount = GeneratedColumn<int>(
      'login_count', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  @override
  List<GeneratedColumn> get $columns => [
        id,
        username,
        fullName,
        email,
        role,
        password,
        dateOfBirth,
        location,
        phoneNumber,
        bio,
        createdAt,
        windowsSid,
        lastLoginAt,
        loginCount
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'users';
  @override
  VerificationContext validateIntegrity(Insertable<User> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('username')) {
      context.handle(_usernameMeta,
          username.isAcceptableOrUnknown(data['username']!, _usernameMeta));
    } else if (isInserting) {
      context.missing(_usernameMeta);
    }
    if (data.containsKey('full_name')) {
      context.handle(_fullNameMeta,
          fullName.isAcceptableOrUnknown(data['full_name']!, _fullNameMeta));
    } else if (isInserting) {
      context.missing(_fullNameMeta);
    }
    if (data.containsKey('email')) {
      context.handle(
          _emailMeta, email.isAcceptableOrUnknown(data['email']!, _emailMeta));
    } else if (isInserting) {
      context.missing(_emailMeta);
    }
    if (data.containsKey('role')) {
      context.handle(
          _roleMeta, role.isAcceptableOrUnknown(data['role']!, _roleMeta));
    } else if (isInserting) {
      context.missing(_roleMeta);
    }
    if (data.containsKey('password')) {
      context.handle(_passwordMeta,
          password.isAcceptableOrUnknown(data['password']!, _passwordMeta));
    }
    if (data.containsKey('date_of_birth')) {
      context.handle(
          _dateOfBirthMeta,
          dateOfBirth.isAcceptableOrUnknown(
              data['date_of_birth']!, _dateOfBirthMeta));
    }
    if (data.containsKey('location')) {
      context.handle(_locationMeta,
          location.isAcceptableOrUnknown(data['location']!, _locationMeta));
    }
    if (data.containsKey('phone_number')) {
      context.handle(
          _phoneNumberMeta,
          phoneNumber.isAcceptableOrUnknown(
              data['phone_number']!, _phoneNumberMeta));
    }
    if (data.containsKey('bio')) {
      context.handle(
          _bioMeta, bio.isAcceptableOrUnknown(data['bio']!, _bioMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    }
    if (data.containsKey('windows_sid')) {
      context.handle(
          _windowsSidMeta,
          windowsSid.isAcceptableOrUnknown(
              data['windows_sid']!, _windowsSidMeta));
    }
    if (data.containsKey('last_login_at')) {
      context.handle(
          _lastLoginAtMeta,
          lastLoginAt.isAcceptableOrUnknown(
              data['last_login_at']!, _lastLoginAtMeta));
    }
    if (data.containsKey('login_count')) {
      context.handle(
          _loginCountMeta,
          loginCount.isAcceptableOrUnknown(
              data['login_count']!, _loginCountMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  User map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return User(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      username: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}username'])!,
      fullName: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}full_name'])!,
      email: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}email'])!,
      role: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}role'])!,
      password: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}password'])!,
      dateOfBirth: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}date_of_birth']),
      location: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}location']),
      phoneNumber: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}phone_number']),
      bio: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}bio']),
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      windowsSid: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}windows_sid']),
      lastLoginAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}last_login_at']),
      loginCount: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}login_count'])!,
    );
  }

  @override
  $UsersTable createAlias(String alias) {
    return $UsersTable(attachedDatabase, alias);
  }
}

class User extends DataClass implements Insertable<User> {
  final int id;
  final String username;
  final String fullName;
  final String email;
  final String role;
  final String password;
  final DateTime? dateOfBirth;
  final String? location;
  final String? phoneNumber;
  final String? bio;
  final DateTime createdAt;
  final String? windowsSid;
  final DateTime? lastLoginAt;
  final int loginCount;
  const User(
      {required this.id,
      required this.username,
      required this.fullName,
      required this.email,
      required this.role,
      required this.password,
      this.dateOfBirth,
      this.location,
      this.phoneNumber,
      this.bio,
      required this.createdAt,
      this.windowsSid,
      this.lastLoginAt,
      required this.loginCount});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['username'] = Variable<String>(username);
    map['full_name'] = Variable<String>(fullName);
    map['email'] = Variable<String>(email);
    map['role'] = Variable<String>(role);
    map['password'] = Variable<String>(password);
    if (!nullToAbsent || dateOfBirth != null) {
      map['date_of_birth'] = Variable<DateTime>(dateOfBirth);
    }
    if (!nullToAbsent || location != null) {
      map['location'] = Variable<String>(location);
    }
    if (!nullToAbsent || phoneNumber != null) {
      map['phone_number'] = Variable<String>(phoneNumber);
    }
    if (!nullToAbsent || bio != null) {
      map['bio'] = Variable<String>(bio);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    if (!nullToAbsent || windowsSid != null) {
      map['windows_sid'] = Variable<String>(windowsSid);
    }
    if (!nullToAbsent || lastLoginAt != null) {
      map['last_login_at'] = Variable<DateTime>(lastLoginAt);
    }
    map['login_count'] = Variable<int>(loginCount);
    return map;
  }

  UsersCompanion toCompanion(bool nullToAbsent) {
    return UsersCompanion(
      id: Value(id),
      username: Value(username),
      fullName: Value(fullName),
      email: Value(email),
      role: Value(role),
      password: Value(password),
      dateOfBirth: dateOfBirth == null && nullToAbsent
          ? const Value.absent()
          : Value(dateOfBirth),
      location: location == null && nullToAbsent
          ? const Value.absent()
          : Value(location),
      phoneNumber: phoneNumber == null && nullToAbsent
          ? const Value.absent()
          : Value(phoneNumber),
      bio: bio == null && nullToAbsent ? const Value.absent() : Value(bio),
      createdAt: Value(createdAt),
      windowsSid: windowsSid == null && nullToAbsent
          ? const Value.absent()
          : Value(windowsSid),
      lastLoginAt: lastLoginAt == null && nullToAbsent
          ? const Value.absent()
          : Value(lastLoginAt),
      loginCount: Value(loginCount),
    );
  }

  factory User.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return User(
      id: serializer.fromJson<int>(json['id']),
      username: serializer.fromJson<String>(json['username']),
      fullName: serializer.fromJson<String>(json['fullName']),
      email: serializer.fromJson<String>(json['email']),
      role: serializer.fromJson<String>(json['role']),
      password: serializer.fromJson<String>(json['password']),
      dateOfBirth: serializer.fromJson<DateTime?>(json['dateOfBirth']),
      location: serializer.fromJson<String?>(json['location']),
      phoneNumber: serializer.fromJson<String?>(json['phoneNumber']),
      bio: serializer.fromJson<String?>(json['bio']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      windowsSid: serializer.fromJson<String?>(json['windowsSid']),
      lastLoginAt: serializer.fromJson<DateTime?>(json['lastLoginAt']),
      loginCount: serializer.fromJson<int>(json['loginCount']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'username': serializer.toJson<String>(username),
      'fullName': serializer.toJson<String>(fullName),
      'email': serializer.toJson<String>(email),
      'role': serializer.toJson<String>(role),
      'password': serializer.toJson<String>(password),
      'dateOfBirth': serializer.toJson<DateTime?>(dateOfBirth),
      'location': serializer.toJson<String?>(location),
      'phoneNumber': serializer.toJson<String?>(phoneNumber),
      'bio': serializer.toJson<String?>(bio),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'windowsSid': serializer.toJson<String?>(windowsSid),
      'lastLoginAt': serializer.toJson<DateTime?>(lastLoginAt),
      'loginCount': serializer.toJson<int>(loginCount),
    };
  }

  User copyWith(
          {int? id,
          String? username,
          String? fullName,
          String? email,
          String? role,
          String? password,
          Value<DateTime?> dateOfBirth = const Value.absent(),
          Value<String?> location = const Value.absent(),
          Value<String?> phoneNumber = const Value.absent(),
          Value<String?> bio = const Value.absent(),
          DateTime? createdAt,
          Value<String?> windowsSid = const Value.absent(),
          Value<DateTime?> lastLoginAt = const Value.absent(),
          int? loginCount}) =>
      User(
        id: id ?? this.id,
        username: username ?? this.username,
        fullName: fullName ?? this.fullName,
        email: email ?? this.email,
        role: role ?? this.role,
        password: password ?? this.password,
        dateOfBirth: dateOfBirth.present ? dateOfBirth.value : this.dateOfBirth,
        location: location.present ? location.value : this.location,
        phoneNumber: phoneNumber.present ? phoneNumber.value : this.phoneNumber,
        bio: bio.present ? bio.value : this.bio,
        createdAt: createdAt ?? this.createdAt,
        windowsSid: windowsSid.present ? windowsSid.value : this.windowsSid,
        lastLoginAt: lastLoginAt.present ? lastLoginAt.value : this.lastLoginAt,
        loginCount: loginCount ?? this.loginCount,
      );
  User copyWithCompanion(UsersCompanion data) {
    return User(
      id: data.id.present ? data.id.value : this.id,
      username: data.username.present ? data.username.value : this.username,
      fullName: data.fullName.present ? data.fullName.value : this.fullName,
      email: data.email.present ? data.email.value : this.email,
      role: data.role.present ? data.role.value : this.role,
      password: data.password.present ? data.password.value : this.password,
      dateOfBirth:
          data.dateOfBirth.present ? data.dateOfBirth.value : this.dateOfBirth,
      location: data.location.present ? data.location.value : this.location,
      phoneNumber:
          data.phoneNumber.present ? data.phoneNumber.value : this.phoneNumber,
      bio: data.bio.present ? data.bio.value : this.bio,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      windowsSid:
          data.windowsSid.present ? data.windowsSid.value : this.windowsSid,
      lastLoginAt:
          data.lastLoginAt.present ? data.lastLoginAt.value : this.lastLoginAt,
      loginCount:
          data.loginCount.present ? data.loginCount.value : this.loginCount,
    );
  }

  @override
  String toString() {
    return (StringBuffer('User(')
          ..write('id: $id, ')
          ..write('username: $username, ')
          ..write('fullName: $fullName, ')
          ..write('email: $email, ')
          ..write('role: $role, ')
          ..write('password: $password, ')
          ..write('dateOfBirth: $dateOfBirth, ')
          ..write('location: $location, ')
          ..write('phoneNumber: $phoneNumber, ')
          ..write('bio: $bio, ')
          ..write('createdAt: $createdAt, ')
          ..write('windowsSid: $windowsSid, ')
          ..write('lastLoginAt: $lastLoginAt, ')
          ..write('loginCount: $loginCount')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id,
      username,
      fullName,
      email,
      role,
      password,
      dateOfBirth,
      location,
      phoneNumber,
      bio,
      createdAt,
      windowsSid,
      lastLoginAt,
      loginCount);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is User &&
          other.id == this.id &&
          other.username == this.username &&
          other.fullName == this.fullName &&
          other.email == this.email &&
          other.role == this.role &&
          other.password == this.password &&
          other.dateOfBirth == this.dateOfBirth &&
          other.location == this.location &&
          other.phoneNumber == this.phoneNumber &&
          other.bio == this.bio &&
          other.createdAt == this.createdAt &&
          other.windowsSid == this.windowsSid &&
          other.lastLoginAt == this.lastLoginAt &&
          other.loginCount == this.loginCount);
}

class UsersCompanion extends UpdateCompanion<User> {
  final Value<int> id;
  final Value<String> username;
  final Value<String> fullName;
  final Value<String> email;
  final Value<String> role;
  final Value<String> password;
  final Value<DateTime?> dateOfBirth;
  final Value<String?> location;
  final Value<String?> phoneNumber;
  final Value<String?> bio;
  final Value<DateTime> createdAt;
  final Value<String?> windowsSid;
  final Value<DateTime?> lastLoginAt;
  final Value<int> loginCount;
  const UsersCompanion({
    this.id = const Value.absent(),
    this.username = const Value.absent(),
    this.fullName = const Value.absent(),
    this.email = const Value.absent(),
    this.role = const Value.absent(),
    this.password = const Value.absent(),
    this.dateOfBirth = const Value.absent(),
    this.location = const Value.absent(),
    this.phoneNumber = const Value.absent(),
    this.bio = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.windowsSid = const Value.absent(),
    this.lastLoginAt = const Value.absent(),
    this.loginCount = const Value.absent(),
  });
  UsersCompanion.insert({
    this.id = const Value.absent(),
    required String username,
    required String fullName,
    required String email,
    required String role,
    this.password = const Value.absent(),
    this.dateOfBirth = const Value.absent(),
    this.location = const Value.absent(),
    this.phoneNumber = const Value.absent(),
    this.bio = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.windowsSid = const Value.absent(),
    this.lastLoginAt = const Value.absent(),
    this.loginCount = const Value.absent(),
  })  : username = Value(username),
        fullName = Value(fullName),
        email = Value(email),
        role = Value(role);
  static Insertable<User> custom({
    Expression<int>? id,
    Expression<String>? username,
    Expression<String>? fullName,
    Expression<String>? email,
    Expression<String>? role,
    Expression<String>? password,
    Expression<DateTime>? dateOfBirth,
    Expression<String>? location,
    Expression<String>? phoneNumber,
    Expression<String>? bio,
    Expression<DateTime>? createdAt,
    Expression<String>? windowsSid,
    Expression<DateTime>? lastLoginAt,
    Expression<int>? loginCount,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (username != null) 'username': username,
      if (fullName != null) 'full_name': fullName,
      if (email != null) 'email': email,
      if (role != null) 'role': role,
      if (password != null) 'password': password,
      if (dateOfBirth != null) 'date_of_birth': dateOfBirth,
      if (location != null) 'location': location,
      if (phoneNumber != null) 'phone_number': phoneNumber,
      if (bio != null) 'bio': bio,
      if (createdAt != null) 'created_at': createdAt,
      if (windowsSid != null) 'windows_sid': windowsSid,
      if (lastLoginAt != null) 'last_login_at': lastLoginAt,
      if (loginCount != null) 'login_count': loginCount,
    });
  }

  UsersCompanion copyWith(
      {Value<int>? id,
      Value<String>? username,
      Value<String>? fullName,
      Value<String>? email,
      Value<String>? role,
      Value<String>? password,
      Value<DateTime?>? dateOfBirth,
      Value<String?>? location,
      Value<String?>? phoneNumber,
      Value<String?>? bio,
      Value<DateTime>? createdAt,
      Value<String?>? windowsSid,
      Value<DateTime?>? lastLoginAt,
      Value<int>? loginCount}) {
    return UsersCompanion(
      id: id ?? this.id,
      username: username ?? this.username,
      fullName: fullName ?? this.fullName,
      email: email ?? this.email,
      role: role ?? this.role,
      password: password ?? this.password,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      location: location ?? this.location,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      bio: bio ?? this.bio,
      createdAt: createdAt ?? this.createdAt,
      windowsSid: windowsSid ?? this.windowsSid,
      lastLoginAt: lastLoginAt ?? this.lastLoginAt,
      loginCount: loginCount ?? this.loginCount,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (username.present) {
      map['username'] = Variable<String>(username.value);
    }
    if (fullName.present) {
      map['full_name'] = Variable<String>(fullName.value);
    }
    if (email.present) {
      map['email'] = Variable<String>(email.value);
    }
    if (role.present) {
      map['role'] = Variable<String>(role.value);
    }
    if (password.present) {
      map['password'] = Variable<String>(password.value);
    }
    if (dateOfBirth.present) {
      map['date_of_birth'] = Variable<DateTime>(dateOfBirth.value);
    }
    if (location.present) {
      map['location'] = Variable<String>(location.value);
    }
    if (phoneNumber.present) {
      map['phone_number'] = Variable<String>(phoneNumber.value);
    }
    if (bio.present) {
      map['bio'] = Variable<String>(bio.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (windowsSid.present) {
      map['windows_sid'] = Variable<String>(windowsSid.value);
    }
    if (lastLoginAt.present) {
      map['last_login_at'] = Variable<DateTime>(lastLoginAt.value);
    }
    if (loginCount.present) {
      map['login_count'] = Variable<int>(loginCount.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('UsersCompanion(')
          ..write('id: $id, ')
          ..write('username: $username, ')
          ..write('fullName: $fullName, ')
          ..write('email: $email, ')
          ..write('role: $role, ')
          ..write('password: $password, ')
          ..write('dateOfBirth: $dateOfBirth, ')
          ..write('location: $location, ')
          ..write('phoneNumber: $phoneNumber, ')
          ..write('bio: $bio, ')
          ..write('createdAt: $createdAt, ')
          ..write('windowsSid: $windowsSid, ')
          ..write('lastLoginAt: $lastLoginAt, ')
          ..write('loginCount: $loginCount')
          ..write(')'))
        .toString();
  }
}

class $WeatherSnapshotTable extends WeatherSnapshot
    with TableInfo<$WeatherSnapshotTable, WeatherSnapshotData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $WeatherSnapshotTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _regionMeta = const VerificationMeta('region');
  @override
  late final GeneratedColumn<String> region = GeneratedColumn<String>(
      'region', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _temperatureMeta =
      const VerificationMeta('temperature');
  @override
  late final GeneratedColumn<int> temperature = GeneratedColumn<int>(
      'temperature', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _conditionMeta =
      const VerificationMeta('condition');
  @override
  late final GeneratedColumn<String> condition = GeneratedColumn<String>(
      'condition', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _fetchedAtMeta =
      const VerificationMeta('fetchedAt');
  @override
  late final GeneratedColumn<DateTime> fetchedAt = GeneratedColumn<DateTime>(
      'fetched_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _sourceMeta = const VerificationMeta('source');
  @override
  late final GeneratedColumn<String> source = GeneratedColumn<String>(
      'source', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _zipCodeMeta =
      const VerificationMeta('zipCode');
  @override
  late final GeneratedColumn<String> zipCode = GeneratedColumn<String>(
      'zip_code', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns =>
      [id, region, temperature, condition, fetchedAt, source, zipCode];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'weather_snapshot';
  @override
  VerificationContext validateIntegrity(
      Insertable<WeatherSnapshotData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('region')) {
      context.handle(_regionMeta,
          region.isAcceptableOrUnknown(data['region']!, _regionMeta));
    } else if (isInserting) {
      context.missing(_regionMeta);
    }
    if (data.containsKey('temperature')) {
      context.handle(
          _temperatureMeta,
          temperature.isAcceptableOrUnknown(
              data['temperature']!, _temperatureMeta));
    } else if (isInserting) {
      context.missing(_temperatureMeta);
    }
    if (data.containsKey('condition')) {
      context.handle(_conditionMeta,
          condition.isAcceptableOrUnknown(data['condition']!, _conditionMeta));
    } else if (isInserting) {
      context.missing(_conditionMeta);
    }
    if (data.containsKey('fetched_at')) {
      context.handle(_fetchedAtMeta,
          fetchedAt.isAcceptableOrUnknown(data['fetched_at']!, _fetchedAtMeta));
    } else if (isInserting) {
      context.missing(_fetchedAtMeta);
    }
    if (data.containsKey('source')) {
      context.handle(_sourceMeta,
          source.isAcceptableOrUnknown(data['source']!, _sourceMeta));
    } else if (isInserting) {
      context.missing(_sourceMeta);
    }
    if (data.containsKey('zip_code')) {
      context.handle(_zipCodeMeta,
          zipCode.isAcceptableOrUnknown(data['zip_code']!, _zipCodeMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  WeatherSnapshotData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return WeatherSnapshotData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      region: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}region'])!,
      temperature: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}temperature'])!,
      condition: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}condition'])!,
      fetchedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}fetched_at'])!,
      source: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}source'])!,
      zipCode: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}zip_code']),
    );
  }

  @override
  $WeatherSnapshotTable createAlias(String alias) {
    return $WeatherSnapshotTable(attachedDatabase, alias);
  }
}

class WeatherSnapshotData extends DataClass
    implements Insertable<WeatherSnapshotData> {
  final int id;
  final String region;
  final int temperature;
  final String condition;
  final DateTime fetchedAt;
  final String source;
  final String? zipCode;
  const WeatherSnapshotData(
      {required this.id,
      required this.region,
      required this.temperature,
      required this.condition,
      required this.fetchedAt,
      required this.source,
      this.zipCode});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['region'] = Variable<String>(region);
    map['temperature'] = Variable<int>(temperature);
    map['condition'] = Variable<String>(condition);
    map['fetched_at'] = Variable<DateTime>(fetchedAt);
    map['source'] = Variable<String>(source);
    if (!nullToAbsent || zipCode != null) {
      map['zip_code'] = Variable<String>(zipCode);
    }
    return map;
  }

  WeatherSnapshotCompanion toCompanion(bool nullToAbsent) {
    return WeatherSnapshotCompanion(
      id: Value(id),
      region: Value(region),
      temperature: Value(temperature),
      condition: Value(condition),
      fetchedAt: Value(fetchedAt),
      source: Value(source),
      zipCode: zipCode == null && nullToAbsent
          ? const Value.absent()
          : Value(zipCode),
    );
  }

  factory WeatherSnapshotData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return WeatherSnapshotData(
      id: serializer.fromJson<int>(json['id']),
      region: serializer.fromJson<String>(json['region']),
      temperature: serializer.fromJson<int>(json['temperature']),
      condition: serializer.fromJson<String>(json['condition']),
      fetchedAt: serializer.fromJson<DateTime>(json['fetchedAt']),
      source: serializer.fromJson<String>(json['source']),
      zipCode: serializer.fromJson<String?>(json['zipCode']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'region': serializer.toJson<String>(region),
      'temperature': serializer.toJson<int>(temperature),
      'condition': serializer.toJson<String>(condition),
      'fetchedAt': serializer.toJson<DateTime>(fetchedAt),
      'source': serializer.toJson<String>(source),
      'zipCode': serializer.toJson<String?>(zipCode),
    };
  }

  WeatherSnapshotData copyWith(
          {int? id,
          String? region,
          int? temperature,
          String? condition,
          DateTime? fetchedAt,
          String? source,
          Value<String?> zipCode = const Value.absent()}) =>
      WeatherSnapshotData(
        id: id ?? this.id,
        region: region ?? this.region,
        temperature: temperature ?? this.temperature,
        condition: condition ?? this.condition,
        fetchedAt: fetchedAt ?? this.fetchedAt,
        source: source ?? this.source,
        zipCode: zipCode.present ? zipCode.value : this.zipCode,
      );
  WeatherSnapshotData copyWithCompanion(WeatherSnapshotCompanion data) {
    return WeatherSnapshotData(
      id: data.id.present ? data.id.value : this.id,
      region: data.region.present ? data.region.value : this.region,
      temperature:
          data.temperature.present ? data.temperature.value : this.temperature,
      condition: data.condition.present ? data.condition.value : this.condition,
      fetchedAt: data.fetchedAt.present ? data.fetchedAt.value : this.fetchedAt,
      source: data.source.present ? data.source.value : this.source,
      zipCode: data.zipCode.present ? data.zipCode.value : this.zipCode,
    );
  }

  @override
  String toString() {
    return (StringBuffer('WeatherSnapshotData(')
          ..write('id: $id, ')
          ..write('region: $region, ')
          ..write('temperature: $temperature, ')
          ..write('condition: $condition, ')
          ..write('fetchedAt: $fetchedAt, ')
          ..write('source: $source, ')
          ..write('zipCode: $zipCode')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id, region, temperature, condition, fetchedAt, source, zipCode);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is WeatherSnapshotData &&
          other.id == this.id &&
          other.region == this.region &&
          other.temperature == this.temperature &&
          other.condition == this.condition &&
          other.fetchedAt == this.fetchedAt &&
          other.source == this.source &&
          other.zipCode == this.zipCode);
}

class WeatherSnapshotCompanion extends UpdateCompanion<WeatherSnapshotData> {
  final Value<int> id;
  final Value<String> region;
  final Value<int> temperature;
  final Value<String> condition;
  final Value<DateTime> fetchedAt;
  final Value<String> source;
  final Value<String?> zipCode;
  const WeatherSnapshotCompanion({
    this.id = const Value.absent(),
    this.region = const Value.absent(),
    this.temperature = const Value.absent(),
    this.condition = const Value.absent(),
    this.fetchedAt = const Value.absent(),
    this.source = const Value.absent(),
    this.zipCode = const Value.absent(),
  });
  WeatherSnapshotCompanion.insert({
    this.id = const Value.absent(),
    required String region,
    required int temperature,
    required String condition,
    required DateTime fetchedAt,
    required String source,
    this.zipCode = const Value.absent(),
  })  : region = Value(region),
        temperature = Value(temperature),
        condition = Value(condition),
        fetchedAt = Value(fetchedAt),
        source = Value(source);
  static Insertable<WeatherSnapshotData> custom({
    Expression<int>? id,
    Expression<String>? region,
    Expression<int>? temperature,
    Expression<String>? condition,
    Expression<DateTime>? fetchedAt,
    Expression<String>? source,
    Expression<String>? zipCode,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (region != null) 'region': region,
      if (temperature != null) 'temperature': temperature,
      if (condition != null) 'condition': condition,
      if (fetchedAt != null) 'fetched_at': fetchedAt,
      if (source != null) 'source': source,
      if (zipCode != null) 'zip_code': zipCode,
    });
  }

  WeatherSnapshotCompanion copyWith(
      {Value<int>? id,
      Value<String>? region,
      Value<int>? temperature,
      Value<String>? condition,
      Value<DateTime>? fetchedAt,
      Value<String>? source,
      Value<String?>? zipCode}) {
    return WeatherSnapshotCompanion(
      id: id ?? this.id,
      region: region ?? this.region,
      temperature: temperature ?? this.temperature,
      condition: condition ?? this.condition,
      fetchedAt: fetchedAt ?? this.fetchedAt,
      source: source ?? this.source,
      zipCode: zipCode ?? this.zipCode,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (region.present) {
      map['region'] = Variable<String>(region.value);
    }
    if (temperature.present) {
      map['temperature'] = Variable<int>(temperature.value);
    }
    if (condition.present) {
      map['condition'] = Variable<String>(condition.value);
    }
    if (fetchedAt.present) {
      map['fetched_at'] = Variable<DateTime>(fetchedAt.value);
    }
    if (source.present) {
      map['source'] = Variable<String>(source.value);
    }
    if (zipCode.present) {
      map['zip_code'] = Variable<String>(zipCode.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('WeatherSnapshotCompanion(')
          ..write('id: $id, ')
          ..write('region: $region, ')
          ..write('temperature: $temperature, ')
          ..write('condition: $condition, ')
          ..write('fetchedAt: $fetchedAt, ')
          ..write('source: $source, ')
          ..write('zipCode: $zipCode')
          ..write(')'))
        .toString();
  }
}

class $TrafficSnapshotTable extends TrafficSnapshot
    with TableInfo<$TrafficSnapshotTable, TrafficSnapshotData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TrafficSnapshotTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _routeLabelMeta =
      const VerificationMeta('routeLabel');
  @override
  late final GeneratedColumn<String> routeLabel = GeneratedColumn<String>(
      'route_label', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _etaMinutesMeta =
      const VerificationMeta('etaMinutes');
  @override
  late final GeneratedColumn<int> etaMinutes = GeneratedColumn<int>(
      'eta_minutes', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _conditionLabelMeta =
      const VerificationMeta('conditionLabel');
  @override
  late final GeneratedColumn<String> conditionLabel = GeneratedColumn<String>(
      'condition_label', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _fetchedAtMeta =
      const VerificationMeta('fetchedAt');
  @override
  late final GeneratedColumn<DateTime> fetchedAt = GeneratedColumn<DateTime>(
      'fetched_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _sourceMeta = const VerificationMeta('source');
  @override
  late final GeneratedColumn<String> source = GeneratedColumn<String>(
      'source', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns =>
      [id, routeLabel, etaMinutes, conditionLabel, fetchedAt, source];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'traffic_snapshot';
  @override
  VerificationContext validateIntegrity(
      Insertable<TrafficSnapshotData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('route_label')) {
      context.handle(
          _routeLabelMeta,
          routeLabel.isAcceptableOrUnknown(
              data['route_label']!, _routeLabelMeta));
    } else if (isInserting) {
      context.missing(_routeLabelMeta);
    }
    if (data.containsKey('eta_minutes')) {
      context.handle(
          _etaMinutesMeta,
          etaMinutes.isAcceptableOrUnknown(
              data['eta_minutes']!, _etaMinutesMeta));
    } else if (isInserting) {
      context.missing(_etaMinutesMeta);
    }
    if (data.containsKey('condition_label')) {
      context.handle(
          _conditionLabelMeta,
          conditionLabel.isAcceptableOrUnknown(
              data['condition_label']!, _conditionLabelMeta));
    } else if (isInserting) {
      context.missing(_conditionLabelMeta);
    }
    if (data.containsKey('fetched_at')) {
      context.handle(_fetchedAtMeta,
          fetchedAt.isAcceptableOrUnknown(data['fetched_at']!, _fetchedAtMeta));
    } else if (isInserting) {
      context.missing(_fetchedAtMeta);
    }
    if (data.containsKey('source')) {
      context.handle(_sourceMeta,
          source.isAcceptableOrUnknown(data['source']!, _sourceMeta));
    } else if (isInserting) {
      context.missing(_sourceMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  TrafficSnapshotData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return TrafficSnapshotData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      routeLabel: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}route_label'])!,
      etaMinutes: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}eta_minutes'])!,
      conditionLabel: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}condition_label'])!,
      fetchedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}fetched_at'])!,
      source: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}source'])!,
    );
  }

  @override
  $TrafficSnapshotTable createAlias(String alias) {
    return $TrafficSnapshotTable(attachedDatabase, alias);
  }
}

class TrafficSnapshotData extends DataClass
    implements Insertable<TrafficSnapshotData> {
  final int id;
  final String routeLabel;
  final int etaMinutes;
  final String conditionLabel;
  final DateTime fetchedAt;
  final String source;
  const TrafficSnapshotData(
      {required this.id,
      required this.routeLabel,
      required this.etaMinutes,
      required this.conditionLabel,
      required this.fetchedAt,
      required this.source});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['route_label'] = Variable<String>(routeLabel);
    map['eta_minutes'] = Variable<int>(etaMinutes);
    map['condition_label'] = Variable<String>(conditionLabel);
    map['fetched_at'] = Variable<DateTime>(fetchedAt);
    map['source'] = Variable<String>(source);
    return map;
  }

  TrafficSnapshotCompanion toCompanion(bool nullToAbsent) {
    return TrafficSnapshotCompanion(
      id: Value(id),
      routeLabel: Value(routeLabel),
      etaMinutes: Value(etaMinutes),
      conditionLabel: Value(conditionLabel),
      fetchedAt: Value(fetchedAt),
      source: Value(source),
    );
  }

  factory TrafficSnapshotData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return TrafficSnapshotData(
      id: serializer.fromJson<int>(json['id']),
      routeLabel: serializer.fromJson<String>(json['routeLabel']),
      etaMinutes: serializer.fromJson<int>(json['etaMinutes']),
      conditionLabel: serializer.fromJson<String>(json['conditionLabel']),
      fetchedAt: serializer.fromJson<DateTime>(json['fetchedAt']),
      source: serializer.fromJson<String>(json['source']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'routeLabel': serializer.toJson<String>(routeLabel),
      'etaMinutes': serializer.toJson<int>(etaMinutes),
      'conditionLabel': serializer.toJson<String>(conditionLabel),
      'fetchedAt': serializer.toJson<DateTime>(fetchedAt),
      'source': serializer.toJson<String>(source),
    };
  }

  TrafficSnapshotData copyWith(
          {int? id,
          String? routeLabel,
          int? etaMinutes,
          String? conditionLabel,
          DateTime? fetchedAt,
          String? source}) =>
      TrafficSnapshotData(
        id: id ?? this.id,
        routeLabel: routeLabel ?? this.routeLabel,
        etaMinutes: etaMinutes ?? this.etaMinutes,
        conditionLabel: conditionLabel ?? this.conditionLabel,
        fetchedAt: fetchedAt ?? this.fetchedAt,
        source: source ?? this.source,
      );
  TrafficSnapshotData copyWithCompanion(TrafficSnapshotCompanion data) {
    return TrafficSnapshotData(
      id: data.id.present ? data.id.value : this.id,
      routeLabel:
          data.routeLabel.present ? data.routeLabel.value : this.routeLabel,
      etaMinutes:
          data.etaMinutes.present ? data.etaMinutes.value : this.etaMinutes,
      conditionLabel: data.conditionLabel.present
          ? data.conditionLabel.value
          : this.conditionLabel,
      fetchedAt: data.fetchedAt.present ? data.fetchedAt.value : this.fetchedAt,
      source: data.source.present ? data.source.value : this.source,
    );
  }

  @override
  String toString() {
    return (StringBuffer('TrafficSnapshotData(')
          ..write('id: $id, ')
          ..write('routeLabel: $routeLabel, ')
          ..write('etaMinutes: $etaMinutes, ')
          ..write('conditionLabel: $conditionLabel, ')
          ..write('fetchedAt: $fetchedAt, ')
          ..write('source: $source')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id, routeLabel, etaMinutes, conditionLabel, fetchedAt, source);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is TrafficSnapshotData &&
          other.id == this.id &&
          other.routeLabel == this.routeLabel &&
          other.etaMinutes == this.etaMinutes &&
          other.conditionLabel == this.conditionLabel &&
          other.fetchedAt == this.fetchedAt &&
          other.source == this.source);
}

class TrafficSnapshotCompanion extends UpdateCompanion<TrafficSnapshotData> {
  final Value<int> id;
  final Value<String> routeLabel;
  final Value<int> etaMinutes;
  final Value<String> conditionLabel;
  final Value<DateTime> fetchedAt;
  final Value<String> source;
  const TrafficSnapshotCompanion({
    this.id = const Value.absent(),
    this.routeLabel = const Value.absent(),
    this.etaMinutes = const Value.absent(),
    this.conditionLabel = const Value.absent(),
    this.fetchedAt = const Value.absent(),
    this.source = const Value.absent(),
  });
  TrafficSnapshotCompanion.insert({
    this.id = const Value.absent(),
    required String routeLabel,
    required int etaMinutes,
    required String conditionLabel,
    required DateTime fetchedAt,
    required String source,
  })  : routeLabel = Value(routeLabel),
        etaMinutes = Value(etaMinutes),
        conditionLabel = Value(conditionLabel),
        fetchedAt = Value(fetchedAt),
        source = Value(source);
  static Insertable<TrafficSnapshotData> custom({
    Expression<int>? id,
    Expression<String>? routeLabel,
    Expression<int>? etaMinutes,
    Expression<String>? conditionLabel,
    Expression<DateTime>? fetchedAt,
    Expression<String>? source,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (routeLabel != null) 'route_label': routeLabel,
      if (etaMinutes != null) 'eta_minutes': etaMinutes,
      if (conditionLabel != null) 'condition_label': conditionLabel,
      if (fetchedAt != null) 'fetched_at': fetchedAt,
      if (source != null) 'source': source,
    });
  }

  TrafficSnapshotCompanion copyWith(
      {Value<int>? id,
      Value<String>? routeLabel,
      Value<int>? etaMinutes,
      Value<String>? conditionLabel,
      Value<DateTime>? fetchedAt,
      Value<String>? source}) {
    return TrafficSnapshotCompanion(
      id: id ?? this.id,
      routeLabel: routeLabel ?? this.routeLabel,
      etaMinutes: etaMinutes ?? this.etaMinutes,
      conditionLabel: conditionLabel ?? this.conditionLabel,
      fetchedAt: fetchedAt ?? this.fetchedAt,
      source: source ?? this.source,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (routeLabel.present) {
      map['route_label'] = Variable<String>(routeLabel.value);
    }
    if (etaMinutes.present) {
      map['eta_minutes'] = Variable<int>(etaMinutes.value);
    }
    if (conditionLabel.present) {
      map['condition_label'] = Variable<String>(conditionLabel.value);
    }
    if (fetchedAt.present) {
      map['fetched_at'] = Variable<DateTime>(fetchedAt.value);
    }
    if (source.present) {
      map['source'] = Variable<String>(source.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TrafficSnapshotCompanion(')
          ..write('id: $id, ')
          ..write('routeLabel: $routeLabel, ')
          ..write('etaMinutes: $etaMinutes, ')
          ..write('conditionLabel: $conditionLabel, ')
          ..write('fetchedAt: $fetchedAt, ')
          ..write('source: $source')
          ..write(')'))
        .toString();
  }
}

class $WorkCallsTable extends WorkCalls
    with TableInfo<$WorkCallsTable, WorkCall> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $WorkCallsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
      'status', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _scheduledAtMeta =
      const VerificationMeta('scheduledAt');
  @override
  late final GeneratedColumn<DateTime> scheduledAt = GeneratedColumn<DateTime>(
      'scheduled_at', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _completedAtMeta =
      const VerificationMeta('completedAt');
  @override
  late final GeneratedColumn<DateTime> completedAt = GeneratedColumn<DateTime>(
      'completed_at', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _workOrderNumberMeta =
      const VerificationMeta('workOrderNumber');
  @override
  late final GeneratedColumn<String> workOrderNumber = GeneratedColumn<String>(
      'work_order_number', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns =>
      [id, status, scheduledAt, completedAt, workOrderNumber];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'work_calls';
  @override
  VerificationContext validateIntegrity(Insertable<WorkCall> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('status')) {
      context.handle(_statusMeta,
          status.isAcceptableOrUnknown(data['status']!, _statusMeta));
    } else if (isInserting) {
      context.missing(_statusMeta);
    }
    if (data.containsKey('scheduled_at')) {
      context.handle(
          _scheduledAtMeta,
          scheduledAt.isAcceptableOrUnknown(
              data['scheduled_at']!, _scheduledAtMeta));
    }
    if (data.containsKey('completed_at')) {
      context.handle(
          _completedAtMeta,
          completedAt.isAcceptableOrUnknown(
              data['completed_at']!, _completedAtMeta));
    }
    if (data.containsKey('work_order_number')) {
      context.handle(
          _workOrderNumberMeta,
          workOrderNumber.isAcceptableOrUnknown(
              data['work_order_number']!, _workOrderNumberMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  WorkCall map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return WorkCall(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      status: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}status'])!,
      scheduledAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}scheduled_at']),
      completedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}completed_at']),
      workOrderNumber: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}work_order_number']),
    );
  }

  @override
  $WorkCallsTable createAlias(String alias) {
    return $WorkCallsTable(attachedDatabase, alias);
  }
}

class WorkCall extends DataClass implements Insertable<WorkCall> {
  final int id;
  final String status;
  final DateTime? scheduledAt;
  final DateTime? completedAt;
  final String? workOrderNumber;
  const WorkCall(
      {required this.id,
      required this.status,
      this.scheduledAt,
      this.completedAt,
      this.workOrderNumber});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['status'] = Variable<String>(status);
    if (!nullToAbsent || scheduledAt != null) {
      map['scheduled_at'] = Variable<DateTime>(scheduledAt);
    }
    if (!nullToAbsent || completedAt != null) {
      map['completed_at'] = Variable<DateTime>(completedAt);
    }
    if (!nullToAbsent || workOrderNumber != null) {
      map['work_order_number'] = Variable<String>(workOrderNumber);
    }
    return map;
  }

  WorkCallsCompanion toCompanion(bool nullToAbsent) {
    return WorkCallsCompanion(
      id: Value(id),
      status: Value(status),
      scheduledAt: scheduledAt == null && nullToAbsent
          ? const Value.absent()
          : Value(scheduledAt),
      completedAt: completedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(completedAt),
      workOrderNumber: workOrderNumber == null && nullToAbsent
          ? const Value.absent()
          : Value(workOrderNumber),
    );
  }

  factory WorkCall.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return WorkCall(
      id: serializer.fromJson<int>(json['id']),
      status: serializer.fromJson<String>(json['status']),
      scheduledAt: serializer.fromJson<DateTime?>(json['scheduledAt']),
      completedAt: serializer.fromJson<DateTime?>(json['completedAt']),
      workOrderNumber: serializer.fromJson<String?>(json['workOrderNumber']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'status': serializer.toJson<String>(status),
      'scheduledAt': serializer.toJson<DateTime?>(scheduledAt),
      'completedAt': serializer.toJson<DateTime?>(completedAt),
      'workOrderNumber': serializer.toJson<String?>(workOrderNumber),
    };
  }

  WorkCall copyWith(
          {int? id,
          String? status,
          Value<DateTime?> scheduledAt = const Value.absent(),
          Value<DateTime?> completedAt = const Value.absent(),
          Value<String?> workOrderNumber = const Value.absent()}) =>
      WorkCall(
        id: id ?? this.id,
        status: status ?? this.status,
        scheduledAt: scheduledAt.present ? scheduledAt.value : this.scheduledAt,
        completedAt: completedAt.present ? completedAt.value : this.completedAt,
        workOrderNumber: workOrderNumber.present
            ? workOrderNumber.value
            : this.workOrderNumber,
      );
  WorkCall copyWithCompanion(WorkCallsCompanion data) {
    return WorkCall(
      id: data.id.present ? data.id.value : this.id,
      status: data.status.present ? data.status.value : this.status,
      scheduledAt:
          data.scheduledAt.present ? data.scheduledAt.value : this.scheduledAt,
      completedAt:
          data.completedAt.present ? data.completedAt.value : this.completedAt,
      workOrderNumber: data.workOrderNumber.present
          ? data.workOrderNumber.value
          : this.workOrderNumber,
    );
  }

  @override
  String toString() {
    return (StringBuffer('WorkCall(')
          ..write('id: $id, ')
          ..write('status: $status, ')
          ..write('scheduledAt: $scheduledAt, ')
          ..write('completedAt: $completedAt, ')
          ..write('workOrderNumber: $workOrderNumber')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, status, scheduledAt, completedAt, workOrderNumber);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is WorkCall &&
          other.id == this.id &&
          other.status == this.status &&
          other.scheduledAt == this.scheduledAt &&
          other.completedAt == this.completedAt &&
          other.workOrderNumber == this.workOrderNumber);
}

class WorkCallsCompanion extends UpdateCompanion<WorkCall> {
  final Value<int> id;
  final Value<String> status;
  final Value<DateTime?> scheduledAt;
  final Value<DateTime?> completedAt;
  final Value<String?> workOrderNumber;
  const WorkCallsCompanion({
    this.id = const Value.absent(),
    this.status = const Value.absent(),
    this.scheduledAt = const Value.absent(),
    this.completedAt = const Value.absent(),
    this.workOrderNumber = const Value.absent(),
  });
  WorkCallsCompanion.insert({
    this.id = const Value.absent(),
    required String status,
    this.scheduledAt = const Value.absent(),
    this.completedAt = const Value.absent(),
    this.workOrderNumber = const Value.absent(),
  }) : status = Value(status);
  static Insertable<WorkCall> custom({
    Expression<int>? id,
    Expression<String>? status,
    Expression<DateTime>? scheduledAt,
    Expression<DateTime>? completedAt,
    Expression<String>? workOrderNumber,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (status != null) 'status': status,
      if (scheduledAt != null) 'scheduled_at': scheduledAt,
      if (completedAt != null) 'completed_at': completedAt,
      if (workOrderNumber != null) 'work_order_number': workOrderNumber,
    });
  }

  WorkCallsCompanion copyWith(
      {Value<int>? id,
      Value<String>? status,
      Value<DateTime?>? scheduledAt,
      Value<DateTime?>? completedAt,
      Value<String?>? workOrderNumber}) {
    return WorkCallsCompanion(
      id: id ?? this.id,
      status: status ?? this.status,
      scheduledAt: scheduledAt ?? this.scheduledAt,
      completedAt: completedAt ?? this.completedAt,
      workOrderNumber: workOrderNumber ?? this.workOrderNumber,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (scheduledAt.present) {
      map['scheduled_at'] = Variable<DateTime>(scheduledAt.value);
    }
    if (completedAt.present) {
      map['completed_at'] = Variable<DateTime>(completedAt.value);
    }
    if (workOrderNumber.present) {
      map['work_order_number'] = Variable<String>(workOrderNumber.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('WorkCallsCompanion(')
          ..write('id: $id, ')
          ..write('status: $status, ')
          ..write('scheduledAt: $scheduledAt, ')
          ..write('completedAt: $completedAt, ')
          ..write('workOrderNumber: $workOrderNumber')
          ..write(')'))
        .toString();
  }
}

class $IndustryBriefingTable extends IndustryBriefing
    with TableInfo<$IndustryBriefingTable, IndustryBriefingData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $IndustryBriefingTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
      'title', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _sourceMeta = const VerificationMeta('source');
  @override
  late final GeneratedColumn<String> source = GeneratedColumn<String>(
      'source', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _previewImageMeta =
      const VerificationMeta('previewImage');
  @override
  late final GeneratedColumn<String> previewImage = GeneratedColumn<String>(
      'preview_image', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _publishedAtMeta =
      const VerificationMeta('publishedAt');
  @override
  late final GeneratedColumn<DateTime> publishedAt = GeneratedColumn<DateTime>(
      'published_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _fetchedAtMeta =
      const VerificationMeta('fetchedAt');
  @override
  late final GeneratedColumn<DateTime> fetchedAt = GeneratedColumn<DateTime>(
      'fetched_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns =>
      [id, title, source, previewImage, publishedAt, fetchedAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'industry_briefing';
  @override
  VerificationContext validateIntegrity(
      Insertable<IndustryBriefingData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('title')) {
      context.handle(
          _titleMeta, title.isAcceptableOrUnknown(data['title']!, _titleMeta));
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('source')) {
      context.handle(_sourceMeta,
          source.isAcceptableOrUnknown(data['source']!, _sourceMeta));
    } else if (isInserting) {
      context.missing(_sourceMeta);
    }
    if (data.containsKey('preview_image')) {
      context.handle(
          _previewImageMeta,
          previewImage.isAcceptableOrUnknown(
              data['preview_image']!, _previewImageMeta));
    }
    if (data.containsKey('published_at')) {
      context.handle(
          _publishedAtMeta,
          publishedAt.isAcceptableOrUnknown(
              data['published_at']!, _publishedAtMeta));
    } else if (isInserting) {
      context.missing(_publishedAtMeta);
    }
    if (data.containsKey('fetched_at')) {
      context.handle(_fetchedAtMeta,
          fetchedAt.isAcceptableOrUnknown(data['fetched_at']!, _fetchedAtMeta));
    } else if (isInserting) {
      context.missing(_fetchedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  IndustryBriefingData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return IndustryBriefingData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      title: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}title'])!,
      source: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}source'])!,
      previewImage: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}preview_image']),
      publishedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}published_at'])!,
      fetchedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}fetched_at'])!,
    );
  }

  @override
  $IndustryBriefingTable createAlias(String alias) {
    return $IndustryBriefingTable(attachedDatabase, alias);
  }
}

class IndustryBriefingData extends DataClass
    implements Insertable<IndustryBriefingData> {
  final int id;
  final String title;
  final String source;
  final String? previewImage;
  final DateTime publishedAt;
  final DateTime fetchedAt;
  const IndustryBriefingData(
      {required this.id,
      required this.title,
      required this.source,
      this.previewImage,
      required this.publishedAt,
      required this.fetchedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['title'] = Variable<String>(title);
    map['source'] = Variable<String>(source);
    if (!nullToAbsent || previewImage != null) {
      map['preview_image'] = Variable<String>(previewImage);
    }
    map['published_at'] = Variable<DateTime>(publishedAt);
    map['fetched_at'] = Variable<DateTime>(fetchedAt);
    return map;
  }

  IndustryBriefingCompanion toCompanion(bool nullToAbsent) {
    return IndustryBriefingCompanion(
      id: Value(id),
      title: Value(title),
      source: Value(source),
      previewImage: previewImage == null && nullToAbsent
          ? const Value.absent()
          : Value(previewImage),
      publishedAt: Value(publishedAt),
      fetchedAt: Value(fetchedAt),
    );
  }

  factory IndustryBriefingData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return IndustryBriefingData(
      id: serializer.fromJson<int>(json['id']),
      title: serializer.fromJson<String>(json['title']),
      source: serializer.fromJson<String>(json['source']),
      previewImage: serializer.fromJson<String?>(json['previewImage']),
      publishedAt: serializer.fromJson<DateTime>(json['publishedAt']),
      fetchedAt: serializer.fromJson<DateTime>(json['fetchedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'title': serializer.toJson<String>(title),
      'source': serializer.toJson<String>(source),
      'previewImage': serializer.toJson<String?>(previewImage),
      'publishedAt': serializer.toJson<DateTime>(publishedAt),
      'fetchedAt': serializer.toJson<DateTime>(fetchedAt),
    };
  }

  IndustryBriefingData copyWith(
          {int? id,
          String? title,
          String? source,
          Value<String?> previewImage = const Value.absent(),
          DateTime? publishedAt,
          DateTime? fetchedAt}) =>
      IndustryBriefingData(
        id: id ?? this.id,
        title: title ?? this.title,
        source: source ?? this.source,
        previewImage:
            previewImage.present ? previewImage.value : this.previewImage,
        publishedAt: publishedAt ?? this.publishedAt,
        fetchedAt: fetchedAt ?? this.fetchedAt,
      );
  IndustryBriefingData copyWithCompanion(IndustryBriefingCompanion data) {
    return IndustryBriefingData(
      id: data.id.present ? data.id.value : this.id,
      title: data.title.present ? data.title.value : this.title,
      source: data.source.present ? data.source.value : this.source,
      previewImage: data.previewImage.present
          ? data.previewImage.value
          : this.previewImage,
      publishedAt:
          data.publishedAt.present ? data.publishedAt.value : this.publishedAt,
      fetchedAt: data.fetchedAt.present ? data.fetchedAt.value : this.fetchedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('IndustryBriefingData(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('source: $source, ')
          ..write('previewImage: $previewImage, ')
          ..write('publishedAt: $publishedAt, ')
          ..write('fetchedAt: $fetchedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, title, source, previewImage, publishedAt, fetchedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is IndustryBriefingData &&
          other.id == this.id &&
          other.title == this.title &&
          other.source == this.source &&
          other.previewImage == this.previewImage &&
          other.publishedAt == this.publishedAt &&
          other.fetchedAt == this.fetchedAt);
}

class IndustryBriefingCompanion extends UpdateCompanion<IndustryBriefingData> {
  final Value<int> id;
  final Value<String> title;
  final Value<String> source;
  final Value<String?> previewImage;
  final Value<DateTime> publishedAt;
  final Value<DateTime> fetchedAt;
  const IndustryBriefingCompanion({
    this.id = const Value.absent(),
    this.title = const Value.absent(),
    this.source = const Value.absent(),
    this.previewImage = const Value.absent(),
    this.publishedAt = const Value.absent(),
    this.fetchedAt = const Value.absent(),
  });
  IndustryBriefingCompanion.insert({
    this.id = const Value.absent(),
    required String title,
    required String source,
    this.previewImage = const Value.absent(),
    required DateTime publishedAt,
    required DateTime fetchedAt,
  })  : title = Value(title),
        source = Value(source),
        publishedAt = Value(publishedAt),
        fetchedAt = Value(fetchedAt);
  static Insertable<IndustryBriefingData> custom({
    Expression<int>? id,
    Expression<String>? title,
    Expression<String>? source,
    Expression<String>? previewImage,
    Expression<DateTime>? publishedAt,
    Expression<DateTime>? fetchedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (title != null) 'title': title,
      if (source != null) 'source': source,
      if (previewImage != null) 'preview_image': previewImage,
      if (publishedAt != null) 'published_at': publishedAt,
      if (fetchedAt != null) 'fetched_at': fetchedAt,
    });
  }

  IndustryBriefingCompanion copyWith(
      {Value<int>? id,
      Value<String>? title,
      Value<String>? source,
      Value<String?>? previewImage,
      Value<DateTime>? publishedAt,
      Value<DateTime>? fetchedAt}) {
    return IndustryBriefingCompanion(
      id: id ?? this.id,
      title: title ?? this.title,
      source: source ?? this.source,
      previewImage: previewImage ?? this.previewImage,
      publishedAt: publishedAt ?? this.publishedAt,
      fetchedAt: fetchedAt ?? this.fetchedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (source.present) {
      map['source'] = Variable<String>(source.value);
    }
    if (previewImage.present) {
      map['preview_image'] = Variable<String>(previewImage.value);
    }
    if (publishedAt.present) {
      map['published_at'] = Variable<DateTime>(publishedAt.value);
    }
    if (fetchedAt.present) {
      map['fetched_at'] = Variable<DateTime>(fetchedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('IndustryBriefingCompanion(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('source: $source, ')
          ..write('previewImage: $previewImage, ')
          ..write('publishedAt: $publishedAt, ')
          ..write('fetchedAt: $fetchedAt')
          ..write(')'))
        .toString();
  }
}

class $CompanyAnnouncementsTable extends CompanyAnnouncements
    with TableInfo<$CompanyAnnouncementsTable, CompanyAnnouncement> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CompanyAnnouncementsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _categoryMeta =
      const VerificationMeta('category');
  @override
  late final GeneratedColumn<String> category = GeneratedColumn<String>(
      'category', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
      'title', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _bodyMeta = const VerificationMeta('body');
  @override
  late final GeneratedColumn<String> body = GeneratedColumn<String>(
      'body', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _actionLabelMeta =
      const VerificationMeta('actionLabel');
  @override
  late final GeneratedColumn<String> actionLabel = GeneratedColumn<String>(
      'action_label', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _activeMeta = const VerificationMeta('active');
  @override
  late final GeneratedColumn<bool> active = GeneratedColumn<bool>(
      'active', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("active" IN (0, 1))'),
      defaultValue: const Constant(true));
  static const VerificationMeta _publishedAtMeta =
      const VerificationMeta('publishedAt');
  @override
  late final GeneratedColumn<DateTime> publishedAt = GeneratedColumn<DateTime>(
      'published_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _acknowledgedMeta =
      const VerificationMeta('acknowledged');
  @override
  late final GeneratedColumn<bool> acknowledged = GeneratedColumn<bool>(
      'acknowledged', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("acknowledged" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _acknowledgedAtMeta =
      const VerificationMeta('acknowledgedAt');
  @override
  late final GeneratedColumn<DateTime> acknowledgedAt =
      GeneratedColumn<DateTime>('acknowledged_at', aliasedName, true,
          type: DriftSqlType.dateTime, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        category,
        title,
        body,
        actionLabel,
        active,
        publishedAt,
        acknowledged,
        acknowledgedAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'company_announcements';
  @override
  VerificationContext validateIntegrity(
      Insertable<CompanyAnnouncement> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('category')) {
      context.handle(_categoryMeta,
          category.isAcceptableOrUnknown(data['category']!, _categoryMeta));
    } else if (isInserting) {
      context.missing(_categoryMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
          _titleMeta, title.isAcceptableOrUnknown(data['title']!, _titleMeta));
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('body')) {
      context.handle(
          _bodyMeta, body.isAcceptableOrUnknown(data['body']!, _bodyMeta));
    } else if (isInserting) {
      context.missing(_bodyMeta);
    }
    if (data.containsKey('action_label')) {
      context.handle(
          _actionLabelMeta,
          actionLabel.isAcceptableOrUnknown(
              data['action_label']!, _actionLabelMeta));
    }
    if (data.containsKey('active')) {
      context.handle(_activeMeta,
          active.isAcceptableOrUnknown(data['active']!, _activeMeta));
    }
    if (data.containsKey('published_at')) {
      context.handle(
          _publishedAtMeta,
          publishedAt.isAcceptableOrUnknown(
              data['published_at']!, _publishedAtMeta));
    } else if (isInserting) {
      context.missing(_publishedAtMeta);
    }
    if (data.containsKey('acknowledged')) {
      context.handle(
          _acknowledgedMeta,
          acknowledged.isAcceptableOrUnknown(
              data['acknowledged']!, _acknowledgedMeta));
    }
    if (data.containsKey('acknowledged_at')) {
      context.handle(
          _acknowledgedAtMeta,
          acknowledgedAt.isAcceptableOrUnknown(
              data['acknowledged_at']!, _acknowledgedAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  CompanyAnnouncement map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CompanyAnnouncement(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      category: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}category'])!,
      title: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}title'])!,
      body: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}body'])!,
      actionLabel: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}action_label']),
      active: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}active'])!,
      publishedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}published_at'])!,
      acknowledged: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}acknowledged'])!,
      acknowledgedAt: attachedDatabase.typeMapping.read(
          DriftSqlType.dateTime, data['${effectivePrefix}acknowledged_at']),
    );
  }

  @override
  $CompanyAnnouncementsTable createAlias(String alias) {
    return $CompanyAnnouncementsTable(attachedDatabase, alias);
  }
}

class CompanyAnnouncement extends DataClass
    implements Insertable<CompanyAnnouncement> {
  final int id;
  final String category;
  final String title;
  final String body;
  final String? actionLabel;
  final bool active;
  final DateTime publishedAt;
  final bool acknowledged;
  final DateTime? acknowledgedAt;
  const CompanyAnnouncement(
      {required this.id,
      required this.category,
      required this.title,
      required this.body,
      this.actionLabel,
      required this.active,
      required this.publishedAt,
      required this.acknowledged,
      this.acknowledgedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['category'] = Variable<String>(category);
    map['title'] = Variable<String>(title);
    map['body'] = Variable<String>(body);
    if (!nullToAbsent || actionLabel != null) {
      map['action_label'] = Variable<String>(actionLabel);
    }
    map['active'] = Variable<bool>(active);
    map['published_at'] = Variable<DateTime>(publishedAt);
    map['acknowledged'] = Variable<bool>(acknowledged);
    if (!nullToAbsent || acknowledgedAt != null) {
      map['acknowledged_at'] = Variable<DateTime>(acknowledgedAt);
    }
    return map;
  }

  CompanyAnnouncementsCompanion toCompanion(bool nullToAbsent) {
    return CompanyAnnouncementsCompanion(
      id: Value(id),
      category: Value(category),
      title: Value(title),
      body: Value(body),
      actionLabel: actionLabel == null && nullToAbsent
          ? const Value.absent()
          : Value(actionLabel),
      active: Value(active),
      publishedAt: Value(publishedAt),
      acknowledged: Value(acknowledged),
      acknowledgedAt: acknowledgedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(acknowledgedAt),
    );
  }

  factory CompanyAnnouncement.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CompanyAnnouncement(
      id: serializer.fromJson<int>(json['id']),
      category: serializer.fromJson<String>(json['category']),
      title: serializer.fromJson<String>(json['title']),
      body: serializer.fromJson<String>(json['body']),
      actionLabel: serializer.fromJson<String?>(json['actionLabel']),
      active: serializer.fromJson<bool>(json['active']),
      publishedAt: serializer.fromJson<DateTime>(json['publishedAt']),
      acknowledged: serializer.fromJson<bool>(json['acknowledged']),
      acknowledgedAt: serializer.fromJson<DateTime?>(json['acknowledgedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'category': serializer.toJson<String>(category),
      'title': serializer.toJson<String>(title),
      'body': serializer.toJson<String>(body),
      'actionLabel': serializer.toJson<String?>(actionLabel),
      'active': serializer.toJson<bool>(active),
      'publishedAt': serializer.toJson<DateTime>(publishedAt),
      'acknowledged': serializer.toJson<bool>(acknowledged),
      'acknowledgedAt': serializer.toJson<DateTime?>(acknowledgedAt),
    };
  }

  CompanyAnnouncement copyWith(
          {int? id,
          String? category,
          String? title,
          String? body,
          Value<String?> actionLabel = const Value.absent(),
          bool? active,
          DateTime? publishedAt,
          bool? acknowledged,
          Value<DateTime?> acknowledgedAt = const Value.absent()}) =>
      CompanyAnnouncement(
        id: id ?? this.id,
        category: category ?? this.category,
        title: title ?? this.title,
        body: body ?? this.body,
        actionLabel: actionLabel.present ? actionLabel.value : this.actionLabel,
        active: active ?? this.active,
        publishedAt: publishedAt ?? this.publishedAt,
        acknowledged: acknowledged ?? this.acknowledged,
        acknowledgedAt:
            acknowledgedAt.present ? acknowledgedAt.value : this.acknowledgedAt,
      );
  CompanyAnnouncement copyWithCompanion(CompanyAnnouncementsCompanion data) {
    return CompanyAnnouncement(
      id: data.id.present ? data.id.value : this.id,
      category: data.category.present ? data.category.value : this.category,
      title: data.title.present ? data.title.value : this.title,
      body: data.body.present ? data.body.value : this.body,
      actionLabel:
          data.actionLabel.present ? data.actionLabel.value : this.actionLabel,
      active: data.active.present ? data.active.value : this.active,
      publishedAt:
          data.publishedAt.present ? data.publishedAt.value : this.publishedAt,
      acknowledged: data.acknowledged.present
          ? data.acknowledged.value
          : this.acknowledged,
      acknowledgedAt: data.acknowledgedAt.present
          ? data.acknowledgedAt.value
          : this.acknowledgedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CompanyAnnouncement(')
          ..write('id: $id, ')
          ..write('category: $category, ')
          ..write('title: $title, ')
          ..write('body: $body, ')
          ..write('actionLabel: $actionLabel, ')
          ..write('active: $active, ')
          ..write('publishedAt: $publishedAt, ')
          ..write('acknowledged: $acknowledged, ')
          ..write('acknowledgedAt: $acknowledgedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, category, title, body, actionLabel,
      active, publishedAt, acknowledged, acknowledgedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CompanyAnnouncement &&
          other.id == this.id &&
          other.category == this.category &&
          other.title == this.title &&
          other.body == this.body &&
          other.actionLabel == this.actionLabel &&
          other.active == this.active &&
          other.publishedAt == this.publishedAt &&
          other.acknowledged == this.acknowledged &&
          other.acknowledgedAt == this.acknowledgedAt);
}

class CompanyAnnouncementsCompanion
    extends UpdateCompanion<CompanyAnnouncement> {
  final Value<int> id;
  final Value<String> category;
  final Value<String> title;
  final Value<String> body;
  final Value<String?> actionLabel;
  final Value<bool> active;
  final Value<DateTime> publishedAt;
  final Value<bool> acknowledged;
  final Value<DateTime?> acknowledgedAt;
  const CompanyAnnouncementsCompanion({
    this.id = const Value.absent(),
    this.category = const Value.absent(),
    this.title = const Value.absent(),
    this.body = const Value.absent(),
    this.actionLabel = const Value.absent(),
    this.active = const Value.absent(),
    this.publishedAt = const Value.absent(),
    this.acknowledged = const Value.absent(),
    this.acknowledgedAt = const Value.absent(),
  });
  CompanyAnnouncementsCompanion.insert({
    this.id = const Value.absent(),
    required String category,
    required String title,
    required String body,
    this.actionLabel = const Value.absent(),
    this.active = const Value.absent(),
    required DateTime publishedAt,
    this.acknowledged = const Value.absent(),
    this.acknowledgedAt = const Value.absent(),
  })  : category = Value(category),
        title = Value(title),
        body = Value(body),
        publishedAt = Value(publishedAt);
  static Insertable<CompanyAnnouncement> custom({
    Expression<int>? id,
    Expression<String>? category,
    Expression<String>? title,
    Expression<String>? body,
    Expression<String>? actionLabel,
    Expression<bool>? active,
    Expression<DateTime>? publishedAt,
    Expression<bool>? acknowledged,
    Expression<DateTime>? acknowledgedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (category != null) 'category': category,
      if (title != null) 'title': title,
      if (body != null) 'body': body,
      if (actionLabel != null) 'action_label': actionLabel,
      if (active != null) 'active': active,
      if (publishedAt != null) 'published_at': publishedAt,
      if (acknowledged != null) 'acknowledged': acknowledged,
      if (acknowledgedAt != null) 'acknowledged_at': acknowledgedAt,
    });
  }

  CompanyAnnouncementsCompanion copyWith(
      {Value<int>? id,
      Value<String>? category,
      Value<String>? title,
      Value<String>? body,
      Value<String?>? actionLabel,
      Value<bool>? active,
      Value<DateTime>? publishedAt,
      Value<bool>? acknowledged,
      Value<DateTime?>? acknowledgedAt}) {
    return CompanyAnnouncementsCompanion(
      id: id ?? this.id,
      category: category ?? this.category,
      title: title ?? this.title,
      body: body ?? this.body,
      actionLabel: actionLabel ?? this.actionLabel,
      active: active ?? this.active,
      publishedAt: publishedAt ?? this.publishedAt,
      acknowledged: acknowledged ?? this.acknowledged,
      acknowledgedAt: acknowledgedAt ?? this.acknowledgedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (category.present) {
      map['category'] = Variable<String>(category.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (body.present) {
      map['body'] = Variable<String>(body.value);
    }
    if (actionLabel.present) {
      map['action_label'] = Variable<String>(actionLabel.value);
    }
    if (active.present) {
      map['active'] = Variable<bool>(active.value);
    }
    if (publishedAt.present) {
      map['published_at'] = Variable<DateTime>(publishedAt.value);
    }
    if (acknowledged.present) {
      map['acknowledged'] = Variable<bool>(acknowledged.value);
    }
    if (acknowledgedAt.present) {
      map['acknowledged_at'] = Variable<DateTime>(acknowledgedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CompanyAnnouncementsCompanion(')
          ..write('id: $id, ')
          ..write('category: $category, ')
          ..write('title: $title, ')
          ..write('body: $body, ')
          ..write('actionLabel: $actionLabel, ')
          ..write('active: $active, ')
          ..write('publishedAt: $publishedAt, ')
          ..write('acknowledged: $acknowledged, ')
          ..write('acknowledgedAt: $acknowledgedAt')
          ..write(')'))
        .toString();
  }
}

class $WorkOrdersTable extends WorkOrders
    with TableInfo<$WorkOrdersTable, WorkOrder> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $WorkOrdersTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _siteIdMeta = const VerificationMeta('siteId');
  @override
  late final GeneratedColumn<int> siteId = GeneratedColumn<int>(
      'site_id', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
      'status', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _priorityMeta =
      const VerificationMeta('priority');
  @override
  late final GeneratedColumn<String> priority = GeneratedColumn<String>(
      'priority', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _descriptionOfWorkMeta =
      const VerificationMeta('descriptionOfWork');
  @override
  late final GeneratedColumn<String> descriptionOfWork =
      GeneratedColumn<String>('description_of_work', aliasedName, true,
          type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _internalNotesMeta =
      const VerificationMeta('internalNotes');
  @override
  late final GeneratedColumn<String> internalNotes = GeneratedColumn<String>(
      'internal_notes', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _closedAtMeta =
      const VerificationMeta('closedAt');
  @override
  late final GeneratedColumn<DateTime> closedAt = GeneratedColumn<DateTime>(
      'closed_at', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _createdByMeta =
      const VerificationMeta('createdBy');
  @override
  late final GeneratedColumn<String> createdBy = GeneratedColumn<String>(
      'created_by', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _assignedTechnicianMeta =
      const VerificationMeta('assignedTechnician');
  @override
  late final GeneratedColumn<String> assignedTechnician =
      GeneratedColumn<String>('assigned_technician', aliasedName, true,
          type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _completionNotesMeta =
      const VerificationMeta('completionNotes');
  @override
  late final GeneratedColumn<String> completionNotes = GeneratedColumn<String>(
      'completion_notes', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _resolutionMeta =
      const VerificationMeta('resolution');
  @override
  late final GeneratedColumn<String> resolution = GeneratedColumn<String>(
      'resolution', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _repeatIssueMeta =
      const VerificationMeta('repeatIssue');
  @override
  late final GeneratedColumn<bool> repeatIssue = GeneratedColumn<bool>(
      'repeat_issue', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("repeat_issue" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _previousStatusMeta =
      const VerificationMeta('previousStatus');
  @override
  late final GeneratedColumn<String> previousStatus = GeneratedColumn<String>(
      'previous_status', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _statusChangedByMeta =
      const VerificationMeta('statusChangedBy');
  @override
  late final GeneratedColumn<int> statusChangedBy = GeneratedColumn<int>(
      'status_changed_by', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _statusChangedAtMeta =
      const VerificationMeta('statusChangedAt');
  @override
  late final GeneratedColumn<DateTime> statusChangedAt =
      GeneratedColumn<DateTime>('status_changed_at', aliasedName, true,
          type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _workflowStateMeta =
      const VerificationMeta('workflowState');
  @override
  late final GeneratedColumn<String> workflowState = GeneratedColumn<String>(
      'workflow_state', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('draft'));
  static const VerificationMeta _approvalStatusMeta =
      const VerificationMeta('approvalStatus');
  @override
  late final GeneratedColumn<String> approvalStatus = GeneratedColumn<String>(
      'approval_status', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _approvedByMeta =
      const VerificationMeta('approvedBy');
  @override
  late final GeneratedColumn<int> approvedBy = GeneratedColumn<int>(
      'approved_by', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _approvedAtMeta =
      const VerificationMeta('approvedAt');
  @override
  late final GeneratedColumn<DateTime> approvedAt = GeneratedColumn<DateTime>(
      'approved_at', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _versionMeta =
      const VerificationMeta('version');
  @override
  late final GeneratedColumn<int> version = GeneratedColumn<int>(
      'version', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(1));
  static const VerificationMeta _expectedDateMeta =
      const VerificationMeta('expectedDate');
  @override
  late final GeneratedColumn<DateTime> expectedDate = GeneratedColumn<DateTime>(
      'expected_date', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _expectedDurationMinutesMeta =
      const VerificationMeta('expectedDurationMinutes');
  @override
  late final GeneratedColumn<int> expectedDurationMinutes =
      GeneratedColumn<int>('expected_duration_minutes', aliasedName, true,
          type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _contactPersonMeta =
      const VerificationMeta('contactPerson');
  @override
  late final GeneratedColumn<String> contactPerson = GeneratedColumn<String>(
      'contact_person', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _contactPhoneMeta =
      const VerificationMeta('contactPhone');
  @override
  late final GeneratedColumn<String> contactPhone = GeneratedColumn<String>(
      'contact_phone', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _contactEmailMeta =
      const VerificationMeta('contactEmail');
  @override
  late final GeneratedColumn<String> contactEmail = GeneratedColumn<String>(
      'contact_email', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _billingContactNameMeta =
      const VerificationMeta('billingContactName');
  @override
  late final GeneratedColumn<String> billingContactName =
      GeneratedColumn<String>('billing_contact_name', aliasedName, true,
          type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _billingContactEmailMeta =
      const VerificationMeta('billingContactEmail');
  @override
  late final GeneratedColumn<String> billingContactEmail =
      GeneratedColumn<String>('billing_contact_email', aliasedName, true,
          type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _billingAddressMeta =
      const VerificationMeta('billingAddress');
  @override
  late final GeneratedColumn<String> billingAddress = GeneratedColumn<String>(
      'billing_address', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _copsAccountMeta =
      const VerificationMeta('copsAccount');
  @override
  late final GeneratedColumn<String> copsAccount = GeneratedColumn<String>(
      'cops_account', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _cmsAccountMeta =
      const VerificationMeta('cmsAccount');
  @override
  late final GeneratedColumn<String> cmsAccount = GeneratedColumn<String>(
      'cms_account', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _alarmNetAccountMeta =
      const VerificationMeta('alarmNetAccount');
  @override
  late final GeneratedColumn<String> alarmNetAccount = GeneratedColumn<String>(
      'alarm_net_account', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _ictAccountMeta =
      const VerificationMeta('ictAccount');
  @override
  late final GeneratedColumn<String> ictAccount = GeneratedColumn<String>(
      'ict_account', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _alarmDotComAccountMeta =
      const VerificationMeta('alarmDotComAccount');
  @override
  late final GeneratedColumn<String> alarmDotComAccount =
      GeneratedColumn<String>('alarm_dot_com_account', aliasedName, true,
          type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _telguardAccountMeta =
      const VerificationMeta('telguardAccount');
  @override
  late final GeneratedColumn<String> telguardAccount = GeneratedColumn<String>(
      'telguard_account', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _openEyeLicenseMeta =
      const VerificationMeta('openEyeLicense');
  @override
  late final GeneratedColumn<String> openEyeLicense = GeneratedColumn<String>(
      'open_eye_license', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _onServiceContractMeta =
      const VerificationMeta('onServiceContract');
  @override
  late final GeneratedColumn<bool> onServiceContract = GeneratedColumn<bool>(
      'on_service_contract', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("on_service_contract" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _contractTypeMeta =
      const VerificationMeta('contractType');
  @override
  late final GeneratedColumn<String> contractType = GeneratedColumn<String>(
      'contract_type', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _referenceNumberMeta =
      const VerificationMeta('referenceNumber');
  @override
  late final GeneratedColumn<String> referenceNumber = GeneratedColumn<String>(
      'reference_number', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _poNumberMeta =
      const VerificationMeta('poNumber');
  @override
  late final GeneratedColumn<String> poNumber = GeneratedColumn<String>(
      'po_number', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        siteId,
        status,
        priority,
        descriptionOfWork,
        internalNotes,
        createdAt,
        closedAt,
        createdBy,
        assignedTechnician,
        completionNotes,
        resolution,
        repeatIssue,
        previousStatus,
        statusChangedBy,
        statusChangedAt,
        workflowState,
        approvalStatus,
        approvedBy,
        approvedAt,
        version,
        expectedDate,
        expectedDurationMinutes,
        contactPerson,
        contactPhone,
        contactEmail,
        billingContactName,
        billingContactEmail,
        billingAddress,
        copsAccount,
        cmsAccount,
        alarmNetAccount,
        ictAccount,
        alarmDotComAccount,
        telguardAccount,
        openEyeLicense,
        onServiceContract,
        contractType,
        referenceNumber,
        poNumber
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'work_orders';
  @override
  VerificationContext validateIntegrity(Insertable<WorkOrder> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('site_id')) {
      context.handle(_siteIdMeta,
          siteId.isAcceptableOrUnknown(data['site_id']!, _siteIdMeta));
    } else if (isInserting) {
      context.missing(_siteIdMeta);
    }
    if (data.containsKey('status')) {
      context.handle(_statusMeta,
          status.isAcceptableOrUnknown(data['status']!, _statusMeta));
    } else if (isInserting) {
      context.missing(_statusMeta);
    }
    if (data.containsKey('priority')) {
      context.handle(_priorityMeta,
          priority.isAcceptableOrUnknown(data['priority']!, _priorityMeta));
    }
    if (data.containsKey('description_of_work')) {
      context.handle(
          _descriptionOfWorkMeta,
          descriptionOfWork.isAcceptableOrUnknown(
              data['description_of_work']!, _descriptionOfWorkMeta));
    }
    if (data.containsKey('internal_notes')) {
      context.handle(
          _internalNotesMeta,
          internalNotes.isAcceptableOrUnknown(
              data['internal_notes']!, _internalNotesMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('closed_at')) {
      context.handle(_closedAtMeta,
          closedAt.isAcceptableOrUnknown(data['closed_at']!, _closedAtMeta));
    }
    if (data.containsKey('created_by')) {
      context.handle(_createdByMeta,
          createdBy.isAcceptableOrUnknown(data['created_by']!, _createdByMeta));
    }
    if (data.containsKey('assigned_technician')) {
      context.handle(
          _assignedTechnicianMeta,
          assignedTechnician.isAcceptableOrUnknown(
              data['assigned_technician']!, _assignedTechnicianMeta));
    }
    if (data.containsKey('completion_notes')) {
      context.handle(
          _completionNotesMeta,
          completionNotes.isAcceptableOrUnknown(
              data['completion_notes']!, _completionNotesMeta));
    }
    if (data.containsKey('resolution')) {
      context.handle(
          _resolutionMeta,
          resolution.isAcceptableOrUnknown(
              data['resolution']!, _resolutionMeta));
    }
    if (data.containsKey('repeat_issue')) {
      context.handle(
          _repeatIssueMeta,
          repeatIssue.isAcceptableOrUnknown(
              data['repeat_issue']!, _repeatIssueMeta));
    }
    if (data.containsKey('previous_status')) {
      context.handle(
          _previousStatusMeta,
          previousStatus.isAcceptableOrUnknown(
              data['previous_status']!, _previousStatusMeta));
    }
    if (data.containsKey('status_changed_by')) {
      context.handle(
          _statusChangedByMeta,
          statusChangedBy.isAcceptableOrUnknown(
              data['status_changed_by']!, _statusChangedByMeta));
    }
    if (data.containsKey('status_changed_at')) {
      context.handle(
          _statusChangedAtMeta,
          statusChangedAt.isAcceptableOrUnknown(
              data['status_changed_at']!, _statusChangedAtMeta));
    }
    if (data.containsKey('workflow_state')) {
      context.handle(
          _workflowStateMeta,
          workflowState.isAcceptableOrUnknown(
              data['workflow_state']!, _workflowStateMeta));
    }
    if (data.containsKey('approval_status')) {
      context.handle(
          _approvalStatusMeta,
          approvalStatus.isAcceptableOrUnknown(
              data['approval_status']!, _approvalStatusMeta));
    }
    if (data.containsKey('approved_by')) {
      context.handle(
          _approvedByMeta,
          approvedBy.isAcceptableOrUnknown(
              data['approved_by']!, _approvedByMeta));
    }
    if (data.containsKey('approved_at')) {
      context.handle(
          _approvedAtMeta,
          approvedAt.isAcceptableOrUnknown(
              data['approved_at']!, _approvedAtMeta));
    }
    if (data.containsKey('version')) {
      context.handle(_versionMeta,
          version.isAcceptableOrUnknown(data['version']!, _versionMeta));
    }
    if (data.containsKey('expected_date')) {
      context.handle(
          _expectedDateMeta,
          expectedDate.isAcceptableOrUnknown(
              data['expected_date']!, _expectedDateMeta));
    }
    if (data.containsKey('expected_duration_minutes')) {
      context.handle(
          _expectedDurationMinutesMeta,
          expectedDurationMinutes.isAcceptableOrUnknown(
              data['expected_duration_minutes']!,
              _expectedDurationMinutesMeta));
    }
    if (data.containsKey('contact_person')) {
      context.handle(
          _contactPersonMeta,
          contactPerson.isAcceptableOrUnknown(
              data['contact_person']!, _contactPersonMeta));
    }
    if (data.containsKey('contact_phone')) {
      context.handle(
          _contactPhoneMeta,
          contactPhone.isAcceptableOrUnknown(
              data['contact_phone']!, _contactPhoneMeta));
    }
    if (data.containsKey('contact_email')) {
      context.handle(
          _contactEmailMeta,
          contactEmail.isAcceptableOrUnknown(
              data['contact_email']!, _contactEmailMeta));
    }
    if (data.containsKey('billing_contact_name')) {
      context.handle(
          _billingContactNameMeta,
          billingContactName.isAcceptableOrUnknown(
              data['billing_contact_name']!, _billingContactNameMeta));
    }
    if (data.containsKey('billing_contact_email')) {
      context.handle(
          _billingContactEmailMeta,
          billingContactEmail.isAcceptableOrUnknown(
              data['billing_contact_email']!, _billingContactEmailMeta));
    }
    if (data.containsKey('billing_address')) {
      context.handle(
          _billingAddressMeta,
          billingAddress.isAcceptableOrUnknown(
              data['billing_address']!, _billingAddressMeta));
    }
    if (data.containsKey('cops_account')) {
      context.handle(
          _copsAccountMeta,
          copsAccount.isAcceptableOrUnknown(
              data['cops_account']!, _copsAccountMeta));
    }
    if (data.containsKey('cms_account')) {
      context.handle(
          _cmsAccountMeta,
          cmsAccount.isAcceptableOrUnknown(
              data['cms_account']!, _cmsAccountMeta));
    }
    if (data.containsKey('alarm_net_account')) {
      context.handle(
          _alarmNetAccountMeta,
          alarmNetAccount.isAcceptableOrUnknown(
              data['alarm_net_account']!, _alarmNetAccountMeta));
    }
    if (data.containsKey('ict_account')) {
      context.handle(
          _ictAccountMeta,
          ictAccount.isAcceptableOrUnknown(
              data['ict_account']!, _ictAccountMeta));
    }
    if (data.containsKey('alarm_dot_com_account')) {
      context.handle(
          _alarmDotComAccountMeta,
          alarmDotComAccount.isAcceptableOrUnknown(
              data['alarm_dot_com_account']!, _alarmDotComAccountMeta));
    }
    if (data.containsKey('telguard_account')) {
      context.handle(
          _telguardAccountMeta,
          telguardAccount.isAcceptableOrUnknown(
              data['telguard_account']!, _telguardAccountMeta));
    }
    if (data.containsKey('open_eye_license')) {
      context.handle(
          _openEyeLicenseMeta,
          openEyeLicense.isAcceptableOrUnknown(
              data['open_eye_license']!, _openEyeLicenseMeta));
    }
    if (data.containsKey('on_service_contract')) {
      context.handle(
          _onServiceContractMeta,
          onServiceContract.isAcceptableOrUnknown(
              data['on_service_contract']!, _onServiceContractMeta));
    }
    if (data.containsKey('contract_type')) {
      context.handle(
          _contractTypeMeta,
          contractType.isAcceptableOrUnknown(
              data['contract_type']!, _contractTypeMeta));
    }
    if (data.containsKey('reference_number')) {
      context.handle(
          _referenceNumberMeta,
          referenceNumber.isAcceptableOrUnknown(
              data['reference_number']!, _referenceNumberMeta));
    }
    if (data.containsKey('po_number')) {
      context.handle(_poNumberMeta,
          poNumber.isAcceptableOrUnknown(data['po_number']!, _poNumberMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  WorkOrder map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return WorkOrder(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      siteId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}site_id'])!,
      status: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}status'])!,
      priority: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}priority']),
      descriptionOfWork: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}description_of_work']),
      internalNotes: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}internal_notes']),
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      closedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}closed_at']),
      createdBy: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}created_by']),
      assignedTechnician: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}assigned_technician']),
      completionNotes: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}completion_notes']),
      resolution: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}resolution']),
      repeatIssue: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}repeat_issue'])!,
      previousStatus: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}previous_status']),
      statusChangedBy: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}status_changed_by']),
      statusChangedAt: attachedDatabase.typeMapping.read(
          DriftSqlType.dateTime, data['${effectivePrefix}status_changed_at']),
      workflowState: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}workflow_state'])!,
      approvalStatus: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}approval_status']),
      approvedBy: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}approved_by']),
      approvedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}approved_at']),
      version: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}version'])!,
      expectedDate: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}expected_date']),
      expectedDurationMinutes: attachedDatabase.typeMapping.read(
          DriftSqlType.int,
          data['${effectivePrefix}expected_duration_minutes']),
      contactPerson: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}contact_person']),
      contactPhone: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}contact_phone']),
      contactEmail: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}contact_email']),
      billingContactName: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}billing_contact_name']),
      billingContactEmail: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}billing_contact_email']),
      billingAddress: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}billing_address']),
      copsAccount: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}cops_account']),
      cmsAccount: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}cms_account']),
      alarmNetAccount: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}alarm_net_account']),
      ictAccount: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}ict_account']),
      alarmDotComAccount: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}alarm_dot_com_account']),
      telguardAccount: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}telguard_account']),
      openEyeLicense: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}open_eye_license']),
      onServiceContract: attachedDatabase.typeMapping.read(
          DriftSqlType.bool, data['${effectivePrefix}on_service_contract'])!,
      contractType: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}contract_type']),
      referenceNumber: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}reference_number']),
      poNumber: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}po_number']),
    );
  }

  @override
  $WorkOrdersTable createAlias(String alias) {
    return $WorkOrdersTable(attachedDatabase, alias);
  }
}

class WorkOrder extends DataClass implements Insertable<WorkOrder> {
  final int id;
  final int siteId;
  final String status;
  final String? priority;
  final String? descriptionOfWork;
  final String? internalNotes;
  final DateTime createdAt;
  final DateTime? closedAt;
  final String? createdBy;
  final String? assignedTechnician;
  final String? completionNotes;
  final String? resolution;
  final bool repeatIssue;
  final String? previousStatus;
  final int? statusChangedBy;
  final DateTime? statusChangedAt;
  final String workflowState;
  final String? approvalStatus;
  final int? approvedBy;
  final DateTime? approvedAt;
  final int version;
  final DateTime? expectedDate;
  final int? expectedDurationMinutes;
  final String? contactPerson;
  final String? contactPhone;
  final String? contactEmail;
  final String? billingContactName;
  final String? billingContactEmail;
  final String? billingAddress;
  final String? copsAccount;
  final String? cmsAccount;
  final String? alarmNetAccount;
  final String? ictAccount;
  final String? alarmDotComAccount;
  final String? telguardAccount;
  final String? openEyeLicense;
  final bool onServiceContract;
  final String? contractType;
  final String? referenceNumber;
  final String? poNumber;
  const WorkOrder(
      {required this.id,
      required this.siteId,
      required this.status,
      this.priority,
      this.descriptionOfWork,
      this.internalNotes,
      required this.createdAt,
      this.closedAt,
      this.createdBy,
      this.assignedTechnician,
      this.completionNotes,
      this.resolution,
      required this.repeatIssue,
      this.previousStatus,
      this.statusChangedBy,
      this.statusChangedAt,
      required this.workflowState,
      this.approvalStatus,
      this.approvedBy,
      this.approvedAt,
      required this.version,
      this.expectedDate,
      this.expectedDurationMinutes,
      this.contactPerson,
      this.contactPhone,
      this.contactEmail,
      this.billingContactName,
      this.billingContactEmail,
      this.billingAddress,
      this.copsAccount,
      this.cmsAccount,
      this.alarmNetAccount,
      this.ictAccount,
      this.alarmDotComAccount,
      this.telguardAccount,
      this.openEyeLicense,
      required this.onServiceContract,
      this.contractType,
      this.referenceNumber,
      this.poNumber});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['site_id'] = Variable<int>(siteId);
    map['status'] = Variable<String>(status);
    if (!nullToAbsent || priority != null) {
      map['priority'] = Variable<String>(priority);
    }
    if (!nullToAbsent || descriptionOfWork != null) {
      map['description_of_work'] = Variable<String>(descriptionOfWork);
    }
    if (!nullToAbsent || internalNotes != null) {
      map['internal_notes'] = Variable<String>(internalNotes);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    if (!nullToAbsent || closedAt != null) {
      map['closed_at'] = Variable<DateTime>(closedAt);
    }
    if (!nullToAbsent || createdBy != null) {
      map['created_by'] = Variable<String>(createdBy);
    }
    if (!nullToAbsent || assignedTechnician != null) {
      map['assigned_technician'] = Variable<String>(assignedTechnician);
    }
    if (!nullToAbsent || completionNotes != null) {
      map['completion_notes'] = Variable<String>(completionNotes);
    }
    if (!nullToAbsent || resolution != null) {
      map['resolution'] = Variable<String>(resolution);
    }
    map['repeat_issue'] = Variable<bool>(repeatIssue);
    if (!nullToAbsent || previousStatus != null) {
      map['previous_status'] = Variable<String>(previousStatus);
    }
    if (!nullToAbsent || statusChangedBy != null) {
      map['status_changed_by'] = Variable<int>(statusChangedBy);
    }
    if (!nullToAbsent || statusChangedAt != null) {
      map['status_changed_at'] = Variable<DateTime>(statusChangedAt);
    }
    map['workflow_state'] = Variable<String>(workflowState);
    if (!nullToAbsent || approvalStatus != null) {
      map['approval_status'] = Variable<String>(approvalStatus);
    }
    if (!nullToAbsent || approvedBy != null) {
      map['approved_by'] = Variable<int>(approvedBy);
    }
    if (!nullToAbsent || approvedAt != null) {
      map['approved_at'] = Variable<DateTime>(approvedAt);
    }
    map['version'] = Variable<int>(version);
    if (!nullToAbsent || expectedDate != null) {
      map['expected_date'] = Variable<DateTime>(expectedDate);
    }
    if (!nullToAbsent || expectedDurationMinutes != null) {
      map['expected_duration_minutes'] = Variable<int>(expectedDurationMinutes);
    }
    if (!nullToAbsent || contactPerson != null) {
      map['contact_person'] = Variable<String>(contactPerson);
    }
    if (!nullToAbsent || contactPhone != null) {
      map['contact_phone'] = Variable<String>(contactPhone);
    }
    if (!nullToAbsent || contactEmail != null) {
      map['contact_email'] = Variable<String>(contactEmail);
    }
    if (!nullToAbsent || billingContactName != null) {
      map['billing_contact_name'] = Variable<String>(billingContactName);
    }
    if (!nullToAbsent || billingContactEmail != null) {
      map['billing_contact_email'] = Variable<String>(billingContactEmail);
    }
    if (!nullToAbsent || billingAddress != null) {
      map['billing_address'] = Variable<String>(billingAddress);
    }
    if (!nullToAbsent || copsAccount != null) {
      map['cops_account'] = Variable<String>(copsAccount);
    }
    if (!nullToAbsent || cmsAccount != null) {
      map['cms_account'] = Variable<String>(cmsAccount);
    }
    if (!nullToAbsent || alarmNetAccount != null) {
      map['alarm_net_account'] = Variable<String>(alarmNetAccount);
    }
    if (!nullToAbsent || ictAccount != null) {
      map['ict_account'] = Variable<String>(ictAccount);
    }
    if (!nullToAbsent || alarmDotComAccount != null) {
      map['alarm_dot_com_account'] = Variable<String>(alarmDotComAccount);
    }
    if (!nullToAbsent || telguardAccount != null) {
      map['telguard_account'] = Variable<String>(telguardAccount);
    }
    if (!nullToAbsent || openEyeLicense != null) {
      map['open_eye_license'] = Variable<String>(openEyeLicense);
    }
    map['on_service_contract'] = Variable<bool>(onServiceContract);
    if (!nullToAbsent || contractType != null) {
      map['contract_type'] = Variable<String>(contractType);
    }
    if (!nullToAbsent || referenceNumber != null) {
      map['reference_number'] = Variable<String>(referenceNumber);
    }
    if (!nullToAbsent || poNumber != null) {
      map['po_number'] = Variable<String>(poNumber);
    }
    return map;
  }

  WorkOrdersCompanion toCompanion(bool nullToAbsent) {
    return WorkOrdersCompanion(
      id: Value(id),
      siteId: Value(siteId),
      status: Value(status),
      priority: priority == null && nullToAbsent
          ? const Value.absent()
          : Value(priority),
      descriptionOfWork: descriptionOfWork == null && nullToAbsent
          ? const Value.absent()
          : Value(descriptionOfWork),
      internalNotes: internalNotes == null && nullToAbsent
          ? const Value.absent()
          : Value(internalNotes),
      createdAt: Value(createdAt),
      closedAt: closedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(closedAt),
      createdBy: createdBy == null && nullToAbsent
          ? const Value.absent()
          : Value(createdBy),
      assignedTechnician: assignedTechnician == null && nullToAbsent
          ? const Value.absent()
          : Value(assignedTechnician),
      completionNotes: completionNotes == null && nullToAbsent
          ? const Value.absent()
          : Value(completionNotes),
      resolution: resolution == null && nullToAbsent
          ? const Value.absent()
          : Value(resolution),
      repeatIssue: Value(repeatIssue),
      previousStatus: previousStatus == null && nullToAbsent
          ? const Value.absent()
          : Value(previousStatus),
      statusChangedBy: statusChangedBy == null && nullToAbsent
          ? const Value.absent()
          : Value(statusChangedBy),
      statusChangedAt: statusChangedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(statusChangedAt),
      workflowState: Value(workflowState),
      approvalStatus: approvalStatus == null && nullToAbsent
          ? const Value.absent()
          : Value(approvalStatus),
      approvedBy: approvedBy == null && nullToAbsent
          ? const Value.absent()
          : Value(approvedBy),
      approvedAt: approvedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(approvedAt),
      version: Value(version),
      expectedDate: expectedDate == null && nullToAbsent
          ? const Value.absent()
          : Value(expectedDate),
      expectedDurationMinutes: expectedDurationMinutes == null && nullToAbsent
          ? const Value.absent()
          : Value(expectedDurationMinutes),
      contactPerson: contactPerson == null && nullToAbsent
          ? const Value.absent()
          : Value(contactPerson),
      contactPhone: contactPhone == null && nullToAbsent
          ? const Value.absent()
          : Value(contactPhone),
      contactEmail: contactEmail == null && nullToAbsent
          ? const Value.absent()
          : Value(contactEmail),
      billingContactName: billingContactName == null && nullToAbsent
          ? const Value.absent()
          : Value(billingContactName),
      billingContactEmail: billingContactEmail == null && nullToAbsent
          ? const Value.absent()
          : Value(billingContactEmail),
      billingAddress: billingAddress == null && nullToAbsent
          ? const Value.absent()
          : Value(billingAddress),
      copsAccount: copsAccount == null && nullToAbsent
          ? const Value.absent()
          : Value(copsAccount),
      cmsAccount: cmsAccount == null && nullToAbsent
          ? const Value.absent()
          : Value(cmsAccount),
      alarmNetAccount: alarmNetAccount == null && nullToAbsent
          ? const Value.absent()
          : Value(alarmNetAccount),
      ictAccount: ictAccount == null && nullToAbsent
          ? const Value.absent()
          : Value(ictAccount),
      alarmDotComAccount: alarmDotComAccount == null && nullToAbsent
          ? const Value.absent()
          : Value(alarmDotComAccount),
      telguardAccount: telguardAccount == null && nullToAbsent
          ? const Value.absent()
          : Value(telguardAccount),
      openEyeLicense: openEyeLicense == null && nullToAbsent
          ? const Value.absent()
          : Value(openEyeLicense),
      onServiceContract: Value(onServiceContract),
      contractType: contractType == null && nullToAbsent
          ? const Value.absent()
          : Value(contractType),
      referenceNumber: referenceNumber == null && nullToAbsent
          ? const Value.absent()
          : Value(referenceNumber),
      poNumber: poNumber == null && nullToAbsent
          ? const Value.absent()
          : Value(poNumber),
    );
  }

  factory WorkOrder.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return WorkOrder(
      id: serializer.fromJson<int>(json['id']),
      siteId: serializer.fromJson<int>(json['siteId']),
      status: serializer.fromJson<String>(json['status']),
      priority: serializer.fromJson<String?>(json['priority']),
      descriptionOfWork:
          serializer.fromJson<String?>(json['descriptionOfWork']),
      internalNotes: serializer.fromJson<String?>(json['internalNotes']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      closedAt: serializer.fromJson<DateTime?>(json['closedAt']),
      createdBy: serializer.fromJson<String?>(json['createdBy']),
      assignedTechnician:
          serializer.fromJson<String?>(json['assignedTechnician']),
      completionNotes: serializer.fromJson<String?>(json['completionNotes']),
      resolution: serializer.fromJson<String?>(json['resolution']),
      repeatIssue: serializer.fromJson<bool>(json['repeatIssue']),
      previousStatus: serializer.fromJson<String?>(json['previousStatus']),
      statusChangedBy: serializer.fromJson<int?>(json['statusChangedBy']),
      statusChangedAt: serializer.fromJson<DateTime?>(json['statusChangedAt']),
      workflowState: serializer.fromJson<String>(json['workflowState']),
      approvalStatus: serializer.fromJson<String?>(json['approvalStatus']),
      approvedBy: serializer.fromJson<int?>(json['approvedBy']),
      approvedAt: serializer.fromJson<DateTime?>(json['approvedAt']),
      version: serializer.fromJson<int>(json['version']),
      expectedDate: serializer.fromJson<DateTime?>(json['expectedDate']),
      expectedDurationMinutes:
          serializer.fromJson<int?>(json['expectedDurationMinutes']),
      contactPerson: serializer.fromJson<String?>(json['contactPerson']),
      contactPhone: serializer.fromJson<String?>(json['contactPhone']),
      contactEmail: serializer.fromJson<String?>(json['contactEmail']),
      billingContactName:
          serializer.fromJson<String?>(json['billingContactName']),
      billingContactEmail:
          serializer.fromJson<String?>(json['billingContactEmail']),
      billingAddress: serializer.fromJson<String?>(json['billingAddress']),
      copsAccount: serializer.fromJson<String?>(json['copsAccount']),
      cmsAccount: serializer.fromJson<String?>(json['cmsAccount']),
      alarmNetAccount: serializer.fromJson<String?>(json['alarmNetAccount']),
      ictAccount: serializer.fromJson<String?>(json['ictAccount']),
      alarmDotComAccount:
          serializer.fromJson<String?>(json['alarmDotComAccount']),
      telguardAccount: serializer.fromJson<String?>(json['telguardAccount']),
      openEyeLicense: serializer.fromJson<String?>(json['openEyeLicense']),
      onServiceContract: serializer.fromJson<bool>(json['onServiceContract']),
      contractType: serializer.fromJson<String?>(json['contractType']),
      referenceNumber: serializer.fromJson<String?>(json['referenceNumber']),
      poNumber: serializer.fromJson<String?>(json['poNumber']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'siteId': serializer.toJson<int>(siteId),
      'status': serializer.toJson<String>(status),
      'priority': serializer.toJson<String?>(priority),
      'descriptionOfWork': serializer.toJson<String?>(descriptionOfWork),
      'internalNotes': serializer.toJson<String?>(internalNotes),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'closedAt': serializer.toJson<DateTime?>(closedAt),
      'createdBy': serializer.toJson<String?>(createdBy),
      'assignedTechnician': serializer.toJson<String?>(assignedTechnician),
      'completionNotes': serializer.toJson<String?>(completionNotes),
      'resolution': serializer.toJson<String?>(resolution),
      'repeatIssue': serializer.toJson<bool>(repeatIssue),
      'previousStatus': serializer.toJson<String?>(previousStatus),
      'statusChangedBy': serializer.toJson<int?>(statusChangedBy),
      'statusChangedAt': serializer.toJson<DateTime?>(statusChangedAt),
      'workflowState': serializer.toJson<String>(workflowState),
      'approvalStatus': serializer.toJson<String?>(approvalStatus),
      'approvedBy': serializer.toJson<int?>(approvedBy),
      'approvedAt': serializer.toJson<DateTime?>(approvedAt),
      'version': serializer.toJson<int>(version),
      'expectedDate': serializer.toJson<DateTime?>(expectedDate),
      'expectedDurationMinutes':
          serializer.toJson<int?>(expectedDurationMinutes),
      'contactPerson': serializer.toJson<String?>(contactPerson),
      'contactPhone': serializer.toJson<String?>(contactPhone),
      'contactEmail': serializer.toJson<String?>(contactEmail),
      'billingContactName': serializer.toJson<String?>(billingContactName),
      'billingContactEmail': serializer.toJson<String?>(billingContactEmail),
      'billingAddress': serializer.toJson<String?>(billingAddress),
      'copsAccount': serializer.toJson<String?>(copsAccount),
      'cmsAccount': serializer.toJson<String?>(cmsAccount),
      'alarmNetAccount': serializer.toJson<String?>(alarmNetAccount),
      'ictAccount': serializer.toJson<String?>(ictAccount),
      'alarmDotComAccount': serializer.toJson<String?>(alarmDotComAccount),
      'telguardAccount': serializer.toJson<String?>(telguardAccount),
      'openEyeLicense': serializer.toJson<String?>(openEyeLicense),
      'onServiceContract': serializer.toJson<bool>(onServiceContract),
      'contractType': serializer.toJson<String?>(contractType),
      'referenceNumber': serializer.toJson<String?>(referenceNumber),
      'poNumber': serializer.toJson<String?>(poNumber),
    };
  }

  WorkOrder copyWith(
          {int? id,
          int? siteId,
          String? status,
          Value<String?> priority = const Value.absent(),
          Value<String?> descriptionOfWork = const Value.absent(),
          Value<String?> internalNotes = const Value.absent(),
          DateTime? createdAt,
          Value<DateTime?> closedAt = const Value.absent(),
          Value<String?> createdBy = const Value.absent(),
          Value<String?> assignedTechnician = const Value.absent(),
          Value<String?> completionNotes = const Value.absent(),
          Value<String?> resolution = const Value.absent(),
          bool? repeatIssue,
          Value<String?> previousStatus = const Value.absent(),
          Value<int?> statusChangedBy = const Value.absent(),
          Value<DateTime?> statusChangedAt = const Value.absent(),
          String? workflowState,
          Value<String?> approvalStatus = const Value.absent(),
          Value<int?> approvedBy = const Value.absent(),
          Value<DateTime?> approvedAt = const Value.absent(),
          int? version,
          Value<DateTime?> expectedDate = const Value.absent(),
          Value<int?> expectedDurationMinutes = const Value.absent(),
          Value<String?> contactPerson = const Value.absent(),
          Value<String?> contactPhone = const Value.absent(),
          Value<String?> contactEmail = const Value.absent(),
          Value<String?> billingContactName = const Value.absent(),
          Value<String?> billingContactEmail = const Value.absent(),
          Value<String?> billingAddress = const Value.absent(),
          Value<String?> copsAccount = const Value.absent(),
          Value<String?> cmsAccount = const Value.absent(),
          Value<String?> alarmNetAccount = const Value.absent(),
          Value<String?> ictAccount = const Value.absent(),
          Value<String?> alarmDotComAccount = const Value.absent(),
          Value<String?> telguardAccount = const Value.absent(),
          Value<String?> openEyeLicense = const Value.absent(),
          bool? onServiceContract,
          Value<String?> contractType = const Value.absent(),
          Value<String?> referenceNumber = const Value.absent(),
          Value<String?> poNumber = const Value.absent()}) =>
      WorkOrder(
        id: id ?? this.id,
        siteId: siteId ?? this.siteId,
        status: status ?? this.status,
        priority: priority.present ? priority.value : this.priority,
        descriptionOfWork: descriptionOfWork.present
            ? descriptionOfWork.value
            : this.descriptionOfWork,
        internalNotes:
            internalNotes.present ? internalNotes.value : this.internalNotes,
        createdAt: createdAt ?? this.createdAt,
        closedAt: closedAt.present ? closedAt.value : this.closedAt,
        createdBy: createdBy.present ? createdBy.value : this.createdBy,
        assignedTechnician: assignedTechnician.present
            ? assignedTechnician.value
            : this.assignedTechnician,
        completionNotes: completionNotes.present
            ? completionNotes.value
            : this.completionNotes,
        resolution: resolution.present ? resolution.value : this.resolution,
        repeatIssue: repeatIssue ?? this.repeatIssue,
        previousStatus:
            previousStatus.present ? previousStatus.value : this.previousStatus,
        statusChangedBy: statusChangedBy.present
            ? statusChangedBy.value
            : this.statusChangedBy,
        statusChangedAt: statusChangedAt.present
            ? statusChangedAt.value
            : this.statusChangedAt,
        workflowState: workflowState ?? this.workflowState,
        approvalStatus:
            approvalStatus.present ? approvalStatus.value : this.approvalStatus,
        approvedBy: approvedBy.present ? approvedBy.value : this.approvedBy,
        approvedAt: approvedAt.present ? approvedAt.value : this.approvedAt,
        version: version ?? this.version,
        expectedDate:
            expectedDate.present ? expectedDate.value : this.expectedDate,
        expectedDurationMinutes: expectedDurationMinutes.present
            ? expectedDurationMinutes.value
            : this.expectedDurationMinutes,
        contactPerson:
            contactPerson.present ? contactPerson.value : this.contactPerson,
        contactPhone:
            contactPhone.present ? contactPhone.value : this.contactPhone,
        contactEmail:
            contactEmail.present ? contactEmail.value : this.contactEmail,
        billingContactName: billingContactName.present
            ? billingContactName.value
            : this.billingContactName,
        billingContactEmail: billingContactEmail.present
            ? billingContactEmail.value
            : this.billingContactEmail,
        billingAddress:
            billingAddress.present ? billingAddress.value : this.billingAddress,
        copsAccount: copsAccount.present ? copsAccount.value : this.copsAccount,
        cmsAccount: cmsAccount.present ? cmsAccount.value : this.cmsAccount,
        alarmNetAccount: alarmNetAccount.present
            ? alarmNetAccount.value
            : this.alarmNetAccount,
        ictAccount: ictAccount.present ? ictAccount.value : this.ictAccount,
        alarmDotComAccount: alarmDotComAccount.present
            ? alarmDotComAccount.value
            : this.alarmDotComAccount,
        telguardAccount: telguardAccount.present
            ? telguardAccount.value
            : this.telguardAccount,
        openEyeLicense:
            openEyeLicense.present ? openEyeLicense.value : this.openEyeLicense,
        onServiceContract: onServiceContract ?? this.onServiceContract,
        contractType:
            contractType.present ? contractType.value : this.contractType,
        referenceNumber: referenceNumber.present
            ? referenceNumber.value
            : this.referenceNumber,
        poNumber: poNumber.present ? poNumber.value : this.poNumber,
      );
  WorkOrder copyWithCompanion(WorkOrdersCompanion data) {
    return WorkOrder(
      id: data.id.present ? data.id.value : this.id,
      siteId: data.siteId.present ? data.siteId.value : this.siteId,
      status: data.status.present ? data.status.value : this.status,
      priority: data.priority.present ? data.priority.value : this.priority,
      descriptionOfWork: data.descriptionOfWork.present
          ? data.descriptionOfWork.value
          : this.descriptionOfWork,
      internalNotes: data.internalNotes.present
          ? data.internalNotes.value
          : this.internalNotes,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      closedAt: data.closedAt.present ? data.closedAt.value : this.closedAt,
      createdBy: data.createdBy.present ? data.createdBy.value : this.createdBy,
      assignedTechnician: data.assignedTechnician.present
          ? data.assignedTechnician.value
          : this.assignedTechnician,
      completionNotes: data.completionNotes.present
          ? data.completionNotes.value
          : this.completionNotes,
      resolution:
          data.resolution.present ? data.resolution.value : this.resolution,
      repeatIssue:
          data.repeatIssue.present ? data.repeatIssue.value : this.repeatIssue,
      previousStatus: data.previousStatus.present
          ? data.previousStatus.value
          : this.previousStatus,
      statusChangedBy: data.statusChangedBy.present
          ? data.statusChangedBy.value
          : this.statusChangedBy,
      statusChangedAt: data.statusChangedAt.present
          ? data.statusChangedAt.value
          : this.statusChangedAt,
      workflowState: data.workflowState.present
          ? data.workflowState.value
          : this.workflowState,
      approvalStatus: data.approvalStatus.present
          ? data.approvalStatus.value
          : this.approvalStatus,
      approvedBy:
          data.approvedBy.present ? data.approvedBy.value : this.approvedBy,
      approvedAt:
          data.approvedAt.present ? data.approvedAt.value : this.approvedAt,
      version: data.version.present ? data.version.value : this.version,
      expectedDate: data.expectedDate.present
          ? data.expectedDate.value
          : this.expectedDate,
      expectedDurationMinutes: data.expectedDurationMinutes.present
          ? data.expectedDurationMinutes.value
          : this.expectedDurationMinutes,
      contactPerson: data.contactPerson.present
          ? data.contactPerson.value
          : this.contactPerson,
      contactPhone: data.contactPhone.present
          ? data.contactPhone.value
          : this.contactPhone,
      contactEmail: data.contactEmail.present
          ? data.contactEmail.value
          : this.contactEmail,
      billingContactName: data.billingContactName.present
          ? data.billingContactName.value
          : this.billingContactName,
      billingContactEmail: data.billingContactEmail.present
          ? data.billingContactEmail.value
          : this.billingContactEmail,
      billingAddress: data.billingAddress.present
          ? data.billingAddress.value
          : this.billingAddress,
      copsAccount:
          data.copsAccount.present ? data.copsAccount.value : this.copsAccount,
      cmsAccount:
          data.cmsAccount.present ? data.cmsAccount.value : this.cmsAccount,
      alarmNetAccount: data.alarmNetAccount.present
          ? data.alarmNetAccount.value
          : this.alarmNetAccount,
      ictAccount:
          data.ictAccount.present ? data.ictAccount.value : this.ictAccount,
      alarmDotComAccount: data.alarmDotComAccount.present
          ? data.alarmDotComAccount.value
          : this.alarmDotComAccount,
      telguardAccount: data.telguardAccount.present
          ? data.telguardAccount.value
          : this.telguardAccount,
      openEyeLicense: data.openEyeLicense.present
          ? data.openEyeLicense.value
          : this.openEyeLicense,
      onServiceContract: data.onServiceContract.present
          ? data.onServiceContract.value
          : this.onServiceContract,
      contractType: data.contractType.present
          ? data.contractType.value
          : this.contractType,
      referenceNumber: data.referenceNumber.present
          ? data.referenceNumber.value
          : this.referenceNumber,
      poNumber: data.poNumber.present ? data.poNumber.value : this.poNumber,
    );
  }

  @override
  String toString() {
    return (StringBuffer('WorkOrder(')
          ..write('id: $id, ')
          ..write('siteId: $siteId, ')
          ..write('status: $status, ')
          ..write('priority: $priority, ')
          ..write('descriptionOfWork: $descriptionOfWork, ')
          ..write('internalNotes: $internalNotes, ')
          ..write('createdAt: $createdAt, ')
          ..write('closedAt: $closedAt, ')
          ..write('createdBy: $createdBy, ')
          ..write('assignedTechnician: $assignedTechnician, ')
          ..write('completionNotes: $completionNotes, ')
          ..write('resolution: $resolution, ')
          ..write('repeatIssue: $repeatIssue, ')
          ..write('previousStatus: $previousStatus, ')
          ..write('statusChangedBy: $statusChangedBy, ')
          ..write('statusChangedAt: $statusChangedAt, ')
          ..write('workflowState: $workflowState, ')
          ..write('approvalStatus: $approvalStatus, ')
          ..write('approvedBy: $approvedBy, ')
          ..write('approvedAt: $approvedAt, ')
          ..write('version: $version, ')
          ..write('expectedDate: $expectedDate, ')
          ..write('expectedDurationMinutes: $expectedDurationMinutes, ')
          ..write('contactPerson: $contactPerson, ')
          ..write('contactPhone: $contactPhone, ')
          ..write('contactEmail: $contactEmail, ')
          ..write('billingContactName: $billingContactName, ')
          ..write('billingContactEmail: $billingContactEmail, ')
          ..write('billingAddress: $billingAddress, ')
          ..write('copsAccount: $copsAccount, ')
          ..write('cmsAccount: $cmsAccount, ')
          ..write('alarmNetAccount: $alarmNetAccount, ')
          ..write('ictAccount: $ictAccount, ')
          ..write('alarmDotComAccount: $alarmDotComAccount, ')
          ..write('telguardAccount: $telguardAccount, ')
          ..write('openEyeLicense: $openEyeLicense, ')
          ..write('onServiceContract: $onServiceContract, ')
          ..write('contractType: $contractType, ')
          ..write('referenceNumber: $referenceNumber, ')
          ..write('poNumber: $poNumber')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hashAll([
        id,
        siteId,
        status,
        priority,
        descriptionOfWork,
        internalNotes,
        createdAt,
        closedAt,
        createdBy,
        assignedTechnician,
        completionNotes,
        resolution,
        repeatIssue,
        previousStatus,
        statusChangedBy,
        statusChangedAt,
        workflowState,
        approvalStatus,
        approvedBy,
        approvedAt,
        version,
        expectedDate,
        expectedDurationMinutes,
        contactPerson,
        contactPhone,
        contactEmail,
        billingContactName,
        billingContactEmail,
        billingAddress,
        copsAccount,
        cmsAccount,
        alarmNetAccount,
        ictAccount,
        alarmDotComAccount,
        telguardAccount,
        openEyeLicense,
        onServiceContract,
        contractType,
        referenceNumber,
        poNumber
      ]);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is WorkOrder &&
          other.id == this.id &&
          other.siteId == this.siteId &&
          other.status == this.status &&
          other.priority == this.priority &&
          other.descriptionOfWork == this.descriptionOfWork &&
          other.internalNotes == this.internalNotes &&
          other.createdAt == this.createdAt &&
          other.closedAt == this.closedAt &&
          other.createdBy == this.createdBy &&
          other.assignedTechnician == this.assignedTechnician &&
          other.completionNotes == this.completionNotes &&
          other.resolution == this.resolution &&
          other.repeatIssue == this.repeatIssue &&
          other.previousStatus == this.previousStatus &&
          other.statusChangedBy == this.statusChangedBy &&
          other.statusChangedAt == this.statusChangedAt &&
          other.workflowState == this.workflowState &&
          other.approvalStatus == this.approvalStatus &&
          other.approvedBy == this.approvedBy &&
          other.approvedAt == this.approvedAt &&
          other.version == this.version &&
          other.expectedDate == this.expectedDate &&
          other.expectedDurationMinutes == this.expectedDurationMinutes &&
          other.contactPerson == this.contactPerson &&
          other.contactPhone == this.contactPhone &&
          other.contactEmail == this.contactEmail &&
          other.billingContactName == this.billingContactName &&
          other.billingContactEmail == this.billingContactEmail &&
          other.billingAddress == this.billingAddress &&
          other.copsAccount == this.copsAccount &&
          other.cmsAccount == this.cmsAccount &&
          other.alarmNetAccount == this.alarmNetAccount &&
          other.ictAccount == this.ictAccount &&
          other.alarmDotComAccount == this.alarmDotComAccount &&
          other.telguardAccount == this.telguardAccount &&
          other.openEyeLicense == this.openEyeLicense &&
          other.onServiceContract == this.onServiceContract &&
          other.contractType == this.contractType &&
          other.referenceNumber == this.referenceNumber &&
          other.poNumber == this.poNumber);
}

class WorkOrdersCompanion extends UpdateCompanion<WorkOrder> {
  final Value<int> id;
  final Value<int> siteId;
  final Value<String> status;
  final Value<String?> priority;
  final Value<String?> descriptionOfWork;
  final Value<String?> internalNotes;
  final Value<DateTime> createdAt;
  final Value<DateTime?> closedAt;
  final Value<String?> createdBy;
  final Value<String?> assignedTechnician;
  final Value<String?> completionNotes;
  final Value<String?> resolution;
  final Value<bool> repeatIssue;
  final Value<String?> previousStatus;
  final Value<int?> statusChangedBy;
  final Value<DateTime?> statusChangedAt;
  final Value<String> workflowState;
  final Value<String?> approvalStatus;
  final Value<int?> approvedBy;
  final Value<DateTime?> approvedAt;
  final Value<int> version;
  final Value<DateTime?> expectedDate;
  final Value<int?> expectedDurationMinutes;
  final Value<String?> contactPerson;
  final Value<String?> contactPhone;
  final Value<String?> contactEmail;
  final Value<String?> billingContactName;
  final Value<String?> billingContactEmail;
  final Value<String?> billingAddress;
  final Value<String?> copsAccount;
  final Value<String?> cmsAccount;
  final Value<String?> alarmNetAccount;
  final Value<String?> ictAccount;
  final Value<String?> alarmDotComAccount;
  final Value<String?> telguardAccount;
  final Value<String?> openEyeLicense;
  final Value<bool> onServiceContract;
  final Value<String?> contractType;
  final Value<String?> referenceNumber;
  final Value<String?> poNumber;
  const WorkOrdersCompanion({
    this.id = const Value.absent(),
    this.siteId = const Value.absent(),
    this.status = const Value.absent(),
    this.priority = const Value.absent(),
    this.descriptionOfWork = const Value.absent(),
    this.internalNotes = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.closedAt = const Value.absent(),
    this.createdBy = const Value.absent(),
    this.assignedTechnician = const Value.absent(),
    this.completionNotes = const Value.absent(),
    this.resolution = const Value.absent(),
    this.repeatIssue = const Value.absent(),
    this.previousStatus = const Value.absent(),
    this.statusChangedBy = const Value.absent(),
    this.statusChangedAt = const Value.absent(),
    this.workflowState = const Value.absent(),
    this.approvalStatus = const Value.absent(),
    this.approvedBy = const Value.absent(),
    this.approvedAt = const Value.absent(),
    this.version = const Value.absent(),
    this.expectedDate = const Value.absent(),
    this.expectedDurationMinutes = const Value.absent(),
    this.contactPerson = const Value.absent(),
    this.contactPhone = const Value.absent(),
    this.contactEmail = const Value.absent(),
    this.billingContactName = const Value.absent(),
    this.billingContactEmail = const Value.absent(),
    this.billingAddress = const Value.absent(),
    this.copsAccount = const Value.absent(),
    this.cmsAccount = const Value.absent(),
    this.alarmNetAccount = const Value.absent(),
    this.ictAccount = const Value.absent(),
    this.alarmDotComAccount = const Value.absent(),
    this.telguardAccount = const Value.absent(),
    this.openEyeLicense = const Value.absent(),
    this.onServiceContract = const Value.absent(),
    this.contractType = const Value.absent(),
    this.referenceNumber = const Value.absent(),
    this.poNumber = const Value.absent(),
  });
  WorkOrdersCompanion.insert({
    this.id = const Value.absent(),
    required int siteId,
    required String status,
    this.priority = const Value.absent(),
    this.descriptionOfWork = const Value.absent(),
    this.internalNotes = const Value.absent(),
    required DateTime createdAt,
    this.closedAt = const Value.absent(),
    this.createdBy = const Value.absent(),
    this.assignedTechnician = const Value.absent(),
    this.completionNotes = const Value.absent(),
    this.resolution = const Value.absent(),
    this.repeatIssue = const Value.absent(),
    this.previousStatus = const Value.absent(),
    this.statusChangedBy = const Value.absent(),
    this.statusChangedAt = const Value.absent(),
    this.workflowState = const Value.absent(),
    this.approvalStatus = const Value.absent(),
    this.approvedBy = const Value.absent(),
    this.approvedAt = const Value.absent(),
    this.version = const Value.absent(),
    this.expectedDate = const Value.absent(),
    this.expectedDurationMinutes = const Value.absent(),
    this.contactPerson = const Value.absent(),
    this.contactPhone = const Value.absent(),
    this.contactEmail = const Value.absent(),
    this.billingContactName = const Value.absent(),
    this.billingContactEmail = const Value.absent(),
    this.billingAddress = const Value.absent(),
    this.copsAccount = const Value.absent(),
    this.cmsAccount = const Value.absent(),
    this.alarmNetAccount = const Value.absent(),
    this.ictAccount = const Value.absent(),
    this.alarmDotComAccount = const Value.absent(),
    this.telguardAccount = const Value.absent(),
    this.openEyeLicense = const Value.absent(),
    this.onServiceContract = const Value.absent(),
    this.contractType = const Value.absent(),
    this.referenceNumber = const Value.absent(),
    this.poNumber = const Value.absent(),
  })  : siteId = Value(siteId),
        status = Value(status),
        createdAt = Value(createdAt);
  static Insertable<WorkOrder> custom({
    Expression<int>? id,
    Expression<int>? siteId,
    Expression<String>? status,
    Expression<String>? priority,
    Expression<String>? descriptionOfWork,
    Expression<String>? internalNotes,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? closedAt,
    Expression<String>? createdBy,
    Expression<String>? assignedTechnician,
    Expression<String>? completionNotes,
    Expression<String>? resolution,
    Expression<bool>? repeatIssue,
    Expression<String>? previousStatus,
    Expression<int>? statusChangedBy,
    Expression<DateTime>? statusChangedAt,
    Expression<String>? workflowState,
    Expression<String>? approvalStatus,
    Expression<int>? approvedBy,
    Expression<DateTime>? approvedAt,
    Expression<int>? version,
    Expression<DateTime>? expectedDate,
    Expression<int>? expectedDurationMinutes,
    Expression<String>? contactPerson,
    Expression<String>? contactPhone,
    Expression<String>? contactEmail,
    Expression<String>? billingContactName,
    Expression<String>? billingContactEmail,
    Expression<String>? billingAddress,
    Expression<String>? copsAccount,
    Expression<String>? cmsAccount,
    Expression<String>? alarmNetAccount,
    Expression<String>? ictAccount,
    Expression<String>? alarmDotComAccount,
    Expression<String>? telguardAccount,
    Expression<String>? openEyeLicense,
    Expression<bool>? onServiceContract,
    Expression<String>? contractType,
    Expression<String>? referenceNumber,
    Expression<String>? poNumber,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (siteId != null) 'site_id': siteId,
      if (status != null) 'status': status,
      if (priority != null) 'priority': priority,
      if (descriptionOfWork != null) 'description_of_work': descriptionOfWork,
      if (internalNotes != null) 'internal_notes': internalNotes,
      if (createdAt != null) 'created_at': createdAt,
      if (closedAt != null) 'closed_at': closedAt,
      if (createdBy != null) 'created_by': createdBy,
      if (assignedTechnician != null) 'assigned_technician': assignedTechnician,
      if (completionNotes != null) 'completion_notes': completionNotes,
      if (resolution != null) 'resolution': resolution,
      if (repeatIssue != null) 'repeat_issue': repeatIssue,
      if (previousStatus != null) 'previous_status': previousStatus,
      if (statusChangedBy != null) 'status_changed_by': statusChangedBy,
      if (statusChangedAt != null) 'status_changed_at': statusChangedAt,
      if (workflowState != null) 'workflow_state': workflowState,
      if (approvalStatus != null) 'approval_status': approvalStatus,
      if (approvedBy != null) 'approved_by': approvedBy,
      if (approvedAt != null) 'approved_at': approvedAt,
      if (version != null) 'version': version,
      if (expectedDate != null) 'expected_date': expectedDate,
      if (expectedDurationMinutes != null)
        'expected_duration_minutes': expectedDurationMinutes,
      if (contactPerson != null) 'contact_person': contactPerson,
      if (contactPhone != null) 'contact_phone': contactPhone,
      if (contactEmail != null) 'contact_email': contactEmail,
      if (billingContactName != null)
        'billing_contact_name': billingContactName,
      if (billingContactEmail != null)
        'billing_contact_email': billingContactEmail,
      if (billingAddress != null) 'billing_address': billingAddress,
      if (copsAccount != null) 'cops_account': copsAccount,
      if (cmsAccount != null) 'cms_account': cmsAccount,
      if (alarmNetAccount != null) 'alarm_net_account': alarmNetAccount,
      if (ictAccount != null) 'ict_account': ictAccount,
      if (alarmDotComAccount != null)
        'alarm_dot_com_account': alarmDotComAccount,
      if (telguardAccount != null) 'telguard_account': telguardAccount,
      if (openEyeLicense != null) 'open_eye_license': openEyeLicense,
      if (onServiceContract != null) 'on_service_contract': onServiceContract,
      if (contractType != null) 'contract_type': contractType,
      if (referenceNumber != null) 'reference_number': referenceNumber,
      if (poNumber != null) 'po_number': poNumber,
    });
  }

  WorkOrdersCompanion copyWith(
      {Value<int>? id,
      Value<int>? siteId,
      Value<String>? status,
      Value<String?>? priority,
      Value<String?>? descriptionOfWork,
      Value<String?>? internalNotes,
      Value<DateTime>? createdAt,
      Value<DateTime?>? closedAt,
      Value<String?>? createdBy,
      Value<String?>? assignedTechnician,
      Value<String?>? completionNotes,
      Value<String?>? resolution,
      Value<bool>? repeatIssue,
      Value<String?>? previousStatus,
      Value<int?>? statusChangedBy,
      Value<DateTime?>? statusChangedAt,
      Value<String>? workflowState,
      Value<String?>? approvalStatus,
      Value<int?>? approvedBy,
      Value<DateTime?>? approvedAt,
      Value<int>? version,
      Value<DateTime?>? expectedDate,
      Value<int?>? expectedDurationMinutes,
      Value<String?>? contactPerson,
      Value<String?>? contactPhone,
      Value<String?>? contactEmail,
      Value<String?>? billingContactName,
      Value<String?>? billingContactEmail,
      Value<String?>? billingAddress,
      Value<String?>? copsAccount,
      Value<String?>? cmsAccount,
      Value<String?>? alarmNetAccount,
      Value<String?>? ictAccount,
      Value<String?>? alarmDotComAccount,
      Value<String?>? telguardAccount,
      Value<String?>? openEyeLicense,
      Value<bool>? onServiceContract,
      Value<String?>? contractType,
      Value<String?>? referenceNumber,
      Value<String?>? poNumber}) {
    return WorkOrdersCompanion(
      id: id ?? this.id,
      siteId: siteId ?? this.siteId,
      status: status ?? this.status,
      priority: priority ?? this.priority,
      descriptionOfWork: descriptionOfWork ?? this.descriptionOfWork,
      internalNotes: internalNotes ?? this.internalNotes,
      createdAt: createdAt ?? this.createdAt,
      closedAt: closedAt ?? this.closedAt,
      createdBy: createdBy ?? this.createdBy,
      assignedTechnician: assignedTechnician ?? this.assignedTechnician,
      completionNotes: completionNotes ?? this.completionNotes,
      resolution: resolution ?? this.resolution,
      repeatIssue: repeatIssue ?? this.repeatIssue,
      previousStatus: previousStatus ?? this.previousStatus,
      statusChangedBy: statusChangedBy ?? this.statusChangedBy,
      statusChangedAt: statusChangedAt ?? this.statusChangedAt,
      workflowState: workflowState ?? this.workflowState,
      approvalStatus: approvalStatus ?? this.approvalStatus,
      approvedBy: approvedBy ?? this.approvedBy,
      approvedAt: approvedAt ?? this.approvedAt,
      version: version ?? this.version,
      expectedDate: expectedDate ?? this.expectedDate,
      expectedDurationMinutes:
          expectedDurationMinutes ?? this.expectedDurationMinutes,
      contactPerson: contactPerson ?? this.contactPerson,
      contactPhone: contactPhone ?? this.contactPhone,
      contactEmail: contactEmail ?? this.contactEmail,
      billingContactName: billingContactName ?? this.billingContactName,
      billingContactEmail: billingContactEmail ?? this.billingContactEmail,
      billingAddress: billingAddress ?? this.billingAddress,
      copsAccount: copsAccount ?? this.copsAccount,
      cmsAccount: cmsAccount ?? this.cmsAccount,
      alarmNetAccount: alarmNetAccount ?? this.alarmNetAccount,
      ictAccount: ictAccount ?? this.ictAccount,
      alarmDotComAccount: alarmDotComAccount ?? this.alarmDotComAccount,
      telguardAccount: telguardAccount ?? this.telguardAccount,
      openEyeLicense: openEyeLicense ?? this.openEyeLicense,
      onServiceContract: onServiceContract ?? this.onServiceContract,
      contractType: contractType ?? this.contractType,
      referenceNumber: referenceNumber ?? this.referenceNumber,
      poNumber: poNumber ?? this.poNumber,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (siteId.present) {
      map['site_id'] = Variable<int>(siteId.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (priority.present) {
      map['priority'] = Variable<String>(priority.value);
    }
    if (descriptionOfWork.present) {
      map['description_of_work'] = Variable<String>(descriptionOfWork.value);
    }
    if (internalNotes.present) {
      map['internal_notes'] = Variable<String>(internalNotes.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (closedAt.present) {
      map['closed_at'] = Variable<DateTime>(closedAt.value);
    }
    if (createdBy.present) {
      map['created_by'] = Variable<String>(createdBy.value);
    }
    if (assignedTechnician.present) {
      map['assigned_technician'] = Variable<String>(assignedTechnician.value);
    }
    if (completionNotes.present) {
      map['completion_notes'] = Variable<String>(completionNotes.value);
    }
    if (resolution.present) {
      map['resolution'] = Variable<String>(resolution.value);
    }
    if (repeatIssue.present) {
      map['repeat_issue'] = Variable<bool>(repeatIssue.value);
    }
    if (previousStatus.present) {
      map['previous_status'] = Variable<String>(previousStatus.value);
    }
    if (statusChangedBy.present) {
      map['status_changed_by'] = Variable<int>(statusChangedBy.value);
    }
    if (statusChangedAt.present) {
      map['status_changed_at'] = Variable<DateTime>(statusChangedAt.value);
    }
    if (workflowState.present) {
      map['workflow_state'] = Variable<String>(workflowState.value);
    }
    if (approvalStatus.present) {
      map['approval_status'] = Variable<String>(approvalStatus.value);
    }
    if (approvedBy.present) {
      map['approved_by'] = Variable<int>(approvedBy.value);
    }
    if (approvedAt.present) {
      map['approved_at'] = Variable<DateTime>(approvedAt.value);
    }
    if (version.present) {
      map['version'] = Variable<int>(version.value);
    }
    if (expectedDate.present) {
      map['expected_date'] = Variable<DateTime>(expectedDate.value);
    }
    if (expectedDurationMinutes.present) {
      map['expected_duration_minutes'] =
          Variable<int>(expectedDurationMinutes.value);
    }
    if (contactPerson.present) {
      map['contact_person'] = Variable<String>(contactPerson.value);
    }
    if (contactPhone.present) {
      map['contact_phone'] = Variable<String>(contactPhone.value);
    }
    if (contactEmail.present) {
      map['contact_email'] = Variable<String>(contactEmail.value);
    }
    if (billingContactName.present) {
      map['billing_contact_name'] = Variable<String>(billingContactName.value);
    }
    if (billingContactEmail.present) {
      map['billing_contact_email'] =
          Variable<String>(billingContactEmail.value);
    }
    if (billingAddress.present) {
      map['billing_address'] = Variable<String>(billingAddress.value);
    }
    if (copsAccount.present) {
      map['cops_account'] = Variable<String>(copsAccount.value);
    }
    if (cmsAccount.present) {
      map['cms_account'] = Variable<String>(cmsAccount.value);
    }
    if (alarmNetAccount.present) {
      map['alarm_net_account'] = Variable<String>(alarmNetAccount.value);
    }
    if (ictAccount.present) {
      map['ict_account'] = Variable<String>(ictAccount.value);
    }
    if (alarmDotComAccount.present) {
      map['alarm_dot_com_account'] = Variable<String>(alarmDotComAccount.value);
    }
    if (telguardAccount.present) {
      map['telguard_account'] = Variable<String>(telguardAccount.value);
    }
    if (openEyeLicense.present) {
      map['open_eye_license'] = Variable<String>(openEyeLicense.value);
    }
    if (onServiceContract.present) {
      map['on_service_contract'] = Variable<bool>(onServiceContract.value);
    }
    if (contractType.present) {
      map['contract_type'] = Variable<String>(contractType.value);
    }
    if (referenceNumber.present) {
      map['reference_number'] = Variable<String>(referenceNumber.value);
    }
    if (poNumber.present) {
      map['po_number'] = Variable<String>(poNumber.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('WorkOrdersCompanion(')
          ..write('id: $id, ')
          ..write('siteId: $siteId, ')
          ..write('status: $status, ')
          ..write('priority: $priority, ')
          ..write('descriptionOfWork: $descriptionOfWork, ')
          ..write('internalNotes: $internalNotes, ')
          ..write('createdAt: $createdAt, ')
          ..write('closedAt: $closedAt, ')
          ..write('createdBy: $createdBy, ')
          ..write('assignedTechnician: $assignedTechnician, ')
          ..write('completionNotes: $completionNotes, ')
          ..write('resolution: $resolution, ')
          ..write('repeatIssue: $repeatIssue, ')
          ..write('previousStatus: $previousStatus, ')
          ..write('statusChangedBy: $statusChangedBy, ')
          ..write('statusChangedAt: $statusChangedAt, ')
          ..write('workflowState: $workflowState, ')
          ..write('approvalStatus: $approvalStatus, ')
          ..write('approvedBy: $approvedBy, ')
          ..write('approvedAt: $approvedAt, ')
          ..write('version: $version, ')
          ..write('expectedDate: $expectedDate, ')
          ..write('expectedDurationMinutes: $expectedDurationMinutes, ')
          ..write('contactPerson: $contactPerson, ')
          ..write('contactPhone: $contactPhone, ')
          ..write('contactEmail: $contactEmail, ')
          ..write('billingContactName: $billingContactName, ')
          ..write('billingContactEmail: $billingContactEmail, ')
          ..write('billingAddress: $billingAddress, ')
          ..write('copsAccount: $copsAccount, ')
          ..write('cmsAccount: $cmsAccount, ')
          ..write('alarmNetAccount: $alarmNetAccount, ')
          ..write('ictAccount: $ictAccount, ')
          ..write('alarmDotComAccount: $alarmDotComAccount, ')
          ..write('telguardAccount: $telguardAccount, ')
          ..write('openEyeLicense: $openEyeLicense, ')
          ..write('onServiceContract: $onServiceContract, ')
          ..write('contractType: $contractType, ')
          ..write('referenceNumber: $referenceNumber, ')
          ..write('poNumber: $poNumber')
          ..write(')'))
        .toString();
  }
}

class $AppointmentsTable extends Appointments
    with TableInfo<$AppointmentsTable, Appointment> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AppointmentsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _workOrderIdMeta =
      const VerificationMeta('workOrderId');
  @override
  late final GeneratedColumn<int> workOrderId = GeneratedColumn<int>(
      'work_order_id', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _scheduledStartMeta =
      const VerificationMeta('scheduledStart');
  @override
  late final GeneratedColumn<DateTime> scheduledStart =
      GeneratedColumn<DateTime>('scheduled_start', aliasedName, false,
          type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _expectedDurationMinutesMeta =
      const VerificationMeta('expectedDurationMinutes');
  @override
  late final GeneratedColumn<int> expectedDurationMinutes =
      GeneratedColumn<int>('expected_duration_minutes', aliasedName, true,
          type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _technicianMeta =
      const VerificationMeta('technician');
  @override
  late final GeneratedColumn<String> technician = GeneratedColumn<String>(
      'technician', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns =>
      [id, workOrderId, scheduledStart, expectedDurationMinutes, technician];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'appointments';
  @override
  VerificationContext validateIntegrity(Insertable<Appointment> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('work_order_id')) {
      context.handle(
          _workOrderIdMeta,
          workOrderId.isAcceptableOrUnknown(
              data['work_order_id']!, _workOrderIdMeta));
    } else if (isInserting) {
      context.missing(_workOrderIdMeta);
    }
    if (data.containsKey('scheduled_start')) {
      context.handle(
          _scheduledStartMeta,
          scheduledStart.isAcceptableOrUnknown(
              data['scheduled_start']!, _scheduledStartMeta));
    } else if (isInserting) {
      context.missing(_scheduledStartMeta);
    }
    if (data.containsKey('expected_duration_minutes')) {
      context.handle(
          _expectedDurationMinutesMeta,
          expectedDurationMinutes.isAcceptableOrUnknown(
              data['expected_duration_minutes']!,
              _expectedDurationMinutesMeta));
    }
    if (data.containsKey('technician')) {
      context.handle(
          _technicianMeta,
          technician.isAcceptableOrUnknown(
              data['technician']!, _technicianMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Appointment map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Appointment(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      workOrderId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}work_order_id'])!,
      scheduledStart: attachedDatabase.typeMapping.read(
          DriftSqlType.dateTime, data['${effectivePrefix}scheduled_start'])!,
      expectedDurationMinutes: attachedDatabase.typeMapping.read(
          DriftSqlType.int,
          data['${effectivePrefix}expected_duration_minutes']),
      technician: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}technician']),
    );
  }

  @override
  $AppointmentsTable createAlias(String alias) {
    return $AppointmentsTable(attachedDatabase, alias);
  }
}

class Appointment extends DataClass implements Insertable<Appointment> {
  final int id;
  final int workOrderId;
  final DateTime scheduledStart;
  final int? expectedDurationMinutes;
  final String? technician;
  const Appointment(
      {required this.id,
      required this.workOrderId,
      required this.scheduledStart,
      this.expectedDurationMinutes,
      this.technician});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['work_order_id'] = Variable<int>(workOrderId);
    map['scheduled_start'] = Variable<DateTime>(scheduledStart);
    if (!nullToAbsent || expectedDurationMinutes != null) {
      map['expected_duration_minutes'] = Variable<int>(expectedDurationMinutes);
    }
    if (!nullToAbsent || technician != null) {
      map['technician'] = Variable<String>(technician);
    }
    return map;
  }

  AppointmentsCompanion toCompanion(bool nullToAbsent) {
    return AppointmentsCompanion(
      id: Value(id),
      workOrderId: Value(workOrderId),
      scheduledStart: Value(scheduledStart),
      expectedDurationMinutes: expectedDurationMinutes == null && nullToAbsent
          ? const Value.absent()
          : Value(expectedDurationMinutes),
      technician: technician == null && nullToAbsent
          ? const Value.absent()
          : Value(technician),
    );
  }

  factory Appointment.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Appointment(
      id: serializer.fromJson<int>(json['id']),
      workOrderId: serializer.fromJson<int>(json['workOrderId']),
      scheduledStart: serializer.fromJson<DateTime>(json['scheduledStart']),
      expectedDurationMinutes:
          serializer.fromJson<int?>(json['expectedDurationMinutes']),
      technician: serializer.fromJson<String?>(json['technician']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'workOrderId': serializer.toJson<int>(workOrderId),
      'scheduledStart': serializer.toJson<DateTime>(scheduledStart),
      'expectedDurationMinutes':
          serializer.toJson<int?>(expectedDurationMinutes),
      'technician': serializer.toJson<String?>(technician),
    };
  }

  Appointment copyWith(
          {int? id,
          int? workOrderId,
          DateTime? scheduledStart,
          Value<int?> expectedDurationMinutes = const Value.absent(),
          Value<String?> technician = const Value.absent()}) =>
      Appointment(
        id: id ?? this.id,
        workOrderId: workOrderId ?? this.workOrderId,
        scheduledStart: scheduledStart ?? this.scheduledStart,
        expectedDurationMinutes: expectedDurationMinutes.present
            ? expectedDurationMinutes.value
            : this.expectedDurationMinutes,
        technician: technician.present ? technician.value : this.technician,
      );
  Appointment copyWithCompanion(AppointmentsCompanion data) {
    return Appointment(
      id: data.id.present ? data.id.value : this.id,
      workOrderId:
          data.workOrderId.present ? data.workOrderId.value : this.workOrderId,
      scheduledStart: data.scheduledStart.present
          ? data.scheduledStart.value
          : this.scheduledStart,
      expectedDurationMinutes: data.expectedDurationMinutes.present
          ? data.expectedDurationMinutes.value
          : this.expectedDurationMinutes,
      technician:
          data.technician.present ? data.technician.value : this.technician,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Appointment(')
          ..write('id: $id, ')
          ..write('workOrderId: $workOrderId, ')
          ..write('scheduledStart: $scheduledStart, ')
          ..write('expectedDurationMinutes: $expectedDurationMinutes, ')
          ..write('technician: $technician')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id, workOrderId, scheduledStart, expectedDurationMinutes, technician);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Appointment &&
          other.id == this.id &&
          other.workOrderId == this.workOrderId &&
          other.scheduledStart == this.scheduledStart &&
          other.expectedDurationMinutes == this.expectedDurationMinutes &&
          other.technician == this.technician);
}

class AppointmentsCompanion extends UpdateCompanion<Appointment> {
  final Value<int> id;
  final Value<int> workOrderId;
  final Value<DateTime> scheduledStart;
  final Value<int?> expectedDurationMinutes;
  final Value<String?> technician;
  const AppointmentsCompanion({
    this.id = const Value.absent(),
    this.workOrderId = const Value.absent(),
    this.scheduledStart = const Value.absent(),
    this.expectedDurationMinutes = const Value.absent(),
    this.technician = const Value.absent(),
  });
  AppointmentsCompanion.insert({
    this.id = const Value.absent(),
    required int workOrderId,
    required DateTime scheduledStart,
    this.expectedDurationMinutes = const Value.absent(),
    this.technician = const Value.absent(),
  })  : workOrderId = Value(workOrderId),
        scheduledStart = Value(scheduledStart);
  static Insertable<Appointment> custom({
    Expression<int>? id,
    Expression<int>? workOrderId,
    Expression<DateTime>? scheduledStart,
    Expression<int>? expectedDurationMinutes,
    Expression<String>? technician,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (workOrderId != null) 'work_order_id': workOrderId,
      if (scheduledStart != null) 'scheduled_start': scheduledStart,
      if (expectedDurationMinutes != null)
        'expected_duration_minutes': expectedDurationMinutes,
      if (technician != null) 'technician': technician,
    });
  }

  AppointmentsCompanion copyWith(
      {Value<int>? id,
      Value<int>? workOrderId,
      Value<DateTime>? scheduledStart,
      Value<int?>? expectedDurationMinutes,
      Value<String?>? technician}) {
    return AppointmentsCompanion(
      id: id ?? this.id,
      workOrderId: workOrderId ?? this.workOrderId,
      scheduledStart: scheduledStart ?? this.scheduledStart,
      expectedDurationMinutes:
          expectedDurationMinutes ?? this.expectedDurationMinutes,
      technician: technician ?? this.technician,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (workOrderId.present) {
      map['work_order_id'] = Variable<int>(workOrderId.value);
    }
    if (scheduledStart.present) {
      map['scheduled_start'] = Variable<DateTime>(scheduledStart.value);
    }
    if (expectedDurationMinutes.present) {
      map['expected_duration_minutes'] =
          Variable<int>(expectedDurationMinutes.value);
    }
    if (technician.present) {
      map['technician'] = Variable<String>(technician.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AppointmentsCompanion(')
          ..write('id: $id, ')
          ..write('workOrderId: $workOrderId, ')
          ..write('scheduledStart: $scheduledStart, ')
          ..write('expectedDurationMinutes: $expectedDurationMinutes, ')
          ..write('technician: $technician')
          ..write(')'))
        .toString();
  }
}

class $EquipmentTable extends Equipment
    with TableInfo<$EquipmentTable, EquipmentData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $EquipmentTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _siteIdMeta = const VerificationMeta('siteId');
  @override
  late final GeneratedColumn<int> siteId = GeneratedColumn<int>(
      'site_id', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _equipmentTypeMeta =
      const VerificationMeta('equipmentType');
  @override
  late final GeneratedColumn<String> equipmentType = GeneratedColumn<String>(
      'equipment_type', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _manufacturerMeta =
      const VerificationMeta('manufacturer');
  @override
  late final GeneratedColumn<String> manufacturer = GeneratedColumn<String>(
      'manufacturer', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _modelMeta = const VerificationMeta('model');
  @override
  late final GeneratedColumn<String> model = GeneratedColumn<String>(
      'model', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _serialNumberMeta =
      const VerificationMeta('serialNumber');
  @override
  late final GeneratedColumn<String> serialNumber = GeneratedColumn<String>(
      'serial_number', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _underWarrantyMeta =
      const VerificationMeta('underWarranty');
  @override
  late final GeneratedColumn<bool> underWarranty = GeneratedColumn<bool>(
      'under_warranty', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("under_warranty" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _underServiceContractMeta =
      const VerificationMeta('underServiceContract');
  @override
  late final GeneratedColumn<bool> underServiceContract = GeneratedColumn<bool>(
      'under_service_contract', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("under_service_contract" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _contractReferenceMeta =
      const VerificationMeta('contractReference');
  @override
  late final GeneratedColumn<String> contractReference =
      GeneratedColumn<String>('contract_reference', aliasedName, true,
          type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _activeMeta = const VerificationMeta('active');
  @override
  late final GeneratedColumn<bool> active = GeneratedColumn<bool>(
      'active', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("active" IN (0, 1))'),
      defaultValue: const Constant(true));
  @override
  List<GeneratedColumn> get $columns => [
        id,
        siteId,
        equipmentType,
        manufacturer,
        model,
        serialNumber,
        underWarranty,
        underServiceContract,
        contractReference,
        active
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'equipment';
  @override
  VerificationContext validateIntegrity(Insertable<EquipmentData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('site_id')) {
      context.handle(_siteIdMeta,
          siteId.isAcceptableOrUnknown(data['site_id']!, _siteIdMeta));
    } else if (isInserting) {
      context.missing(_siteIdMeta);
    }
    if (data.containsKey('equipment_type')) {
      context.handle(
          _equipmentTypeMeta,
          equipmentType.isAcceptableOrUnknown(
              data['equipment_type']!, _equipmentTypeMeta));
    } else if (isInserting) {
      context.missing(_equipmentTypeMeta);
    }
    if (data.containsKey('manufacturer')) {
      context.handle(
          _manufacturerMeta,
          manufacturer.isAcceptableOrUnknown(
              data['manufacturer']!, _manufacturerMeta));
    }
    if (data.containsKey('model')) {
      context.handle(
          _modelMeta, model.isAcceptableOrUnknown(data['model']!, _modelMeta));
    }
    if (data.containsKey('serial_number')) {
      context.handle(
          _serialNumberMeta,
          serialNumber.isAcceptableOrUnknown(
              data['serial_number']!, _serialNumberMeta));
    }
    if (data.containsKey('under_warranty')) {
      context.handle(
          _underWarrantyMeta,
          underWarranty.isAcceptableOrUnknown(
              data['under_warranty']!, _underWarrantyMeta));
    }
    if (data.containsKey('under_service_contract')) {
      context.handle(
          _underServiceContractMeta,
          underServiceContract.isAcceptableOrUnknown(
              data['under_service_contract']!, _underServiceContractMeta));
    }
    if (data.containsKey('contract_reference')) {
      context.handle(
          _contractReferenceMeta,
          contractReference.isAcceptableOrUnknown(
              data['contract_reference']!, _contractReferenceMeta));
    }
    if (data.containsKey('active')) {
      context.handle(_activeMeta,
          active.isAcceptableOrUnknown(data['active']!, _activeMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  EquipmentData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return EquipmentData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      siteId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}site_id'])!,
      equipmentType: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}equipment_type'])!,
      manufacturer: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}manufacturer']),
      model: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}model']),
      serialNumber: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}serial_number']),
      underWarranty: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}under_warranty'])!,
      underServiceContract: attachedDatabase.typeMapping.read(
          DriftSqlType.bool, data['${effectivePrefix}under_service_contract'])!,
      contractReference: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}contract_reference']),
      active: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}active'])!,
    );
  }

  @override
  $EquipmentTable createAlias(String alias) {
    return $EquipmentTable(attachedDatabase, alias);
  }
}

class EquipmentData extends DataClass implements Insertable<EquipmentData> {
  final int id;
  final int siteId;
  final String equipmentType;
  final String? manufacturer;
  final String? model;
  final String? serialNumber;
  final bool underWarranty;
  final bool underServiceContract;
  final String? contractReference;
  final bool active;
  const EquipmentData(
      {required this.id,
      required this.siteId,
      required this.equipmentType,
      this.manufacturer,
      this.model,
      this.serialNumber,
      required this.underWarranty,
      required this.underServiceContract,
      this.contractReference,
      required this.active});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['site_id'] = Variable<int>(siteId);
    map['equipment_type'] = Variable<String>(equipmentType);
    if (!nullToAbsent || manufacturer != null) {
      map['manufacturer'] = Variable<String>(manufacturer);
    }
    if (!nullToAbsent || model != null) {
      map['model'] = Variable<String>(model);
    }
    if (!nullToAbsent || serialNumber != null) {
      map['serial_number'] = Variable<String>(serialNumber);
    }
    map['under_warranty'] = Variable<bool>(underWarranty);
    map['under_service_contract'] = Variable<bool>(underServiceContract);
    if (!nullToAbsent || contractReference != null) {
      map['contract_reference'] = Variable<String>(contractReference);
    }
    map['active'] = Variable<bool>(active);
    return map;
  }

  EquipmentCompanion toCompanion(bool nullToAbsent) {
    return EquipmentCompanion(
      id: Value(id),
      siteId: Value(siteId),
      equipmentType: Value(equipmentType),
      manufacturer: manufacturer == null && nullToAbsent
          ? const Value.absent()
          : Value(manufacturer),
      model:
          model == null && nullToAbsent ? const Value.absent() : Value(model),
      serialNumber: serialNumber == null && nullToAbsent
          ? const Value.absent()
          : Value(serialNumber),
      underWarranty: Value(underWarranty),
      underServiceContract: Value(underServiceContract),
      contractReference: contractReference == null && nullToAbsent
          ? const Value.absent()
          : Value(contractReference),
      active: Value(active),
    );
  }

  factory EquipmentData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return EquipmentData(
      id: serializer.fromJson<int>(json['id']),
      siteId: serializer.fromJson<int>(json['siteId']),
      equipmentType: serializer.fromJson<String>(json['equipmentType']),
      manufacturer: serializer.fromJson<String?>(json['manufacturer']),
      model: serializer.fromJson<String?>(json['model']),
      serialNumber: serializer.fromJson<String?>(json['serialNumber']),
      underWarranty: serializer.fromJson<bool>(json['underWarranty']),
      underServiceContract:
          serializer.fromJson<bool>(json['underServiceContract']),
      contractReference:
          serializer.fromJson<String?>(json['contractReference']),
      active: serializer.fromJson<bool>(json['active']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'siteId': serializer.toJson<int>(siteId),
      'equipmentType': serializer.toJson<String>(equipmentType),
      'manufacturer': serializer.toJson<String?>(manufacturer),
      'model': serializer.toJson<String?>(model),
      'serialNumber': serializer.toJson<String?>(serialNumber),
      'underWarranty': serializer.toJson<bool>(underWarranty),
      'underServiceContract': serializer.toJson<bool>(underServiceContract),
      'contractReference': serializer.toJson<String?>(contractReference),
      'active': serializer.toJson<bool>(active),
    };
  }

  EquipmentData copyWith(
          {int? id,
          int? siteId,
          String? equipmentType,
          Value<String?> manufacturer = const Value.absent(),
          Value<String?> model = const Value.absent(),
          Value<String?> serialNumber = const Value.absent(),
          bool? underWarranty,
          bool? underServiceContract,
          Value<String?> contractReference = const Value.absent(),
          bool? active}) =>
      EquipmentData(
        id: id ?? this.id,
        siteId: siteId ?? this.siteId,
        equipmentType: equipmentType ?? this.equipmentType,
        manufacturer:
            manufacturer.present ? manufacturer.value : this.manufacturer,
        model: model.present ? model.value : this.model,
        serialNumber:
            serialNumber.present ? serialNumber.value : this.serialNumber,
        underWarranty: underWarranty ?? this.underWarranty,
        underServiceContract: underServiceContract ?? this.underServiceContract,
        contractReference: contractReference.present
            ? contractReference.value
            : this.contractReference,
        active: active ?? this.active,
      );
  EquipmentData copyWithCompanion(EquipmentCompanion data) {
    return EquipmentData(
      id: data.id.present ? data.id.value : this.id,
      siteId: data.siteId.present ? data.siteId.value : this.siteId,
      equipmentType: data.equipmentType.present
          ? data.equipmentType.value
          : this.equipmentType,
      manufacturer: data.manufacturer.present
          ? data.manufacturer.value
          : this.manufacturer,
      model: data.model.present ? data.model.value : this.model,
      serialNumber: data.serialNumber.present
          ? data.serialNumber.value
          : this.serialNumber,
      underWarranty: data.underWarranty.present
          ? data.underWarranty.value
          : this.underWarranty,
      underServiceContract: data.underServiceContract.present
          ? data.underServiceContract.value
          : this.underServiceContract,
      contractReference: data.contractReference.present
          ? data.contractReference.value
          : this.contractReference,
      active: data.active.present ? data.active.value : this.active,
    );
  }

  @override
  String toString() {
    return (StringBuffer('EquipmentData(')
          ..write('id: $id, ')
          ..write('siteId: $siteId, ')
          ..write('equipmentType: $equipmentType, ')
          ..write('manufacturer: $manufacturer, ')
          ..write('model: $model, ')
          ..write('serialNumber: $serialNumber, ')
          ..write('underWarranty: $underWarranty, ')
          ..write('underServiceContract: $underServiceContract, ')
          ..write('contractReference: $contractReference, ')
          ..write('active: $active')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id,
      siteId,
      equipmentType,
      manufacturer,
      model,
      serialNumber,
      underWarranty,
      underServiceContract,
      contractReference,
      active);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is EquipmentData &&
          other.id == this.id &&
          other.siteId == this.siteId &&
          other.equipmentType == this.equipmentType &&
          other.manufacturer == this.manufacturer &&
          other.model == this.model &&
          other.serialNumber == this.serialNumber &&
          other.underWarranty == this.underWarranty &&
          other.underServiceContract == this.underServiceContract &&
          other.contractReference == this.contractReference &&
          other.active == this.active);
}

class EquipmentCompanion extends UpdateCompanion<EquipmentData> {
  final Value<int> id;
  final Value<int> siteId;
  final Value<String> equipmentType;
  final Value<String?> manufacturer;
  final Value<String?> model;
  final Value<String?> serialNumber;
  final Value<bool> underWarranty;
  final Value<bool> underServiceContract;
  final Value<String?> contractReference;
  final Value<bool> active;
  const EquipmentCompanion({
    this.id = const Value.absent(),
    this.siteId = const Value.absent(),
    this.equipmentType = const Value.absent(),
    this.manufacturer = const Value.absent(),
    this.model = const Value.absent(),
    this.serialNumber = const Value.absent(),
    this.underWarranty = const Value.absent(),
    this.underServiceContract = const Value.absent(),
    this.contractReference = const Value.absent(),
    this.active = const Value.absent(),
  });
  EquipmentCompanion.insert({
    this.id = const Value.absent(),
    required int siteId,
    required String equipmentType,
    this.manufacturer = const Value.absent(),
    this.model = const Value.absent(),
    this.serialNumber = const Value.absent(),
    this.underWarranty = const Value.absent(),
    this.underServiceContract = const Value.absent(),
    this.contractReference = const Value.absent(),
    this.active = const Value.absent(),
  })  : siteId = Value(siteId),
        equipmentType = Value(equipmentType);
  static Insertable<EquipmentData> custom({
    Expression<int>? id,
    Expression<int>? siteId,
    Expression<String>? equipmentType,
    Expression<String>? manufacturer,
    Expression<String>? model,
    Expression<String>? serialNumber,
    Expression<bool>? underWarranty,
    Expression<bool>? underServiceContract,
    Expression<String>? contractReference,
    Expression<bool>? active,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (siteId != null) 'site_id': siteId,
      if (equipmentType != null) 'equipment_type': equipmentType,
      if (manufacturer != null) 'manufacturer': manufacturer,
      if (model != null) 'model': model,
      if (serialNumber != null) 'serial_number': serialNumber,
      if (underWarranty != null) 'under_warranty': underWarranty,
      if (underServiceContract != null)
        'under_service_contract': underServiceContract,
      if (contractReference != null) 'contract_reference': contractReference,
      if (active != null) 'active': active,
    });
  }

  EquipmentCompanion copyWith(
      {Value<int>? id,
      Value<int>? siteId,
      Value<String>? equipmentType,
      Value<String?>? manufacturer,
      Value<String?>? model,
      Value<String?>? serialNumber,
      Value<bool>? underWarranty,
      Value<bool>? underServiceContract,
      Value<String?>? contractReference,
      Value<bool>? active}) {
    return EquipmentCompanion(
      id: id ?? this.id,
      siteId: siteId ?? this.siteId,
      equipmentType: equipmentType ?? this.equipmentType,
      manufacturer: manufacturer ?? this.manufacturer,
      model: model ?? this.model,
      serialNumber: serialNumber ?? this.serialNumber,
      underWarranty: underWarranty ?? this.underWarranty,
      underServiceContract: underServiceContract ?? this.underServiceContract,
      contractReference: contractReference ?? this.contractReference,
      active: active ?? this.active,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (siteId.present) {
      map['site_id'] = Variable<int>(siteId.value);
    }
    if (equipmentType.present) {
      map['equipment_type'] = Variable<String>(equipmentType.value);
    }
    if (manufacturer.present) {
      map['manufacturer'] = Variable<String>(manufacturer.value);
    }
    if (model.present) {
      map['model'] = Variable<String>(model.value);
    }
    if (serialNumber.present) {
      map['serial_number'] = Variable<String>(serialNumber.value);
    }
    if (underWarranty.present) {
      map['under_warranty'] = Variable<bool>(underWarranty.value);
    }
    if (underServiceContract.present) {
      map['under_service_contract'] =
          Variable<bool>(underServiceContract.value);
    }
    if (contractReference.present) {
      map['contract_reference'] = Variable<String>(contractReference.value);
    }
    if (active.present) {
      map['active'] = Variable<bool>(active.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('EquipmentCompanion(')
          ..write('id: $id, ')
          ..write('siteId: $siteId, ')
          ..write('equipmentType: $equipmentType, ')
          ..write('manufacturer: $manufacturer, ')
          ..write('model: $model, ')
          ..write('serialNumber: $serialNumber, ')
          ..write('underWarranty: $underWarranty, ')
          ..write('underServiceContract: $underServiceContract, ')
          ..write('contractReference: $contractReference, ')
          ..write('active: $active')
          ..write(')'))
        .toString();
  }
}

class $WorkOrderEquipmentTable extends WorkOrderEquipment
    with TableInfo<$WorkOrderEquipmentTable, WorkOrderEquipmentData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $WorkOrderEquipmentTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _workOrderIdMeta =
      const VerificationMeta('workOrderId');
  @override
  late final GeneratedColumn<int> workOrderId = GeneratedColumn<int>(
      'work_order_id', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _equipmentIdMeta =
      const VerificationMeta('equipmentId');
  @override
  late final GeneratedColumn<int> equipmentId = GeneratedColumn<int>(
      'equipment_id', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [workOrderId, equipmentId];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'work_order_equipment';
  @override
  VerificationContext validateIntegrity(
      Insertable<WorkOrderEquipmentData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('work_order_id')) {
      context.handle(
          _workOrderIdMeta,
          workOrderId.isAcceptableOrUnknown(
              data['work_order_id']!, _workOrderIdMeta));
    } else if (isInserting) {
      context.missing(_workOrderIdMeta);
    }
    if (data.containsKey('equipment_id')) {
      context.handle(
          _equipmentIdMeta,
          equipmentId.isAcceptableOrUnknown(
              data['equipment_id']!, _equipmentIdMeta));
    } else if (isInserting) {
      context.missing(_equipmentIdMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {workOrderId, equipmentId};
  @override
  WorkOrderEquipmentData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return WorkOrderEquipmentData(
      workOrderId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}work_order_id'])!,
      equipmentId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}equipment_id'])!,
    );
  }

  @override
  $WorkOrderEquipmentTable createAlias(String alias) {
    return $WorkOrderEquipmentTable(attachedDatabase, alias);
  }
}

class WorkOrderEquipmentData extends DataClass
    implements Insertable<WorkOrderEquipmentData> {
  final int workOrderId;
  final int equipmentId;
  const WorkOrderEquipmentData(
      {required this.workOrderId, required this.equipmentId});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['work_order_id'] = Variable<int>(workOrderId);
    map['equipment_id'] = Variable<int>(equipmentId);
    return map;
  }

  WorkOrderEquipmentCompanion toCompanion(bool nullToAbsent) {
    return WorkOrderEquipmentCompanion(
      workOrderId: Value(workOrderId),
      equipmentId: Value(equipmentId),
    );
  }

  factory WorkOrderEquipmentData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return WorkOrderEquipmentData(
      workOrderId: serializer.fromJson<int>(json['workOrderId']),
      equipmentId: serializer.fromJson<int>(json['equipmentId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'workOrderId': serializer.toJson<int>(workOrderId),
      'equipmentId': serializer.toJson<int>(equipmentId),
    };
  }

  WorkOrderEquipmentData copyWith({int? workOrderId, int? equipmentId}) =>
      WorkOrderEquipmentData(
        workOrderId: workOrderId ?? this.workOrderId,
        equipmentId: equipmentId ?? this.equipmentId,
      );
  WorkOrderEquipmentData copyWithCompanion(WorkOrderEquipmentCompanion data) {
    return WorkOrderEquipmentData(
      workOrderId:
          data.workOrderId.present ? data.workOrderId.value : this.workOrderId,
      equipmentId:
          data.equipmentId.present ? data.equipmentId.value : this.equipmentId,
    );
  }

  @override
  String toString() {
    return (StringBuffer('WorkOrderEquipmentData(')
          ..write('workOrderId: $workOrderId, ')
          ..write('equipmentId: $equipmentId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(workOrderId, equipmentId);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is WorkOrderEquipmentData &&
          other.workOrderId == this.workOrderId &&
          other.equipmentId == this.equipmentId);
}

class WorkOrderEquipmentCompanion
    extends UpdateCompanion<WorkOrderEquipmentData> {
  final Value<int> workOrderId;
  final Value<int> equipmentId;
  final Value<int> rowid;
  const WorkOrderEquipmentCompanion({
    this.workOrderId = const Value.absent(),
    this.equipmentId = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  WorkOrderEquipmentCompanion.insert({
    required int workOrderId,
    required int equipmentId,
    this.rowid = const Value.absent(),
  })  : workOrderId = Value(workOrderId),
        equipmentId = Value(equipmentId);
  static Insertable<WorkOrderEquipmentData> custom({
    Expression<int>? workOrderId,
    Expression<int>? equipmentId,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (workOrderId != null) 'work_order_id': workOrderId,
      if (equipmentId != null) 'equipment_id': equipmentId,
      if (rowid != null) 'rowid': rowid,
    });
  }

  WorkOrderEquipmentCompanion copyWith(
      {Value<int>? workOrderId, Value<int>? equipmentId, Value<int>? rowid}) {
    return WorkOrderEquipmentCompanion(
      workOrderId: workOrderId ?? this.workOrderId,
      equipmentId: equipmentId ?? this.equipmentId,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (workOrderId.present) {
      map['work_order_id'] = Variable<int>(workOrderId.value);
    }
    if (equipmentId.present) {
      map['equipment_id'] = Variable<int>(equipmentId.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('WorkOrderEquipmentCompanion(')
          ..write('workOrderId: $workOrderId, ')
          ..write('equipmentId: $equipmentId, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $WorkPerformedTable extends WorkPerformed
    with TableInfo<$WorkPerformedTable, WorkPerformedData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $WorkPerformedTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _workOrderIdMeta =
      const VerificationMeta('workOrderId');
  @override
  late final GeneratedColumn<int> workOrderId = GeneratedColumn<int>(
      'work_order_id', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _equipmentIdMeta =
      const VerificationMeta('equipmentId');
  @override
  late final GeneratedColumn<int> equipmentId = GeneratedColumn<int>(
      'equipment_id', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _technicianMeta =
      const VerificationMeta('technician');
  @override
  late final GeneratedColumn<String> technician = GeneratedColumn<String>(
      'technician', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _startedAtMeta =
      const VerificationMeta('startedAt');
  @override
  late final GeneratedColumn<DateTime> startedAt = GeneratedColumn<DateTime>(
      'started_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _durationMinutesMeta =
      const VerificationMeta('durationMinutes');
  @override
  late final GeneratedColumn<int> durationMinutes = GeneratedColumn<int>(
      'duration_minutes', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _workDescriptionMeta =
      const VerificationMeta('workDescription');
  @override
  late final GeneratedColumn<String> workDescription = GeneratedColumn<String>(
      'work_description', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _resolutionMeta =
      const VerificationMeta('resolution');
  @override
  late final GeneratedColumn<String> resolution = GeneratedColumn<String>(
      'resolution', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _repeatIssueMeta =
      const VerificationMeta('repeatIssue');
  @override
  late final GeneratedColumn<bool> repeatIssue = GeneratedColumn<bool>(
      'repeat_issue', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("repeat_issue" IN (0, 1))'),
      defaultValue: const Constant(false));
  @override
  List<GeneratedColumn> get $columns => [
        id,
        workOrderId,
        equipmentId,
        technician,
        startedAt,
        durationMinutes,
        workDescription,
        resolution,
        repeatIssue
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'work_performed';
  @override
  VerificationContext validateIntegrity(Insertable<WorkPerformedData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('work_order_id')) {
      context.handle(
          _workOrderIdMeta,
          workOrderId.isAcceptableOrUnknown(
              data['work_order_id']!, _workOrderIdMeta));
    } else if (isInserting) {
      context.missing(_workOrderIdMeta);
    }
    if (data.containsKey('equipment_id')) {
      context.handle(
          _equipmentIdMeta,
          equipmentId.isAcceptableOrUnknown(
              data['equipment_id']!, _equipmentIdMeta));
    }
    if (data.containsKey('technician')) {
      context.handle(
          _technicianMeta,
          technician.isAcceptableOrUnknown(
              data['technician']!, _technicianMeta));
    } else if (isInserting) {
      context.missing(_technicianMeta);
    }
    if (data.containsKey('started_at')) {
      context.handle(_startedAtMeta,
          startedAt.isAcceptableOrUnknown(data['started_at']!, _startedAtMeta));
    } else if (isInserting) {
      context.missing(_startedAtMeta);
    }
    if (data.containsKey('duration_minutes')) {
      context.handle(
          _durationMinutesMeta,
          durationMinutes.isAcceptableOrUnknown(
              data['duration_minutes']!, _durationMinutesMeta));
    }
    if (data.containsKey('work_description')) {
      context.handle(
          _workDescriptionMeta,
          workDescription.isAcceptableOrUnknown(
              data['work_description']!, _workDescriptionMeta));
    }
    if (data.containsKey('resolution')) {
      context.handle(
          _resolutionMeta,
          resolution.isAcceptableOrUnknown(
              data['resolution']!, _resolutionMeta));
    }
    if (data.containsKey('repeat_issue')) {
      context.handle(
          _repeatIssueMeta,
          repeatIssue.isAcceptableOrUnknown(
              data['repeat_issue']!, _repeatIssueMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  WorkPerformedData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return WorkPerformedData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      workOrderId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}work_order_id'])!,
      equipmentId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}equipment_id']),
      technician: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}technician'])!,
      startedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}started_at'])!,
      durationMinutes: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}duration_minutes']),
      workDescription: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}work_description']),
      resolution: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}resolution']),
      repeatIssue: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}repeat_issue'])!,
    );
  }

  @override
  $WorkPerformedTable createAlias(String alias) {
    return $WorkPerformedTable(attachedDatabase, alias);
  }
}

class WorkPerformedData extends DataClass
    implements Insertable<WorkPerformedData> {
  final int id;
  final int workOrderId;
  final int? equipmentId;
  final String technician;
  final DateTime startedAt;
  final int? durationMinutes;
  final String? workDescription;
  final String? resolution;
  final bool repeatIssue;
  const WorkPerformedData(
      {required this.id,
      required this.workOrderId,
      this.equipmentId,
      required this.technician,
      required this.startedAt,
      this.durationMinutes,
      this.workDescription,
      this.resolution,
      required this.repeatIssue});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['work_order_id'] = Variable<int>(workOrderId);
    if (!nullToAbsent || equipmentId != null) {
      map['equipment_id'] = Variable<int>(equipmentId);
    }
    map['technician'] = Variable<String>(technician);
    map['started_at'] = Variable<DateTime>(startedAt);
    if (!nullToAbsent || durationMinutes != null) {
      map['duration_minutes'] = Variable<int>(durationMinutes);
    }
    if (!nullToAbsent || workDescription != null) {
      map['work_description'] = Variable<String>(workDescription);
    }
    if (!nullToAbsent || resolution != null) {
      map['resolution'] = Variable<String>(resolution);
    }
    map['repeat_issue'] = Variable<bool>(repeatIssue);
    return map;
  }

  WorkPerformedCompanion toCompanion(bool nullToAbsent) {
    return WorkPerformedCompanion(
      id: Value(id),
      workOrderId: Value(workOrderId),
      equipmentId: equipmentId == null && nullToAbsent
          ? const Value.absent()
          : Value(equipmentId),
      technician: Value(technician),
      startedAt: Value(startedAt),
      durationMinutes: durationMinutes == null && nullToAbsent
          ? const Value.absent()
          : Value(durationMinutes),
      workDescription: workDescription == null && nullToAbsent
          ? const Value.absent()
          : Value(workDescription),
      resolution: resolution == null && nullToAbsent
          ? const Value.absent()
          : Value(resolution),
      repeatIssue: Value(repeatIssue),
    );
  }

  factory WorkPerformedData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return WorkPerformedData(
      id: serializer.fromJson<int>(json['id']),
      workOrderId: serializer.fromJson<int>(json['workOrderId']),
      equipmentId: serializer.fromJson<int?>(json['equipmentId']),
      technician: serializer.fromJson<String>(json['technician']),
      startedAt: serializer.fromJson<DateTime>(json['startedAt']),
      durationMinutes: serializer.fromJson<int?>(json['durationMinutes']),
      workDescription: serializer.fromJson<String?>(json['workDescription']),
      resolution: serializer.fromJson<String?>(json['resolution']),
      repeatIssue: serializer.fromJson<bool>(json['repeatIssue']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'workOrderId': serializer.toJson<int>(workOrderId),
      'equipmentId': serializer.toJson<int?>(equipmentId),
      'technician': serializer.toJson<String>(technician),
      'startedAt': serializer.toJson<DateTime>(startedAt),
      'durationMinutes': serializer.toJson<int?>(durationMinutes),
      'workDescription': serializer.toJson<String?>(workDescription),
      'resolution': serializer.toJson<String?>(resolution),
      'repeatIssue': serializer.toJson<bool>(repeatIssue),
    };
  }

  WorkPerformedData copyWith(
          {int? id,
          int? workOrderId,
          Value<int?> equipmentId = const Value.absent(),
          String? technician,
          DateTime? startedAt,
          Value<int?> durationMinutes = const Value.absent(),
          Value<String?> workDescription = const Value.absent(),
          Value<String?> resolution = const Value.absent(),
          bool? repeatIssue}) =>
      WorkPerformedData(
        id: id ?? this.id,
        workOrderId: workOrderId ?? this.workOrderId,
        equipmentId: equipmentId.present ? equipmentId.value : this.equipmentId,
        technician: technician ?? this.technician,
        startedAt: startedAt ?? this.startedAt,
        durationMinutes: durationMinutes.present
            ? durationMinutes.value
            : this.durationMinutes,
        workDescription: workDescription.present
            ? workDescription.value
            : this.workDescription,
        resolution: resolution.present ? resolution.value : this.resolution,
        repeatIssue: repeatIssue ?? this.repeatIssue,
      );
  WorkPerformedData copyWithCompanion(WorkPerformedCompanion data) {
    return WorkPerformedData(
      id: data.id.present ? data.id.value : this.id,
      workOrderId:
          data.workOrderId.present ? data.workOrderId.value : this.workOrderId,
      equipmentId:
          data.equipmentId.present ? data.equipmentId.value : this.equipmentId,
      technician:
          data.technician.present ? data.technician.value : this.technician,
      startedAt: data.startedAt.present ? data.startedAt.value : this.startedAt,
      durationMinutes: data.durationMinutes.present
          ? data.durationMinutes.value
          : this.durationMinutes,
      workDescription: data.workDescription.present
          ? data.workDescription.value
          : this.workDescription,
      resolution:
          data.resolution.present ? data.resolution.value : this.resolution,
      repeatIssue:
          data.repeatIssue.present ? data.repeatIssue.value : this.repeatIssue,
    );
  }

  @override
  String toString() {
    return (StringBuffer('WorkPerformedData(')
          ..write('id: $id, ')
          ..write('workOrderId: $workOrderId, ')
          ..write('equipmentId: $equipmentId, ')
          ..write('technician: $technician, ')
          ..write('startedAt: $startedAt, ')
          ..write('durationMinutes: $durationMinutes, ')
          ..write('workDescription: $workDescription, ')
          ..write('resolution: $resolution, ')
          ..write('repeatIssue: $repeatIssue')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, workOrderId, equipmentId, technician,
      startedAt, durationMinutes, workDescription, resolution, repeatIssue);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is WorkPerformedData &&
          other.id == this.id &&
          other.workOrderId == this.workOrderId &&
          other.equipmentId == this.equipmentId &&
          other.technician == this.technician &&
          other.startedAt == this.startedAt &&
          other.durationMinutes == this.durationMinutes &&
          other.workDescription == this.workDescription &&
          other.resolution == this.resolution &&
          other.repeatIssue == this.repeatIssue);
}

class WorkPerformedCompanion extends UpdateCompanion<WorkPerformedData> {
  final Value<int> id;
  final Value<int> workOrderId;
  final Value<int?> equipmentId;
  final Value<String> technician;
  final Value<DateTime> startedAt;
  final Value<int?> durationMinutes;
  final Value<String?> workDescription;
  final Value<String?> resolution;
  final Value<bool> repeatIssue;
  const WorkPerformedCompanion({
    this.id = const Value.absent(),
    this.workOrderId = const Value.absent(),
    this.equipmentId = const Value.absent(),
    this.technician = const Value.absent(),
    this.startedAt = const Value.absent(),
    this.durationMinutes = const Value.absent(),
    this.workDescription = const Value.absent(),
    this.resolution = const Value.absent(),
    this.repeatIssue = const Value.absent(),
  });
  WorkPerformedCompanion.insert({
    this.id = const Value.absent(),
    required int workOrderId,
    this.equipmentId = const Value.absent(),
    required String technician,
    required DateTime startedAt,
    this.durationMinutes = const Value.absent(),
    this.workDescription = const Value.absent(),
    this.resolution = const Value.absent(),
    this.repeatIssue = const Value.absent(),
  })  : workOrderId = Value(workOrderId),
        technician = Value(technician),
        startedAt = Value(startedAt);
  static Insertable<WorkPerformedData> custom({
    Expression<int>? id,
    Expression<int>? workOrderId,
    Expression<int>? equipmentId,
    Expression<String>? technician,
    Expression<DateTime>? startedAt,
    Expression<int>? durationMinutes,
    Expression<String>? workDescription,
    Expression<String>? resolution,
    Expression<bool>? repeatIssue,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (workOrderId != null) 'work_order_id': workOrderId,
      if (equipmentId != null) 'equipment_id': equipmentId,
      if (technician != null) 'technician': technician,
      if (startedAt != null) 'started_at': startedAt,
      if (durationMinutes != null) 'duration_minutes': durationMinutes,
      if (workDescription != null) 'work_description': workDescription,
      if (resolution != null) 'resolution': resolution,
      if (repeatIssue != null) 'repeat_issue': repeatIssue,
    });
  }

  WorkPerformedCompanion copyWith(
      {Value<int>? id,
      Value<int>? workOrderId,
      Value<int?>? equipmentId,
      Value<String>? technician,
      Value<DateTime>? startedAt,
      Value<int?>? durationMinutes,
      Value<String?>? workDescription,
      Value<String?>? resolution,
      Value<bool>? repeatIssue}) {
    return WorkPerformedCompanion(
      id: id ?? this.id,
      workOrderId: workOrderId ?? this.workOrderId,
      equipmentId: equipmentId ?? this.equipmentId,
      technician: technician ?? this.technician,
      startedAt: startedAt ?? this.startedAt,
      durationMinutes: durationMinutes ?? this.durationMinutes,
      workDescription: workDescription ?? this.workDescription,
      resolution: resolution ?? this.resolution,
      repeatIssue: repeatIssue ?? this.repeatIssue,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (workOrderId.present) {
      map['work_order_id'] = Variable<int>(workOrderId.value);
    }
    if (equipmentId.present) {
      map['equipment_id'] = Variable<int>(equipmentId.value);
    }
    if (technician.present) {
      map['technician'] = Variable<String>(technician.value);
    }
    if (startedAt.present) {
      map['started_at'] = Variable<DateTime>(startedAt.value);
    }
    if (durationMinutes.present) {
      map['duration_minutes'] = Variable<int>(durationMinutes.value);
    }
    if (workDescription.present) {
      map['work_description'] = Variable<String>(workDescription.value);
    }
    if (resolution.present) {
      map['resolution'] = Variable<String>(resolution.value);
    }
    if (repeatIssue.present) {
      map['repeat_issue'] = Variable<bool>(repeatIssue.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('WorkPerformedCompanion(')
          ..write('id: $id, ')
          ..write('workOrderId: $workOrderId, ')
          ..write('equipmentId: $equipmentId, ')
          ..write('technician: $technician, ')
          ..write('startedAt: $startedAt, ')
          ..write('durationMinutes: $durationMinutes, ')
          ..write('workDescription: $workDescription, ')
          ..write('resolution: $resolution, ')
          ..write('repeatIssue: $repeatIssue')
          ..write(')'))
        .toString();
  }
}

class $PartsUsedTable extends PartsUsed
    with TableInfo<$PartsUsedTable, PartsUsedData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PartsUsedTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _workPerformedIdMeta =
      const VerificationMeta('workPerformedId');
  @override
  late final GeneratedColumn<int> workPerformedId = GeneratedColumn<int>(
      'work_performed_id', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _partNumberMeta =
      const VerificationMeta('partNumber');
  @override
  late final GeneratedColumn<String> partNumber = GeneratedColumn<String>(
      'part_number', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _descriptionMeta =
      const VerificationMeta('description');
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
      'description', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _quantityMeta =
      const VerificationMeta('quantity');
  @override
  late final GeneratedColumn<int> quantity = GeneratedColumn<int>(
      'quantity', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(1));
  @override
  List<GeneratedColumn> get $columns =>
      [id, workPerformedId, partNumber, description, quantity];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'parts_used';
  @override
  VerificationContext validateIntegrity(Insertable<PartsUsedData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('work_performed_id')) {
      context.handle(
          _workPerformedIdMeta,
          workPerformedId.isAcceptableOrUnknown(
              data['work_performed_id']!, _workPerformedIdMeta));
    } else if (isInserting) {
      context.missing(_workPerformedIdMeta);
    }
    if (data.containsKey('part_number')) {
      context.handle(
          _partNumberMeta,
          partNumber.isAcceptableOrUnknown(
              data['part_number']!, _partNumberMeta));
    }
    if (data.containsKey('description')) {
      context.handle(
          _descriptionMeta,
          description.isAcceptableOrUnknown(
              data['description']!, _descriptionMeta));
    }
    if (data.containsKey('quantity')) {
      context.handle(_quantityMeta,
          quantity.isAcceptableOrUnknown(data['quantity']!, _quantityMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  PartsUsedData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PartsUsedData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      workPerformedId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}work_performed_id'])!,
      partNumber: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}part_number']),
      description: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}description']),
      quantity: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}quantity'])!,
    );
  }

  @override
  $PartsUsedTable createAlias(String alias) {
    return $PartsUsedTable(attachedDatabase, alias);
  }
}

class PartsUsedData extends DataClass implements Insertable<PartsUsedData> {
  final int id;
  final int workPerformedId;
  final String? partNumber;
  final String? description;
  final int quantity;
  const PartsUsedData(
      {required this.id,
      required this.workPerformedId,
      this.partNumber,
      this.description,
      required this.quantity});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['work_performed_id'] = Variable<int>(workPerformedId);
    if (!nullToAbsent || partNumber != null) {
      map['part_number'] = Variable<String>(partNumber);
    }
    if (!nullToAbsent || description != null) {
      map['description'] = Variable<String>(description);
    }
    map['quantity'] = Variable<int>(quantity);
    return map;
  }

  PartsUsedCompanion toCompanion(bool nullToAbsent) {
    return PartsUsedCompanion(
      id: Value(id),
      workPerformedId: Value(workPerformedId),
      partNumber: partNumber == null && nullToAbsent
          ? const Value.absent()
          : Value(partNumber),
      description: description == null && nullToAbsent
          ? const Value.absent()
          : Value(description),
      quantity: Value(quantity),
    );
  }

  factory PartsUsedData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PartsUsedData(
      id: serializer.fromJson<int>(json['id']),
      workPerformedId: serializer.fromJson<int>(json['workPerformedId']),
      partNumber: serializer.fromJson<String?>(json['partNumber']),
      description: serializer.fromJson<String?>(json['description']),
      quantity: serializer.fromJson<int>(json['quantity']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'workPerformedId': serializer.toJson<int>(workPerformedId),
      'partNumber': serializer.toJson<String?>(partNumber),
      'description': serializer.toJson<String?>(description),
      'quantity': serializer.toJson<int>(quantity),
    };
  }

  PartsUsedData copyWith(
          {int? id,
          int? workPerformedId,
          Value<String?> partNumber = const Value.absent(),
          Value<String?> description = const Value.absent(),
          int? quantity}) =>
      PartsUsedData(
        id: id ?? this.id,
        workPerformedId: workPerformedId ?? this.workPerformedId,
        partNumber: partNumber.present ? partNumber.value : this.partNumber,
        description: description.present ? description.value : this.description,
        quantity: quantity ?? this.quantity,
      );
  PartsUsedData copyWithCompanion(PartsUsedCompanion data) {
    return PartsUsedData(
      id: data.id.present ? data.id.value : this.id,
      workPerformedId: data.workPerformedId.present
          ? data.workPerformedId.value
          : this.workPerformedId,
      partNumber:
          data.partNumber.present ? data.partNumber.value : this.partNumber,
      description:
          data.description.present ? data.description.value : this.description,
      quantity: data.quantity.present ? data.quantity.value : this.quantity,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PartsUsedData(')
          ..write('id: $id, ')
          ..write('workPerformedId: $workPerformedId, ')
          ..write('partNumber: $partNumber, ')
          ..write('description: $description, ')
          ..write('quantity: $quantity')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, workPerformedId, partNumber, description, quantity);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PartsUsedData &&
          other.id == this.id &&
          other.workPerformedId == this.workPerformedId &&
          other.partNumber == this.partNumber &&
          other.description == this.description &&
          other.quantity == this.quantity);
}

class PartsUsedCompanion extends UpdateCompanion<PartsUsedData> {
  final Value<int> id;
  final Value<int> workPerformedId;
  final Value<String?> partNumber;
  final Value<String?> description;
  final Value<int> quantity;
  const PartsUsedCompanion({
    this.id = const Value.absent(),
    this.workPerformedId = const Value.absent(),
    this.partNumber = const Value.absent(),
    this.description = const Value.absent(),
    this.quantity = const Value.absent(),
  });
  PartsUsedCompanion.insert({
    this.id = const Value.absent(),
    required int workPerformedId,
    this.partNumber = const Value.absent(),
    this.description = const Value.absent(),
    this.quantity = const Value.absent(),
  }) : workPerformedId = Value(workPerformedId);
  static Insertable<PartsUsedData> custom({
    Expression<int>? id,
    Expression<int>? workPerformedId,
    Expression<String>? partNumber,
    Expression<String>? description,
    Expression<int>? quantity,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (workPerformedId != null) 'work_performed_id': workPerformedId,
      if (partNumber != null) 'part_number': partNumber,
      if (description != null) 'description': description,
      if (quantity != null) 'quantity': quantity,
    });
  }

  PartsUsedCompanion copyWith(
      {Value<int>? id,
      Value<int>? workPerformedId,
      Value<String?>? partNumber,
      Value<String?>? description,
      Value<int>? quantity}) {
    return PartsUsedCompanion(
      id: id ?? this.id,
      workPerformedId: workPerformedId ?? this.workPerformedId,
      partNumber: partNumber ?? this.partNumber,
      description: description ?? this.description,
      quantity: quantity ?? this.quantity,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (workPerformedId.present) {
      map['work_performed_id'] = Variable<int>(workPerformedId.value);
    }
    if (partNumber.present) {
      map['part_number'] = Variable<String>(partNumber.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (quantity.present) {
      map['quantity'] = Variable<int>(quantity.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PartsUsedCompanion(')
          ..write('id: $id, ')
          ..write('workPerformedId: $workPerformedId, ')
          ..write('partNumber: $partNumber, ')
          ..write('description: $description, ')
          ..write('quantity: $quantity')
          ..write(')'))
        .toString();
  }
}

class $NotesTable extends Notes with TableInfo<$NotesTable, Note> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $NotesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _siteIdMeta = const VerificationMeta('siteId');
  @override
  late final GeneratedColumn<int> siteId = GeneratedColumn<int>(
      'site_id', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _workOrderIdMeta =
      const VerificationMeta('workOrderId');
  @override
  late final GeneratedColumn<int> workOrderId = GeneratedColumn<int>(
      'work_order_id', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _noteTypeMeta =
      const VerificationMeta('noteType');
  @override
  late final GeneratedColumn<String> noteType = GeneratedColumn<String>(
      'note_type', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _noteTextMeta =
      const VerificationMeta('noteText');
  @override
  late final GeneratedColumn<String> noteText = GeneratedColumn<String>(
      'note_text', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _createdByMeta =
      const VerificationMeta('createdBy');
  @override
  late final GeneratedColumn<String> createdBy = GeneratedColumn<String>(
      'created_by', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns =>
      [id, siteId, workOrderId, noteType, noteText, createdAt, createdBy];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'notes';
  @override
  VerificationContext validateIntegrity(Insertable<Note> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('site_id')) {
      context.handle(_siteIdMeta,
          siteId.isAcceptableOrUnknown(data['site_id']!, _siteIdMeta));
    } else if (isInserting) {
      context.missing(_siteIdMeta);
    }
    if (data.containsKey('work_order_id')) {
      context.handle(
          _workOrderIdMeta,
          workOrderId.isAcceptableOrUnknown(
              data['work_order_id']!, _workOrderIdMeta));
    }
    if (data.containsKey('note_type')) {
      context.handle(_noteTypeMeta,
          noteType.isAcceptableOrUnknown(data['note_type']!, _noteTypeMeta));
    } else if (isInserting) {
      context.missing(_noteTypeMeta);
    }
    if (data.containsKey('note_text')) {
      context.handle(_noteTextMeta,
          noteText.isAcceptableOrUnknown(data['note_text']!, _noteTextMeta));
    } else if (isInserting) {
      context.missing(_noteTextMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('created_by')) {
      context.handle(_createdByMeta,
          createdBy.isAcceptableOrUnknown(data['created_by']!, _createdByMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Note map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Note(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      siteId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}site_id'])!,
      workOrderId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}work_order_id']),
      noteType: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}note_type'])!,
      noteText: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}note_text'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      createdBy: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}created_by']),
    );
  }

  @override
  $NotesTable createAlias(String alias) {
    return $NotesTable(attachedDatabase, alias);
  }
}

class Note extends DataClass implements Insertable<Note> {
  final int id;
  final int siteId;
  final int? workOrderId;
  final String noteType;
  final String noteText;
  final DateTime createdAt;
  final String? createdBy;
  const Note(
      {required this.id,
      required this.siteId,
      this.workOrderId,
      required this.noteType,
      required this.noteText,
      required this.createdAt,
      this.createdBy});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['site_id'] = Variable<int>(siteId);
    if (!nullToAbsent || workOrderId != null) {
      map['work_order_id'] = Variable<int>(workOrderId);
    }
    map['note_type'] = Variable<String>(noteType);
    map['note_text'] = Variable<String>(noteText);
    map['created_at'] = Variable<DateTime>(createdAt);
    if (!nullToAbsent || createdBy != null) {
      map['created_by'] = Variable<String>(createdBy);
    }
    return map;
  }

  NotesCompanion toCompanion(bool nullToAbsent) {
    return NotesCompanion(
      id: Value(id),
      siteId: Value(siteId),
      workOrderId: workOrderId == null && nullToAbsent
          ? const Value.absent()
          : Value(workOrderId),
      noteType: Value(noteType),
      noteText: Value(noteText),
      createdAt: Value(createdAt),
      createdBy: createdBy == null && nullToAbsent
          ? const Value.absent()
          : Value(createdBy),
    );
  }

  factory Note.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Note(
      id: serializer.fromJson<int>(json['id']),
      siteId: serializer.fromJson<int>(json['siteId']),
      workOrderId: serializer.fromJson<int?>(json['workOrderId']),
      noteType: serializer.fromJson<String>(json['noteType']),
      noteText: serializer.fromJson<String>(json['noteText']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      createdBy: serializer.fromJson<String?>(json['createdBy']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'siteId': serializer.toJson<int>(siteId),
      'workOrderId': serializer.toJson<int?>(workOrderId),
      'noteType': serializer.toJson<String>(noteType),
      'noteText': serializer.toJson<String>(noteText),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'createdBy': serializer.toJson<String?>(createdBy),
    };
  }

  Note copyWith(
          {int? id,
          int? siteId,
          Value<int?> workOrderId = const Value.absent(),
          String? noteType,
          String? noteText,
          DateTime? createdAt,
          Value<String?> createdBy = const Value.absent()}) =>
      Note(
        id: id ?? this.id,
        siteId: siteId ?? this.siteId,
        workOrderId: workOrderId.present ? workOrderId.value : this.workOrderId,
        noteType: noteType ?? this.noteType,
        noteText: noteText ?? this.noteText,
        createdAt: createdAt ?? this.createdAt,
        createdBy: createdBy.present ? createdBy.value : this.createdBy,
      );
  Note copyWithCompanion(NotesCompanion data) {
    return Note(
      id: data.id.present ? data.id.value : this.id,
      siteId: data.siteId.present ? data.siteId.value : this.siteId,
      workOrderId:
          data.workOrderId.present ? data.workOrderId.value : this.workOrderId,
      noteType: data.noteType.present ? data.noteType.value : this.noteType,
      noteText: data.noteText.present ? data.noteText.value : this.noteText,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      createdBy: data.createdBy.present ? data.createdBy.value : this.createdBy,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Note(')
          ..write('id: $id, ')
          ..write('siteId: $siteId, ')
          ..write('workOrderId: $workOrderId, ')
          ..write('noteType: $noteType, ')
          ..write('noteText: $noteText, ')
          ..write('createdAt: $createdAt, ')
          ..write('createdBy: $createdBy')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id, siteId, workOrderId, noteType, noteText, createdAt, createdBy);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Note &&
          other.id == this.id &&
          other.siteId == this.siteId &&
          other.workOrderId == this.workOrderId &&
          other.noteType == this.noteType &&
          other.noteText == this.noteText &&
          other.createdAt == this.createdAt &&
          other.createdBy == this.createdBy);
}

class NotesCompanion extends UpdateCompanion<Note> {
  final Value<int> id;
  final Value<int> siteId;
  final Value<int?> workOrderId;
  final Value<String> noteType;
  final Value<String> noteText;
  final Value<DateTime> createdAt;
  final Value<String?> createdBy;
  const NotesCompanion({
    this.id = const Value.absent(),
    this.siteId = const Value.absent(),
    this.workOrderId = const Value.absent(),
    this.noteType = const Value.absent(),
    this.noteText = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.createdBy = const Value.absent(),
  });
  NotesCompanion.insert({
    this.id = const Value.absent(),
    required int siteId,
    this.workOrderId = const Value.absent(),
    required String noteType,
    required String noteText,
    required DateTime createdAt,
    this.createdBy = const Value.absent(),
  })  : siteId = Value(siteId),
        noteType = Value(noteType),
        noteText = Value(noteText),
        createdAt = Value(createdAt);
  static Insertable<Note> custom({
    Expression<int>? id,
    Expression<int>? siteId,
    Expression<int>? workOrderId,
    Expression<String>? noteType,
    Expression<String>? noteText,
    Expression<DateTime>? createdAt,
    Expression<String>? createdBy,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (siteId != null) 'site_id': siteId,
      if (workOrderId != null) 'work_order_id': workOrderId,
      if (noteType != null) 'note_type': noteType,
      if (noteText != null) 'note_text': noteText,
      if (createdAt != null) 'created_at': createdAt,
      if (createdBy != null) 'created_by': createdBy,
    });
  }

  NotesCompanion copyWith(
      {Value<int>? id,
      Value<int>? siteId,
      Value<int?>? workOrderId,
      Value<String>? noteType,
      Value<String>? noteText,
      Value<DateTime>? createdAt,
      Value<String?>? createdBy}) {
    return NotesCompanion(
      id: id ?? this.id,
      siteId: siteId ?? this.siteId,
      workOrderId: workOrderId ?? this.workOrderId,
      noteType: noteType ?? this.noteType,
      noteText: noteText ?? this.noteText,
      createdAt: createdAt ?? this.createdAt,
      createdBy: createdBy ?? this.createdBy,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (siteId.present) {
      map['site_id'] = Variable<int>(siteId.value);
    }
    if (workOrderId.present) {
      map['work_order_id'] = Variable<int>(workOrderId.value);
    }
    if (noteType.present) {
      map['note_type'] = Variable<String>(noteType.value);
    }
    if (noteText.present) {
      map['note_text'] = Variable<String>(noteText.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (createdBy.present) {
      map['created_by'] = Variable<String>(createdBy.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('NotesCompanion(')
          ..write('id: $id, ')
          ..write('siteId: $siteId, ')
          ..write('workOrderId: $workOrderId, ')
          ..write('noteType: $noteType, ')
          ..write('noteText: $noteText, ')
          ..write('createdAt: $createdAt, ')
          ..write('createdBy: $createdBy')
          ..write(')'))
        .toString();
  }
}

class $DocumentsTable extends Documents
    with TableInfo<$DocumentsTable, Document> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DocumentsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _workOrderIdMeta =
      const VerificationMeta('workOrderId');
  @override
  late final GeneratedColumn<int> workOrderId = GeneratedColumn<int>(
      'work_order_id', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _siteIdMeta = const VerificationMeta('siteId');
  @override
  late final GeneratedColumn<int> siteId = GeneratedColumn<int>(
      'site_id', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _fileNameMeta =
      const VerificationMeta('fileName');
  @override
  late final GeneratedColumn<String> fileName = GeneratedColumn<String>(
      'file_name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _filePathMeta =
      const VerificationMeta('filePath');
  @override
  late final GeneratedColumn<String> filePath = GeneratedColumn<String>(
      'file_path', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _uploadedAtMeta =
      const VerificationMeta('uploadedAt');
  @override
  late final GeneratedColumn<DateTime> uploadedAt = GeneratedColumn<DateTime>(
      'uploaded_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _uploadedByMeta =
      const VerificationMeta('uploadedBy');
  @override
  late final GeneratedColumn<String> uploadedBy = GeneratedColumn<String>(
      'uploaded_by', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns =>
      [id, workOrderId, siteId, fileName, filePath, uploadedAt, uploadedBy];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'documents';
  @override
  VerificationContext validateIntegrity(Insertable<Document> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('work_order_id')) {
      context.handle(
          _workOrderIdMeta,
          workOrderId.isAcceptableOrUnknown(
              data['work_order_id']!, _workOrderIdMeta));
    }
    if (data.containsKey('site_id')) {
      context.handle(_siteIdMeta,
          siteId.isAcceptableOrUnknown(data['site_id']!, _siteIdMeta));
    }
    if (data.containsKey('file_name')) {
      context.handle(_fileNameMeta,
          fileName.isAcceptableOrUnknown(data['file_name']!, _fileNameMeta));
    } else if (isInserting) {
      context.missing(_fileNameMeta);
    }
    if (data.containsKey('file_path')) {
      context.handle(_filePathMeta,
          filePath.isAcceptableOrUnknown(data['file_path']!, _filePathMeta));
    } else if (isInserting) {
      context.missing(_filePathMeta);
    }
    if (data.containsKey('uploaded_at')) {
      context.handle(
          _uploadedAtMeta,
          uploadedAt.isAcceptableOrUnknown(
              data['uploaded_at']!, _uploadedAtMeta));
    } else if (isInserting) {
      context.missing(_uploadedAtMeta);
    }
    if (data.containsKey('uploaded_by')) {
      context.handle(
          _uploadedByMeta,
          uploadedBy.isAcceptableOrUnknown(
              data['uploaded_by']!, _uploadedByMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Document map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Document(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      workOrderId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}work_order_id']),
      siteId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}site_id']),
      fileName: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}file_name'])!,
      filePath: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}file_path'])!,
      uploadedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}uploaded_at'])!,
      uploadedBy: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}uploaded_by']),
    );
  }

  @override
  $DocumentsTable createAlias(String alias) {
    return $DocumentsTable(attachedDatabase, alias);
  }
}

class Document extends DataClass implements Insertable<Document> {
  final int id;
  final int? workOrderId;
  final int? siteId;
  final String fileName;
  final String filePath;
  final DateTime uploadedAt;
  final String? uploadedBy;
  const Document(
      {required this.id,
      this.workOrderId,
      this.siteId,
      required this.fileName,
      required this.filePath,
      required this.uploadedAt,
      this.uploadedBy});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    if (!nullToAbsent || workOrderId != null) {
      map['work_order_id'] = Variable<int>(workOrderId);
    }
    if (!nullToAbsent || siteId != null) {
      map['site_id'] = Variable<int>(siteId);
    }
    map['file_name'] = Variable<String>(fileName);
    map['file_path'] = Variable<String>(filePath);
    map['uploaded_at'] = Variable<DateTime>(uploadedAt);
    if (!nullToAbsent || uploadedBy != null) {
      map['uploaded_by'] = Variable<String>(uploadedBy);
    }
    return map;
  }

  DocumentsCompanion toCompanion(bool nullToAbsent) {
    return DocumentsCompanion(
      id: Value(id),
      workOrderId: workOrderId == null && nullToAbsent
          ? const Value.absent()
          : Value(workOrderId),
      siteId:
          siteId == null && nullToAbsent ? const Value.absent() : Value(siteId),
      fileName: Value(fileName),
      filePath: Value(filePath),
      uploadedAt: Value(uploadedAt),
      uploadedBy: uploadedBy == null && nullToAbsent
          ? const Value.absent()
          : Value(uploadedBy),
    );
  }

  factory Document.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Document(
      id: serializer.fromJson<int>(json['id']),
      workOrderId: serializer.fromJson<int?>(json['workOrderId']),
      siteId: serializer.fromJson<int?>(json['siteId']),
      fileName: serializer.fromJson<String>(json['fileName']),
      filePath: serializer.fromJson<String>(json['filePath']),
      uploadedAt: serializer.fromJson<DateTime>(json['uploadedAt']),
      uploadedBy: serializer.fromJson<String?>(json['uploadedBy']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'workOrderId': serializer.toJson<int?>(workOrderId),
      'siteId': serializer.toJson<int?>(siteId),
      'fileName': serializer.toJson<String>(fileName),
      'filePath': serializer.toJson<String>(filePath),
      'uploadedAt': serializer.toJson<DateTime>(uploadedAt),
      'uploadedBy': serializer.toJson<String?>(uploadedBy),
    };
  }

  Document copyWith(
          {int? id,
          Value<int?> workOrderId = const Value.absent(),
          Value<int?> siteId = const Value.absent(),
          String? fileName,
          String? filePath,
          DateTime? uploadedAt,
          Value<String?> uploadedBy = const Value.absent()}) =>
      Document(
        id: id ?? this.id,
        workOrderId: workOrderId.present ? workOrderId.value : this.workOrderId,
        siteId: siteId.present ? siteId.value : this.siteId,
        fileName: fileName ?? this.fileName,
        filePath: filePath ?? this.filePath,
        uploadedAt: uploadedAt ?? this.uploadedAt,
        uploadedBy: uploadedBy.present ? uploadedBy.value : this.uploadedBy,
      );
  Document copyWithCompanion(DocumentsCompanion data) {
    return Document(
      id: data.id.present ? data.id.value : this.id,
      workOrderId:
          data.workOrderId.present ? data.workOrderId.value : this.workOrderId,
      siteId: data.siteId.present ? data.siteId.value : this.siteId,
      fileName: data.fileName.present ? data.fileName.value : this.fileName,
      filePath: data.filePath.present ? data.filePath.value : this.filePath,
      uploadedAt:
          data.uploadedAt.present ? data.uploadedAt.value : this.uploadedAt,
      uploadedBy:
          data.uploadedBy.present ? data.uploadedBy.value : this.uploadedBy,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Document(')
          ..write('id: $id, ')
          ..write('workOrderId: $workOrderId, ')
          ..write('siteId: $siteId, ')
          ..write('fileName: $fileName, ')
          ..write('filePath: $filePath, ')
          ..write('uploadedAt: $uploadedAt, ')
          ..write('uploadedBy: $uploadedBy')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id, workOrderId, siteId, fileName, filePath, uploadedAt, uploadedBy);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Document &&
          other.id == this.id &&
          other.workOrderId == this.workOrderId &&
          other.siteId == this.siteId &&
          other.fileName == this.fileName &&
          other.filePath == this.filePath &&
          other.uploadedAt == this.uploadedAt &&
          other.uploadedBy == this.uploadedBy);
}

class DocumentsCompanion extends UpdateCompanion<Document> {
  final Value<int> id;
  final Value<int?> workOrderId;
  final Value<int?> siteId;
  final Value<String> fileName;
  final Value<String> filePath;
  final Value<DateTime> uploadedAt;
  final Value<String?> uploadedBy;
  const DocumentsCompanion({
    this.id = const Value.absent(),
    this.workOrderId = const Value.absent(),
    this.siteId = const Value.absent(),
    this.fileName = const Value.absent(),
    this.filePath = const Value.absent(),
    this.uploadedAt = const Value.absent(),
    this.uploadedBy = const Value.absent(),
  });
  DocumentsCompanion.insert({
    this.id = const Value.absent(),
    this.workOrderId = const Value.absent(),
    this.siteId = const Value.absent(),
    required String fileName,
    required String filePath,
    required DateTime uploadedAt,
    this.uploadedBy = const Value.absent(),
  })  : fileName = Value(fileName),
        filePath = Value(filePath),
        uploadedAt = Value(uploadedAt);
  static Insertable<Document> custom({
    Expression<int>? id,
    Expression<int>? workOrderId,
    Expression<int>? siteId,
    Expression<String>? fileName,
    Expression<String>? filePath,
    Expression<DateTime>? uploadedAt,
    Expression<String>? uploadedBy,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (workOrderId != null) 'work_order_id': workOrderId,
      if (siteId != null) 'site_id': siteId,
      if (fileName != null) 'file_name': fileName,
      if (filePath != null) 'file_path': filePath,
      if (uploadedAt != null) 'uploaded_at': uploadedAt,
      if (uploadedBy != null) 'uploaded_by': uploadedBy,
    });
  }

  DocumentsCompanion copyWith(
      {Value<int>? id,
      Value<int?>? workOrderId,
      Value<int?>? siteId,
      Value<String>? fileName,
      Value<String>? filePath,
      Value<DateTime>? uploadedAt,
      Value<String?>? uploadedBy}) {
    return DocumentsCompanion(
      id: id ?? this.id,
      workOrderId: workOrderId ?? this.workOrderId,
      siteId: siteId ?? this.siteId,
      fileName: fileName ?? this.fileName,
      filePath: filePath ?? this.filePath,
      uploadedAt: uploadedAt ?? this.uploadedAt,
      uploadedBy: uploadedBy ?? this.uploadedBy,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (workOrderId.present) {
      map['work_order_id'] = Variable<int>(workOrderId.value);
    }
    if (siteId.present) {
      map['site_id'] = Variable<int>(siteId.value);
    }
    if (fileName.present) {
      map['file_name'] = Variable<String>(fileName.value);
    }
    if (filePath.present) {
      map['file_path'] = Variable<String>(filePath.value);
    }
    if (uploadedAt.present) {
      map['uploaded_at'] = Variable<DateTime>(uploadedAt.value);
    }
    if (uploadedBy.present) {
      map['uploaded_by'] = Variable<String>(uploadedBy.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DocumentsCompanion(')
          ..write('id: $id, ')
          ..write('workOrderId: $workOrderId, ')
          ..write('siteId: $siteId, ')
          ..write('fileName: $fileName, ')
          ..write('filePath: $filePath, ')
          ..write('uploadedAt: $uploadedAt, ')
          ..write('uploadedBy: $uploadedBy')
          ..write(')'))
        .toString();
  }
}

class $KnowledgeEntriesTable extends KnowledgeEntries
    with TableInfo<$KnowledgeEntriesTable, KnowledgeEntry> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $KnowledgeEntriesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
      'title', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _categoryMeta =
      const VerificationMeta('category');
  @override
  late final GeneratedColumn<String> category = GeneratedColumn<String>(
      'category', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _equipmentTypeMeta =
      const VerificationMeta('equipmentType');
  @override
  late final GeneratedColumn<String> equipmentType = GeneratedColumn<String>(
      'equipment_type', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _equipmentModelMeta =
      const VerificationMeta('equipmentModel');
  @override
  late final GeneratedColumn<String> equipmentModel = GeneratedColumn<String>(
      'equipment_model', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _contentMeta =
      const VerificationMeta('content');
  @override
  late final GeneratedColumn<String> content = GeneratedColumn<String>(
      'content', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _sourceTypeMeta =
      const VerificationMeta('sourceType');
  @override
  late final GeneratedColumn<String> sourceType = GeneratedColumn<String>(
      'source_type', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _sourceFileMeta =
      const VerificationMeta('sourceFile');
  @override
  late final GeneratedColumn<String> sourceFile = GeneratedColumn<String>(
      'source_file', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _versionMeta =
      const VerificationMeta('version');
  @override
  late final GeneratedColumn<String> version = GeneratedColumn<String>(
      'version', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
      'status', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _contentTypeMeta =
      const VerificationMeta('contentType');
  @override
  late final GeneratedColumn<String> contentType = GeneratedColumn<String>(
      'content_type', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('reference'));
  static const VerificationMeta _difficultyMeta =
      const VerificationMeta('difficulty');
  @override
  late final GeneratedColumn<String> difficulty = GeneratedColumn<String>(
      'difficulty', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _estimatedTimeMeta =
      const VerificationMeta('estimatedTime');
  @override
  late final GeneratedColumn<int> estimatedTime = GeneratedColumn<int>(
      'estimated_time', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _keywordsMeta =
      const VerificationMeta('keywords');
  @override
  late final GeneratedColumn<String> keywords = GeneratedColumn<String>(
      'keywords', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant(''));
  static const VerificationMeta _summaryMeta =
      const VerificationMeta('summary');
  @override
  late final GeneratedColumn<String> summary = GeneratedColumn<String>(
      'summary', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _preconditionsMeta =
      const VerificationMeta('preconditions');
  @override
  late final GeneratedColumn<String> preconditions = GeneratedColumn<String>(
      'preconditions', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('[]'));
  static const VerificationMeta _tagsMeta = const VerificationMeta('tags');
  @override
  late final GeneratedColumn<String> tags = GeneratedColumn<String>(
      'tags', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('[]'));
  static const VerificationMeta _lastReviewedAtMeta =
      const VerificationMeta('lastReviewedAt');
  @override
  late final GeneratedColumn<DateTime> lastReviewedAt =
      GeneratedColumn<DateTime>('last_reviewed_at', aliasedName, true,
          type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _isDeprecatedMeta =
      const VerificationMeta('isDeprecated');
  @override
  late final GeneratedColumn<bool> isDeprecated = GeneratedColumn<bool>(
      'is_deprecated', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("is_deprecated" IN (0, 1))'),
      defaultValue: const Constant(false));
  @override
  List<GeneratedColumn> get $columns => [
        id,
        title,
        category,
        equipmentType,
        equipmentModel,
        content,
        sourceType,
        sourceFile,
        version,
        status,
        createdAt,
        updatedAt,
        contentType,
        difficulty,
        estimatedTime,
        keywords,
        summary,
        preconditions,
        tags,
        lastReviewedAt,
        isDeprecated
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'knowledge_entries';
  @override
  VerificationContext validateIntegrity(Insertable<KnowledgeEntry> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
          _titleMeta, title.isAcceptableOrUnknown(data['title']!, _titleMeta));
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('category')) {
      context.handle(_categoryMeta,
          category.isAcceptableOrUnknown(data['category']!, _categoryMeta));
    } else if (isInserting) {
      context.missing(_categoryMeta);
    }
    if (data.containsKey('equipment_type')) {
      context.handle(
          _equipmentTypeMeta,
          equipmentType.isAcceptableOrUnknown(
              data['equipment_type']!, _equipmentTypeMeta));
    } else if (isInserting) {
      context.missing(_equipmentTypeMeta);
    }
    if (data.containsKey('equipment_model')) {
      context.handle(
          _equipmentModelMeta,
          equipmentModel.isAcceptableOrUnknown(
              data['equipment_model']!, _equipmentModelMeta));
    }
    if (data.containsKey('content')) {
      context.handle(_contentMeta,
          content.isAcceptableOrUnknown(data['content']!, _contentMeta));
    } else if (isInserting) {
      context.missing(_contentMeta);
    }
    if (data.containsKey('source_type')) {
      context.handle(
          _sourceTypeMeta,
          sourceType.isAcceptableOrUnknown(
              data['source_type']!, _sourceTypeMeta));
    } else if (isInserting) {
      context.missing(_sourceTypeMeta);
    }
    if (data.containsKey('source_file')) {
      context.handle(
          _sourceFileMeta,
          sourceFile.isAcceptableOrUnknown(
              data['source_file']!, _sourceFileMeta));
    } else if (isInserting) {
      context.missing(_sourceFileMeta);
    }
    if (data.containsKey('version')) {
      context.handle(_versionMeta,
          version.isAcceptableOrUnknown(data['version']!, _versionMeta));
    } else if (isInserting) {
      context.missing(_versionMeta);
    }
    if (data.containsKey('status')) {
      context.handle(_statusMeta,
          status.isAcceptableOrUnknown(data['status']!, _statusMeta));
    } else if (isInserting) {
      context.missing(_statusMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    if (data.containsKey('content_type')) {
      context.handle(
          _contentTypeMeta,
          contentType.isAcceptableOrUnknown(
              data['content_type']!, _contentTypeMeta));
    }
    if (data.containsKey('difficulty')) {
      context.handle(
          _difficultyMeta,
          difficulty.isAcceptableOrUnknown(
              data['difficulty']!, _difficultyMeta));
    }
    if (data.containsKey('estimated_time')) {
      context.handle(
          _estimatedTimeMeta,
          estimatedTime.isAcceptableOrUnknown(
              data['estimated_time']!, _estimatedTimeMeta));
    }
    if (data.containsKey('keywords')) {
      context.handle(_keywordsMeta,
          keywords.isAcceptableOrUnknown(data['keywords']!, _keywordsMeta));
    }
    if (data.containsKey('summary')) {
      context.handle(_summaryMeta,
          summary.isAcceptableOrUnknown(data['summary']!, _summaryMeta));
    }
    if (data.containsKey('preconditions')) {
      context.handle(
          _preconditionsMeta,
          preconditions.isAcceptableOrUnknown(
              data['preconditions']!, _preconditionsMeta));
    }
    if (data.containsKey('tags')) {
      context.handle(
          _tagsMeta, tags.isAcceptableOrUnknown(data['tags']!, _tagsMeta));
    }
    if (data.containsKey('last_reviewed_at')) {
      context.handle(
          _lastReviewedAtMeta,
          lastReviewedAt.isAcceptableOrUnknown(
              data['last_reviewed_at']!, _lastReviewedAtMeta));
    }
    if (data.containsKey('is_deprecated')) {
      context.handle(
          _isDeprecatedMeta,
          isDeprecated.isAcceptableOrUnknown(
              data['is_deprecated']!, _isDeprecatedMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  KnowledgeEntry map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return KnowledgeEntry(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      title: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}title'])!,
      category: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}category'])!,
      equipmentType: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}equipment_type'])!,
      equipmentModel: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}equipment_model']),
      content: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}content'])!,
      sourceType: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}source_type'])!,
      sourceFile: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}source_file'])!,
      version: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}version'])!,
      status: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}status'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at'])!,
      contentType: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}content_type'])!,
      difficulty: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}difficulty']),
      estimatedTime: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}estimated_time']),
      keywords: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}keywords'])!,
      summary: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}summary']),
      preconditions: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}preconditions'])!,
      tags: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}tags'])!,
      lastReviewedAt: attachedDatabase.typeMapping.read(
          DriftSqlType.dateTime, data['${effectivePrefix}last_reviewed_at']),
      isDeprecated: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_deprecated'])!,
    );
  }

  @override
  $KnowledgeEntriesTable createAlias(String alias) {
    return $KnowledgeEntriesTable(attachedDatabase, alias);
  }
}

class KnowledgeEntry extends DataClass implements Insertable<KnowledgeEntry> {
  final String id;
  final String title;
  final String category;
  final String equipmentType;
  final String? equipmentModel;
  final String content;
  final String sourceType;
  final String sourceFile;
  final String version;
  final String status;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String contentType;
  final String? difficulty;
  final int? estimatedTime;
  final String keywords;
  final String? summary;
  final String preconditions;
  final String tags;
  final DateTime? lastReviewedAt;
  final bool isDeprecated;
  const KnowledgeEntry(
      {required this.id,
      required this.title,
      required this.category,
      required this.equipmentType,
      this.equipmentModel,
      required this.content,
      required this.sourceType,
      required this.sourceFile,
      required this.version,
      required this.status,
      required this.createdAt,
      required this.updatedAt,
      required this.contentType,
      this.difficulty,
      this.estimatedTime,
      required this.keywords,
      this.summary,
      required this.preconditions,
      required this.tags,
      this.lastReviewedAt,
      required this.isDeprecated});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['title'] = Variable<String>(title);
    map['category'] = Variable<String>(category);
    map['equipment_type'] = Variable<String>(equipmentType);
    if (!nullToAbsent || equipmentModel != null) {
      map['equipment_model'] = Variable<String>(equipmentModel);
    }
    map['content'] = Variable<String>(content);
    map['source_type'] = Variable<String>(sourceType);
    map['source_file'] = Variable<String>(sourceFile);
    map['version'] = Variable<String>(version);
    map['status'] = Variable<String>(status);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    map['content_type'] = Variable<String>(contentType);
    if (!nullToAbsent || difficulty != null) {
      map['difficulty'] = Variable<String>(difficulty);
    }
    if (!nullToAbsent || estimatedTime != null) {
      map['estimated_time'] = Variable<int>(estimatedTime);
    }
    map['keywords'] = Variable<String>(keywords);
    if (!nullToAbsent || summary != null) {
      map['summary'] = Variable<String>(summary);
    }
    map['preconditions'] = Variable<String>(preconditions);
    map['tags'] = Variable<String>(tags);
    if (!nullToAbsent || lastReviewedAt != null) {
      map['last_reviewed_at'] = Variable<DateTime>(lastReviewedAt);
    }
    map['is_deprecated'] = Variable<bool>(isDeprecated);
    return map;
  }

  KnowledgeEntriesCompanion toCompanion(bool nullToAbsent) {
    return KnowledgeEntriesCompanion(
      id: Value(id),
      title: Value(title),
      category: Value(category),
      equipmentType: Value(equipmentType),
      equipmentModel: equipmentModel == null && nullToAbsent
          ? const Value.absent()
          : Value(equipmentModel),
      content: Value(content),
      sourceType: Value(sourceType),
      sourceFile: Value(sourceFile),
      version: Value(version),
      status: Value(status),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      contentType: Value(contentType),
      difficulty: difficulty == null && nullToAbsent
          ? const Value.absent()
          : Value(difficulty),
      estimatedTime: estimatedTime == null && nullToAbsent
          ? const Value.absent()
          : Value(estimatedTime),
      keywords: Value(keywords),
      summary: summary == null && nullToAbsent
          ? const Value.absent()
          : Value(summary),
      preconditions: Value(preconditions),
      tags: Value(tags),
      lastReviewedAt: lastReviewedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(lastReviewedAt),
      isDeprecated: Value(isDeprecated),
    );
  }

  factory KnowledgeEntry.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return KnowledgeEntry(
      id: serializer.fromJson<String>(json['id']),
      title: serializer.fromJson<String>(json['title']),
      category: serializer.fromJson<String>(json['category']),
      equipmentType: serializer.fromJson<String>(json['equipmentType']),
      equipmentModel: serializer.fromJson<String?>(json['equipmentModel']),
      content: serializer.fromJson<String>(json['content']),
      sourceType: serializer.fromJson<String>(json['sourceType']),
      sourceFile: serializer.fromJson<String>(json['sourceFile']),
      version: serializer.fromJson<String>(json['version']),
      status: serializer.fromJson<String>(json['status']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      contentType: serializer.fromJson<String>(json['contentType']),
      difficulty: serializer.fromJson<String?>(json['difficulty']),
      estimatedTime: serializer.fromJson<int?>(json['estimatedTime']),
      keywords: serializer.fromJson<String>(json['keywords']),
      summary: serializer.fromJson<String?>(json['summary']),
      preconditions: serializer.fromJson<String>(json['preconditions']),
      tags: serializer.fromJson<String>(json['tags']),
      lastReviewedAt: serializer.fromJson<DateTime?>(json['lastReviewedAt']),
      isDeprecated: serializer.fromJson<bool>(json['isDeprecated']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'title': serializer.toJson<String>(title),
      'category': serializer.toJson<String>(category),
      'equipmentType': serializer.toJson<String>(equipmentType),
      'equipmentModel': serializer.toJson<String?>(equipmentModel),
      'content': serializer.toJson<String>(content),
      'sourceType': serializer.toJson<String>(sourceType),
      'sourceFile': serializer.toJson<String>(sourceFile),
      'version': serializer.toJson<String>(version),
      'status': serializer.toJson<String>(status),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'contentType': serializer.toJson<String>(contentType),
      'difficulty': serializer.toJson<String?>(difficulty),
      'estimatedTime': serializer.toJson<int?>(estimatedTime),
      'keywords': serializer.toJson<String>(keywords),
      'summary': serializer.toJson<String?>(summary),
      'preconditions': serializer.toJson<String>(preconditions),
      'tags': serializer.toJson<String>(tags),
      'lastReviewedAt': serializer.toJson<DateTime?>(lastReviewedAt),
      'isDeprecated': serializer.toJson<bool>(isDeprecated),
    };
  }

  KnowledgeEntry copyWith(
          {String? id,
          String? title,
          String? category,
          String? equipmentType,
          Value<String?> equipmentModel = const Value.absent(),
          String? content,
          String? sourceType,
          String? sourceFile,
          String? version,
          String? status,
          DateTime? createdAt,
          DateTime? updatedAt,
          String? contentType,
          Value<String?> difficulty = const Value.absent(),
          Value<int?> estimatedTime = const Value.absent(),
          String? keywords,
          Value<String?> summary = const Value.absent(),
          String? preconditions,
          String? tags,
          Value<DateTime?> lastReviewedAt = const Value.absent(),
          bool? isDeprecated}) =>
      KnowledgeEntry(
        id: id ?? this.id,
        title: title ?? this.title,
        category: category ?? this.category,
        equipmentType: equipmentType ?? this.equipmentType,
        equipmentModel:
            equipmentModel.present ? equipmentModel.value : this.equipmentModel,
        content: content ?? this.content,
        sourceType: sourceType ?? this.sourceType,
        sourceFile: sourceFile ?? this.sourceFile,
        version: version ?? this.version,
        status: status ?? this.status,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
        contentType: contentType ?? this.contentType,
        difficulty: difficulty.present ? difficulty.value : this.difficulty,
        estimatedTime:
            estimatedTime.present ? estimatedTime.value : this.estimatedTime,
        keywords: keywords ?? this.keywords,
        summary: summary.present ? summary.value : this.summary,
        preconditions: preconditions ?? this.preconditions,
        tags: tags ?? this.tags,
        lastReviewedAt:
            lastReviewedAt.present ? lastReviewedAt.value : this.lastReviewedAt,
        isDeprecated: isDeprecated ?? this.isDeprecated,
      );
  KnowledgeEntry copyWithCompanion(KnowledgeEntriesCompanion data) {
    return KnowledgeEntry(
      id: data.id.present ? data.id.value : this.id,
      title: data.title.present ? data.title.value : this.title,
      category: data.category.present ? data.category.value : this.category,
      equipmentType: data.equipmentType.present
          ? data.equipmentType.value
          : this.equipmentType,
      equipmentModel: data.equipmentModel.present
          ? data.equipmentModel.value
          : this.equipmentModel,
      content: data.content.present ? data.content.value : this.content,
      sourceType:
          data.sourceType.present ? data.sourceType.value : this.sourceType,
      sourceFile:
          data.sourceFile.present ? data.sourceFile.value : this.sourceFile,
      version: data.version.present ? data.version.value : this.version,
      status: data.status.present ? data.status.value : this.status,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      contentType:
          data.contentType.present ? data.contentType.value : this.contentType,
      difficulty:
          data.difficulty.present ? data.difficulty.value : this.difficulty,
      estimatedTime: data.estimatedTime.present
          ? data.estimatedTime.value
          : this.estimatedTime,
      keywords: data.keywords.present ? data.keywords.value : this.keywords,
      summary: data.summary.present ? data.summary.value : this.summary,
      preconditions: data.preconditions.present
          ? data.preconditions.value
          : this.preconditions,
      tags: data.tags.present ? data.tags.value : this.tags,
      lastReviewedAt: data.lastReviewedAt.present
          ? data.lastReviewedAt.value
          : this.lastReviewedAt,
      isDeprecated: data.isDeprecated.present
          ? data.isDeprecated.value
          : this.isDeprecated,
    );
  }

  @override
  String toString() {
    return (StringBuffer('KnowledgeEntry(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('category: $category, ')
          ..write('equipmentType: $equipmentType, ')
          ..write('equipmentModel: $equipmentModel, ')
          ..write('content: $content, ')
          ..write('sourceType: $sourceType, ')
          ..write('sourceFile: $sourceFile, ')
          ..write('version: $version, ')
          ..write('status: $status, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('contentType: $contentType, ')
          ..write('difficulty: $difficulty, ')
          ..write('estimatedTime: $estimatedTime, ')
          ..write('keywords: $keywords, ')
          ..write('summary: $summary, ')
          ..write('preconditions: $preconditions, ')
          ..write('tags: $tags, ')
          ..write('lastReviewedAt: $lastReviewedAt, ')
          ..write('isDeprecated: $isDeprecated')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hashAll([
        id,
        title,
        category,
        equipmentType,
        equipmentModel,
        content,
        sourceType,
        sourceFile,
        version,
        status,
        createdAt,
        updatedAt,
        contentType,
        difficulty,
        estimatedTime,
        keywords,
        summary,
        preconditions,
        tags,
        lastReviewedAt,
        isDeprecated
      ]);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is KnowledgeEntry &&
          other.id == this.id &&
          other.title == this.title &&
          other.category == this.category &&
          other.equipmentType == this.equipmentType &&
          other.equipmentModel == this.equipmentModel &&
          other.content == this.content &&
          other.sourceType == this.sourceType &&
          other.sourceFile == this.sourceFile &&
          other.version == this.version &&
          other.status == this.status &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.contentType == this.contentType &&
          other.difficulty == this.difficulty &&
          other.estimatedTime == this.estimatedTime &&
          other.keywords == this.keywords &&
          other.summary == this.summary &&
          other.preconditions == this.preconditions &&
          other.tags == this.tags &&
          other.lastReviewedAt == this.lastReviewedAt &&
          other.isDeprecated == this.isDeprecated);
}

class KnowledgeEntriesCompanion extends UpdateCompanion<KnowledgeEntry> {
  final Value<String> id;
  final Value<String> title;
  final Value<String> category;
  final Value<String> equipmentType;
  final Value<String?> equipmentModel;
  final Value<String> content;
  final Value<String> sourceType;
  final Value<String> sourceFile;
  final Value<String> version;
  final Value<String> status;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<String> contentType;
  final Value<String?> difficulty;
  final Value<int?> estimatedTime;
  final Value<String> keywords;
  final Value<String?> summary;
  final Value<String> preconditions;
  final Value<String> tags;
  final Value<DateTime?> lastReviewedAt;
  final Value<bool> isDeprecated;
  final Value<int> rowid;
  const KnowledgeEntriesCompanion({
    this.id = const Value.absent(),
    this.title = const Value.absent(),
    this.category = const Value.absent(),
    this.equipmentType = const Value.absent(),
    this.equipmentModel = const Value.absent(),
    this.content = const Value.absent(),
    this.sourceType = const Value.absent(),
    this.sourceFile = const Value.absent(),
    this.version = const Value.absent(),
    this.status = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.contentType = const Value.absent(),
    this.difficulty = const Value.absent(),
    this.estimatedTime = const Value.absent(),
    this.keywords = const Value.absent(),
    this.summary = const Value.absent(),
    this.preconditions = const Value.absent(),
    this.tags = const Value.absent(),
    this.lastReviewedAt = const Value.absent(),
    this.isDeprecated = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  KnowledgeEntriesCompanion.insert({
    required String id,
    required String title,
    required String category,
    required String equipmentType,
    this.equipmentModel = const Value.absent(),
    required String content,
    required String sourceType,
    required String sourceFile,
    required String version,
    required String status,
    required DateTime createdAt,
    required DateTime updatedAt,
    this.contentType = const Value.absent(),
    this.difficulty = const Value.absent(),
    this.estimatedTime = const Value.absent(),
    this.keywords = const Value.absent(),
    this.summary = const Value.absent(),
    this.preconditions = const Value.absent(),
    this.tags = const Value.absent(),
    this.lastReviewedAt = const Value.absent(),
    this.isDeprecated = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        title = Value(title),
        category = Value(category),
        equipmentType = Value(equipmentType),
        content = Value(content),
        sourceType = Value(sourceType),
        sourceFile = Value(sourceFile),
        version = Value(version),
        status = Value(status),
        createdAt = Value(createdAt),
        updatedAt = Value(updatedAt);
  static Insertable<KnowledgeEntry> custom({
    Expression<String>? id,
    Expression<String>? title,
    Expression<String>? category,
    Expression<String>? equipmentType,
    Expression<String>? equipmentModel,
    Expression<String>? content,
    Expression<String>? sourceType,
    Expression<String>? sourceFile,
    Expression<String>? version,
    Expression<String>? status,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<String>? contentType,
    Expression<String>? difficulty,
    Expression<int>? estimatedTime,
    Expression<String>? keywords,
    Expression<String>? summary,
    Expression<String>? preconditions,
    Expression<String>? tags,
    Expression<DateTime>? lastReviewedAt,
    Expression<bool>? isDeprecated,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (title != null) 'title': title,
      if (category != null) 'category': category,
      if (equipmentType != null) 'equipment_type': equipmentType,
      if (equipmentModel != null) 'equipment_model': equipmentModel,
      if (content != null) 'content': content,
      if (sourceType != null) 'source_type': sourceType,
      if (sourceFile != null) 'source_file': sourceFile,
      if (version != null) 'version': version,
      if (status != null) 'status': status,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (contentType != null) 'content_type': contentType,
      if (difficulty != null) 'difficulty': difficulty,
      if (estimatedTime != null) 'estimated_time': estimatedTime,
      if (keywords != null) 'keywords': keywords,
      if (summary != null) 'summary': summary,
      if (preconditions != null) 'preconditions': preconditions,
      if (tags != null) 'tags': tags,
      if (lastReviewedAt != null) 'last_reviewed_at': lastReviewedAt,
      if (isDeprecated != null) 'is_deprecated': isDeprecated,
      if (rowid != null) 'rowid': rowid,
    });
  }

  KnowledgeEntriesCompanion copyWith(
      {Value<String>? id,
      Value<String>? title,
      Value<String>? category,
      Value<String>? equipmentType,
      Value<String?>? equipmentModel,
      Value<String>? content,
      Value<String>? sourceType,
      Value<String>? sourceFile,
      Value<String>? version,
      Value<String>? status,
      Value<DateTime>? createdAt,
      Value<DateTime>? updatedAt,
      Value<String>? contentType,
      Value<String?>? difficulty,
      Value<int?>? estimatedTime,
      Value<String>? keywords,
      Value<String?>? summary,
      Value<String>? preconditions,
      Value<String>? tags,
      Value<DateTime?>? lastReviewedAt,
      Value<bool>? isDeprecated,
      Value<int>? rowid}) {
    return KnowledgeEntriesCompanion(
      id: id ?? this.id,
      title: title ?? this.title,
      category: category ?? this.category,
      equipmentType: equipmentType ?? this.equipmentType,
      equipmentModel: equipmentModel ?? this.equipmentModel,
      content: content ?? this.content,
      sourceType: sourceType ?? this.sourceType,
      sourceFile: sourceFile ?? this.sourceFile,
      version: version ?? this.version,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      contentType: contentType ?? this.contentType,
      difficulty: difficulty ?? this.difficulty,
      estimatedTime: estimatedTime ?? this.estimatedTime,
      keywords: keywords ?? this.keywords,
      summary: summary ?? this.summary,
      preconditions: preconditions ?? this.preconditions,
      tags: tags ?? this.tags,
      lastReviewedAt: lastReviewedAt ?? this.lastReviewedAt,
      isDeprecated: isDeprecated ?? this.isDeprecated,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (category.present) {
      map['category'] = Variable<String>(category.value);
    }
    if (equipmentType.present) {
      map['equipment_type'] = Variable<String>(equipmentType.value);
    }
    if (equipmentModel.present) {
      map['equipment_model'] = Variable<String>(equipmentModel.value);
    }
    if (content.present) {
      map['content'] = Variable<String>(content.value);
    }
    if (sourceType.present) {
      map['source_type'] = Variable<String>(sourceType.value);
    }
    if (sourceFile.present) {
      map['source_file'] = Variable<String>(sourceFile.value);
    }
    if (version.present) {
      map['version'] = Variable<String>(version.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (contentType.present) {
      map['content_type'] = Variable<String>(contentType.value);
    }
    if (difficulty.present) {
      map['difficulty'] = Variable<String>(difficulty.value);
    }
    if (estimatedTime.present) {
      map['estimated_time'] = Variable<int>(estimatedTime.value);
    }
    if (keywords.present) {
      map['keywords'] = Variable<String>(keywords.value);
    }
    if (summary.present) {
      map['summary'] = Variable<String>(summary.value);
    }
    if (preconditions.present) {
      map['preconditions'] = Variable<String>(preconditions.value);
    }
    if (tags.present) {
      map['tags'] = Variable<String>(tags.value);
    }
    if (lastReviewedAt.present) {
      map['last_reviewed_at'] = Variable<DateTime>(lastReviewedAt.value);
    }
    if (isDeprecated.present) {
      map['is_deprecated'] = Variable<bool>(isDeprecated.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('KnowledgeEntriesCompanion(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('category: $category, ')
          ..write('equipmentType: $equipmentType, ')
          ..write('equipmentModel: $equipmentModel, ')
          ..write('content: $content, ')
          ..write('sourceType: $sourceType, ')
          ..write('sourceFile: $sourceFile, ')
          ..write('version: $version, ')
          ..write('status: $status, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('contentType: $contentType, ')
          ..write('difficulty: $difficulty, ')
          ..write('estimatedTime: $estimatedTime, ')
          ..write('keywords: $keywords, ')
          ..write('summary: $summary, ')
          ..write('preconditions: $preconditions, ')
          ..write('tags: $tags, ')
          ..write('lastReviewedAt: $lastReviewedAt, ')
          ..write('isDeprecated: $isDeprecated, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $KnowledgeProceduresTable extends KnowledgeProcedures
    with TableInfo<$KnowledgeProceduresTable, KnowledgeProcedure> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $KnowledgeProceduresTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _knowledgeEntryIdMeta =
      const VerificationMeta('knowledgeEntryId');
  @override
  late final GeneratedColumn<String> knowledgeEntryId = GeneratedColumn<String>(
      'knowledge_entry_id', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'REFERENCES knowledge_entries (id)'));
  static const VerificationMeta _stepNumberMeta =
      const VerificationMeta('stepNumber');
  @override
  late final GeneratedColumn<int> stepNumber = GeneratedColumn<int>(
      'step_number', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
      'title', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _descriptionMeta =
      const VerificationMeta('description');
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
      'description', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _warningsMeta =
      const VerificationMeta('warnings');
  @override
  late final GeneratedColumn<String> warnings = GeneratedColumn<String>(
      'warnings', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('[]'));
  static const VerificationMeta _expectedResultMeta =
      const VerificationMeta('expectedResult');
  @override
  late final GeneratedColumn<String> expectedResult = GeneratedColumn<String>(
      'expected_result', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _commonMistakesMeta =
      const VerificationMeta('commonMistakes');
  @override
  late final GeneratedColumn<String> commonMistakes = GeneratedColumn<String>(
      'common_mistakes', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        knowledgeEntryId,
        stepNumber,
        title,
        description,
        warnings,
        expectedResult,
        commonMistakes
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'knowledge_procedures';
  @override
  VerificationContext validateIntegrity(Insertable<KnowledgeProcedure> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('knowledge_entry_id')) {
      context.handle(
          _knowledgeEntryIdMeta,
          knowledgeEntryId.isAcceptableOrUnknown(
              data['knowledge_entry_id']!, _knowledgeEntryIdMeta));
    } else if (isInserting) {
      context.missing(_knowledgeEntryIdMeta);
    }
    if (data.containsKey('step_number')) {
      context.handle(
          _stepNumberMeta,
          stepNumber.isAcceptableOrUnknown(
              data['step_number']!, _stepNumberMeta));
    } else if (isInserting) {
      context.missing(_stepNumberMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
          _titleMeta, title.isAcceptableOrUnknown(data['title']!, _titleMeta));
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('description')) {
      context.handle(
          _descriptionMeta,
          description.isAcceptableOrUnknown(
              data['description']!, _descriptionMeta));
    } else if (isInserting) {
      context.missing(_descriptionMeta);
    }
    if (data.containsKey('warnings')) {
      context.handle(_warningsMeta,
          warnings.isAcceptableOrUnknown(data['warnings']!, _warningsMeta));
    }
    if (data.containsKey('expected_result')) {
      context.handle(
          _expectedResultMeta,
          expectedResult.isAcceptableOrUnknown(
              data['expected_result']!, _expectedResultMeta));
    }
    if (data.containsKey('common_mistakes')) {
      context.handle(
          _commonMistakesMeta,
          commonMistakes.isAcceptableOrUnknown(
              data['common_mistakes']!, _commonMistakesMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  KnowledgeProcedure map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return KnowledgeProcedure(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      knowledgeEntryId: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}knowledge_entry_id'])!,
      stepNumber: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}step_number'])!,
      title: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}title'])!,
      description: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}description'])!,
      warnings: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}warnings'])!,
      expectedResult: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}expected_result']),
      commonMistakes: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}common_mistakes']),
    );
  }

  @override
  $KnowledgeProceduresTable createAlias(String alias) {
    return $KnowledgeProceduresTable(attachedDatabase, alias);
  }
}

class KnowledgeProcedure extends DataClass
    implements Insertable<KnowledgeProcedure> {
  final int id;
  final String knowledgeEntryId;
  final int stepNumber;
  final String title;
  final String description;
  final String warnings;
  final String? expectedResult;
  final String? commonMistakes;
  const KnowledgeProcedure(
      {required this.id,
      required this.knowledgeEntryId,
      required this.stepNumber,
      required this.title,
      required this.description,
      required this.warnings,
      this.expectedResult,
      this.commonMistakes});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['knowledge_entry_id'] = Variable<String>(knowledgeEntryId);
    map['step_number'] = Variable<int>(stepNumber);
    map['title'] = Variable<String>(title);
    map['description'] = Variable<String>(description);
    map['warnings'] = Variable<String>(warnings);
    if (!nullToAbsent || expectedResult != null) {
      map['expected_result'] = Variable<String>(expectedResult);
    }
    if (!nullToAbsent || commonMistakes != null) {
      map['common_mistakes'] = Variable<String>(commonMistakes);
    }
    return map;
  }

  KnowledgeProceduresCompanion toCompanion(bool nullToAbsent) {
    return KnowledgeProceduresCompanion(
      id: Value(id),
      knowledgeEntryId: Value(knowledgeEntryId),
      stepNumber: Value(stepNumber),
      title: Value(title),
      description: Value(description),
      warnings: Value(warnings),
      expectedResult: expectedResult == null && nullToAbsent
          ? const Value.absent()
          : Value(expectedResult),
      commonMistakes: commonMistakes == null && nullToAbsent
          ? const Value.absent()
          : Value(commonMistakes),
    );
  }

  factory KnowledgeProcedure.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return KnowledgeProcedure(
      id: serializer.fromJson<int>(json['id']),
      knowledgeEntryId: serializer.fromJson<String>(json['knowledgeEntryId']),
      stepNumber: serializer.fromJson<int>(json['stepNumber']),
      title: serializer.fromJson<String>(json['title']),
      description: serializer.fromJson<String>(json['description']),
      warnings: serializer.fromJson<String>(json['warnings']),
      expectedResult: serializer.fromJson<String?>(json['expectedResult']),
      commonMistakes: serializer.fromJson<String?>(json['commonMistakes']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'knowledgeEntryId': serializer.toJson<String>(knowledgeEntryId),
      'stepNumber': serializer.toJson<int>(stepNumber),
      'title': serializer.toJson<String>(title),
      'description': serializer.toJson<String>(description),
      'warnings': serializer.toJson<String>(warnings),
      'expectedResult': serializer.toJson<String?>(expectedResult),
      'commonMistakes': serializer.toJson<String?>(commonMistakes),
    };
  }

  KnowledgeProcedure copyWith(
          {int? id,
          String? knowledgeEntryId,
          int? stepNumber,
          String? title,
          String? description,
          String? warnings,
          Value<String?> expectedResult = const Value.absent(),
          Value<String?> commonMistakes = const Value.absent()}) =>
      KnowledgeProcedure(
        id: id ?? this.id,
        knowledgeEntryId: knowledgeEntryId ?? this.knowledgeEntryId,
        stepNumber: stepNumber ?? this.stepNumber,
        title: title ?? this.title,
        description: description ?? this.description,
        warnings: warnings ?? this.warnings,
        expectedResult:
            expectedResult.present ? expectedResult.value : this.expectedResult,
        commonMistakes:
            commonMistakes.present ? commonMistakes.value : this.commonMistakes,
      );
  KnowledgeProcedure copyWithCompanion(KnowledgeProceduresCompanion data) {
    return KnowledgeProcedure(
      id: data.id.present ? data.id.value : this.id,
      knowledgeEntryId: data.knowledgeEntryId.present
          ? data.knowledgeEntryId.value
          : this.knowledgeEntryId,
      stepNumber:
          data.stepNumber.present ? data.stepNumber.value : this.stepNumber,
      title: data.title.present ? data.title.value : this.title,
      description:
          data.description.present ? data.description.value : this.description,
      warnings: data.warnings.present ? data.warnings.value : this.warnings,
      expectedResult: data.expectedResult.present
          ? data.expectedResult.value
          : this.expectedResult,
      commonMistakes: data.commonMistakes.present
          ? data.commonMistakes.value
          : this.commonMistakes,
    );
  }

  @override
  String toString() {
    return (StringBuffer('KnowledgeProcedure(')
          ..write('id: $id, ')
          ..write('knowledgeEntryId: $knowledgeEntryId, ')
          ..write('stepNumber: $stepNumber, ')
          ..write('title: $title, ')
          ..write('description: $description, ')
          ..write('warnings: $warnings, ')
          ..write('expectedResult: $expectedResult, ')
          ..write('commonMistakes: $commonMistakes')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, knowledgeEntryId, stepNumber, title,
      description, warnings, expectedResult, commonMistakes);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is KnowledgeProcedure &&
          other.id == this.id &&
          other.knowledgeEntryId == this.knowledgeEntryId &&
          other.stepNumber == this.stepNumber &&
          other.title == this.title &&
          other.description == this.description &&
          other.warnings == this.warnings &&
          other.expectedResult == this.expectedResult &&
          other.commonMistakes == this.commonMistakes);
}

class KnowledgeProceduresCompanion extends UpdateCompanion<KnowledgeProcedure> {
  final Value<int> id;
  final Value<String> knowledgeEntryId;
  final Value<int> stepNumber;
  final Value<String> title;
  final Value<String> description;
  final Value<String> warnings;
  final Value<String?> expectedResult;
  final Value<String?> commonMistakes;
  const KnowledgeProceduresCompanion({
    this.id = const Value.absent(),
    this.knowledgeEntryId = const Value.absent(),
    this.stepNumber = const Value.absent(),
    this.title = const Value.absent(),
    this.description = const Value.absent(),
    this.warnings = const Value.absent(),
    this.expectedResult = const Value.absent(),
    this.commonMistakes = const Value.absent(),
  });
  KnowledgeProceduresCompanion.insert({
    this.id = const Value.absent(),
    required String knowledgeEntryId,
    required int stepNumber,
    required String title,
    required String description,
    this.warnings = const Value.absent(),
    this.expectedResult = const Value.absent(),
    this.commonMistakes = const Value.absent(),
  })  : knowledgeEntryId = Value(knowledgeEntryId),
        stepNumber = Value(stepNumber),
        title = Value(title),
        description = Value(description);
  static Insertable<KnowledgeProcedure> custom({
    Expression<int>? id,
    Expression<String>? knowledgeEntryId,
    Expression<int>? stepNumber,
    Expression<String>? title,
    Expression<String>? description,
    Expression<String>? warnings,
    Expression<String>? expectedResult,
    Expression<String>? commonMistakes,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (knowledgeEntryId != null) 'knowledge_entry_id': knowledgeEntryId,
      if (stepNumber != null) 'step_number': stepNumber,
      if (title != null) 'title': title,
      if (description != null) 'description': description,
      if (warnings != null) 'warnings': warnings,
      if (expectedResult != null) 'expected_result': expectedResult,
      if (commonMistakes != null) 'common_mistakes': commonMistakes,
    });
  }

  KnowledgeProceduresCompanion copyWith(
      {Value<int>? id,
      Value<String>? knowledgeEntryId,
      Value<int>? stepNumber,
      Value<String>? title,
      Value<String>? description,
      Value<String>? warnings,
      Value<String?>? expectedResult,
      Value<String?>? commonMistakes}) {
    return KnowledgeProceduresCompanion(
      id: id ?? this.id,
      knowledgeEntryId: knowledgeEntryId ?? this.knowledgeEntryId,
      stepNumber: stepNumber ?? this.stepNumber,
      title: title ?? this.title,
      description: description ?? this.description,
      warnings: warnings ?? this.warnings,
      expectedResult: expectedResult ?? this.expectedResult,
      commonMistakes: commonMistakes ?? this.commonMistakes,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (knowledgeEntryId.present) {
      map['knowledge_entry_id'] = Variable<String>(knowledgeEntryId.value);
    }
    if (stepNumber.present) {
      map['step_number'] = Variable<int>(stepNumber.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (warnings.present) {
      map['warnings'] = Variable<String>(warnings.value);
    }
    if (expectedResult.present) {
      map['expected_result'] = Variable<String>(expectedResult.value);
    }
    if (commonMistakes.present) {
      map['common_mistakes'] = Variable<String>(commonMistakes.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('KnowledgeProceduresCompanion(')
          ..write('id: $id, ')
          ..write('knowledgeEntryId: $knowledgeEntryId, ')
          ..write('stepNumber: $stepNumber, ')
          ..write('title: $title, ')
          ..write('description: $description, ')
          ..write('warnings: $warnings, ')
          ..write('expectedResult: $expectedResult, ')
          ..write('commonMistakes: $commonMistakes')
          ..write(')'))
        .toString();
  }
}

class $KnowledgeTroubleshootingTable extends KnowledgeTroubleshooting
    with
        TableInfo<$KnowledgeTroubleshootingTable,
            KnowledgeTroubleshootingData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $KnowledgeTroubleshootingTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _knowledgeEntryIdMeta =
      const VerificationMeta('knowledgeEntryId');
  @override
  late final GeneratedColumn<String> knowledgeEntryId = GeneratedColumn<String>(
      'knowledge_entry_id', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'REFERENCES knowledge_entries (id)'));
  static const VerificationMeta _symptomMeta =
      const VerificationMeta('symptom');
  @override
  late final GeneratedColumn<String> symptom = GeneratedColumn<String>(
      'symptom', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _rootCauseMeta =
      const VerificationMeta('rootCause');
  @override
  late final GeneratedColumn<String> rootCause = GeneratedColumn<String>(
      'root_cause', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _diagnosticStepsMeta =
      const VerificationMeta('diagnosticSteps');
  @override
  late final GeneratedColumn<String> diagnosticSteps = GeneratedColumn<String>(
      'diagnostic_steps', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('[]'));
  static const VerificationMeta _resolutionMeta =
      const VerificationMeta('resolution');
  @override
  late final GeneratedColumn<String> resolution = GeneratedColumn<String>(
      'resolution', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _preventionTipsMeta =
      const VerificationMeta('preventionTips');
  @override
  late final GeneratedColumn<String> preventionTips = GeneratedColumn<String>(
      'prevention_tips', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _relatedIssuesMeta =
      const VerificationMeta('relatedIssues');
  @override
  late final GeneratedColumn<String> relatedIssues = GeneratedColumn<String>(
      'related_issues', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('[]'));
  @override
  List<GeneratedColumn> get $columns => [
        id,
        knowledgeEntryId,
        symptom,
        rootCause,
        diagnosticSteps,
        resolution,
        preventionTips,
        relatedIssues
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'knowledge_troubleshooting';
  @override
  VerificationContext validateIntegrity(
      Insertable<KnowledgeTroubleshootingData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('knowledge_entry_id')) {
      context.handle(
          _knowledgeEntryIdMeta,
          knowledgeEntryId.isAcceptableOrUnknown(
              data['knowledge_entry_id']!, _knowledgeEntryIdMeta));
    } else if (isInserting) {
      context.missing(_knowledgeEntryIdMeta);
    }
    if (data.containsKey('symptom')) {
      context.handle(_symptomMeta,
          symptom.isAcceptableOrUnknown(data['symptom']!, _symptomMeta));
    } else if (isInserting) {
      context.missing(_symptomMeta);
    }
    if (data.containsKey('root_cause')) {
      context.handle(_rootCauseMeta,
          rootCause.isAcceptableOrUnknown(data['root_cause']!, _rootCauseMeta));
    } else if (isInserting) {
      context.missing(_rootCauseMeta);
    }
    if (data.containsKey('diagnostic_steps')) {
      context.handle(
          _diagnosticStepsMeta,
          diagnosticSteps.isAcceptableOrUnknown(
              data['diagnostic_steps']!, _diagnosticStepsMeta));
    }
    if (data.containsKey('resolution')) {
      context.handle(
          _resolutionMeta,
          resolution.isAcceptableOrUnknown(
              data['resolution']!, _resolutionMeta));
    } else if (isInserting) {
      context.missing(_resolutionMeta);
    }
    if (data.containsKey('prevention_tips')) {
      context.handle(
          _preventionTipsMeta,
          preventionTips.isAcceptableOrUnknown(
              data['prevention_tips']!, _preventionTipsMeta));
    }
    if (data.containsKey('related_issues')) {
      context.handle(
          _relatedIssuesMeta,
          relatedIssues.isAcceptableOrUnknown(
              data['related_issues']!, _relatedIssuesMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  KnowledgeTroubleshootingData map(Map<String, dynamic> data,
      {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return KnowledgeTroubleshootingData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      knowledgeEntryId: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}knowledge_entry_id'])!,
      symptom: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}symptom'])!,
      rootCause: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}root_cause'])!,
      diagnosticSteps: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}diagnostic_steps'])!,
      resolution: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}resolution'])!,
      preventionTips: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}prevention_tips']),
      relatedIssues: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}related_issues'])!,
    );
  }

  @override
  $KnowledgeTroubleshootingTable createAlias(String alias) {
    return $KnowledgeTroubleshootingTable(attachedDatabase, alias);
  }
}

class KnowledgeTroubleshootingData extends DataClass
    implements Insertable<KnowledgeTroubleshootingData> {
  final int id;
  final String knowledgeEntryId;
  final String symptom;
  final String rootCause;
  final String diagnosticSteps;
  final String resolution;
  final String? preventionTips;
  final String relatedIssues;
  const KnowledgeTroubleshootingData(
      {required this.id,
      required this.knowledgeEntryId,
      required this.symptom,
      required this.rootCause,
      required this.diagnosticSteps,
      required this.resolution,
      this.preventionTips,
      required this.relatedIssues});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['knowledge_entry_id'] = Variable<String>(knowledgeEntryId);
    map['symptom'] = Variable<String>(symptom);
    map['root_cause'] = Variable<String>(rootCause);
    map['diagnostic_steps'] = Variable<String>(diagnosticSteps);
    map['resolution'] = Variable<String>(resolution);
    if (!nullToAbsent || preventionTips != null) {
      map['prevention_tips'] = Variable<String>(preventionTips);
    }
    map['related_issues'] = Variable<String>(relatedIssues);
    return map;
  }

  KnowledgeTroubleshootingCompanion toCompanion(bool nullToAbsent) {
    return KnowledgeTroubleshootingCompanion(
      id: Value(id),
      knowledgeEntryId: Value(knowledgeEntryId),
      symptom: Value(symptom),
      rootCause: Value(rootCause),
      diagnosticSteps: Value(diagnosticSteps),
      resolution: Value(resolution),
      preventionTips: preventionTips == null && nullToAbsent
          ? const Value.absent()
          : Value(preventionTips),
      relatedIssues: Value(relatedIssues),
    );
  }

  factory KnowledgeTroubleshootingData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return KnowledgeTroubleshootingData(
      id: serializer.fromJson<int>(json['id']),
      knowledgeEntryId: serializer.fromJson<String>(json['knowledgeEntryId']),
      symptom: serializer.fromJson<String>(json['symptom']),
      rootCause: serializer.fromJson<String>(json['rootCause']),
      diagnosticSteps: serializer.fromJson<String>(json['diagnosticSteps']),
      resolution: serializer.fromJson<String>(json['resolution']),
      preventionTips: serializer.fromJson<String?>(json['preventionTips']),
      relatedIssues: serializer.fromJson<String>(json['relatedIssues']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'knowledgeEntryId': serializer.toJson<String>(knowledgeEntryId),
      'symptom': serializer.toJson<String>(symptom),
      'rootCause': serializer.toJson<String>(rootCause),
      'diagnosticSteps': serializer.toJson<String>(diagnosticSteps),
      'resolution': serializer.toJson<String>(resolution),
      'preventionTips': serializer.toJson<String?>(preventionTips),
      'relatedIssues': serializer.toJson<String>(relatedIssues),
    };
  }

  KnowledgeTroubleshootingData copyWith(
          {int? id,
          String? knowledgeEntryId,
          String? symptom,
          String? rootCause,
          String? diagnosticSteps,
          String? resolution,
          Value<String?> preventionTips = const Value.absent(),
          String? relatedIssues}) =>
      KnowledgeTroubleshootingData(
        id: id ?? this.id,
        knowledgeEntryId: knowledgeEntryId ?? this.knowledgeEntryId,
        symptom: symptom ?? this.symptom,
        rootCause: rootCause ?? this.rootCause,
        diagnosticSteps: diagnosticSteps ?? this.diagnosticSteps,
        resolution: resolution ?? this.resolution,
        preventionTips:
            preventionTips.present ? preventionTips.value : this.preventionTips,
        relatedIssues: relatedIssues ?? this.relatedIssues,
      );
  KnowledgeTroubleshootingData copyWithCompanion(
      KnowledgeTroubleshootingCompanion data) {
    return KnowledgeTroubleshootingData(
      id: data.id.present ? data.id.value : this.id,
      knowledgeEntryId: data.knowledgeEntryId.present
          ? data.knowledgeEntryId.value
          : this.knowledgeEntryId,
      symptom: data.symptom.present ? data.symptom.value : this.symptom,
      rootCause: data.rootCause.present ? data.rootCause.value : this.rootCause,
      diagnosticSteps: data.diagnosticSteps.present
          ? data.diagnosticSteps.value
          : this.diagnosticSteps,
      resolution:
          data.resolution.present ? data.resolution.value : this.resolution,
      preventionTips: data.preventionTips.present
          ? data.preventionTips.value
          : this.preventionTips,
      relatedIssues: data.relatedIssues.present
          ? data.relatedIssues.value
          : this.relatedIssues,
    );
  }

  @override
  String toString() {
    return (StringBuffer('KnowledgeTroubleshootingData(')
          ..write('id: $id, ')
          ..write('knowledgeEntryId: $knowledgeEntryId, ')
          ..write('symptom: $symptom, ')
          ..write('rootCause: $rootCause, ')
          ..write('diagnosticSteps: $diagnosticSteps, ')
          ..write('resolution: $resolution, ')
          ..write('preventionTips: $preventionTips, ')
          ..write('relatedIssues: $relatedIssues')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, knowledgeEntryId, symptom, rootCause,
      diagnosticSteps, resolution, preventionTips, relatedIssues);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is KnowledgeTroubleshootingData &&
          other.id == this.id &&
          other.knowledgeEntryId == this.knowledgeEntryId &&
          other.symptom == this.symptom &&
          other.rootCause == this.rootCause &&
          other.diagnosticSteps == this.diagnosticSteps &&
          other.resolution == this.resolution &&
          other.preventionTips == this.preventionTips &&
          other.relatedIssues == this.relatedIssues);
}

class KnowledgeTroubleshootingCompanion
    extends UpdateCompanion<KnowledgeTroubleshootingData> {
  final Value<int> id;
  final Value<String> knowledgeEntryId;
  final Value<String> symptom;
  final Value<String> rootCause;
  final Value<String> diagnosticSteps;
  final Value<String> resolution;
  final Value<String?> preventionTips;
  final Value<String> relatedIssues;
  const KnowledgeTroubleshootingCompanion({
    this.id = const Value.absent(),
    this.knowledgeEntryId = const Value.absent(),
    this.symptom = const Value.absent(),
    this.rootCause = const Value.absent(),
    this.diagnosticSteps = const Value.absent(),
    this.resolution = const Value.absent(),
    this.preventionTips = const Value.absent(),
    this.relatedIssues = const Value.absent(),
  });
  KnowledgeTroubleshootingCompanion.insert({
    this.id = const Value.absent(),
    required String knowledgeEntryId,
    required String symptom,
    required String rootCause,
    this.diagnosticSteps = const Value.absent(),
    required String resolution,
    this.preventionTips = const Value.absent(),
    this.relatedIssues = const Value.absent(),
  })  : knowledgeEntryId = Value(knowledgeEntryId),
        symptom = Value(symptom),
        rootCause = Value(rootCause),
        resolution = Value(resolution);
  static Insertable<KnowledgeTroubleshootingData> custom({
    Expression<int>? id,
    Expression<String>? knowledgeEntryId,
    Expression<String>? symptom,
    Expression<String>? rootCause,
    Expression<String>? diagnosticSteps,
    Expression<String>? resolution,
    Expression<String>? preventionTips,
    Expression<String>? relatedIssues,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (knowledgeEntryId != null) 'knowledge_entry_id': knowledgeEntryId,
      if (symptom != null) 'symptom': symptom,
      if (rootCause != null) 'root_cause': rootCause,
      if (diagnosticSteps != null) 'diagnostic_steps': diagnosticSteps,
      if (resolution != null) 'resolution': resolution,
      if (preventionTips != null) 'prevention_tips': preventionTips,
      if (relatedIssues != null) 'related_issues': relatedIssues,
    });
  }

  KnowledgeTroubleshootingCompanion copyWith(
      {Value<int>? id,
      Value<String>? knowledgeEntryId,
      Value<String>? symptom,
      Value<String>? rootCause,
      Value<String>? diagnosticSteps,
      Value<String>? resolution,
      Value<String?>? preventionTips,
      Value<String>? relatedIssues}) {
    return KnowledgeTroubleshootingCompanion(
      id: id ?? this.id,
      knowledgeEntryId: knowledgeEntryId ?? this.knowledgeEntryId,
      symptom: symptom ?? this.symptom,
      rootCause: rootCause ?? this.rootCause,
      diagnosticSteps: diagnosticSteps ?? this.diagnosticSteps,
      resolution: resolution ?? this.resolution,
      preventionTips: preventionTips ?? this.preventionTips,
      relatedIssues: relatedIssues ?? this.relatedIssues,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (knowledgeEntryId.present) {
      map['knowledge_entry_id'] = Variable<String>(knowledgeEntryId.value);
    }
    if (symptom.present) {
      map['symptom'] = Variable<String>(symptom.value);
    }
    if (rootCause.present) {
      map['root_cause'] = Variable<String>(rootCause.value);
    }
    if (diagnosticSteps.present) {
      map['diagnostic_steps'] = Variable<String>(diagnosticSteps.value);
    }
    if (resolution.present) {
      map['resolution'] = Variable<String>(resolution.value);
    }
    if (preventionTips.present) {
      map['prevention_tips'] = Variable<String>(preventionTips.value);
    }
    if (relatedIssues.present) {
      map['related_issues'] = Variable<String>(relatedIssues.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('KnowledgeTroubleshootingCompanion(')
          ..write('id: $id, ')
          ..write('knowledgeEntryId: $knowledgeEntryId, ')
          ..write('symptom: $symptom, ')
          ..write('rootCause: $rootCause, ')
          ..write('diagnosticSteps: $diagnosticSteps, ')
          ..write('resolution: $resolution, ')
          ..write('preventionTips: $preventionTips, ')
          ..write('relatedIssues: $relatedIssues')
          ..write(')'))
        .toString();
  }
}

class $EquipmentSpecsTable extends EquipmentSpecs
    with TableInfo<$EquipmentSpecsTable, EquipmentSpec> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $EquipmentSpecsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _knowledgeEntryIdMeta =
      const VerificationMeta('knowledgeEntryId');
  @override
  late final GeneratedColumn<String> knowledgeEntryId = GeneratedColumn<String>(
      'knowledge_entry_id', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'REFERENCES knowledge_entries (id)'));
  static const VerificationMeta _equipmentTypeMeta =
      const VerificationMeta('equipmentType');
  @override
  late final GeneratedColumn<String> equipmentType = GeneratedColumn<String>(
      'equipment_type', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _manufacturerMeta =
      const VerificationMeta('manufacturer');
  @override
  late final GeneratedColumn<String> manufacturer = GeneratedColumn<String>(
      'manufacturer', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _modelMeta = const VerificationMeta('model');
  @override
  late final GeneratedColumn<String> model = GeneratedColumn<String>(
      'model', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _serialNumberPatternMeta =
      const VerificationMeta('serialNumberPattern');
  @override
  late final GeneratedColumn<String> serialNumberPattern =
      GeneratedColumn<String>('serial_number_pattern', aliasedName, true,
          type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _specificationsMeta =
      const VerificationMeta('specifications');
  @override
  late final GeneratedColumn<String> specifications = GeneratedColumn<String>(
      'specifications', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('{}'));
  static const VerificationMeta _compatibilityMeta =
      const VerificationMeta('compatibility');
  @override
  late final GeneratedColumn<String> compatibility = GeneratedColumn<String>(
      'compatibility', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('[]'));
  static const VerificationMeta _eolDateMeta =
      const VerificationMeta('eolDate');
  @override
  late final GeneratedColumn<DateTime> eolDate = GeneratedColumn<DateTime>(
      'eol_date', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _supportUrlMeta =
      const VerificationMeta('supportUrl');
  @override
  late final GeneratedColumn<String> supportUrl = GeneratedColumn<String>(
      'support_url', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        knowledgeEntryId,
        equipmentType,
        manufacturer,
        model,
        serialNumberPattern,
        specifications,
        compatibility,
        eolDate,
        supportUrl
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'equipment_specs';
  @override
  VerificationContext validateIntegrity(Insertable<EquipmentSpec> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('knowledge_entry_id')) {
      context.handle(
          _knowledgeEntryIdMeta,
          knowledgeEntryId.isAcceptableOrUnknown(
              data['knowledge_entry_id']!, _knowledgeEntryIdMeta));
    } else if (isInserting) {
      context.missing(_knowledgeEntryIdMeta);
    }
    if (data.containsKey('equipment_type')) {
      context.handle(
          _equipmentTypeMeta,
          equipmentType.isAcceptableOrUnknown(
              data['equipment_type']!, _equipmentTypeMeta));
    } else if (isInserting) {
      context.missing(_equipmentTypeMeta);
    }
    if (data.containsKey('manufacturer')) {
      context.handle(
          _manufacturerMeta,
          manufacturer.isAcceptableOrUnknown(
              data['manufacturer']!, _manufacturerMeta));
    }
    if (data.containsKey('model')) {
      context.handle(
          _modelMeta, model.isAcceptableOrUnknown(data['model']!, _modelMeta));
    } else if (isInserting) {
      context.missing(_modelMeta);
    }
    if (data.containsKey('serial_number_pattern')) {
      context.handle(
          _serialNumberPatternMeta,
          serialNumberPattern.isAcceptableOrUnknown(
              data['serial_number_pattern']!, _serialNumberPatternMeta));
    }
    if (data.containsKey('specifications')) {
      context.handle(
          _specificationsMeta,
          specifications.isAcceptableOrUnknown(
              data['specifications']!, _specificationsMeta));
    }
    if (data.containsKey('compatibility')) {
      context.handle(
          _compatibilityMeta,
          compatibility.isAcceptableOrUnknown(
              data['compatibility']!, _compatibilityMeta));
    }
    if (data.containsKey('eol_date')) {
      context.handle(_eolDateMeta,
          eolDate.isAcceptableOrUnknown(data['eol_date']!, _eolDateMeta));
    }
    if (data.containsKey('support_url')) {
      context.handle(
          _supportUrlMeta,
          supportUrl.isAcceptableOrUnknown(
              data['support_url']!, _supportUrlMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  EquipmentSpec map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return EquipmentSpec(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      knowledgeEntryId: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}knowledge_entry_id'])!,
      equipmentType: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}equipment_type'])!,
      manufacturer: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}manufacturer']),
      model: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}model'])!,
      serialNumberPattern: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}serial_number_pattern']),
      specifications: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}specifications'])!,
      compatibility: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}compatibility'])!,
      eolDate: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}eol_date']),
      supportUrl: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}support_url']),
    );
  }

  @override
  $EquipmentSpecsTable createAlias(String alias) {
    return $EquipmentSpecsTable(attachedDatabase, alias);
  }
}

class EquipmentSpec extends DataClass implements Insertable<EquipmentSpec> {
  final int id;
  final String knowledgeEntryId;
  final String equipmentType;
  final String? manufacturer;
  final String model;
  final String? serialNumberPattern;
  final String specifications;
  final String compatibility;
  final DateTime? eolDate;
  final String? supportUrl;
  const EquipmentSpec(
      {required this.id,
      required this.knowledgeEntryId,
      required this.equipmentType,
      this.manufacturer,
      required this.model,
      this.serialNumberPattern,
      required this.specifications,
      required this.compatibility,
      this.eolDate,
      this.supportUrl});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['knowledge_entry_id'] = Variable<String>(knowledgeEntryId);
    map['equipment_type'] = Variable<String>(equipmentType);
    if (!nullToAbsent || manufacturer != null) {
      map['manufacturer'] = Variable<String>(manufacturer);
    }
    map['model'] = Variable<String>(model);
    if (!nullToAbsent || serialNumberPattern != null) {
      map['serial_number_pattern'] = Variable<String>(serialNumberPattern);
    }
    map['specifications'] = Variable<String>(specifications);
    map['compatibility'] = Variable<String>(compatibility);
    if (!nullToAbsent || eolDate != null) {
      map['eol_date'] = Variable<DateTime>(eolDate);
    }
    if (!nullToAbsent || supportUrl != null) {
      map['support_url'] = Variable<String>(supportUrl);
    }
    return map;
  }

  EquipmentSpecsCompanion toCompanion(bool nullToAbsent) {
    return EquipmentSpecsCompanion(
      id: Value(id),
      knowledgeEntryId: Value(knowledgeEntryId),
      equipmentType: Value(equipmentType),
      manufacturer: manufacturer == null && nullToAbsent
          ? const Value.absent()
          : Value(manufacturer),
      model: Value(model),
      serialNumberPattern: serialNumberPattern == null && nullToAbsent
          ? const Value.absent()
          : Value(serialNumberPattern),
      specifications: Value(specifications),
      compatibility: Value(compatibility),
      eolDate: eolDate == null && nullToAbsent
          ? const Value.absent()
          : Value(eolDate),
      supportUrl: supportUrl == null && nullToAbsent
          ? const Value.absent()
          : Value(supportUrl),
    );
  }

  factory EquipmentSpec.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return EquipmentSpec(
      id: serializer.fromJson<int>(json['id']),
      knowledgeEntryId: serializer.fromJson<String>(json['knowledgeEntryId']),
      equipmentType: serializer.fromJson<String>(json['equipmentType']),
      manufacturer: serializer.fromJson<String?>(json['manufacturer']),
      model: serializer.fromJson<String>(json['model']),
      serialNumberPattern:
          serializer.fromJson<String?>(json['serialNumberPattern']),
      specifications: serializer.fromJson<String>(json['specifications']),
      compatibility: serializer.fromJson<String>(json['compatibility']),
      eolDate: serializer.fromJson<DateTime?>(json['eolDate']),
      supportUrl: serializer.fromJson<String?>(json['supportUrl']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'knowledgeEntryId': serializer.toJson<String>(knowledgeEntryId),
      'equipmentType': serializer.toJson<String>(equipmentType),
      'manufacturer': serializer.toJson<String?>(manufacturer),
      'model': serializer.toJson<String>(model),
      'serialNumberPattern': serializer.toJson<String?>(serialNumberPattern),
      'specifications': serializer.toJson<String>(specifications),
      'compatibility': serializer.toJson<String>(compatibility),
      'eolDate': serializer.toJson<DateTime?>(eolDate),
      'supportUrl': serializer.toJson<String?>(supportUrl),
    };
  }

  EquipmentSpec copyWith(
          {int? id,
          String? knowledgeEntryId,
          String? equipmentType,
          Value<String?> manufacturer = const Value.absent(),
          String? model,
          Value<String?> serialNumberPattern = const Value.absent(),
          String? specifications,
          String? compatibility,
          Value<DateTime?> eolDate = const Value.absent(),
          Value<String?> supportUrl = const Value.absent()}) =>
      EquipmentSpec(
        id: id ?? this.id,
        knowledgeEntryId: knowledgeEntryId ?? this.knowledgeEntryId,
        equipmentType: equipmentType ?? this.equipmentType,
        manufacturer:
            manufacturer.present ? manufacturer.value : this.manufacturer,
        model: model ?? this.model,
        serialNumberPattern: serialNumberPattern.present
            ? serialNumberPattern.value
            : this.serialNumberPattern,
        specifications: specifications ?? this.specifications,
        compatibility: compatibility ?? this.compatibility,
        eolDate: eolDate.present ? eolDate.value : this.eolDate,
        supportUrl: supportUrl.present ? supportUrl.value : this.supportUrl,
      );
  EquipmentSpec copyWithCompanion(EquipmentSpecsCompanion data) {
    return EquipmentSpec(
      id: data.id.present ? data.id.value : this.id,
      knowledgeEntryId: data.knowledgeEntryId.present
          ? data.knowledgeEntryId.value
          : this.knowledgeEntryId,
      equipmentType: data.equipmentType.present
          ? data.equipmentType.value
          : this.equipmentType,
      manufacturer: data.manufacturer.present
          ? data.manufacturer.value
          : this.manufacturer,
      model: data.model.present ? data.model.value : this.model,
      serialNumberPattern: data.serialNumberPattern.present
          ? data.serialNumberPattern.value
          : this.serialNumberPattern,
      specifications: data.specifications.present
          ? data.specifications.value
          : this.specifications,
      compatibility: data.compatibility.present
          ? data.compatibility.value
          : this.compatibility,
      eolDate: data.eolDate.present ? data.eolDate.value : this.eolDate,
      supportUrl:
          data.supportUrl.present ? data.supportUrl.value : this.supportUrl,
    );
  }

  @override
  String toString() {
    return (StringBuffer('EquipmentSpec(')
          ..write('id: $id, ')
          ..write('knowledgeEntryId: $knowledgeEntryId, ')
          ..write('equipmentType: $equipmentType, ')
          ..write('manufacturer: $manufacturer, ')
          ..write('model: $model, ')
          ..write('serialNumberPattern: $serialNumberPattern, ')
          ..write('specifications: $specifications, ')
          ..write('compatibility: $compatibility, ')
          ..write('eolDate: $eolDate, ')
          ..write('supportUrl: $supportUrl')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id,
      knowledgeEntryId,
      equipmentType,
      manufacturer,
      model,
      serialNumberPattern,
      specifications,
      compatibility,
      eolDate,
      supportUrl);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is EquipmentSpec &&
          other.id == this.id &&
          other.knowledgeEntryId == this.knowledgeEntryId &&
          other.equipmentType == this.equipmentType &&
          other.manufacturer == this.manufacturer &&
          other.model == this.model &&
          other.serialNumberPattern == this.serialNumberPattern &&
          other.specifications == this.specifications &&
          other.compatibility == this.compatibility &&
          other.eolDate == this.eolDate &&
          other.supportUrl == this.supportUrl);
}

class EquipmentSpecsCompanion extends UpdateCompanion<EquipmentSpec> {
  final Value<int> id;
  final Value<String> knowledgeEntryId;
  final Value<String> equipmentType;
  final Value<String?> manufacturer;
  final Value<String> model;
  final Value<String?> serialNumberPattern;
  final Value<String> specifications;
  final Value<String> compatibility;
  final Value<DateTime?> eolDate;
  final Value<String?> supportUrl;
  const EquipmentSpecsCompanion({
    this.id = const Value.absent(),
    this.knowledgeEntryId = const Value.absent(),
    this.equipmentType = const Value.absent(),
    this.manufacturer = const Value.absent(),
    this.model = const Value.absent(),
    this.serialNumberPattern = const Value.absent(),
    this.specifications = const Value.absent(),
    this.compatibility = const Value.absent(),
    this.eolDate = const Value.absent(),
    this.supportUrl = const Value.absent(),
  });
  EquipmentSpecsCompanion.insert({
    this.id = const Value.absent(),
    required String knowledgeEntryId,
    required String equipmentType,
    this.manufacturer = const Value.absent(),
    required String model,
    this.serialNumberPattern = const Value.absent(),
    this.specifications = const Value.absent(),
    this.compatibility = const Value.absent(),
    this.eolDate = const Value.absent(),
    this.supportUrl = const Value.absent(),
  })  : knowledgeEntryId = Value(knowledgeEntryId),
        equipmentType = Value(equipmentType),
        model = Value(model);
  static Insertable<EquipmentSpec> custom({
    Expression<int>? id,
    Expression<String>? knowledgeEntryId,
    Expression<String>? equipmentType,
    Expression<String>? manufacturer,
    Expression<String>? model,
    Expression<String>? serialNumberPattern,
    Expression<String>? specifications,
    Expression<String>? compatibility,
    Expression<DateTime>? eolDate,
    Expression<String>? supportUrl,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (knowledgeEntryId != null) 'knowledge_entry_id': knowledgeEntryId,
      if (equipmentType != null) 'equipment_type': equipmentType,
      if (manufacturer != null) 'manufacturer': manufacturer,
      if (model != null) 'model': model,
      if (serialNumberPattern != null)
        'serial_number_pattern': serialNumberPattern,
      if (specifications != null) 'specifications': specifications,
      if (compatibility != null) 'compatibility': compatibility,
      if (eolDate != null) 'eol_date': eolDate,
      if (supportUrl != null) 'support_url': supportUrl,
    });
  }

  EquipmentSpecsCompanion copyWith(
      {Value<int>? id,
      Value<String>? knowledgeEntryId,
      Value<String>? equipmentType,
      Value<String?>? manufacturer,
      Value<String>? model,
      Value<String?>? serialNumberPattern,
      Value<String>? specifications,
      Value<String>? compatibility,
      Value<DateTime?>? eolDate,
      Value<String?>? supportUrl}) {
    return EquipmentSpecsCompanion(
      id: id ?? this.id,
      knowledgeEntryId: knowledgeEntryId ?? this.knowledgeEntryId,
      equipmentType: equipmentType ?? this.equipmentType,
      manufacturer: manufacturer ?? this.manufacturer,
      model: model ?? this.model,
      serialNumberPattern: serialNumberPattern ?? this.serialNumberPattern,
      specifications: specifications ?? this.specifications,
      compatibility: compatibility ?? this.compatibility,
      eolDate: eolDate ?? this.eolDate,
      supportUrl: supportUrl ?? this.supportUrl,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (knowledgeEntryId.present) {
      map['knowledge_entry_id'] = Variable<String>(knowledgeEntryId.value);
    }
    if (equipmentType.present) {
      map['equipment_type'] = Variable<String>(equipmentType.value);
    }
    if (manufacturer.present) {
      map['manufacturer'] = Variable<String>(manufacturer.value);
    }
    if (model.present) {
      map['model'] = Variable<String>(model.value);
    }
    if (serialNumberPattern.present) {
      map['serial_number_pattern'] =
          Variable<String>(serialNumberPattern.value);
    }
    if (specifications.present) {
      map['specifications'] = Variable<String>(specifications.value);
    }
    if (compatibility.present) {
      map['compatibility'] = Variable<String>(compatibility.value);
    }
    if (eolDate.present) {
      map['eol_date'] = Variable<DateTime>(eolDate.value);
    }
    if (supportUrl.present) {
      map['support_url'] = Variable<String>(supportUrl.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('EquipmentSpecsCompanion(')
          ..write('id: $id, ')
          ..write('knowledgeEntryId: $knowledgeEntryId, ')
          ..write('equipmentType: $equipmentType, ')
          ..write('manufacturer: $manufacturer, ')
          ..write('model: $model, ')
          ..write('serialNumberPattern: $serialNumberPattern, ')
          ..write('specifications: $specifications, ')
          ..write('compatibility: $compatibility, ')
          ..write('eolDate: $eolDate, ')
          ..write('supportUrl: $supportUrl')
          ..write(')'))
        .toString();
  }
}

class $KnowledgeRelationshipsTable extends KnowledgeRelationships
    with TableInfo<$KnowledgeRelationshipsTable, KnowledgeRelationship> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $KnowledgeRelationshipsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _fromEntryIdMeta =
      const VerificationMeta('fromEntryId');
  @override
  late final GeneratedColumn<String> fromEntryId = GeneratedColumn<String>(
      'from_entry_id', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'REFERENCES knowledge_entries (id)'));
  static const VerificationMeta _toEntryIdMeta =
      const VerificationMeta('toEntryId');
  @override
  late final GeneratedColumn<String> toEntryId = GeneratedColumn<String>(
      'to_entry_id', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'REFERENCES knowledge_entries (id)'));
  static const VerificationMeta _relationshipTypeMeta =
      const VerificationMeta('relationshipType');
  @override
  late final GeneratedColumn<String> relationshipType = GeneratedColumn<String>(
      'relationship_type', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _descriptionMeta =
      const VerificationMeta('description');
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
      'description', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns =>
      [id, fromEntryId, toEntryId, relationshipType, description];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'knowledge_relationships';
  @override
  VerificationContext validateIntegrity(
      Insertable<KnowledgeRelationship> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('from_entry_id')) {
      context.handle(
          _fromEntryIdMeta,
          fromEntryId.isAcceptableOrUnknown(
              data['from_entry_id']!, _fromEntryIdMeta));
    } else if (isInserting) {
      context.missing(_fromEntryIdMeta);
    }
    if (data.containsKey('to_entry_id')) {
      context.handle(
          _toEntryIdMeta,
          toEntryId.isAcceptableOrUnknown(
              data['to_entry_id']!, _toEntryIdMeta));
    } else if (isInserting) {
      context.missing(_toEntryIdMeta);
    }
    if (data.containsKey('relationship_type')) {
      context.handle(
          _relationshipTypeMeta,
          relationshipType.isAcceptableOrUnknown(
              data['relationship_type']!, _relationshipTypeMeta));
    } else if (isInserting) {
      context.missing(_relationshipTypeMeta);
    }
    if (data.containsKey('description')) {
      context.handle(
          _descriptionMeta,
          description.isAcceptableOrUnknown(
              data['description']!, _descriptionMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  KnowledgeRelationship map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return KnowledgeRelationship(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      fromEntryId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}from_entry_id'])!,
      toEntryId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}to_entry_id'])!,
      relationshipType: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}relationship_type'])!,
      description: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}description']),
    );
  }

  @override
  $KnowledgeRelationshipsTable createAlias(String alias) {
    return $KnowledgeRelationshipsTable(attachedDatabase, alias);
  }
}

class KnowledgeRelationship extends DataClass
    implements Insertable<KnowledgeRelationship> {
  final int id;
  final String fromEntryId;
  final String toEntryId;
  final String relationshipType;
  final String? description;
  const KnowledgeRelationship(
      {required this.id,
      required this.fromEntryId,
      required this.toEntryId,
      required this.relationshipType,
      this.description});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['from_entry_id'] = Variable<String>(fromEntryId);
    map['to_entry_id'] = Variable<String>(toEntryId);
    map['relationship_type'] = Variable<String>(relationshipType);
    if (!nullToAbsent || description != null) {
      map['description'] = Variable<String>(description);
    }
    return map;
  }

  KnowledgeRelationshipsCompanion toCompanion(bool nullToAbsent) {
    return KnowledgeRelationshipsCompanion(
      id: Value(id),
      fromEntryId: Value(fromEntryId),
      toEntryId: Value(toEntryId),
      relationshipType: Value(relationshipType),
      description: description == null && nullToAbsent
          ? const Value.absent()
          : Value(description),
    );
  }

  factory KnowledgeRelationship.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return KnowledgeRelationship(
      id: serializer.fromJson<int>(json['id']),
      fromEntryId: serializer.fromJson<String>(json['fromEntryId']),
      toEntryId: serializer.fromJson<String>(json['toEntryId']),
      relationshipType: serializer.fromJson<String>(json['relationshipType']),
      description: serializer.fromJson<String?>(json['description']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'fromEntryId': serializer.toJson<String>(fromEntryId),
      'toEntryId': serializer.toJson<String>(toEntryId),
      'relationshipType': serializer.toJson<String>(relationshipType),
      'description': serializer.toJson<String?>(description),
    };
  }

  KnowledgeRelationship copyWith(
          {int? id,
          String? fromEntryId,
          String? toEntryId,
          String? relationshipType,
          Value<String?> description = const Value.absent()}) =>
      KnowledgeRelationship(
        id: id ?? this.id,
        fromEntryId: fromEntryId ?? this.fromEntryId,
        toEntryId: toEntryId ?? this.toEntryId,
        relationshipType: relationshipType ?? this.relationshipType,
        description: description.present ? description.value : this.description,
      );
  KnowledgeRelationship copyWithCompanion(
      KnowledgeRelationshipsCompanion data) {
    return KnowledgeRelationship(
      id: data.id.present ? data.id.value : this.id,
      fromEntryId:
          data.fromEntryId.present ? data.fromEntryId.value : this.fromEntryId,
      toEntryId: data.toEntryId.present ? data.toEntryId.value : this.toEntryId,
      relationshipType: data.relationshipType.present
          ? data.relationshipType.value
          : this.relationshipType,
      description:
          data.description.present ? data.description.value : this.description,
    );
  }

  @override
  String toString() {
    return (StringBuffer('KnowledgeRelationship(')
          ..write('id: $id, ')
          ..write('fromEntryId: $fromEntryId, ')
          ..write('toEntryId: $toEntryId, ')
          ..write('relationshipType: $relationshipType, ')
          ..write('description: $description')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, fromEntryId, toEntryId, relationshipType, description);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is KnowledgeRelationship &&
          other.id == this.id &&
          other.fromEntryId == this.fromEntryId &&
          other.toEntryId == this.toEntryId &&
          other.relationshipType == this.relationshipType &&
          other.description == this.description);
}

class KnowledgeRelationshipsCompanion
    extends UpdateCompanion<KnowledgeRelationship> {
  final Value<int> id;
  final Value<String> fromEntryId;
  final Value<String> toEntryId;
  final Value<String> relationshipType;
  final Value<String?> description;
  const KnowledgeRelationshipsCompanion({
    this.id = const Value.absent(),
    this.fromEntryId = const Value.absent(),
    this.toEntryId = const Value.absent(),
    this.relationshipType = const Value.absent(),
    this.description = const Value.absent(),
  });
  KnowledgeRelationshipsCompanion.insert({
    this.id = const Value.absent(),
    required String fromEntryId,
    required String toEntryId,
    required String relationshipType,
    this.description = const Value.absent(),
  })  : fromEntryId = Value(fromEntryId),
        toEntryId = Value(toEntryId),
        relationshipType = Value(relationshipType);
  static Insertable<KnowledgeRelationship> custom({
    Expression<int>? id,
    Expression<String>? fromEntryId,
    Expression<String>? toEntryId,
    Expression<String>? relationshipType,
    Expression<String>? description,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (fromEntryId != null) 'from_entry_id': fromEntryId,
      if (toEntryId != null) 'to_entry_id': toEntryId,
      if (relationshipType != null) 'relationship_type': relationshipType,
      if (description != null) 'description': description,
    });
  }

  KnowledgeRelationshipsCompanion copyWith(
      {Value<int>? id,
      Value<String>? fromEntryId,
      Value<String>? toEntryId,
      Value<String>? relationshipType,
      Value<String?>? description}) {
    return KnowledgeRelationshipsCompanion(
      id: id ?? this.id,
      fromEntryId: fromEntryId ?? this.fromEntryId,
      toEntryId: toEntryId ?? this.toEntryId,
      relationshipType: relationshipType ?? this.relationshipType,
      description: description ?? this.description,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (fromEntryId.present) {
      map['from_entry_id'] = Variable<String>(fromEntryId.value);
    }
    if (toEntryId.present) {
      map['to_entry_id'] = Variable<String>(toEntryId.value);
    }
    if (relationshipType.present) {
      map['relationship_type'] = Variable<String>(relationshipType.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('KnowledgeRelationshipsCompanion(')
          ..write('id: $id, ')
          ..write('fromEntryId: $fromEntryId, ')
          ..write('toEntryId: $toEntryId, ')
          ..write('relationshipType: $relationshipType, ')
          ..write('description: $description')
          ..write(')'))
        .toString();
  }
}

class $KnowledgeSearchIndexTable extends KnowledgeSearchIndex
    with TableInfo<$KnowledgeSearchIndexTable, KnowledgeSearchIndexData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $KnowledgeSearchIndexTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _knowledgeEntryIdMeta =
      const VerificationMeta('knowledgeEntryId');
  @override
  late final GeneratedColumn<String> knowledgeEntryId = GeneratedColumn<String>(
      'knowledge_entry_id', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'REFERENCES knowledge_entries (id)'));
  static const VerificationMeta _queryVariationMeta =
      const VerificationMeta('queryVariation');
  @override
  late final GeneratedColumn<String> queryVariation = GeneratedColumn<String>(
      'query_variation', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _synonymsMeta =
      const VerificationMeta('synonyms');
  @override
  late final GeneratedColumn<String> synonyms = GeneratedColumn<String>(
      'synonyms', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('[]'));
  static const VerificationMeta _contextMeta =
      const VerificationMeta('context');
  @override
  late final GeneratedColumn<String> context = GeneratedColumn<String>(
      'context', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _weightMeta = const VerificationMeta('weight');
  @override
  late final GeneratedColumn<double> weight = GeneratedColumn<double>(
      'weight', aliasedName, false,
      type: DriftSqlType.double,
      requiredDuringInsert: false,
      defaultValue: const Constant(1.0));
  @override
  List<GeneratedColumn> get $columns =>
      [id, knowledgeEntryId, queryVariation, synonyms, context, weight];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'knowledge_search_index';
  @override
  VerificationContext validateIntegrity(
      Insertable<KnowledgeSearchIndexData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('knowledge_entry_id')) {
      context.handle(
          _knowledgeEntryIdMeta,
          knowledgeEntryId.isAcceptableOrUnknown(
              data['knowledge_entry_id']!, _knowledgeEntryIdMeta));
    } else if (isInserting) {
      context.missing(_knowledgeEntryIdMeta);
    }
    if (data.containsKey('query_variation')) {
      context.handle(
          _queryVariationMeta,
          queryVariation.isAcceptableOrUnknown(
              data['query_variation']!, _queryVariationMeta));
    } else if (isInserting) {
      context.missing(_queryVariationMeta);
    }
    if (data.containsKey('synonyms')) {
      context.handle(_synonymsMeta,
          synonyms.isAcceptableOrUnknown(data['synonyms']!, _synonymsMeta));
    }
    if (data.containsKey('context')) {
      context.handle(_contextMeta,
          this.context.isAcceptableOrUnknown(data['context']!, _contextMeta));
    }
    if (data.containsKey('weight')) {
      context.handle(_weightMeta,
          weight.isAcceptableOrUnknown(data['weight']!, _weightMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  KnowledgeSearchIndexData map(Map<String, dynamic> data,
      {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return KnowledgeSearchIndexData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      knowledgeEntryId: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}knowledge_entry_id'])!,
      queryVariation: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}query_variation'])!,
      synonyms: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}synonyms'])!,
      context: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}context']),
      weight: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}weight'])!,
    );
  }

  @override
  $KnowledgeSearchIndexTable createAlias(String alias) {
    return $KnowledgeSearchIndexTable(attachedDatabase, alias);
  }
}

class KnowledgeSearchIndexData extends DataClass
    implements Insertable<KnowledgeSearchIndexData> {
  final int id;
  final String knowledgeEntryId;
  final String queryVariation;
  final String synonyms;
  final String? context;
  final double weight;
  const KnowledgeSearchIndexData(
      {required this.id,
      required this.knowledgeEntryId,
      required this.queryVariation,
      required this.synonyms,
      this.context,
      required this.weight});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['knowledge_entry_id'] = Variable<String>(knowledgeEntryId);
    map['query_variation'] = Variable<String>(queryVariation);
    map['synonyms'] = Variable<String>(synonyms);
    if (!nullToAbsent || context != null) {
      map['context'] = Variable<String>(context);
    }
    map['weight'] = Variable<double>(weight);
    return map;
  }

  KnowledgeSearchIndexCompanion toCompanion(bool nullToAbsent) {
    return KnowledgeSearchIndexCompanion(
      id: Value(id),
      knowledgeEntryId: Value(knowledgeEntryId),
      queryVariation: Value(queryVariation),
      synonyms: Value(synonyms),
      context: context == null && nullToAbsent
          ? const Value.absent()
          : Value(context),
      weight: Value(weight),
    );
  }

  factory KnowledgeSearchIndexData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return KnowledgeSearchIndexData(
      id: serializer.fromJson<int>(json['id']),
      knowledgeEntryId: serializer.fromJson<String>(json['knowledgeEntryId']),
      queryVariation: serializer.fromJson<String>(json['queryVariation']),
      synonyms: serializer.fromJson<String>(json['synonyms']),
      context: serializer.fromJson<String?>(json['context']),
      weight: serializer.fromJson<double>(json['weight']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'knowledgeEntryId': serializer.toJson<String>(knowledgeEntryId),
      'queryVariation': serializer.toJson<String>(queryVariation),
      'synonyms': serializer.toJson<String>(synonyms),
      'context': serializer.toJson<String?>(context),
      'weight': serializer.toJson<double>(weight),
    };
  }

  KnowledgeSearchIndexData copyWith(
          {int? id,
          String? knowledgeEntryId,
          String? queryVariation,
          String? synonyms,
          Value<String?> context = const Value.absent(),
          double? weight}) =>
      KnowledgeSearchIndexData(
        id: id ?? this.id,
        knowledgeEntryId: knowledgeEntryId ?? this.knowledgeEntryId,
        queryVariation: queryVariation ?? this.queryVariation,
        synonyms: synonyms ?? this.synonyms,
        context: context.present ? context.value : this.context,
        weight: weight ?? this.weight,
      );
  KnowledgeSearchIndexData copyWithCompanion(
      KnowledgeSearchIndexCompanion data) {
    return KnowledgeSearchIndexData(
      id: data.id.present ? data.id.value : this.id,
      knowledgeEntryId: data.knowledgeEntryId.present
          ? data.knowledgeEntryId.value
          : this.knowledgeEntryId,
      queryVariation: data.queryVariation.present
          ? data.queryVariation.value
          : this.queryVariation,
      synonyms: data.synonyms.present ? data.synonyms.value : this.synonyms,
      context: data.context.present ? data.context.value : this.context,
      weight: data.weight.present ? data.weight.value : this.weight,
    );
  }

  @override
  String toString() {
    return (StringBuffer('KnowledgeSearchIndexData(')
          ..write('id: $id, ')
          ..write('knowledgeEntryId: $knowledgeEntryId, ')
          ..write('queryVariation: $queryVariation, ')
          ..write('synonyms: $synonyms, ')
          ..write('context: $context, ')
          ..write('weight: $weight')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id, knowledgeEntryId, queryVariation, synonyms, context, weight);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is KnowledgeSearchIndexData &&
          other.id == this.id &&
          other.knowledgeEntryId == this.knowledgeEntryId &&
          other.queryVariation == this.queryVariation &&
          other.synonyms == this.synonyms &&
          other.context == this.context &&
          other.weight == this.weight);
}

class KnowledgeSearchIndexCompanion
    extends UpdateCompanion<KnowledgeSearchIndexData> {
  final Value<int> id;
  final Value<String> knowledgeEntryId;
  final Value<String> queryVariation;
  final Value<String> synonyms;
  final Value<String?> context;
  final Value<double> weight;
  const KnowledgeSearchIndexCompanion({
    this.id = const Value.absent(),
    this.knowledgeEntryId = const Value.absent(),
    this.queryVariation = const Value.absent(),
    this.synonyms = const Value.absent(),
    this.context = const Value.absent(),
    this.weight = const Value.absent(),
  });
  KnowledgeSearchIndexCompanion.insert({
    this.id = const Value.absent(),
    required String knowledgeEntryId,
    required String queryVariation,
    this.synonyms = const Value.absent(),
    this.context = const Value.absent(),
    this.weight = const Value.absent(),
  })  : knowledgeEntryId = Value(knowledgeEntryId),
        queryVariation = Value(queryVariation);
  static Insertable<KnowledgeSearchIndexData> custom({
    Expression<int>? id,
    Expression<String>? knowledgeEntryId,
    Expression<String>? queryVariation,
    Expression<String>? synonyms,
    Expression<String>? context,
    Expression<double>? weight,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (knowledgeEntryId != null) 'knowledge_entry_id': knowledgeEntryId,
      if (queryVariation != null) 'query_variation': queryVariation,
      if (synonyms != null) 'synonyms': synonyms,
      if (context != null) 'context': context,
      if (weight != null) 'weight': weight,
    });
  }

  KnowledgeSearchIndexCompanion copyWith(
      {Value<int>? id,
      Value<String>? knowledgeEntryId,
      Value<String>? queryVariation,
      Value<String>? synonyms,
      Value<String?>? context,
      Value<double>? weight}) {
    return KnowledgeSearchIndexCompanion(
      id: id ?? this.id,
      knowledgeEntryId: knowledgeEntryId ?? this.knowledgeEntryId,
      queryVariation: queryVariation ?? this.queryVariation,
      synonyms: synonyms ?? this.synonyms,
      context: context ?? this.context,
      weight: weight ?? this.weight,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (knowledgeEntryId.present) {
      map['knowledge_entry_id'] = Variable<String>(knowledgeEntryId.value);
    }
    if (queryVariation.present) {
      map['query_variation'] = Variable<String>(queryVariation.value);
    }
    if (synonyms.present) {
      map['synonyms'] = Variable<String>(synonyms.value);
    }
    if (context.present) {
      map['context'] = Variable<String>(context.value);
    }
    if (weight.present) {
      map['weight'] = Variable<double>(weight.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('KnowledgeSearchIndexCompanion(')
          ..write('id: $id, ')
          ..write('knowledgeEntryId: $knowledgeEntryId, ')
          ..write('queryVariation: $queryVariation, ')
          ..write('synonyms: $synonyms, ')
          ..write('context: $context, ')
          ..write('weight: $weight')
          ..write(')'))
        .toString();
  }
}

class $KnowledgeQueryLogTable extends KnowledgeQueryLog
    with TableInfo<$KnowledgeQueryLogTable, KnowledgeQueryLogData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $KnowledgeQueryLogTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _queryMeta = const VerificationMeta('query');
  @override
  late final GeneratedColumn<String> query = GeneratedColumn<String>(
      'query', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _matchedEntryIdMeta =
      const VerificationMeta('matchedEntryId');
  @override
  late final GeneratedColumn<String> matchedEntryId = GeneratedColumn<String>(
      'matched_entry_id', aliasedName, true,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'REFERENCES knowledge_entries (id)'));
  static const VerificationMeta _wasHelpfulMeta =
      const VerificationMeta('wasHelpful');
  @override
  late final GeneratedColumn<bool> wasHelpful = GeneratedColumn<bool>(
      'was_helpful', aliasedName, true,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("was_helpful" IN (0, 1))'));
  static const VerificationMeta _timeSpentSecondsMeta =
      const VerificationMeta('timeSpentSeconds');
  @override
  late final GeneratedColumn<int> timeSpentSeconds = GeneratedColumn<int>(
      'time_spent_seconds', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _queriedAtMeta =
      const VerificationMeta('queriedAt');
  @override
  late final GeneratedColumn<DateTime> queriedAt = GeneratedColumn<DateTime>(
      'queried_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
  late final GeneratedColumn<int> userId = GeneratedColumn<int>(
      'user_id', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        query,
        matchedEntryId,
        wasHelpful,
        timeSpentSeconds,
        queriedAt,
        userId
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'knowledge_query_log';
  @override
  VerificationContext validateIntegrity(
      Insertable<KnowledgeQueryLogData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('query')) {
      context.handle(
          _queryMeta, query.isAcceptableOrUnknown(data['query']!, _queryMeta));
    } else if (isInserting) {
      context.missing(_queryMeta);
    }
    if (data.containsKey('matched_entry_id')) {
      context.handle(
          _matchedEntryIdMeta,
          matchedEntryId.isAcceptableOrUnknown(
              data['matched_entry_id']!, _matchedEntryIdMeta));
    }
    if (data.containsKey('was_helpful')) {
      context.handle(
          _wasHelpfulMeta,
          wasHelpful.isAcceptableOrUnknown(
              data['was_helpful']!, _wasHelpfulMeta));
    }
    if (data.containsKey('time_spent_seconds')) {
      context.handle(
          _timeSpentSecondsMeta,
          timeSpentSeconds.isAcceptableOrUnknown(
              data['time_spent_seconds']!, _timeSpentSecondsMeta));
    }
    if (data.containsKey('queried_at')) {
      context.handle(_queriedAtMeta,
          queriedAt.isAcceptableOrUnknown(data['queried_at']!, _queriedAtMeta));
    } else if (isInserting) {
      context.missing(_queriedAtMeta);
    }
    if (data.containsKey('user_id')) {
      context.handle(_userIdMeta,
          userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  KnowledgeQueryLogData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return KnowledgeQueryLogData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      query: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}query'])!,
      matchedEntryId: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}matched_entry_id']),
      wasHelpful: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}was_helpful']),
      timeSpentSeconds: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}time_spent_seconds']),
      queriedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}queried_at'])!,
      userId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}user_id']),
    );
  }

  @override
  $KnowledgeQueryLogTable createAlias(String alias) {
    return $KnowledgeQueryLogTable(attachedDatabase, alias);
  }
}

class KnowledgeQueryLogData extends DataClass
    implements Insertable<KnowledgeQueryLogData> {
  final int id;
  final String query;
  final String? matchedEntryId;
  final bool? wasHelpful;
  final int? timeSpentSeconds;
  final DateTime queriedAt;
  final int? userId;
  const KnowledgeQueryLogData(
      {required this.id,
      required this.query,
      this.matchedEntryId,
      this.wasHelpful,
      this.timeSpentSeconds,
      required this.queriedAt,
      this.userId});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['query'] = Variable<String>(query);
    if (!nullToAbsent || matchedEntryId != null) {
      map['matched_entry_id'] = Variable<String>(matchedEntryId);
    }
    if (!nullToAbsent || wasHelpful != null) {
      map['was_helpful'] = Variable<bool>(wasHelpful);
    }
    if (!nullToAbsent || timeSpentSeconds != null) {
      map['time_spent_seconds'] = Variable<int>(timeSpentSeconds);
    }
    map['queried_at'] = Variable<DateTime>(queriedAt);
    if (!nullToAbsent || userId != null) {
      map['user_id'] = Variable<int>(userId);
    }
    return map;
  }

  KnowledgeQueryLogCompanion toCompanion(bool nullToAbsent) {
    return KnowledgeQueryLogCompanion(
      id: Value(id),
      query: Value(query),
      matchedEntryId: matchedEntryId == null && nullToAbsent
          ? const Value.absent()
          : Value(matchedEntryId),
      wasHelpful: wasHelpful == null && nullToAbsent
          ? const Value.absent()
          : Value(wasHelpful),
      timeSpentSeconds: timeSpentSeconds == null && nullToAbsent
          ? const Value.absent()
          : Value(timeSpentSeconds),
      queriedAt: Value(queriedAt),
      userId:
          userId == null && nullToAbsent ? const Value.absent() : Value(userId),
    );
  }

  factory KnowledgeQueryLogData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return KnowledgeQueryLogData(
      id: serializer.fromJson<int>(json['id']),
      query: serializer.fromJson<String>(json['query']),
      matchedEntryId: serializer.fromJson<String?>(json['matchedEntryId']),
      wasHelpful: serializer.fromJson<bool?>(json['wasHelpful']),
      timeSpentSeconds: serializer.fromJson<int?>(json['timeSpentSeconds']),
      queriedAt: serializer.fromJson<DateTime>(json['queriedAt']),
      userId: serializer.fromJson<int?>(json['userId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'query': serializer.toJson<String>(query),
      'matchedEntryId': serializer.toJson<String?>(matchedEntryId),
      'wasHelpful': serializer.toJson<bool?>(wasHelpful),
      'timeSpentSeconds': serializer.toJson<int?>(timeSpentSeconds),
      'queriedAt': serializer.toJson<DateTime>(queriedAt),
      'userId': serializer.toJson<int?>(userId),
    };
  }

  KnowledgeQueryLogData copyWith(
          {int? id,
          String? query,
          Value<String?> matchedEntryId = const Value.absent(),
          Value<bool?> wasHelpful = const Value.absent(),
          Value<int?> timeSpentSeconds = const Value.absent(),
          DateTime? queriedAt,
          Value<int?> userId = const Value.absent()}) =>
      KnowledgeQueryLogData(
        id: id ?? this.id,
        query: query ?? this.query,
        matchedEntryId:
            matchedEntryId.present ? matchedEntryId.value : this.matchedEntryId,
        wasHelpful: wasHelpful.present ? wasHelpful.value : this.wasHelpful,
        timeSpentSeconds: timeSpentSeconds.present
            ? timeSpentSeconds.value
            : this.timeSpentSeconds,
        queriedAt: queriedAt ?? this.queriedAt,
        userId: userId.present ? userId.value : this.userId,
      );
  KnowledgeQueryLogData copyWithCompanion(KnowledgeQueryLogCompanion data) {
    return KnowledgeQueryLogData(
      id: data.id.present ? data.id.value : this.id,
      query: data.query.present ? data.query.value : this.query,
      matchedEntryId: data.matchedEntryId.present
          ? data.matchedEntryId.value
          : this.matchedEntryId,
      wasHelpful:
          data.wasHelpful.present ? data.wasHelpful.value : this.wasHelpful,
      timeSpentSeconds: data.timeSpentSeconds.present
          ? data.timeSpentSeconds.value
          : this.timeSpentSeconds,
      queriedAt: data.queriedAt.present ? data.queriedAt.value : this.queriedAt,
      userId: data.userId.present ? data.userId.value : this.userId,
    );
  }

  @override
  String toString() {
    return (StringBuffer('KnowledgeQueryLogData(')
          ..write('id: $id, ')
          ..write('query: $query, ')
          ..write('matchedEntryId: $matchedEntryId, ')
          ..write('wasHelpful: $wasHelpful, ')
          ..write('timeSpentSeconds: $timeSpentSeconds, ')
          ..write('queriedAt: $queriedAt, ')
          ..write('userId: $userId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, query, matchedEntryId, wasHelpful,
      timeSpentSeconds, queriedAt, userId);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is KnowledgeQueryLogData &&
          other.id == this.id &&
          other.query == this.query &&
          other.matchedEntryId == this.matchedEntryId &&
          other.wasHelpful == this.wasHelpful &&
          other.timeSpentSeconds == this.timeSpentSeconds &&
          other.queriedAt == this.queriedAt &&
          other.userId == this.userId);
}

class KnowledgeQueryLogCompanion
    extends UpdateCompanion<KnowledgeQueryLogData> {
  final Value<int> id;
  final Value<String> query;
  final Value<String?> matchedEntryId;
  final Value<bool?> wasHelpful;
  final Value<int?> timeSpentSeconds;
  final Value<DateTime> queriedAt;
  final Value<int?> userId;
  const KnowledgeQueryLogCompanion({
    this.id = const Value.absent(),
    this.query = const Value.absent(),
    this.matchedEntryId = const Value.absent(),
    this.wasHelpful = const Value.absent(),
    this.timeSpentSeconds = const Value.absent(),
    this.queriedAt = const Value.absent(),
    this.userId = const Value.absent(),
  });
  KnowledgeQueryLogCompanion.insert({
    this.id = const Value.absent(),
    required String query,
    this.matchedEntryId = const Value.absent(),
    this.wasHelpful = const Value.absent(),
    this.timeSpentSeconds = const Value.absent(),
    required DateTime queriedAt,
    this.userId = const Value.absent(),
  })  : query = Value(query),
        queriedAt = Value(queriedAt);
  static Insertable<KnowledgeQueryLogData> custom({
    Expression<int>? id,
    Expression<String>? query,
    Expression<String>? matchedEntryId,
    Expression<bool>? wasHelpful,
    Expression<int>? timeSpentSeconds,
    Expression<DateTime>? queriedAt,
    Expression<int>? userId,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (query != null) 'query': query,
      if (matchedEntryId != null) 'matched_entry_id': matchedEntryId,
      if (wasHelpful != null) 'was_helpful': wasHelpful,
      if (timeSpentSeconds != null) 'time_spent_seconds': timeSpentSeconds,
      if (queriedAt != null) 'queried_at': queriedAt,
      if (userId != null) 'user_id': userId,
    });
  }

  KnowledgeQueryLogCompanion copyWith(
      {Value<int>? id,
      Value<String>? query,
      Value<String?>? matchedEntryId,
      Value<bool?>? wasHelpful,
      Value<int?>? timeSpentSeconds,
      Value<DateTime>? queriedAt,
      Value<int?>? userId}) {
    return KnowledgeQueryLogCompanion(
      id: id ?? this.id,
      query: query ?? this.query,
      matchedEntryId: matchedEntryId ?? this.matchedEntryId,
      wasHelpful: wasHelpful ?? this.wasHelpful,
      timeSpentSeconds: timeSpentSeconds ?? this.timeSpentSeconds,
      queriedAt: queriedAt ?? this.queriedAt,
      userId: userId ?? this.userId,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (query.present) {
      map['query'] = Variable<String>(query.value);
    }
    if (matchedEntryId.present) {
      map['matched_entry_id'] = Variable<String>(matchedEntryId.value);
    }
    if (wasHelpful.present) {
      map['was_helpful'] = Variable<bool>(wasHelpful.value);
    }
    if (timeSpentSeconds.present) {
      map['time_spent_seconds'] = Variable<int>(timeSpentSeconds.value);
    }
    if (queriedAt.present) {
      map['queried_at'] = Variable<DateTime>(queriedAt.value);
    }
    if (userId.present) {
      map['user_id'] = Variable<int>(userId.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('KnowledgeQueryLogCompanion(')
          ..write('id: $id, ')
          ..write('query: $query, ')
          ..write('matchedEntryId: $matchedEntryId, ')
          ..write('wasHelpful: $wasHelpful, ')
          ..write('timeSpentSeconds: $timeSpentSeconds, ')
          ..write('queriedAt: $queriedAt, ')
          ..write('userId: $userId')
          ..write(')'))
        .toString();
  }
}

class $ChatChannelsTable extends ChatChannels
    with TableInfo<$ChatChannelsTable, ChatChannel> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ChatChannelsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _descriptionMeta =
      const VerificationMeta('description');
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
      'description', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [id, name, description, updatedAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'chat_channels';
  @override
  VerificationContext validateIntegrity(Insertable<ChatChannel> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('description')) {
      context.handle(
          _descriptionMeta,
          description.isAcceptableOrUnknown(
              data['description']!, _descriptionMeta));
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ChatChannel map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ChatChannel(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      description: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}description']),
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at'])!,
    );
  }

  @override
  $ChatChannelsTable createAlias(String alias) {
    return $ChatChannelsTable(attachedDatabase, alias);
  }
}

class ChatChannel extends DataClass implements Insertable<ChatChannel> {
  final String id;
  final String name;
  final String? description;
  final DateTime updatedAt;
  const ChatChannel(
      {required this.id,
      required this.name,
      this.description,
      required this.updatedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || description != null) {
      map['description'] = Variable<String>(description);
    }
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  ChatChannelsCompanion toCompanion(bool nullToAbsent) {
    return ChatChannelsCompanion(
      id: Value(id),
      name: Value(name),
      description: description == null && nullToAbsent
          ? const Value.absent()
          : Value(description),
      updatedAt: Value(updatedAt),
    );
  }

  factory ChatChannel.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ChatChannel(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      description: serializer.fromJson<String?>(json['description']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'description': serializer.toJson<String?>(description),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  ChatChannel copyWith(
          {String? id,
          String? name,
          Value<String?> description = const Value.absent(),
          DateTime? updatedAt}) =>
      ChatChannel(
        id: id ?? this.id,
        name: name ?? this.name,
        description: description.present ? description.value : this.description,
        updatedAt: updatedAt ?? this.updatedAt,
      );
  ChatChannel copyWithCompanion(ChatChannelsCompanion data) {
    return ChatChannel(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      description:
          data.description.present ? data.description.value : this.description,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ChatChannel(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('description: $description, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, description, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ChatChannel &&
          other.id == this.id &&
          other.name == this.name &&
          other.description == this.description &&
          other.updatedAt == this.updatedAt);
}

class ChatChannelsCompanion extends UpdateCompanion<ChatChannel> {
  final Value<String> id;
  final Value<String> name;
  final Value<String?> description;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const ChatChannelsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.description = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ChatChannelsCompanion.insert({
    required String id,
    required String name,
    this.description = const Value.absent(),
    required DateTime updatedAt,
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        name = Value(name),
        updatedAt = Value(updatedAt);
  static Insertable<ChatChannel> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<String>? description,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (description != null) 'description': description,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ChatChannelsCompanion copyWith(
      {Value<String>? id,
      Value<String>? name,
      Value<String?>? description,
      Value<DateTime>? updatedAt,
      Value<int>? rowid}) {
    return ChatChannelsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ChatChannelsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('description: $description, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ChatMessagesTable extends ChatMessages
    with TableInfo<$ChatMessagesTable, ChatMessage> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ChatMessagesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _channelIdMeta =
      const VerificationMeta('channelId');
  @override
  late final GeneratedColumn<String> channelId = GeneratedColumn<String>(
      'channel_id', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES chat_channels (id)'));
  static const VerificationMeta _senderIdMeta =
      const VerificationMeta('senderId');
  @override
  late final GeneratedColumn<String> senderId = GeneratedColumn<String>(
      'sender_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _senderNameMeta =
      const VerificationMeta('senderName');
  @override
  late final GeneratedColumn<String> senderName = GeneratedColumn<String>(
      'sender_name', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _contentMeta =
      const VerificationMeta('content');
  @override
  late final GeneratedColumn<String> content = GeneratedColumn<String>(
      'content', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _attachmentsJsonMeta =
      const VerificationMeta('attachmentsJson');
  @override
  late final GeneratedColumn<String> attachmentsJson = GeneratedColumn<String>(
      'attachments_json', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('[]'));
  static const VerificationMeta _reactionsJsonMeta =
      const VerificationMeta('reactionsJson');
  @override
  late final GeneratedColumn<String> reactionsJson = GeneratedColumn<String>(
      'reactions_json', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('{}'));
  static const VerificationMeta _isSyncedMeta =
      const VerificationMeta('isSynced');
  @override
  late final GeneratedColumn<bool> isSynced = GeneratedColumn<bool>(
      'is_synced', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_synced" IN (0, 1))'),
      defaultValue: const Constant(true));
  @override
  List<GeneratedColumn> get $columns => [
        id,
        channelId,
        senderId,
        senderName,
        content,
        createdAt,
        attachmentsJson,
        reactionsJson,
        isSynced
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'chat_messages';
  @override
  VerificationContext validateIntegrity(Insertable<ChatMessage> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('channel_id')) {
      context.handle(_channelIdMeta,
          channelId.isAcceptableOrUnknown(data['channel_id']!, _channelIdMeta));
    } else if (isInserting) {
      context.missing(_channelIdMeta);
    }
    if (data.containsKey('sender_id')) {
      context.handle(_senderIdMeta,
          senderId.isAcceptableOrUnknown(data['sender_id']!, _senderIdMeta));
    } else if (isInserting) {
      context.missing(_senderIdMeta);
    }
    if (data.containsKey('sender_name')) {
      context.handle(
          _senderNameMeta,
          senderName.isAcceptableOrUnknown(
              data['sender_name']!, _senderNameMeta));
    }
    if (data.containsKey('content')) {
      context.handle(_contentMeta,
          content.isAcceptableOrUnknown(data['content']!, _contentMeta));
    } else if (isInserting) {
      context.missing(_contentMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('attachments_json')) {
      context.handle(
          _attachmentsJsonMeta,
          attachmentsJson.isAcceptableOrUnknown(
              data['attachments_json']!, _attachmentsJsonMeta));
    }
    if (data.containsKey('reactions_json')) {
      context.handle(
          _reactionsJsonMeta,
          reactionsJson.isAcceptableOrUnknown(
              data['reactions_json']!, _reactionsJsonMeta));
    }
    if (data.containsKey('is_synced')) {
      context.handle(_isSyncedMeta,
          isSynced.isAcceptableOrUnknown(data['is_synced']!, _isSyncedMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ChatMessage map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ChatMessage(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      channelId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}channel_id'])!,
      senderId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}sender_id'])!,
      senderName: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}sender_name']),
      content: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}content'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      attachmentsJson: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}attachments_json'])!,
      reactionsJson: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}reactions_json'])!,
      isSynced: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_synced'])!,
    );
  }

  @override
  $ChatMessagesTable createAlias(String alias) {
    return $ChatMessagesTable(attachedDatabase, alias);
  }
}

class ChatMessage extends DataClass implements Insertable<ChatMessage> {
  final String id;
  final String channelId;
  final String senderId;
  final String? senderName;
  final String content;
  final DateTime createdAt;
  final String attachmentsJson;
  final String reactionsJson;
  final bool isSynced;
  const ChatMessage(
      {required this.id,
      required this.channelId,
      required this.senderId,
      this.senderName,
      required this.content,
      required this.createdAt,
      required this.attachmentsJson,
      required this.reactionsJson,
      required this.isSynced});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['channel_id'] = Variable<String>(channelId);
    map['sender_id'] = Variable<String>(senderId);
    if (!nullToAbsent || senderName != null) {
      map['sender_name'] = Variable<String>(senderName);
    }
    map['content'] = Variable<String>(content);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['attachments_json'] = Variable<String>(attachmentsJson);
    map['reactions_json'] = Variable<String>(reactionsJson);
    map['is_synced'] = Variable<bool>(isSynced);
    return map;
  }

  ChatMessagesCompanion toCompanion(bool nullToAbsent) {
    return ChatMessagesCompanion(
      id: Value(id),
      channelId: Value(channelId),
      senderId: Value(senderId),
      senderName: senderName == null && nullToAbsent
          ? const Value.absent()
          : Value(senderName),
      content: Value(content),
      createdAt: Value(createdAt),
      attachmentsJson: Value(attachmentsJson),
      reactionsJson: Value(reactionsJson),
      isSynced: Value(isSynced),
    );
  }

  factory ChatMessage.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ChatMessage(
      id: serializer.fromJson<String>(json['id']),
      channelId: serializer.fromJson<String>(json['channelId']),
      senderId: serializer.fromJson<String>(json['senderId']),
      senderName: serializer.fromJson<String?>(json['senderName']),
      content: serializer.fromJson<String>(json['content']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      attachmentsJson: serializer.fromJson<String>(json['attachmentsJson']),
      reactionsJson: serializer.fromJson<String>(json['reactionsJson']),
      isSynced: serializer.fromJson<bool>(json['isSynced']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'channelId': serializer.toJson<String>(channelId),
      'senderId': serializer.toJson<String>(senderId),
      'senderName': serializer.toJson<String?>(senderName),
      'content': serializer.toJson<String>(content),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'attachmentsJson': serializer.toJson<String>(attachmentsJson),
      'reactionsJson': serializer.toJson<String>(reactionsJson),
      'isSynced': serializer.toJson<bool>(isSynced),
    };
  }

  ChatMessage copyWith(
          {String? id,
          String? channelId,
          String? senderId,
          Value<String?> senderName = const Value.absent(),
          String? content,
          DateTime? createdAt,
          String? attachmentsJson,
          String? reactionsJson,
          bool? isSynced}) =>
      ChatMessage(
        id: id ?? this.id,
        channelId: channelId ?? this.channelId,
        senderId: senderId ?? this.senderId,
        senderName: senderName.present ? senderName.value : this.senderName,
        content: content ?? this.content,
        createdAt: createdAt ?? this.createdAt,
        attachmentsJson: attachmentsJson ?? this.attachmentsJson,
        reactionsJson: reactionsJson ?? this.reactionsJson,
        isSynced: isSynced ?? this.isSynced,
      );
  ChatMessage copyWithCompanion(ChatMessagesCompanion data) {
    return ChatMessage(
      id: data.id.present ? data.id.value : this.id,
      channelId: data.channelId.present ? data.channelId.value : this.channelId,
      senderId: data.senderId.present ? data.senderId.value : this.senderId,
      senderName:
          data.senderName.present ? data.senderName.value : this.senderName,
      content: data.content.present ? data.content.value : this.content,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      attachmentsJson: data.attachmentsJson.present
          ? data.attachmentsJson.value
          : this.attachmentsJson,
      reactionsJson: data.reactionsJson.present
          ? data.reactionsJson.value
          : this.reactionsJson,
      isSynced: data.isSynced.present ? data.isSynced.value : this.isSynced,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ChatMessage(')
          ..write('id: $id, ')
          ..write('channelId: $channelId, ')
          ..write('senderId: $senderId, ')
          ..write('senderName: $senderName, ')
          ..write('content: $content, ')
          ..write('createdAt: $createdAt, ')
          ..write('attachmentsJson: $attachmentsJson, ')
          ..write('reactionsJson: $reactionsJson, ')
          ..write('isSynced: $isSynced')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, channelId, senderId, senderName, content,
      createdAt, attachmentsJson, reactionsJson, isSynced);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ChatMessage &&
          other.id == this.id &&
          other.channelId == this.channelId &&
          other.senderId == this.senderId &&
          other.senderName == this.senderName &&
          other.content == this.content &&
          other.createdAt == this.createdAt &&
          other.attachmentsJson == this.attachmentsJson &&
          other.reactionsJson == this.reactionsJson &&
          other.isSynced == this.isSynced);
}

class ChatMessagesCompanion extends UpdateCompanion<ChatMessage> {
  final Value<String> id;
  final Value<String> channelId;
  final Value<String> senderId;
  final Value<String?> senderName;
  final Value<String> content;
  final Value<DateTime> createdAt;
  final Value<String> attachmentsJson;
  final Value<String> reactionsJson;
  final Value<bool> isSynced;
  final Value<int> rowid;
  const ChatMessagesCompanion({
    this.id = const Value.absent(),
    this.channelId = const Value.absent(),
    this.senderId = const Value.absent(),
    this.senderName = const Value.absent(),
    this.content = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.attachmentsJson = const Value.absent(),
    this.reactionsJson = const Value.absent(),
    this.isSynced = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ChatMessagesCompanion.insert({
    required String id,
    required String channelId,
    required String senderId,
    this.senderName = const Value.absent(),
    required String content,
    required DateTime createdAt,
    this.attachmentsJson = const Value.absent(),
    this.reactionsJson = const Value.absent(),
    this.isSynced = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        channelId = Value(channelId),
        senderId = Value(senderId),
        content = Value(content),
        createdAt = Value(createdAt);
  static Insertable<ChatMessage> custom({
    Expression<String>? id,
    Expression<String>? channelId,
    Expression<String>? senderId,
    Expression<String>? senderName,
    Expression<String>? content,
    Expression<DateTime>? createdAt,
    Expression<String>? attachmentsJson,
    Expression<String>? reactionsJson,
    Expression<bool>? isSynced,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (channelId != null) 'channel_id': channelId,
      if (senderId != null) 'sender_id': senderId,
      if (senderName != null) 'sender_name': senderName,
      if (content != null) 'content': content,
      if (createdAt != null) 'created_at': createdAt,
      if (attachmentsJson != null) 'attachments_json': attachmentsJson,
      if (reactionsJson != null) 'reactions_json': reactionsJson,
      if (isSynced != null) 'is_synced': isSynced,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ChatMessagesCompanion copyWith(
      {Value<String>? id,
      Value<String>? channelId,
      Value<String>? senderId,
      Value<String?>? senderName,
      Value<String>? content,
      Value<DateTime>? createdAt,
      Value<String>? attachmentsJson,
      Value<String>? reactionsJson,
      Value<bool>? isSynced,
      Value<int>? rowid}) {
    return ChatMessagesCompanion(
      id: id ?? this.id,
      channelId: channelId ?? this.channelId,
      senderId: senderId ?? this.senderId,
      senderName: senderName ?? this.senderName,
      content: content ?? this.content,
      createdAt: createdAt ?? this.createdAt,
      attachmentsJson: attachmentsJson ?? this.attachmentsJson,
      reactionsJson: reactionsJson ?? this.reactionsJson,
      isSynced: isSynced ?? this.isSynced,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (channelId.present) {
      map['channel_id'] = Variable<String>(channelId.value);
    }
    if (senderId.present) {
      map['sender_id'] = Variable<String>(senderId.value);
    }
    if (senderName.present) {
      map['sender_name'] = Variable<String>(senderName.value);
    }
    if (content.present) {
      map['content'] = Variable<String>(content.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (attachmentsJson.present) {
      map['attachments_json'] = Variable<String>(attachmentsJson.value);
    }
    if (reactionsJson.present) {
      map['reactions_json'] = Variable<String>(reactionsJson.value);
    }
    if (isSynced.present) {
      map['is_synced'] = Variable<bool>(isSynced.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ChatMessagesCompanion(')
          ..write('id: $id, ')
          ..write('channelId: $channelId, ')
          ..write('senderId: $senderId, ')
          ..write('senderName: $senderName, ')
          ..write('content: $content, ')
          ..write('createdAt: $createdAt, ')
          ..write('attachmentsJson: $attachmentsJson, ')
          ..write('reactionsJson: $reactionsJson, ')
          ..write('isSynced: $isSynced, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ContinuingEducationCoursesTable extends ContinuingEducationCourses
    with
        TableInfo<$ContinuingEducationCoursesTable, ContinuingEducationCourse> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ContinuingEducationCoursesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
      'title', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _providerMeta =
      const VerificationMeta('provider');
  @override
  late final GeneratedColumn<String> provider = GeneratedColumn<String>(
      'provider', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _descriptionMeta =
      const VerificationMeta('description');
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
      'description', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _categoryMeta =
      const VerificationMeta('category');
  @override
  late final GeneratedColumn<String> category = GeneratedColumn<String>(
      'category', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _durationHoursMeta =
      const VerificationMeta('durationHours');
  @override
  late final GeneratedColumn<int> durationHours = GeneratedColumn<int>(
      'duration_hours', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _externalUrlMeta =
      const VerificationMeta('externalUrl');
  @override
  late final GeneratedColumn<String> externalUrl = GeneratedColumn<String>(
      'external_url', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns =>
      [id, title, provider, description, category, durationHours, externalUrl];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'continuing_education_courses';
  @override
  VerificationContext validateIntegrity(
      Insertable<ContinuingEducationCourse> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('title')) {
      context.handle(
          _titleMeta, title.isAcceptableOrUnknown(data['title']!, _titleMeta));
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('provider')) {
      context.handle(_providerMeta,
          provider.isAcceptableOrUnknown(data['provider']!, _providerMeta));
    } else if (isInserting) {
      context.missing(_providerMeta);
    }
    if (data.containsKey('description')) {
      context.handle(
          _descriptionMeta,
          description.isAcceptableOrUnknown(
              data['description']!, _descriptionMeta));
    }
    if (data.containsKey('category')) {
      context.handle(_categoryMeta,
          category.isAcceptableOrUnknown(data['category']!, _categoryMeta));
    } else if (isInserting) {
      context.missing(_categoryMeta);
    }
    if (data.containsKey('duration_hours')) {
      context.handle(
          _durationHoursMeta,
          durationHours.isAcceptableOrUnknown(
              data['duration_hours']!, _durationHoursMeta));
    }
    if (data.containsKey('external_url')) {
      context.handle(
          _externalUrlMeta,
          externalUrl.isAcceptableOrUnknown(
              data['external_url']!, _externalUrlMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ContinuingEducationCourse map(Map<String, dynamic> data,
      {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ContinuingEducationCourse(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      title: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}title'])!,
      provider: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}provider'])!,
      description: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}description']),
      category: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}category'])!,
      durationHours: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}duration_hours']),
      externalUrl: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}external_url']),
    );
  }

  @override
  $ContinuingEducationCoursesTable createAlias(String alias) {
    return $ContinuingEducationCoursesTable(attachedDatabase, alias);
  }
}

class ContinuingEducationCourse extends DataClass
    implements Insertable<ContinuingEducationCourse> {
  final int id;
  final String title;
  final String provider;
  final String? description;
  final String category;
  final int? durationHours;
  final String? externalUrl;
  const ContinuingEducationCourse(
      {required this.id,
      required this.title,
      required this.provider,
      this.description,
      required this.category,
      this.durationHours,
      this.externalUrl});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['title'] = Variable<String>(title);
    map['provider'] = Variable<String>(provider);
    if (!nullToAbsent || description != null) {
      map['description'] = Variable<String>(description);
    }
    map['category'] = Variable<String>(category);
    if (!nullToAbsent || durationHours != null) {
      map['duration_hours'] = Variable<int>(durationHours);
    }
    if (!nullToAbsent || externalUrl != null) {
      map['external_url'] = Variable<String>(externalUrl);
    }
    return map;
  }

  ContinuingEducationCoursesCompanion toCompanion(bool nullToAbsent) {
    return ContinuingEducationCoursesCompanion(
      id: Value(id),
      title: Value(title),
      provider: Value(provider),
      description: description == null && nullToAbsent
          ? const Value.absent()
          : Value(description),
      category: Value(category),
      durationHours: durationHours == null && nullToAbsent
          ? const Value.absent()
          : Value(durationHours),
      externalUrl: externalUrl == null && nullToAbsent
          ? const Value.absent()
          : Value(externalUrl),
    );
  }

  factory ContinuingEducationCourse.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ContinuingEducationCourse(
      id: serializer.fromJson<int>(json['id']),
      title: serializer.fromJson<String>(json['title']),
      provider: serializer.fromJson<String>(json['provider']),
      description: serializer.fromJson<String?>(json['description']),
      category: serializer.fromJson<String>(json['category']),
      durationHours: serializer.fromJson<int?>(json['durationHours']),
      externalUrl: serializer.fromJson<String?>(json['externalUrl']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'title': serializer.toJson<String>(title),
      'provider': serializer.toJson<String>(provider),
      'description': serializer.toJson<String?>(description),
      'category': serializer.toJson<String>(category),
      'durationHours': serializer.toJson<int?>(durationHours),
      'externalUrl': serializer.toJson<String?>(externalUrl),
    };
  }

  ContinuingEducationCourse copyWith(
          {int? id,
          String? title,
          String? provider,
          Value<String?> description = const Value.absent(),
          String? category,
          Value<int?> durationHours = const Value.absent(),
          Value<String?> externalUrl = const Value.absent()}) =>
      ContinuingEducationCourse(
        id: id ?? this.id,
        title: title ?? this.title,
        provider: provider ?? this.provider,
        description: description.present ? description.value : this.description,
        category: category ?? this.category,
        durationHours:
            durationHours.present ? durationHours.value : this.durationHours,
        externalUrl: externalUrl.present ? externalUrl.value : this.externalUrl,
      );
  ContinuingEducationCourse copyWithCompanion(
      ContinuingEducationCoursesCompanion data) {
    return ContinuingEducationCourse(
      id: data.id.present ? data.id.value : this.id,
      title: data.title.present ? data.title.value : this.title,
      provider: data.provider.present ? data.provider.value : this.provider,
      description:
          data.description.present ? data.description.value : this.description,
      category: data.category.present ? data.category.value : this.category,
      durationHours: data.durationHours.present
          ? data.durationHours.value
          : this.durationHours,
      externalUrl:
          data.externalUrl.present ? data.externalUrl.value : this.externalUrl,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ContinuingEducationCourse(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('provider: $provider, ')
          ..write('description: $description, ')
          ..write('category: $category, ')
          ..write('durationHours: $durationHours, ')
          ..write('externalUrl: $externalUrl')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id, title, provider, description, category, durationHours, externalUrl);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ContinuingEducationCourse &&
          other.id == this.id &&
          other.title == this.title &&
          other.provider == this.provider &&
          other.description == this.description &&
          other.category == this.category &&
          other.durationHours == this.durationHours &&
          other.externalUrl == this.externalUrl);
}

class ContinuingEducationCoursesCompanion
    extends UpdateCompanion<ContinuingEducationCourse> {
  final Value<int> id;
  final Value<String> title;
  final Value<String> provider;
  final Value<String?> description;
  final Value<String> category;
  final Value<int?> durationHours;
  final Value<String?> externalUrl;
  const ContinuingEducationCoursesCompanion({
    this.id = const Value.absent(),
    this.title = const Value.absent(),
    this.provider = const Value.absent(),
    this.description = const Value.absent(),
    this.category = const Value.absent(),
    this.durationHours = const Value.absent(),
    this.externalUrl = const Value.absent(),
  });
  ContinuingEducationCoursesCompanion.insert({
    this.id = const Value.absent(),
    required String title,
    required String provider,
    this.description = const Value.absent(),
    required String category,
    this.durationHours = const Value.absent(),
    this.externalUrl = const Value.absent(),
  })  : title = Value(title),
        provider = Value(provider),
        category = Value(category);
  static Insertable<ContinuingEducationCourse> custom({
    Expression<int>? id,
    Expression<String>? title,
    Expression<String>? provider,
    Expression<String>? description,
    Expression<String>? category,
    Expression<int>? durationHours,
    Expression<String>? externalUrl,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (title != null) 'title': title,
      if (provider != null) 'provider': provider,
      if (description != null) 'description': description,
      if (category != null) 'category': category,
      if (durationHours != null) 'duration_hours': durationHours,
      if (externalUrl != null) 'external_url': externalUrl,
    });
  }

  ContinuingEducationCoursesCompanion copyWith(
      {Value<int>? id,
      Value<String>? title,
      Value<String>? provider,
      Value<String?>? description,
      Value<String>? category,
      Value<int?>? durationHours,
      Value<String?>? externalUrl}) {
    return ContinuingEducationCoursesCompanion(
      id: id ?? this.id,
      title: title ?? this.title,
      provider: provider ?? this.provider,
      description: description ?? this.description,
      category: category ?? this.category,
      durationHours: durationHours ?? this.durationHours,
      externalUrl: externalUrl ?? this.externalUrl,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (provider.present) {
      map['provider'] = Variable<String>(provider.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (category.present) {
      map['category'] = Variable<String>(category.value);
    }
    if (durationHours.present) {
      map['duration_hours'] = Variable<int>(durationHours.value);
    }
    if (externalUrl.present) {
      map['external_url'] = Variable<String>(externalUrl.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ContinuingEducationCoursesCompanion(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('provider: $provider, ')
          ..write('description: $description, ')
          ..write('category: $category, ')
          ..write('durationHours: $durationHours, ')
          ..write('externalUrl: $externalUrl')
          ..write(')'))
        .toString();
  }
}

class $UserCourseEnrollmentsTable extends UserCourseEnrollments
    with TableInfo<$UserCourseEnrollmentsTable, UserCourseEnrollment> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $UserCourseEnrollmentsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
  late final GeneratedColumn<int> userId = GeneratedColumn<int>(
      'user_id', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _courseIdMeta =
      const VerificationMeta('courseId');
  @override
  late final GeneratedColumn<int> courseId = GeneratedColumn<int>(
      'course_id', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _enrolledAtMeta =
      const VerificationMeta('enrolledAt');
  @override
  late final GeneratedColumn<DateTime> enrolledAt = GeneratedColumn<DateTime>(
      'enrolled_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _completedAtMeta =
      const VerificationMeta('completedAt');
  @override
  late final GeneratedColumn<DateTime> completedAt = GeneratedColumn<DateTime>(
      'completed_at', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
      'status', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns =>
      [id, userId, courseId, enrolledAt, completedAt, status];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'user_course_enrollments';
  @override
  VerificationContext validateIntegrity(
      Insertable<UserCourseEnrollment> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('user_id')) {
      context.handle(_userIdMeta,
          userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta));
    } else if (isInserting) {
      context.missing(_userIdMeta);
    }
    if (data.containsKey('course_id')) {
      context.handle(_courseIdMeta,
          courseId.isAcceptableOrUnknown(data['course_id']!, _courseIdMeta));
    } else if (isInserting) {
      context.missing(_courseIdMeta);
    }
    if (data.containsKey('enrolled_at')) {
      context.handle(
          _enrolledAtMeta,
          enrolledAt.isAcceptableOrUnknown(
              data['enrolled_at']!, _enrolledAtMeta));
    } else if (isInserting) {
      context.missing(_enrolledAtMeta);
    }
    if (data.containsKey('completed_at')) {
      context.handle(
          _completedAtMeta,
          completedAt.isAcceptableOrUnknown(
              data['completed_at']!, _completedAtMeta));
    }
    if (data.containsKey('status')) {
      context.handle(_statusMeta,
          status.isAcceptableOrUnknown(data['status']!, _statusMeta));
    } else if (isInserting) {
      context.missing(_statusMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  UserCourseEnrollment map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return UserCourseEnrollment(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      userId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}user_id'])!,
      courseId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}course_id'])!,
      enrolledAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}enrolled_at'])!,
      completedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}completed_at']),
      status: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}status'])!,
    );
  }

  @override
  $UserCourseEnrollmentsTable createAlias(String alias) {
    return $UserCourseEnrollmentsTable(attachedDatabase, alias);
  }
}

class UserCourseEnrollment extends DataClass
    implements Insertable<UserCourseEnrollment> {
  final int id;
  final int userId;
  final int courseId;
  final DateTime enrolledAt;
  final DateTime? completedAt;
  final String status;
  const UserCourseEnrollment(
      {required this.id,
      required this.userId,
      required this.courseId,
      required this.enrolledAt,
      this.completedAt,
      required this.status});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['user_id'] = Variable<int>(userId);
    map['course_id'] = Variable<int>(courseId);
    map['enrolled_at'] = Variable<DateTime>(enrolledAt);
    if (!nullToAbsent || completedAt != null) {
      map['completed_at'] = Variable<DateTime>(completedAt);
    }
    map['status'] = Variable<String>(status);
    return map;
  }

  UserCourseEnrollmentsCompanion toCompanion(bool nullToAbsent) {
    return UserCourseEnrollmentsCompanion(
      id: Value(id),
      userId: Value(userId),
      courseId: Value(courseId),
      enrolledAt: Value(enrolledAt),
      completedAt: completedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(completedAt),
      status: Value(status),
    );
  }

  factory UserCourseEnrollment.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return UserCourseEnrollment(
      id: serializer.fromJson<int>(json['id']),
      userId: serializer.fromJson<int>(json['userId']),
      courseId: serializer.fromJson<int>(json['courseId']),
      enrolledAt: serializer.fromJson<DateTime>(json['enrolledAt']),
      completedAt: serializer.fromJson<DateTime?>(json['completedAt']),
      status: serializer.fromJson<String>(json['status']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'userId': serializer.toJson<int>(userId),
      'courseId': serializer.toJson<int>(courseId),
      'enrolledAt': serializer.toJson<DateTime>(enrolledAt),
      'completedAt': serializer.toJson<DateTime?>(completedAt),
      'status': serializer.toJson<String>(status),
    };
  }

  UserCourseEnrollment copyWith(
          {int? id,
          int? userId,
          int? courseId,
          DateTime? enrolledAt,
          Value<DateTime?> completedAt = const Value.absent(),
          String? status}) =>
      UserCourseEnrollment(
        id: id ?? this.id,
        userId: userId ?? this.userId,
        courseId: courseId ?? this.courseId,
        enrolledAt: enrolledAt ?? this.enrolledAt,
        completedAt: completedAt.present ? completedAt.value : this.completedAt,
        status: status ?? this.status,
      );
  UserCourseEnrollment copyWithCompanion(UserCourseEnrollmentsCompanion data) {
    return UserCourseEnrollment(
      id: data.id.present ? data.id.value : this.id,
      userId: data.userId.present ? data.userId.value : this.userId,
      courseId: data.courseId.present ? data.courseId.value : this.courseId,
      enrolledAt:
          data.enrolledAt.present ? data.enrolledAt.value : this.enrolledAt,
      completedAt:
          data.completedAt.present ? data.completedAt.value : this.completedAt,
      status: data.status.present ? data.status.value : this.status,
    );
  }

  @override
  String toString() {
    return (StringBuffer('UserCourseEnrollment(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('courseId: $courseId, ')
          ..write('enrolledAt: $enrolledAt, ')
          ..write('completedAt: $completedAt, ')
          ..write('status: $status')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, userId, courseId, enrolledAt, completedAt, status);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is UserCourseEnrollment &&
          other.id == this.id &&
          other.userId == this.userId &&
          other.courseId == this.courseId &&
          other.enrolledAt == this.enrolledAt &&
          other.completedAt == this.completedAt &&
          other.status == this.status);
}

class UserCourseEnrollmentsCompanion
    extends UpdateCompanion<UserCourseEnrollment> {
  final Value<int> id;
  final Value<int> userId;
  final Value<int> courseId;
  final Value<DateTime> enrolledAt;
  final Value<DateTime?> completedAt;
  final Value<String> status;
  const UserCourseEnrollmentsCompanion({
    this.id = const Value.absent(),
    this.userId = const Value.absent(),
    this.courseId = const Value.absent(),
    this.enrolledAt = const Value.absent(),
    this.completedAt = const Value.absent(),
    this.status = const Value.absent(),
  });
  UserCourseEnrollmentsCompanion.insert({
    this.id = const Value.absent(),
    required int userId,
    required int courseId,
    required DateTime enrolledAt,
    this.completedAt = const Value.absent(),
    required String status,
  })  : userId = Value(userId),
        courseId = Value(courseId),
        enrolledAt = Value(enrolledAt),
        status = Value(status);
  static Insertable<UserCourseEnrollment> custom({
    Expression<int>? id,
    Expression<int>? userId,
    Expression<int>? courseId,
    Expression<DateTime>? enrolledAt,
    Expression<DateTime>? completedAt,
    Expression<String>? status,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (userId != null) 'user_id': userId,
      if (courseId != null) 'course_id': courseId,
      if (enrolledAt != null) 'enrolled_at': enrolledAt,
      if (completedAt != null) 'completed_at': completedAt,
      if (status != null) 'status': status,
    });
  }

  UserCourseEnrollmentsCompanion copyWith(
      {Value<int>? id,
      Value<int>? userId,
      Value<int>? courseId,
      Value<DateTime>? enrolledAt,
      Value<DateTime?>? completedAt,
      Value<String>? status}) {
    return UserCourseEnrollmentsCompanion(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      courseId: courseId ?? this.courseId,
      enrolledAt: enrolledAt ?? this.enrolledAt,
      completedAt: completedAt ?? this.completedAt,
      status: status ?? this.status,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (userId.present) {
      map['user_id'] = Variable<int>(userId.value);
    }
    if (courseId.present) {
      map['course_id'] = Variable<int>(courseId.value);
    }
    if (enrolledAt.present) {
      map['enrolled_at'] = Variable<DateTime>(enrolledAt.value);
    }
    if (completedAt.present) {
      map['completed_at'] = Variable<DateTime>(completedAt.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('UserCourseEnrollmentsCompanion(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('courseId: $courseId, ')
          ..write('enrolledAt: $enrolledAt, ')
          ..write('completedAt: $completedAt, ')
          ..write('status: $status')
          ..write(')'))
        .toString();
  }
}

class $ExpensesTable extends Expenses with TableInfo<$ExpensesTable, Expense> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ExpensesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
  late final GeneratedColumn<int> userId = GeneratedColumn<int>(
      'user_id', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _expenseDateMeta =
      const VerificationMeta('expenseDate');
  @override
  late final GeneratedColumn<DateTime> expenseDate = GeneratedColumn<DateTime>(
      'expense_date', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _categoryMeta =
      const VerificationMeta('category');
  @override
  late final GeneratedColumn<String> category = GeneratedColumn<String>(
      'category', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _amountMeta = const VerificationMeta('amount');
  @override
  late final GeneratedColumn<double> amount = GeneratedColumn<double>(
      'amount', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _descriptionMeta =
      const VerificationMeta('description');
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
      'description', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _receiptPathMeta =
      const VerificationMeta('receiptPath');
  @override
  late final GeneratedColumn<String> receiptPath = GeneratedColumn<String>(
      'receipt_path', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _workOrderIdMeta =
      const VerificationMeta('workOrderId');
  @override
  late final GeneratedColumn<int> workOrderId = GeneratedColumn<int>(
      'work_order_id', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        userId,
        expenseDate,
        category,
        amount,
        description,
        receiptPath,
        workOrderId
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'expenses';
  @override
  VerificationContext validateIntegrity(Insertable<Expense> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('user_id')) {
      context.handle(_userIdMeta,
          userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta));
    } else if (isInserting) {
      context.missing(_userIdMeta);
    }
    if (data.containsKey('expense_date')) {
      context.handle(
          _expenseDateMeta,
          expenseDate.isAcceptableOrUnknown(
              data['expense_date']!, _expenseDateMeta));
    } else if (isInserting) {
      context.missing(_expenseDateMeta);
    }
    if (data.containsKey('category')) {
      context.handle(_categoryMeta,
          category.isAcceptableOrUnknown(data['category']!, _categoryMeta));
    } else if (isInserting) {
      context.missing(_categoryMeta);
    }
    if (data.containsKey('amount')) {
      context.handle(_amountMeta,
          amount.isAcceptableOrUnknown(data['amount']!, _amountMeta));
    } else if (isInserting) {
      context.missing(_amountMeta);
    }
    if (data.containsKey('description')) {
      context.handle(
          _descriptionMeta,
          description.isAcceptableOrUnknown(
              data['description']!, _descriptionMeta));
    }
    if (data.containsKey('receipt_path')) {
      context.handle(
          _receiptPathMeta,
          receiptPath.isAcceptableOrUnknown(
              data['receipt_path']!, _receiptPathMeta));
    }
    if (data.containsKey('work_order_id')) {
      context.handle(
          _workOrderIdMeta,
          workOrderId.isAcceptableOrUnknown(
              data['work_order_id']!, _workOrderIdMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Expense map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Expense(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      userId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}user_id'])!,
      expenseDate: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}expense_date'])!,
      category: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}category'])!,
      amount: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}amount'])!,
      description: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}description']),
      receiptPath: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}receipt_path']),
      workOrderId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}work_order_id']),
    );
  }

  @override
  $ExpensesTable createAlias(String alias) {
    return $ExpensesTable(attachedDatabase, alias);
  }
}

class Expense extends DataClass implements Insertable<Expense> {
  final int id;
  final int userId;
  final DateTime expenseDate;
  final String category;
  final double amount;
  final String? description;
  final String? receiptPath;
  final int? workOrderId;
  const Expense(
      {required this.id,
      required this.userId,
      required this.expenseDate,
      required this.category,
      required this.amount,
      this.description,
      this.receiptPath,
      this.workOrderId});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['user_id'] = Variable<int>(userId);
    map['expense_date'] = Variable<DateTime>(expenseDate);
    map['category'] = Variable<String>(category);
    map['amount'] = Variable<double>(amount);
    if (!nullToAbsent || description != null) {
      map['description'] = Variable<String>(description);
    }
    if (!nullToAbsent || receiptPath != null) {
      map['receipt_path'] = Variable<String>(receiptPath);
    }
    if (!nullToAbsent || workOrderId != null) {
      map['work_order_id'] = Variable<int>(workOrderId);
    }
    return map;
  }

  ExpensesCompanion toCompanion(bool nullToAbsent) {
    return ExpensesCompanion(
      id: Value(id),
      userId: Value(userId),
      expenseDate: Value(expenseDate),
      category: Value(category),
      amount: Value(amount),
      description: description == null && nullToAbsent
          ? const Value.absent()
          : Value(description),
      receiptPath: receiptPath == null && nullToAbsent
          ? const Value.absent()
          : Value(receiptPath),
      workOrderId: workOrderId == null && nullToAbsent
          ? const Value.absent()
          : Value(workOrderId),
    );
  }

  factory Expense.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Expense(
      id: serializer.fromJson<int>(json['id']),
      userId: serializer.fromJson<int>(json['userId']),
      expenseDate: serializer.fromJson<DateTime>(json['expenseDate']),
      category: serializer.fromJson<String>(json['category']),
      amount: serializer.fromJson<double>(json['amount']),
      description: serializer.fromJson<String?>(json['description']),
      receiptPath: serializer.fromJson<String?>(json['receiptPath']),
      workOrderId: serializer.fromJson<int?>(json['workOrderId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'userId': serializer.toJson<int>(userId),
      'expenseDate': serializer.toJson<DateTime>(expenseDate),
      'category': serializer.toJson<String>(category),
      'amount': serializer.toJson<double>(amount),
      'description': serializer.toJson<String?>(description),
      'receiptPath': serializer.toJson<String?>(receiptPath),
      'workOrderId': serializer.toJson<int?>(workOrderId),
    };
  }

  Expense copyWith(
          {int? id,
          int? userId,
          DateTime? expenseDate,
          String? category,
          double? amount,
          Value<String?> description = const Value.absent(),
          Value<String?> receiptPath = const Value.absent(),
          Value<int?> workOrderId = const Value.absent()}) =>
      Expense(
        id: id ?? this.id,
        userId: userId ?? this.userId,
        expenseDate: expenseDate ?? this.expenseDate,
        category: category ?? this.category,
        amount: amount ?? this.amount,
        description: description.present ? description.value : this.description,
        receiptPath: receiptPath.present ? receiptPath.value : this.receiptPath,
        workOrderId: workOrderId.present ? workOrderId.value : this.workOrderId,
      );
  Expense copyWithCompanion(ExpensesCompanion data) {
    return Expense(
      id: data.id.present ? data.id.value : this.id,
      userId: data.userId.present ? data.userId.value : this.userId,
      expenseDate:
          data.expenseDate.present ? data.expenseDate.value : this.expenseDate,
      category: data.category.present ? data.category.value : this.category,
      amount: data.amount.present ? data.amount.value : this.amount,
      description:
          data.description.present ? data.description.value : this.description,
      receiptPath:
          data.receiptPath.present ? data.receiptPath.value : this.receiptPath,
      workOrderId:
          data.workOrderId.present ? data.workOrderId.value : this.workOrderId,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Expense(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('expenseDate: $expenseDate, ')
          ..write('category: $category, ')
          ..write('amount: $amount, ')
          ..write('description: $description, ')
          ..write('receiptPath: $receiptPath, ')
          ..write('workOrderId: $workOrderId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, userId, expenseDate, category, amount,
      description, receiptPath, workOrderId);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Expense &&
          other.id == this.id &&
          other.userId == this.userId &&
          other.expenseDate == this.expenseDate &&
          other.category == this.category &&
          other.amount == this.amount &&
          other.description == this.description &&
          other.receiptPath == this.receiptPath &&
          other.workOrderId == this.workOrderId);
}

class ExpensesCompanion extends UpdateCompanion<Expense> {
  final Value<int> id;
  final Value<int> userId;
  final Value<DateTime> expenseDate;
  final Value<String> category;
  final Value<double> amount;
  final Value<String?> description;
  final Value<String?> receiptPath;
  final Value<int?> workOrderId;
  const ExpensesCompanion({
    this.id = const Value.absent(),
    this.userId = const Value.absent(),
    this.expenseDate = const Value.absent(),
    this.category = const Value.absent(),
    this.amount = const Value.absent(),
    this.description = const Value.absent(),
    this.receiptPath = const Value.absent(),
    this.workOrderId = const Value.absent(),
  });
  ExpensesCompanion.insert({
    this.id = const Value.absent(),
    required int userId,
    required DateTime expenseDate,
    required String category,
    required double amount,
    this.description = const Value.absent(),
    this.receiptPath = const Value.absent(),
    this.workOrderId = const Value.absent(),
  })  : userId = Value(userId),
        expenseDate = Value(expenseDate),
        category = Value(category),
        amount = Value(amount);
  static Insertable<Expense> custom({
    Expression<int>? id,
    Expression<int>? userId,
    Expression<DateTime>? expenseDate,
    Expression<String>? category,
    Expression<double>? amount,
    Expression<String>? description,
    Expression<String>? receiptPath,
    Expression<int>? workOrderId,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (userId != null) 'user_id': userId,
      if (expenseDate != null) 'expense_date': expenseDate,
      if (category != null) 'category': category,
      if (amount != null) 'amount': amount,
      if (description != null) 'description': description,
      if (receiptPath != null) 'receipt_path': receiptPath,
      if (workOrderId != null) 'work_order_id': workOrderId,
    });
  }

  ExpensesCompanion copyWith(
      {Value<int>? id,
      Value<int>? userId,
      Value<DateTime>? expenseDate,
      Value<String>? category,
      Value<double>? amount,
      Value<String?>? description,
      Value<String?>? receiptPath,
      Value<int?>? workOrderId}) {
    return ExpensesCompanion(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      expenseDate: expenseDate ?? this.expenseDate,
      category: category ?? this.category,
      amount: amount ?? this.amount,
      description: description ?? this.description,
      receiptPath: receiptPath ?? this.receiptPath,
      workOrderId: workOrderId ?? this.workOrderId,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (userId.present) {
      map['user_id'] = Variable<int>(userId.value);
    }
    if (expenseDate.present) {
      map['expense_date'] = Variable<DateTime>(expenseDate.value);
    }
    if (category.present) {
      map['category'] = Variable<String>(category.value);
    }
    if (amount.present) {
      map['amount'] = Variable<double>(amount.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (receiptPath.present) {
      map['receipt_path'] = Variable<String>(receiptPath.value);
    }
    if (workOrderId.present) {
      map['work_order_id'] = Variable<int>(workOrderId.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ExpensesCompanion(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('expenseDate: $expenseDate, ')
          ..write('category: $category, ')
          ..write('amount: $amount, ')
          ..write('description: $description, ')
          ..write('receiptPath: $receiptPath, ')
          ..write('workOrderId: $workOrderId')
          ..write(')'))
        .toString();
  }
}

class $WorkOrderAuditLogTable extends WorkOrderAuditLog
    with TableInfo<$WorkOrderAuditLogTable, WorkOrderAuditLogData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $WorkOrderAuditLogTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _workOrderIdMeta =
      const VerificationMeta('workOrderId');
  @override
  late final GeneratedColumn<int> workOrderId = GeneratedColumn<int>(
      'work_order_id', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
  late final GeneratedColumn<int> userId = GeneratedColumn<int>(
      'user_id', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _actionMeta = const VerificationMeta('action');
  @override
  late final GeneratedColumn<String> action = GeneratedColumn<String>(
      'action', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _fieldChangedMeta =
      const VerificationMeta('fieldChanged');
  @override
  late final GeneratedColumn<String> fieldChanged = GeneratedColumn<String>(
      'field_changed', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _oldValueMeta =
      const VerificationMeta('oldValue');
  @override
  late final GeneratedColumn<String> oldValue = GeneratedColumn<String>(
      'old_value', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _newValueMeta =
      const VerificationMeta('newValue');
  @override
  late final GeneratedColumn<String> newValue = GeneratedColumn<String>(
      'new_value', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _changeReasonMeta =
      const VerificationMeta('changeReason');
  @override
  late final GeneratedColumn<String> changeReason = GeneratedColumn<String>(
      'change_reason', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _ipAddressMeta =
      const VerificationMeta('ipAddress');
  @override
  late final GeneratedColumn<String> ipAddress = GeneratedColumn<String>(
      'ip_address', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _changedAtMeta =
      const VerificationMeta('changedAt');
  @override
  late final GeneratedColumn<DateTime> changedAt = GeneratedColumn<DateTime>(
      'changed_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        workOrderId,
        userId,
        action,
        fieldChanged,
        oldValue,
        newValue,
        changeReason,
        ipAddress,
        changedAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'work_order_audit_log';
  @override
  VerificationContext validateIntegrity(
      Insertable<WorkOrderAuditLogData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('work_order_id')) {
      context.handle(
          _workOrderIdMeta,
          workOrderId.isAcceptableOrUnknown(
              data['work_order_id']!, _workOrderIdMeta));
    } else if (isInserting) {
      context.missing(_workOrderIdMeta);
    }
    if (data.containsKey('user_id')) {
      context.handle(_userIdMeta,
          userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta));
    } else if (isInserting) {
      context.missing(_userIdMeta);
    }
    if (data.containsKey('action')) {
      context.handle(_actionMeta,
          action.isAcceptableOrUnknown(data['action']!, _actionMeta));
    } else if (isInserting) {
      context.missing(_actionMeta);
    }
    if (data.containsKey('field_changed')) {
      context.handle(
          _fieldChangedMeta,
          fieldChanged.isAcceptableOrUnknown(
              data['field_changed']!, _fieldChangedMeta));
    }
    if (data.containsKey('old_value')) {
      context.handle(_oldValueMeta,
          oldValue.isAcceptableOrUnknown(data['old_value']!, _oldValueMeta));
    }
    if (data.containsKey('new_value')) {
      context.handle(_newValueMeta,
          newValue.isAcceptableOrUnknown(data['new_value']!, _newValueMeta));
    }
    if (data.containsKey('change_reason')) {
      context.handle(
          _changeReasonMeta,
          changeReason.isAcceptableOrUnknown(
              data['change_reason']!, _changeReasonMeta));
    }
    if (data.containsKey('ip_address')) {
      context.handle(_ipAddressMeta,
          ipAddress.isAcceptableOrUnknown(data['ip_address']!, _ipAddressMeta));
    }
    if (data.containsKey('changed_at')) {
      context.handle(_changedAtMeta,
          changedAt.isAcceptableOrUnknown(data['changed_at']!, _changedAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  WorkOrderAuditLogData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return WorkOrderAuditLogData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      workOrderId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}work_order_id'])!,
      userId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}user_id'])!,
      action: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}action'])!,
      fieldChanged: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}field_changed']),
      oldValue: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}old_value']),
      newValue: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}new_value']),
      changeReason: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}change_reason']),
      ipAddress: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}ip_address']),
      changedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}changed_at'])!,
    );
  }

  @override
  $WorkOrderAuditLogTable createAlias(String alias) {
    return $WorkOrderAuditLogTable(attachedDatabase, alias);
  }
}

class WorkOrderAuditLogData extends DataClass
    implements Insertable<WorkOrderAuditLogData> {
  final int id;
  final int workOrderId;
  final int userId;
  final String action;
  final String? fieldChanged;
  final String? oldValue;
  final String? newValue;
  final String? changeReason;
  final String? ipAddress;
  final DateTime changedAt;
  const WorkOrderAuditLogData(
      {required this.id,
      required this.workOrderId,
      required this.userId,
      required this.action,
      this.fieldChanged,
      this.oldValue,
      this.newValue,
      this.changeReason,
      this.ipAddress,
      required this.changedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['work_order_id'] = Variable<int>(workOrderId);
    map['user_id'] = Variable<int>(userId);
    map['action'] = Variable<String>(action);
    if (!nullToAbsent || fieldChanged != null) {
      map['field_changed'] = Variable<String>(fieldChanged);
    }
    if (!nullToAbsent || oldValue != null) {
      map['old_value'] = Variable<String>(oldValue);
    }
    if (!nullToAbsent || newValue != null) {
      map['new_value'] = Variable<String>(newValue);
    }
    if (!nullToAbsent || changeReason != null) {
      map['change_reason'] = Variable<String>(changeReason);
    }
    if (!nullToAbsent || ipAddress != null) {
      map['ip_address'] = Variable<String>(ipAddress);
    }
    map['changed_at'] = Variable<DateTime>(changedAt);
    return map;
  }

  WorkOrderAuditLogCompanion toCompanion(bool nullToAbsent) {
    return WorkOrderAuditLogCompanion(
      id: Value(id),
      workOrderId: Value(workOrderId),
      userId: Value(userId),
      action: Value(action),
      fieldChanged: fieldChanged == null && nullToAbsent
          ? const Value.absent()
          : Value(fieldChanged),
      oldValue: oldValue == null && nullToAbsent
          ? const Value.absent()
          : Value(oldValue),
      newValue: newValue == null && nullToAbsent
          ? const Value.absent()
          : Value(newValue),
      changeReason: changeReason == null && nullToAbsent
          ? const Value.absent()
          : Value(changeReason),
      ipAddress: ipAddress == null && nullToAbsent
          ? const Value.absent()
          : Value(ipAddress),
      changedAt: Value(changedAt),
    );
  }

  factory WorkOrderAuditLogData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return WorkOrderAuditLogData(
      id: serializer.fromJson<int>(json['id']),
      workOrderId: serializer.fromJson<int>(json['workOrderId']),
      userId: serializer.fromJson<int>(json['userId']),
      action: serializer.fromJson<String>(json['action']),
      fieldChanged: serializer.fromJson<String?>(json['fieldChanged']),
      oldValue: serializer.fromJson<String?>(json['oldValue']),
      newValue: serializer.fromJson<String?>(json['newValue']),
      changeReason: serializer.fromJson<String?>(json['changeReason']),
      ipAddress: serializer.fromJson<String?>(json['ipAddress']),
      changedAt: serializer.fromJson<DateTime>(json['changedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'workOrderId': serializer.toJson<int>(workOrderId),
      'userId': serializer.toJson<int>(userId),
      'action': serializer.toJson<String>(action),
      'fieldChanged': serializer.toJson<String?>(fieldChanged),
      'oldValue': serializer.toJson<String?>(oldValue),
      'newValue': serializer.toJson<String?>(newValue),
      'changeReason': serializer.toJson<String?>(changeReason),
      'ipAddress': serializer.toJson<String?>(ipAddress),
      'changedAt': serializer.toJson<DateTime>(changedAt),
    };
  }

  WorkOrderAuditLogData copyWith(
          {int? id,
          int? workOrderId,
          int? userId,
          String? action,
          Value<String?> fieldChanged = const Value.absent(),
          Value<String?> oldValue = const Value.absent(),
          Value<String?> newValue = const Value.absent(),
          Value<String?> changeReason = const Value.absent(),
          Value<String?> ipAddress = const Value.absent(),
          DateTime? changedAt}) =>
      WorkOrderAuditLogData(
        id: id ?? this.id,
        workOrderId: workOrderId ?? this.workOrderId,
        userId: userId ?? this.userId,
        action: action ?? this.action,
        fieldChanged:
            fieldChanged.present ? fieldChanged.value : this.fieldChanged,
        oldValue: oldValue.present ? oldValue.value : this.oldValue,
        newValue: newValue.present ? newValue.value : this.newValue,
        changeReason:
            changeReason.present ? changeReason.value : this.changeReason,
        ipAddress: ipAddress.present ? ipAddress.value : this.ipAddress,
        changedAt: changedAt ?? this.changedAt,
      );
  WorkOrderAuditLogData copyWithCompanion(WorkOrderAuditLogCompanion data) {
    return WorkOrderAuditLogData(
      id: data.id.present ? data.id.value : this.id,
      workOrderId:
          data.workOrderId.present ? data.workOrderId.value : this.workOrderId,
      userId: data.userId.present ? data.userId.value : this.userId,
      action: data.action.present ? data.action.value : this.action,
      fieldChanged: data.fieldChanged.present
          ? data.fieldChanged.value
          : this.fieldChanged,
      oldValue: data.oldValue.present ? data.oldValue.value : this.oldValue,
      newValue: data.newValue.present ? data.newValue.value : this.newValue,
      changeReason: data.changeReason.present
          ? data.changeReason.value
          : this.changeReason,
      ipAddress: data.ipAddress.present ? data.ipAddress.value : this.ipAddress,
      changedAt: data.changedAt.present ? data.changedAt.value : this.changedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('WorkOrderAuditLogData(')
          ..write('id: $id, ')
          ..write('workOrderId: $workOrderId, ')
          ..write('userId: $userId, ')
          ..write('action: $action, ')
          ..write('fieldChanged: $fieldChanged, ')
          ..write('oldValue: $oldValue, ')
          ..write('newValue: $newValue, ')
          ..write('changeReason: $changeReason, ')
          ..write('ipAddress: $ipAddress, ')
          ..write('changedAt: $changedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, workOrderId, userId, action, fieldChanged,
      oldValue, newValue, changeReason, ipAddress, changedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is WorkOrderAuditLogData &&
          other.id == this.id &&
          other.workOrderId == this.workOrderId &&
          other.userId == this.userId &&
          other.action == this.action &&
          other.fieldChanged == this.fieldChanged &&
          other.oldValue == this.oldValue &&
          other.newValue == this.newValue &&
          other.changeReason == this.changeReason &&
          other.ipAddress == this.ipAddress &&
          other.changedAt == this.changedAt);
}

class WorkOrderAuditLogCompanion
    extends UpdateCompanion<WorkOrderAuditLogData> {
  final Value<int> id;
  final Value<int> workOrderId;
  final Value<int> userId;
  final Value<String> action;
  final Value<String?> fieldChanged;
  final Value<String?> oldValue;
  final Value<String?> newValue;
  final Value<String?> changeReason;
  final Value<String?> ipAddress;
  final Value<DateTime> changedAt;
  const WorkOrderAuditLogCompanion({
    this.id = const Value.absent(),
    this.workOrderId = const Value.absent(),
    this.userId = const Value.absent(),
    this.action = const Value.absent(),
    this.fieldChanged = const Value.absent(),
    this.oldValue = const Value.absent(),
    this.newValue = const Value.absent(),
    this.changeReason = const Value.absent(),
    this.ipAddress = const Value.absent(),
    this.changedAt = const Value.absent(),
  });
  WorkOrderAuditLogCompanion.insert({
    this.id = const Value.absent(),
    required int workOrderId,
    required int userId,
    required String action,
    this.fieldChanged = const Value.absent(),
    this.oldValue = const Value.absent(),
    this.newValue = const Value.absent(),
    this.changeReason = const Value.absent(),
    this.ipAddress = const Value.absent(),
    this.changedAt = const Value.absent(),
  })  : workOrderId = Value(workOrderId),
        userId = Value(userId),
        action = Value(action);
  static Insertable<WorkOrderAuditLogData> custom({
    Expression<int>? id,
    Expression<int>? workOrderId,
    Expression<int>? userId,
    Expression<String>? action,
    Expression<String>? fieldChanged,
    Expression<String>? oldValue,
    Expression<String>? newValue,
    Expression<String>? changeReason,
    Expression<String>? ipAddress,
    Expression<DateTime>? changedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (workOrderId != null) 'work_order_id': workOrderId,
      if (userId != null) 'user_id': userId,
      if (action != null) 'action': action,
      if (fieldChanged != null) 'field_changed': fieldChanged,
      if (oldValue != null) 'old_value': oldValue,
      if (newValue != null) 'new_value': newValue,
      if (changeReason != null) 'change_reason': changeReason,
      if (ipAddress != null) 'ip_address': ipAddress,
      if (changedAt != null) 'changed_at': changedAt,
    });
  }

  WorkOrderAuditLogCompanion copyWith(
      {Value<int>? id,
      Value<int>? workOrderId,
      Value<int>? userId,
      Value<String>? action,
      Value<String?>? fieldChanged,
      Value<String?>? oldValue,
      Value<String?>? newValue,
      Value<String?>? changeReason,
      Value<String?>? ipAddress,
      Value<DateTime>? changedAt}) {
    return WorkOrderAuditLogCompanion(
      id: id ?? this.id,
      workOrderId: workOrderId ?? this.workOrderId,
      userId: userId ?? this.userId,
      action: action ?? this.action,
      fieldChanged: fieldChanged ?? this.fieldChanged,
      oldValue: oldValue ?? this.oldValue,
      newValue: newValue ?? this.newValue,
      changeReason: changeReason ?? this.changeReason,
      ipAddress: ipAddress ?? this.ipAddress,
      changedAt: changedAt ?? this.changedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (workOrderId.present) {
      map['work_order_id'] = Variable<int>(workOrderId.value);
    }
    if (userId.present) {
      map['user_id'] = Variable<int>(userId.value);
    }
    if (action.present) {
      map['action'] = Variable<String>(action.value);
    }
    if (fieldChanged.present) {
      map['field_changed'] = Variable<String>(fieldChanged.value);
    }
    if (oldValue.present) {
      map['old_value'] = Variable<String>(oldValue.value);
    }
    if (newValue.present) {
      map['new_value'] = Variable<String>(newValue.value);
    }
    if (changeReason.present) {
      map['change_reason'] = Variable<String>(changeReason.value);
    }
    if (ipAddress.present) {
      map['ip_address'] = Variable<String>(ipAddress.value);
    }
    if (changedAt.present) {
      map['changed_at'] = Variable<DateTime>(changedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('WorkOrderAuditLogCompanion(')
          ..write('id: $id, ')
          ..write('workOrderId: $workOrderId, ')
          ..write('userId: $userId, ')
          ..write('action: $action, ')
          ..write('fieldChanged: $fieldChanged, ')
          ..write('oldValue: $oldValue, ')
          ..write('newValue: $newValue, ')
          ..write('changeReason: $changeReason, ')
          ..write('ipAddress: $ipAddress, ')
          ..write('changedAt: $changedAt')
          ..write(')'))
        .toString();
  }
}

class $WorkOrderStatusTransitionsTable extends WorkOrderStatusTransitions
    with
        TableInfo<$WorkOrderStatusTransitionsTable, WorkOrderStatusTransition> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $WorkOrderStatusTransitionsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _workOrderIdMeta =
      const VerificationMeta('workOrderId');
  @override
  late final GeneratedColumn<int> workOrderId = GeneratedColumn<int>(
      'work_order_id', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _fromStatusMeta =
      const VerificationMeta('fromStatus');
  @override
  late final GeneratedColumn<String> fromStatus = GeneratedColumn<String>(
      'from_status', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _toStatusMeta =
      const VerificationMeta('toStatus');
  @override
  late final GeneratedColumn<String> toStatus = GeneratedColumn<String>(
      'to_status', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _changedByMeta =
      const VerificationMeta('changedBy');
  @override
  late final GeneratedColumn<int> changedBy = GeneratedColumn<int>(
      'changed_by', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
      'notes', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _transitionedAtMeta =
      const VerificationMeta('transitionedAt');
  @override
  late final GeneratedColumn<DateTime> transitionedAt =
      GeneratedColumn<DateTime>('transitioned_at', aliasedName, false,
          type: DriftSqlType.dateTime,
          requiredDuringInsert: false,
          defaultValue: currentDateAndTime);
  @override
  List<GeneratedColumn> get $columns =>
      [id, workOrderId, fromStatus, toStatus, changedBy, notes, transitionedAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'work_order_status_transitions';
  @override
  VerificationContext validateIntegrity(
      Insertable<WorkOrderStatusTransition> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('work_order_id')) {
      context.handle(
          _workOrderIdMeta,
          workOrderId.isAcceptableOrUnknown(
              data['work_order_id']!, _workOrderIdMeta));
    } else if (isInserting) {
      context.missing(_workOrderIdMeta);
    }
    if (data.containsKey('from_status')) {
      context.handle(
          _fromStatusMeta,
          fromStatus.isAcceptableOrUnknown(
              data['from_status']!, _fromStatusMeta));
    } else if (isInserting) {
      context.missing(_fromStatusMeta);
    }
    if (data.containsKey('to_status')) {
      context.handle(_toStatusMeta,
          toStatus.isAcceptableOrUnknown(data['to_status']!, _toStatusMeta));
    } else if (isInserting) {
      context.missing(_toStatusMeta);
    }
    if (data.containsKey('changed_by')) {
      context.handle(_changedByMeta,
          changedBy.isAcceptableOrUnknown(data['changed_by']!, _changedByMeta));
    } else if (isInserting) {
      context.missing(_changedByMeta);
    }
    if (data.containsKey('notes')) {
      context.handle(
          _notesMeta, notes.isAcceptableOrUnknown(data['notes']!, _notesMeta));
    }
    if (data.containsKey('transitioned_at')) {
      context.handle(
          _transitionedAtMeta,
          transitionedAt.isAcceptableOrUnknown(
              data['transitioned_at']!, _transitionedAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  WorkOrderStatusTransition map(Map<String, dynamic> data,
      {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return WorkOrderStatusTransition(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      workOrderId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}work_order_id'])!,
      fromStatus: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}from_status'])!,
      toStatus: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}to_status'])!,
      changedBy: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}changed_by'])!,
      notes: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}notes']),
      transitionedAt: attachedDatabase.typeMapping.read(
          DriftSqlType.dateTime, data['${effectivePrefix}transitioned_at'])!,
    );
  }

  @override
  $WorkOrderStatusTransitionsTable createAlias(String alias) {
    return $WorkOrderStatusTransitionsTable(attachedDatabase, alias);
  }
}

class WorkOrderStatusTransition extends DataClass
    implements Insertable<WorkOrderStatusTransition> {
  final int id;
  final int workOrderId;
  final String fromStatus;
  final String toStatus;
  final int changedBy;
  final String? notes;
  final DateTime transitionedAt;
  const WorkOrderStatusTransition(
      {required this.id,
      required this.workOrderId,
      required this.fromStatus,
      required this.toStatus,
      required this.changedBy,
      this.notes,
      required this.transitionedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['work_order_id'] = Variable<int>(workOrderId);
    map['from_status'] = Variable<String>(fromStatus);
    map['to_status'] = Variable<String>(toStatus);
    map['changed_by'] = Variable<int>(changedBy);
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    map['transitioned_at'] = Variable<DateTime>(transitionedAt);
    return map;
  }

  WorkOrderStatusTransitionsCompanion toCompanion(bool nullToAbsent) {
    return WorkOrderStatusTransitionsCompanion(
      id: Value(id),
      workOrderId: Value(workOrderId),
      fromStatus: Value(fromStatus),
      toStatus: Value(toStatus),
      changedBy: Value(changedBy),
      notes:
          notes == null && nullToAbsent ? const Value.absent() : Value(notes),
      transitionedAt: Value(transitionedAt),
    );
  }

  factory WorkOrderStatusTransition.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return WorkOrderStatusTransition(
      id: serializer.fromJson<int>(json['id']),
      workOrderId: serializer.fromJson<int>(json['workOrderId']),
      fromStatus: serializer.fromJson<String>(json['fromStatus']),
      toStatus: serializer.fromJson<String>(json['toStatus']),
      changedBy: serializer.fromJson<int>(json['changedBy']),
      notes: serializer.fromJson<String?>(json['notes']),
      transitionedAt: serializer.fromJson<DateTime>(json['transitionedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'workOrderId': serializer.toJson<int>(workOrderId),
      'fromStatus': serializer.toJson<String>(fromStatus),
      'toStatus': serializer.toJson<String>(toStatus),
      'changedBy': serializer.toJson<int>(changedBy),
      'notes': serializer.toJson<String?>(notes),
      'transitionedAt': serializer.toJson<DateTime>(transitionedAt),
    };
  }

  WorkOrderStatusTransition copyWith(
          {int? id,
          int? workOrderId,
          String? fromStatus,
          String? toStatus,
          int? changedBy,
          Value<String?> notes = const Value.absent(),
          DateTime? transitionedAt}) =>
      WorkOrderStatusTransition(
        id: id ?? this.id,
        workOrderId: workOrderId ?? this.workOrderId,
        fromStatus: fromStatus ?? this.fromStatus,
        toStatus: toStatus ?? this.toStatus,
        changedBy: changedBy ?? this.changedBy,
        notes: notes.present ? notes.value : this.notes,
        transitionedAt: transitionedAt ?? this.transitionedAt,
      );
  WorkOrderStatusTransition copyWithCompanion(
      WorkOrderStatusTransitionsCompanion data) {
    return WorkOrderStatusTransition(
      id: data.id.present ? data.id.value : this.id,
      workOrderId:
          data.workOrderId.present ? data.workOrderId.value : this.workOrderId,
      fromStatus:
          data.fromStatus.present ? data.fromStatus.value : this.fromStatus,
      toStatus: data.toStatus.present ? data.toStatus.value : this.toStatus,
      changedBy: data.changedBy.present ? data.changedBy.value : this.changedBy,
      notes: data.notes.present ? data.notes.value : this.notes,
      transitionedAt: data.transitionedAt.present
          ? data.transitionedAt.value
          : this.transitionedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('WorkOrderStatusTransition(')
          ..write('id: $id, ')
          ..write('workOrderId: $workOrderId, ')
          ..write('fromStatus: $fromStatus, ')
          ..write('toStatus: $toStatus, ')
          ..write('changedBy: $changedBy, ')
          ..write('notes: $notes, ')
          ..write('transitionedAt: $transitionedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id, workOrderId, fromStatus, toStatus, changedBy, notes, transitionedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is WorkOrderStatusTransition &&
          other.id == this.id &&
          other.workOrderId == this.workOrderId &&
          other.fromStatus == this.fromStatus &&
          other.toStatus == this.toStatus &&
          other.changedBy == this.changedBy &&
          other.notes == this.notes &&
          other.transitionedAt == this.transitionedAt);
}

class WorkOrderStatusTransitionsCompanion
    extends UpdateCompanion<WorkOrderStatusTransition> {
  final Value<int> id;
  final Value<int> workOrderId;
  final Value<String> fromStatus;
  final Value<String> toStatus;
  final Value<int> changedBy;
  final Value<String?> notes;
  final Value<DateTime> transitionedAt;
  const WorkOrderStatusTransitionsCompanion({
    this.id = const Value.absent(),
    this.workOrderId = const Value.absent(),
    this.fromStatus = const Value.absent(),
    this.toStatus = const Value.absent(),
    this.changedBy = const Value.absent(),
    this.notes = const Value.absent(),
    this.transitionedAt = const Value.absent(),
  });
  WorkOrderStatusTransitionsCompanion.insert({
    this.id = const Value.absent(),
    required int workOrderId,
    required String fromStatus,
    required String toStatus,
    required int changedBy,
    this.notes = const Value.absent(),
    this.transitionedAt = const Value.absent(),
  })  : workOrderId = Value(workOrderId),
        fromStatus = Value(fromStatus),
        toStatus = Value(toStatus),
        changedBy = Value(changedBy);
  static Insertable<WorkOrderStatusTransition> custom({
    Expression<int>? id,
    Expression<int>? workOrderId,
    Expression<String>? fromStatus,
    Expression<String>? toStatus,
    Expression<int>? changedBy,
    Expression<String>? notes,
    Expression<DateTime>? transitionedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (workOrderId != null) 'work_order_id': workOrderId,
      if (fromStatus != null) 'from_status': fromStatus,
      if (toStatus != null) 'to_status': toStatus,
      if (changedBy != null) 'changed_by': changedBy,
      if (notes != null) 'notes': notes,
      if (transitionedAt != null) 'transitioned_at': transitionedAt,
    });
  }

  WorkOrderStatusTransitionsCompanion copyWith(
      {Value<int>? id,
      Value<int>? workOrderId,
      Value<String>? fromStatus,
      Value<String>? toStatus,
      Value<int>? changedBy,
      Value<String?>? notes,
      Value<DateTime>? transitionedAt}) {
    return WorkOrderStatusTransitionsCompanion(
      id: id ?? this.id,
      workOrderId: workOrderId ?? this.workOrderId,
      fromStatus: fromStatus ?? this.fromStatus,
      toStatus: toStatus ?? this.toStatus,
      changedBy: changedBy ?? this.changedBy,
      notes: notes ?? this.notes,
      transitionedAt: transitionedAt ?? this.transitionedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (workOrderId.present) {
      map['work_order_id'] = Variable<int>(workOrderId.value);
    }
    if (fromStatus.present) {
      map['from_status'] = Variable<String>(fromStatus.value);
    }
    if (toStatus.present) {
      map['to_status'] = Variable<String>(toStatus.value);
    }
    if (changedBy.present) {
      map['changed_by'] = Variable<int>(changedBy.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (transitionedAt.present) {
      map['transitioned_at'] = Variable<DateTime>(transitionedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('WorkOrderStatusTransitionsCompanion(')
          ..write('id: $id, ')
          ..write('workOrderId: $workOrderId, ')
          ..write('fromStatus: $fromStatus, ')
          ..write('toStatus: $toStatus, ')
          ..write('changedBy: $changedBy, ')
          ..write('notes: $notes, ')
          ..write('transitionedAt: $transitionedAt')
          ..write(')'))
        .toString();
  }
}

class $ProvenanceLogTable extends ProvenanceLog
    with TableInfo<$ProvenanceLogTable, ProvenanceLogData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ProvenanceLogTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _recordTypeMeta =
      const VerificationMeta('recordType');
  @override
  late final GeneratedColumn<String> recordType = GeneratedColumn<String>(
      'record_type', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _recordIdMeta =
      const VerificationMeta('recordId');
  @override
  late final GeneratedColumn<int> recordId = GeneratedColumn<int>(
      'record_id', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _actionMeta = const VerificationMeta('action');
  @override
  late final GeneratedColumn<String> action = GeneratedColumn<String>(
      'action', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _contentHashMeta =
      const VerificationMeta('contentHash');
  @override
  late final GeneratedColumn<String> contentHash = GeneratedColumn<String>(
      'content_hash', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _previousHashMeta =
      const VerificationMeta('previousHash');
  @override
  late final GeneratedColumn<String> previousHash = GeneratedColumn<String>(
      'previous_hash', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _userSidMeta =
      const VerificationMeta('userSid');
  @override
  late final GeneratedColumn<String> userSid = GeneratedColumn<String>(
      'user_sid', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _userNameMeta =
      const VerificationMeta('userName');
  @override
  late final GeneratedColumn<String> userName = GeneratedColumn<String>(
      'user_name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _timestampMeta =
      const VerificationMeta('timestamp');
  @override
  late final GeneratedColumn<DateTime> timestamp = GeneratedColumn<DateTime>(
      'timestamp', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  static const VerificationMeta _changeMetadataMeta =
      const VerificationMeta('changeMetadata');
  @override
  late final GeneratedColumn<String> changeMetadata = GeneratedColumn<String>(
      'change_metadata', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        recordType,
        recordId,
        action,
        contentHash,
        previousHash,
        userSid,
        userName,
        timestamp,
        changeMetadata
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'provenance_log';
  @override
  VerificationContext validateIntegrity(Insertable<ProvenanceLogData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('record_type')) {
      context.handle(
          _recordTypeMeta,
          recordType.isAcceptableOrUnknown(
              data['record_type']!, _recordTypeMeta));
    } else if (isInserting) {
      context.missing(_recordTypeMeta);
    }
    if (data.containsKey('record_id')) {
      context.handle(_recordIdMeta,
          recordId.isAcceptableOrUnknown(data['record_id']!, _recordIdMeta));
    } else if (isInserting) {
      context.missing(_recordIdMeta);
    }
    if (data.containsKey('action')) {
      context.handle(_actionMeta,
          action.isAcceptableOrUnknown(data['action']!, _actionMeta));
    } else if (isInserting) {
      context.missing(_actionMeta);
    }
    if (data.containsKey('content_hash')) {
      context.handle(
          _contentHashMeta,
          contentHash.isAcceptableOrUnknown(
              data['content_hash']!, _contentHashMeta));
    } else if (isInserting) {
      context.missing(_contentHashMeta);
    }
    if (data.containsKey('previous_hash')) {
      context.handle(
          _previousHashMeta,
          previousHash.isAcceptableOrUnknown(
              data['previous_hash']!, _previousHashMeta));
    }
    if (data.containsKey('user_sid')) {
      context.handle(_userSidMeta,
          userSid.isAcceptableOrUnknown(data['user_sid']!, _userSidMeta));
    } else if (isInserting) {
      context.missing(_userSidMeta);
    }
    if (data.containsKey('user_name')) {
      context.handle(_userNameMeta,
          userName.isAcceptableOrUnknown(data['user_name']!, _userNameMeta));
    } else if (isInserting) {
      context.missing(_userNameMeta);
    }
    if (data.containsKey('timestamp')) {
      context.handle(_timestampMeta,
          timestamp.isAcceptableOrUnknown(data['timestamp']!, _timestampMeta));
    }
    if (data.containsKey('change_metadata')) {
      context.handle(
          _changeMetadataMeta,
          changeMetadata.isAcceptableOrUnknown(
              data['change_metadata']!, _changeMetadataMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ProvenanceLogData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ProvenanceLogData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      recordType: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}record_type'])!,
      recordId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}record_id'])!,
      action: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}action'])!,
      contentHash: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}content_hash'])!,
      previousHash: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}previous_hash']),
      userSid: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}user_sid'])!,
      userName: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}user_name'])!,
      timestamp: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}timestamp'])!,
      changeMetadata: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}change_metadata']),
    );
  }

  @override
  $ProvenanceLogTable createAlias(String alias) {
    return $ProvenanceLogTable(attachedDatabase, alias);
  }
}

class ProvenanceLogData extends DataClass
    implements Insertable<ProvenanceLogData> {
  final int id;
  final String recordType;
  final int recordId;
  final String action;
  final String contentHash;
  final String? previousHash;
  final String userSid;
  final String userName;
  final DateTime timestamp;
  final String? changeMetadata;
  const ProvenanceLogData(
      {required this.id,
      required this.recordType,
      required this.recordId,
      required this.action,
      required this.contentHash,
      this.previousHash,
      required this.userSid,
      required this.userName,
      required this.timestamp,
      this.changeMetadata});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['record_type'] = Variable<String>(recordType);
    map['record_id'] = Variable<int>(recordId);
    map['action'] = Variable<String>(action);
    map['content_hash'] = Variable<String>(contentHash);
    if (!nullToAbsent || previousHash != null) {
      map['previous_hash'] = Variable<String>(previousHash);
    }
    map['user_sid'] = Variable<String>(userSid);
    map['user_name'] = Variable<String>(userName);
    map['timestamp'] = Variable<DateTime>(timestamp);
    if (!nullToAbsent || changeMetadata != null) {
      map['change_metadata'] = Variable<String>(changeMetadata);
    }
    return map;
  }

  ProvenanceLogCompanion toCompanion(bool nullToAbsent) {
    return ProvenanceLogCompanion(
      id: Value(id),
      recordType: Value(recordType),
      recordId: Value(recordId),
      action: Value(action),
      contentHash: Value(contentHash),
      previousHash: previousHash == null && nullToAbsent
          ? const Value.absent()
          : Value(previousHash),
      userSid: Value(userSid),
      userName: Value(userName),
      timestamp: Value(timestamp),
      changeMetadata: changeMetadata == null && nullToAbsent
          ? const Value.absent()
          : Value(changeMetadata),
    );
  }

  factory ProvenanceLogData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ProvenanceLogData(
      id: serializer.fromJson<int>(json['id']),
      recordType: serializer.fromJson<String>(json['recordType']),
      recordId: serializer.fromJson<int>(json['recordId']),
      action: serializer.fromJson<String>(json['action']),
      contentHash: serializer.fromJson<String>(json['contentHash']),
      previousHash: serializer.fromJson<String?>(json['previousHash']),
      userSid: serializer.fromJson<String>(json['userSid']),
      userName: serializer.fromJson<String>(json['userName']),
      timestamp: serializer.fromJson<DateTime>(json['timestamp']),
      changeMetadata: serializer.fromJson<String?>(json['changeMetadata']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'recordType': serializer.toJson<String>(recordType),
      'recordId': serializer.toJson<int>(recordId),
      'action': serializer.toJson<String>(action),
      'contentHash': serializer.toJson<String>(contentHash),
      'previousHash': serializer.toJson<String?>(previousHash),
      'userSid': serializer.toJson<String>(userSid),
      'userName': serializer.toJson<String>(userName),
      'timestamp': serializer.toJson<DateTime>(timestamp),
      'changeMetadata': serializer.toJson<String?>(changeMetadata),
    };
  }

  ProvenanceLogData copyWith(
          {int? id,
          String? recordType,
          int? recordId,
          String? action,
          String? contentHash,
          Value<String?> previousHash = const Value.absent(),
          String? userSid,
          String? userName,
          DateTime? timestamp,
          Value<String?> changeMetadata = const Value.absent()}) =>
      ProvenanceLogData(
        id: id ?? this.id,
        recordType: recordType ?? this.recordType,
        recordId: recordId ?? this.recordId,
        action: action ?? this.action,
        contentHash: contentHash ?? this.contentHash,
        previousHash:
            previousHash.present ? previousHash.value : this.previousHash,
        userSid: userSid ?? this.userSid,
        userName: userName ?? this.userName,
        timestamp: timestamp ?? this.timestamp,
        changeMetadata:
            changeMetadata.present ? changeMetadata.value : this.changeMetadata,
      );
  ProvenanceLogData copyWithCompanion(ProvenanceLogCompanion data) {
    return ProvenanceLogData(
      id: data.id.present ? data.id.value : this.id,
      recordType:
          data.recordType.present ? data.recordType.value : this.recordType,
      recordId: data.recordId.present ? data.recordId.value : this.recordId,
      action: data.action.present ? data.action.value : this.action,
      contentHash:
          data.contentHash.present ? data.contentHash.value : this.contentHash,
      previousHash: data.previousHash.present
          ? data.previousHash.value
          : this.previousHash,
      userSid: data.userSid.present ? data.userSid.value : this.userSid,
      userName: data.userName.present ? data.userName.value : this.userName,
      timestamp: data.timestamp.present ? data.timestamp.value : this.timestamp,
      changeMetadata: data.changeMetadata.present
          ? data.changeMetadata.value
          : this.changeMetadata,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ProvenanceLogData(')
          ..write('id: $id, ')
          ..write('recordType: $recordType, ')
          ..write('recordId: $recordId, ')
          ..write('action: $action, ')
          ..write('contentHash: $contentHash, ')
          ..write('previousHash: $previousHash, ')
          ..write('userSid: $userSid, ')
          ..write('userName: $userName, ')
          ..write('timestamp: $timestamp, ')
          ..write('changeMetadata: $changeMetadata')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, recordType, recordId, action, contentHash,
      previousHash, userSid, userName, timestamp, changeMetadata);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ProvenanceLogData &&
          other.id == this.id &&
          other.recordType == this.recordType &&
          other.recordId == this.recordId &&
          other.action == this.action &&
          other.contentHash == this.contentHash &&
          other.previousHash == this.previousHash &&
          other.userSid == this.userSid &&
          other.userName == this.userName &&
          other.timestamp == this.timestamp &&
          other.changeMetadata == this.changeMetadata);
}

class ProvenanceLogCompanion extends UpdateCompanion<ProvenanceLogData> {
  final Value<int> id;
  final Value<String> recordType;
  final Value<int> recordId;
  final Value<String> action;
  final Value<String> contentHash;
  final Value<String?> previousHash;
  final Value<String> userSid;
  final Value<String> userName;
  final Value<DateTime> timestamp;
  final Value<String?> changeMetadata;
  const ProvenanceLogCompanion({
    this.id = const Value.absent(),
    this.recordType = const Value.absent(),
    this.recordId = const Value.absent(),
    this.action = const Value.absent(),
    this.contentHash = const Value.absent(),
    this.previousHash = const Value.absent(),
    this.userSid = const Value.absent(),
    this.userName = const Value.absent(),
    this.timestamp = const Value.absent(),
    this.changeMetadata = const Value.absent(),
  });
  ProvenanceLogCompanion.insert({
    this.id = const Value.absent(),
    required String recordType,
    required int recordId,
    required String action,
    required String contentHash,
    this.previousHash = const Value.absent(),
    required String userSid,
    required String userName,
    this.timestamp = const Value.absent(),
    this.changeMetadata = const Value.absent(),
  })  : recordType = Value(recordType),
        recordId = Value(recordId),
        action = Value(action),
        contentHash = Value(contentHash),
        userSid = Value(userSid),
        userName = Value(userName);
  static Insertable<ProvenanceLogData> custom({
    Expression<int>? id,
    Expression<String>? recordType,
    Expression<int>? recordId,
    Expression<String>? action,
    Expression<String>? contentHash,
    Expression<String>? previousHash,
    Expression<String>? userSid,
    Expression<String>? userName,
    Expression<DateTime>? timestamp,
    Expression<String>? changeMetadata,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (recordType != null) 'record_type': recordType,
      if (recordId != null) 'record_id': recordId,
      if (action != null) 'action': action,
      if (contentHash != null) 'content_hash': contentHash,
      if (previousHash != null) 'previous_hash': previousHash,
      if (userSid != null) 'user_sid': userSid,
      if (userName != null) 'user_name': userName,
      if (timestamp != null) 'timestamp': timestamp,
      if (changeMetadata != null) 'change_metadata': changeMetadata,
    });
  }

  ProvenanceLogCompanion copyWith(
      {Value<int>? id,
      Value<String>? recordType,
      Value<int>? recordId,
      Value<String>? action,
      Value<String>? contentHash,
      Value<String?>? previousHash,
      Value<String>? userSid,
      Value<String>? userName,
      Value<DateTime>? timestamp,
      Value<String?>? changeMetadata}) {
    return ProvenanceLogCompanion(
      id: id ?? this.id,
      recordType: recordType ?? this.recordType,
      recordId: recordId ?? this.recordId,
      action: action ?? this.action,
      contentHash: contentHash ?? this.contentHash,
      previousHash: previousHash ?? this.previousHash,
      userSid: userSid ?? this.userSid,
      userName: userName ?? this.userName,
      timestamp: timestamp ?? this.timestamp,
      changeMetadata: changeMetadata ?? this.changeMetadata,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (recordType.present) {
      map['record_type'] = Variable<String>(recordType.value);
    }
    if (recordId.present) {
      map['record_id'] = Variable<int>(recordId.value);
    }
    if (action.present) {
      map['action'] = Variable<String>(action.value);
    }
    if (contentHash.present) {
      map['content_hash'] = Variable<String>(contentHash.value);
    }
    if (previousHash.present) {
      map['previous_hash'] = Variable<String>(previousHash.value);
    }
    if (userSid.present) {
      map['user_sid'] = Variable<String>(userSid.value);
    }
    if (userName.present) {
      map['user_name'] = Variable<String>(userName.value);
    }
    if (timestamp.present) {
      map['timestamp'] = Variable<DateTime>(timestamp.value);
    }
    if (changeMetadata.present) {
      map['change_metadata'] = Variable<String>(changeMetadata.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ProvenanceLogCompanion(')
          ..write('id: $id, ')
          ..write('recordType: $recordType, ')
          ..write('recordId: $recordId, ')
          ..write('action: $action, ')
          ..write('contentHash: $contentHash, ')
          ..write('previousHash: $previousHash, ')
          ..write('userSid: $userSid, ')
          ..write('userName: $userName, ')
          ..write('timestamp: $timestamp, ')
          ..write('changeMetadata: $changeMetadata')
          ..write(')'))
        .toString();
  }
}

class $EncryptionKeyStoreTable extends EncryptionKeyStore
    with TableInfo<$EncryptionKeyStoreTable, EncryptionKeyStoreData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $EncryptionKeyStoreTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _keyPurposeMeta =
      const VerificationMeta('keyPurpose');
  @override
  late final GeneratedColumn<String> keyPurpose = GeneratedColumn<String>(
      'key_purpose', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _encryptedKeyMeta =
      const VerificationMeta('encryptedKey');
  @override
  late final GeneratedColumn<String> encryptedKey = GeneratedColumn<String>(
      'encrypted_key', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _keyFingerprintMeta =
      const VerificationMeta('keyFingerprint');
  @override
  late final GeneratedColumn<String> keyFingerprint = GeneratedColumn<String>(
      'key_fingerprint', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  static const VerificationMeta _lastAccessedAtMeta =
      const VerificationMeta('lastAccessedAt');
  @override
  late final GeneratedColumn<DateTime> lastAccessedAt =
      GeneratedColumn<DateTime>('last_accessed_at', aliasedName, true,
          type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _accessCountMeta =
      const VerificationMeta('accessCount');
  @override
  late final GeneratedColumn<int> accessCount = GeneratedColumn<int>(
      'access_count', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  @override
  List<GeneratedColumn> get $columns => [
        id,
        keyPurpose,
        encryptedKey,
        keyFingerprint,
        createdAt,
        lastAccessedAt,
        accessCount
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'encryption_key_store';
  @override
  VerificationContext validateIntegrity(
      Insertable<EncryptionKeyStoreData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('key_purpose')) {
      context.handle(
          _keyPurposeMeta,
          keyPurpose.isAcceptableOrUnknown(
              data['key_purpose']!, _keyPurposeMeta));
    } else if (isInserting) {
      context.missing(_keyPurposeMeta);
    }
    if (data.containsKey('encrypted_key')) {
      context.handle(
          _encryptedKeyMeta,
          encryptedKey.isAcceptableOrUnknown(
              data['encrypted_key']!, _encryptedKeyMeta));
    } else if (isInserting) {
      context.missing(_encryptedKeyMeta);
    }
    if (data.containsKey('key_fingerprint')) {
      context.handle(
          _keyFingerprintMeta,
          keyFingerprint.isAcceptableOrUnknown(
              data['key_fingerprint']!, _keyFingerprintMeta));
    } else if (isInserting) {
      context.missing(_keyFingerprintMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    }
    if (data.containsKey('last_accessed_at')) {
      context.handle(
          _lastAccessedAtMeta,
          lastAccessedAt.isAcceptableOrUnknown(
              data['last_accessed_at']!, _lastAccessedAtMeta));
    }
    if (data.containsKey('access_count')) {
      context.handle(
          _accessCountMeta,
          accessCount.isAcceptableOrUnknown(
              data['access_count']!, _accessCountMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  EncryptionKeyStoreData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return EncryptionKeyStoreData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      keyPurpose: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}key_purpose'])!,
      encryptedKey: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}encrypted_key'])!,
      keyFingerprint: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}key_fingerprint'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      lastAccessedAt: attachedDatabase.typeMapping.read(
          DriftSqlType.dateTime, data['${effectivePrefix}last_accessed_at']),
      accessCount: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}access_count'])!,
    );
  }

  @override
  $EncryptionKeyStoreTable createAlias(String alias) {
    return $EncryptionKeyStoreTable(attachedDatabase, alias);
  }
}

class EncryptionKeyStoreData extends DataClass
    implements Insertable<EncryptionKeyStoreData> {
  final int id;
  final String keyPurpose;
  final String encryptedKey;
  final String keyFingerprint;
  final DateTime createdAt;
  final DateTime? lastAccessedAt;
  final int accessCount;
  const EncryptionKeyStoreData(
      {required this.id,
      required this.keyPurpose,
      required this.encryptedKey,
      required this.keyFingerprint,
      required this.createdAt,
      this.lastAccessedAt,
      required this.accessCount});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['key_purpose'] = Variable<String>(keyPurpose);
    map['encrypted_key'] = Variable<String>(encryptedKey);
    map['key_fingerprint'] = Variable<String>(keyFingerprint);
    map['created_at'] = Variable<DateTime>(createdAt);
    if (!nullToAbsent || lastAccessedAt != null) {
      map['last_accessed_at'] = Variable<DateTime>(lastAccessedAt);
    }
    map['access_count'] = Variable<int>(accessCount);
    return map;
  }

  EncryptionKeyStoreCompanion toCompanion(bool nullToAbsent) {
    return EncryptionKeyStoreCompanion(
      id: Value(id),
      keyPurpose: Value(keyPurpose),
      encryptedKey: Value(encryptedKey),
      keyFingerprint: Value(keyFingerprint),
      createdAt: Value(createdAt),
      lastAccessedAt: lastAccessedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(lastAccessedAt),
      accessCount: Value(accessCount),
    );
  }

  factory EncryptionKeyStoreData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return EncryptionKeyStoreData(
      id: serializer.fromJson<int>(json['id']),
      keyPurpose: serializer.fromJson<String>(json['keyPurpose']),
      encryptedKey: serializer.fromJson<String>(json['encryptedKey']),
      keyFingerprint: serializer.fromJson<String>(json['keyFingerprint']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      lastAccessedAt: serializer.fromJson<DateTime?>(json['lastAccessedAt']),
      accessCount: serializer.fromJson<int>(json['accessCount']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'keyPurpose': serializer.toJson<String>(keyPurpose),
      'encryptedKey': serializer.toJson<String>(encryptedKey),
      'keyFingerprint': serializer.toJson<String>(keyFingerprint),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'lastAccessedAt': serializer.toJson<DateTime?>(lastAccessedAt),
      'accessCount': serializer.toJson<int>(accessCount),
    };
  }

  EncryptionKeyStoreData copyWith(
          {int? id,
          String? keyPurpose,
          String? encryptedKey,
          String? keyFingerprint,
          DateTime? createdAt,
          Value<DateTime?> lastAccessedAt = const Value.absent(),
          int? accessCount}) =>
      EncryptionKeyStoreData(
        id: id ?? this.id,
        keyPurpose: keyPurpose ?? this.keyPurpose,
        encryptedKey: encryptedKey ?? this.encryptedKey,
        keyFingerprint: keyFingerprint ?? this.keyFingerprint,
        createdAt: createdAt ?? this.createdAt,
        lastAccessedAt:
            lastAccessedAt.present ? lastAccessedAt.value : this.lastAccessedAt,
        accessCount: accessCount ?? this.accessCount,
      );
  EncryptionKeyStoreData copyWithCompanion(EncryptionKeyStoreCompanion data) {
    return EncryptionKeyStoreData(
      id: data.id.present ? data.id.value : this.id,
      keyPurpose:
          data.keyPurpose.present ? data.keyPurpose.value : this.keyPurpose,
      encryptedKey: data.encryptedKey.present
          ? data.encryptedKey.value
          : this.encryptedKey,
      keyFingerprint: data.keyFingerprint.present
          ? data.keyFingerprint.value
          : this.keyFingerprint,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      lastAccessedAt: data.lastAccessedAt.present
          ? data.lastAccessedAt.value
          : this.lastAccessedAt,
      accessCount:
          data.accessCount.present ? data.accessCount.value : this.accessCount,
    );
  }

  @override
  String toString() {
    return (StringBuffer('EncryptionKeyStoreData(')
          ..write('id: $id, ')
          ..write('keyPurpose: $keyPurpose, ')
          ..write('encryptedKey: $encryptedKey, ')
          ..write('keyFingerprint: $keyFingerprint, ')
          ..write('createdAt: $createdAt, ')
          ..write('lastAccessedAt: $lastAccessedAt, ')
          ..write('accessCount: $accessCount')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, keyPurpose, encryptedKey, keyFingerprint,
      createdAt, lastAccessedAt, accessCount);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is EncryptionKeyStoreData &&
          other.id == this.id &&
          other.keyPurpose == this.keyPurpose &&
          other.encryptedKey == this.encryptedKey &&
          other.keyFingerprint == this.keyFingerprint &&
          other.createdAt == this.createdAt &&
          other.lastAccessedAt == this.lastAccessedAt &&
          other.accessCount == this.accessCount);
}

class EncryptionKeyStoreCompanion
    extends UpdateCompanion<EncryptionKeyStoreData> {
  final Value<int> id;
  final Value<String> keyPurpose;
  final Value<String> encryptedKey;
  final Value<String> keyFingerprint;
  final Value<DateTime> createdAt;
  final Value<DateTime?> lastAccessedAt;
  final Value<int> accessCount;
  const EncryptionKeyStoreCompanion({
    this.id = const Value.absent(),
    this.keyPurpose = const Value.absent(),
    this.encryptedKey = const Value.absent(),
    this.keyFingerprint = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.lastAccessedAt = const Value.absent(),
    this.accessCount = const Value.absent(),
  });
  EncryptionKeyStoreCompanion.insert({
    this.id = const Value.absent(),
    required String keyPurpose,
    required String encryptedKey,
    required String keyFingerprint,
    this.createdAt = const Value.absent(),
    this.lastAccessedAt = const Value.absent(),
    this.accessCount = const Value.absent(),
  })  : keyPurpose = Value(keyPurpose),
        encryptedKey = Value(encryptedKey),
        keyFingerprint = Value(keyFingerprint);
  static Insertable<EncryptionKeyStoreData> custom({
    Expression<int>? id,
    Expression<String>? keyPurpose,
    Expression<String>? encryptedKey,
    Expression<String>? keyFingerprint,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? lastAccessedAt,
    Expression<int>? accessCount,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (keyPurpose != null) 'key_purpose': keyPurpose,
      if (encryptedKey != null) 'encrypted_key': encryptedKey,
      if (keyFingerprint != null) 'key_fingerprint': keyFingerprint,
      if (createdAt != null) 'created_at': createdAt,
      if (lastAccessedAt != null) 'last_accessed_at': lastAccessedAt,
      if (accessCount != null) 'access_count': accessCount,
    });
  }

  EncryptionKeyStoreCompanion copyWith(
      {Value<int>? id,
      Value<String>? keyPurpose,
      Value<String>? encryptedKey,
      Value<String>? keyFingerprint,
      Value<DateTime>? createdAt,
      Value<DateTime?>? lastAccessedAt,
      Value<int>? accessCount}) {
    return EncryptionKeyStoreCompanion(
      id: id ?? this.id,
      keyPurpose: keyPurpose ?? this.keyPurpose,
      encryptedKey: encryptedKey ?? this.encryptedKey,
      keyFingerprint: keyFingerprint ?? this.keyFingerprint,
      createdAt: createdAt ?? this.createdAt,
      lastAccessedAt: lastAccessedAt ?? this.lastAccessedAt,
      accessCount: accessCount ?? this.accessCount,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (keyPurpose.present) {
      map['key_purpose'] = Variable<String>(keyPurpose.value);
    }
    if (encryptedKey.present) {
      map['encrypted_key'] = Variable<String>(encryptedKey.value);
    }
    if (keyFingerprint.present) {
      map['key_fingerprint'] = Variable<String>(keyFingerprint.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (lastAccessedAt.present) {
      map['last_accessed_at'] = Variable<DateTime>(lastAccessedAt.value);
    }
    if (accessCount.present) {
      map['access_count'] = Variable<int>(accessCount.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('EncryptionKeyStoreCompanion(')
          ..write('id: $id, ')
          ..write('keyPurpose: $keyPurpose, ')
          ..write('encryptedKey: $encryptedKey, ')
          ..write('keyFingerprint: $keyFingerprint, ')
          ..write('createdAt: $createdAt, ')
          ..write('lastAccessedAt: $lastAccessedAt, ')
          ..write('accessCount: $accessCount')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $ClientsTable clients = $ClientsTable(this);
  late final $SitesTable sites = $SitesTable(this);
  late final $StartingPointsTable startingPoints = $StartingPointsTable(this);
  late final $UsersTable users = $UsersTable(this);
  late final $WeatherSnapshotTable weatherSnapshot =
      $WeatherSnapshotTable(this);
  late final $TrafficSnapshotTable trafficSnapshot =
      $TrafficSnapshotTable(this);
  late final $WorkCallsTable workCalls = $WorkCallsTable(this);
  late final $IndustryBriefingTable industryBriefing =
      $IndustryBriefingTable(this);
  late final $CompanyAnnouncementsTable companyAnnouncements =
      $CompanyAnnouncementsTable(this);
  late final $WorkOrdersTable workOrders = $WorkOrdersTable(this);
  late final $AppointmentsTable appointments = $AppointmentsTable(this);
  late final $EquipmentTable equipment = $EquipmentTable(this);
  late final $WorkOrderEquipmentTable workOrderEquipment =
      $WorkOrderEquipmentTable(this);
  late final $WorkPerformedTable workPerformed = $WorkPerformedTable(this);
  late final $PartsUsedTable partsUsed = $PartsUsedTable(this);
  late final $NotesTable notes = $NotesTable(this);
  late final $DocumentsTable documents = $DocumentsTable(this);
  late final $KnowledgeEntriesTable knowledgeEntries =
      $KnowledgeEntriesTable(this);
  late final $KnowledgeProceduresTable knowledgeProcedures =
      $KnowledgeProceduresTable(this);
  late final $KnowledgeTroubleshootingTable knowledgeTroubleshooting =
      $KnowledgeTroubleshootingTable(this);
  late final $EquipmentSpecsTable equipmentSpecs = $EquipmentSpecsTable(this);
  late final $KnowledgeRelationshipsTable knowledgeRelationships =
      $KnowledgeRelationshipsTable(this);
  late final $KnowledgeSearchIndexTable knowledgeSearchIndex =
      $KnowledgeSearchIndexTable(this);
  late final $KnowledgeQueryLogTable knowledgeQueryLog =
      $KnowledgeQueryLogTable(this);
  late final $ChatChannelsTable chatChannels = $ChatChannelsTable(this);
  late final $ChatMessagesTable chatMessages = $ChatMessagesTable(this);
  late final $ContinuingEducationCoursesTable continuingEducationCourses =
      $ContinuingEducationCoursesTable(this);
  late final $UserCourseEnrollmentsTable userCourseEnrollments =
      $UserCourseEnrollmentsTable(this);
  late final $ExpensesTable expenses = $ExpensesTable(this);
  late final $WorkOrderAuditLogTable workOrderAuditLog =
      $WorkOrderAuditLogTable(this);
  late final $WorkOrderStatusTransitionsTable workOrderStatusTransitions =
      $WorkOrderStatusTransitionsTable(this);
  late final $ProvenanceLogTable provenanceLog = $ProvenanceLogTable(this);
  late final $EncryptionKeyStoreTable encryptionKeyStore =
      $EncryptionKeyStoreTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
        clients,
        sites,
        startingPoints,
        users,
        weatherSnapshot,
        trafficSnapshot,
        workCalls,
        industryBriefing,
        companyAnnouncements,
        workOrders,
        appointments,
        equipment,
        workOrderEquipment,
        workPerformed,
        partsUsed,
        notes,
        documents,
        knowledgeEntries,
        knowledgeProcedures,
        knowledgeTroubleshooting,
        equipmentSpecs,
        knowledgeRelationships,
        knowledgeSearchIndex,
        knowledgeQueryLog,
        chatChannels,
        chatMessages,
        continuingEducationCourses,
        userCourseEnrollments,
        expenses,
        workOrderAuditLog,
        workOrderStatusTransitions,
        provenanceLog,
        encryptionKeyStore
      ];
}

typedef $$ClientsTableCreateCompanionBuilder = ClientsCompanion Function({
  Value<int> id,
  required String name,
  required String themeColor,
});
typedef $$ClientsTableUpdateCompanionBuilder = ClientsCompanion Function({
  Value<int> id,
  Value<String> name,
  Value<String> themeColor,
});

final class $$ClientsTableReferences
    extends BaseReferences<_$AppDatabase, $ClientsTable, Client> {
  $$ClientsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$SitesTable, List<Site>> _sitesRefsTable(
          _$AppDatabase db) =>
      MultiTypedResultKey.fromTable(db.sites,
          aliasName: $_aliasNameGenerator(db.clients.id, db.sites.clientId));

  $$SitesTableProcessedTableManager get sitesRefs {
    final manager = $$SitesTableTableManager($_db, $_db.sites)
        .filter((f) => f.clientId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_sitesRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }
}

class $$ClientsTableFilterComposer
    extends Composer<_$AppDatabase, $ClientsTable> {
  $$ClientsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get themeColor => $composableBuilder(
      column: $table.themeColor, builder: (column) => ColumnFilters(column));

  Expression<bool> sitesRefs(
      Expression<bool> Function($$SitesTableFilterComposer f) f) {
    final $$SitesTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.sites,
        getReferencedColumn: (t) => t.clientId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$SitesTableFilterComposer(
              $db: $db,
              $table: $db.sites,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$ClientsTableOrderingComposer
    extends Composer<_$AppDatabase, $ClientsTable> {
  $$ClientsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get themeColor => $composableBuilder(
      column: $table.themeColor, builder: (column) => ColumnOrderings(column));
}

class $$ClientsTableAnnotationComposer
    extends Composer<_$AppDatabase, $ClientsTable> {
  $$ClientsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get themeColor => $composableBuilder(
      column: $table.themeColor, builder: (column) => column);

  Expression<T> sitesRefs<T extends Object>(
      Expression<T> Function($$SitesTableAnnotationComposer a) f) {
    final $$SitesTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.sites,
        getReferencedColumn: (t) => t.clientId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$SitesTableAnnotationComposer(
              $db: $db,
              $table: $db.sites,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$ClientsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $ClientsTable,
    Client,
    $$ClientsTableFilterComposer,
    $$ClientsTableOrderingComposer,
    $$ClientsTableAnnotationComposer,
    $$ClientsTableCreateCompanionBuilder,
    $$ClientsTableUpdateCompanionBuilder,
    (Client, $$ClientsTableReferences),
    Client,
    PrefetchHooks Function({bool sitesRefs})> {
  $$ClientsTableTableManager(_$AppDatabase db, $ClientsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ClientsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ClientsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ClientsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<String> themeColor = const Value.absent(),
          }) =>
              ClientsCompanion(
            id: id,
            name: name,
            themeColor: themeColor,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String name,
            required String themeColor,
          }) =>
              ClientsCompanion.insert(
            id: id,
            name: name,
            themeColor: themeColor,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) =>
                  (e.readTable(table), $$ClientsTableReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: ({sitesRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (sitesRefs) db.sites],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (sitesRefs)
                    await $_getPrefetchedData<Client, $ClientsTable, Site>(
                        currentTable: table,
                        referencedTable:
                            $$ClientsTableReferences._sitesRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$ClientsTableReferences(db, table, p0).sitesRefs,
                        referencedItemsForCurrentItem: (item,
                                referencedItems) =>
                            referencedItems.where((e) => e.clientId == item.id),
                        typedResults: items)
                ];
              },
            );
          },
        ));
}

typedef $$ClientsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $ClientsTable,
    Client,
    $$ClientsTableFilterComposer,
    $$ClientsTableOrderingComposer,
    $$ClientsTableAnnotationComposer,
    $$ClientsTableCreateCompanionBuilder,
    $$ClientsTableUpdateCompanionBuilder,
    (Client, $$ClientsTableReferences),
    Client,
    PrefetchHooks Function({bool sitesRefs})>;
typedef $$SitesTableCreateCompanionBuilder = SitesCompanion Function({
  Value<int> id,
  required int clientId,
  required String branchName,
  required String address,
  required double latitude,
  required double longitude,
  required String region,
});
typedef $$SitesTableUpdateCompanionBuilder = SitesCompanion Function({
  Value<int> id,
  Value<int> clientId,
  Value<String> branchName,
  Value<String> address,
  Value<double> latitude,
  Value<double> longitude,
  Value<String> region,
});

final class $$SitesTableReferences
    extends BaseReferences<_$AppDatabase, $SitesTable, Site> {
  $$SitesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $ClientsTable _clientIdTable(_$AppDatabase db) => db.clients
      .createAlias($_aliasNameGenerator(db.sites.clientId, db.clients.id));

  $$ClientsTableProcessedTableManager get clientId {
    final $_column = $_itemColumn<int>('client_id')!;

    final manager = $$ClientsTableTableManager($_db, $_db.clients)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_clientIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }
}

class $$SitesTableFilterComposer extends Composer<_$AppDatabase, $SitesTable> {
  $$SitesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get branchName => $composableBuilder(
      column: $table.branchName, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get address => $composableBuilder(
      column: $table.address, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get latitude => $composableBuilder(
      column: $table.latitude, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get longitude => $composableBuilder(
      column: $table.longitude, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get region => $composableBuilder(
      column: $table.region, builder: (column) => ColumnFilters(column));

  $$ClientsTableFilterComposer get clientId {
    final $$ClientsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.clientId,
        referencedTable: $db.clients,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ClientsTableFilterComposer(
              $db: $db,
              $table: $db.clients,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$SitesTableOrderingComposer
    extends Composer<_$AppDatabase, $SitesTable> {
  $$SitesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get branchName => $composableBuilder(
      column: $table.branchName, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get address => $composableBuilder(
      column: $table.address, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get latitude => $composableBuilder(
      column: $table.latitude, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get longitude => $composableBuilder(
      column: $table.longitude, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get region => $composableBuilder(
      column: $table.region, builder: (column) => ColumnOrderings(column));

  $$ClientsTableOrderingComposer get clientId {
    final $$ClientsTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.clientId,
        referencedTable: $db.clients,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ClientsTableOrderingComposer(
              $db: $db,
              $table: $db.clients,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$SitesTableAnnotationComposer
    extends Composer<_$AppDatabase, $SitesTable> {
  $$SitesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get branchName => $composableBuilder(
      column: $table.branchName, builder: (column) => column);

  GeneratedColumn<String> get address =>
      $composableBuilder(column: $table.address, builder: (column) => column);

  GeneratedColumn<double> get latitude =>
      $composableBuilder(column: $table.latitude, builder: (column) => column);

  GeneratedColumn<double> get longitude =>
      $composableBuilder(column: $table.longitude, builder: (column) => column);

  GeneratedColumn<String> get region =>
      $composableBuilder(column: $table.region, builder: (column) => column);

  $$ClientsTableAnnotationComposer get clientId {
    final $$ClientsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.clientId,
        referencedTable: $db.clients,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ClientsTableAnnotationComposer(
              $db: $db,
              $table: $db.clients,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$SitesTableTableManager extends RootTableManager<
    _$AppDatabase,
    $SitesTable,
    Site,
    $$SitesTableFilterComposer,
    $$SitesTableOrderingComposer,
    $$SitesTableAnnotationComposer,
    $$SitesTableCreateCompanionBuilder,
    $$SitesTableUpdateCompanionBuilder,
    (Site, $$SitesTableReferences),
    Site,
    PrefetchHooks Function({bool clientId})> {
  $$SitesTableTableManager(_$AppDatabase db, $SitesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SitesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SitesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SitesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<int> clientId = const Value.absent(),
            Value<String> branchName = const Value.absent(),
            Value<String> address = const Value.absent(),
            Value<double> latitude = const Value.absent(),
            Value<double> longitude = const Value.absent(),
            Value<String> region = const Value.absent(),
          }) =>
              SitesCompanion(
            id: id,
            clientId: clientId,
            branchName: branchName,
            address: address,
            latitude: latitude,
            longitude: longitude,
            region: region,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required int clientId,
            required String branchName,
            required String address,
            required double latitude,
            required double longitude,
            required String region,
          }) =>
              SitesCompanion.insert(
            id: id,
            clientId: clientId,
            branchName: branchName,
            address: address,
            latitude: latitude,
            longitude: longitude,
            region: region,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) =>
                  (e.readTable(table), $$SitesTableReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: ({clientId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins: <
                  T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic>>(state) {
                if (clientId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.clientId,
                    referencedTable: $$SitesTableReferences._clientIdTable(db),
                    referencedColumn:
                        $$SitesTableReferences._clientIdTable(db).id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ));
}

typedef $$SitesTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $SitesTable,
    Site,
    $$SitesTableFilterComposer,
    $$SitesTableOrderingComposer,
    $$SitesTableAnnotationComposer,
    $$SitesTableCreateCompanionBuilder,
    $$SitesTableUpdateCompanionBuilder,
    (Site, $$SitesTableReferences),
    Site,
    PrefetchHooks Function({bool clientId})>;
typedef $$StartingPointsTableCreateCompanionBuilder = StartingPointsCompanion
    Function({
  Value<int> id,
  required String name,
  required double latitude,
  required double longitude,
});
typedef $$StartingPointsTableUpdateCompanionBuilder = StartingPointsCompanion
    Function({
  Value<int> id,
  Value<String> name,
  Value<double> latitude,
  Value<double> longitude,
});

class $$StartingPointsTableFilterComposer
    extends Composer<_$AppDatabase, $StartingPointsTable> {
  $$StartingPointsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get latitude => $composableBuilder(
      column: $table.latitude, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get longitude => $composableBuilder(
      column: $table.longitude, builder: (column) => ColumnFilters(column));
}

class $$StartingPointsTableOrderingComposer
    extends Composer<_$AppDatabase, $StartingPointsTable> {
  $$StartingPointsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get latitude => $composableBuilder(
      column: $table.latitude, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get longitude => $composableBuilder(
      column: $table.longitude, builder: (column) => ColumnOrderings(column));
}

class $$StartingPointsTableAnnotationComposer
    extends Composer<_$AppDatabase, $StartingPointsTable> {
  $$StartingPointsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<double> get latitude =>
      $composableBuilder(column: $table.latitude, builder: (column) => column);

  GeneratedColumn<double> get longitude =>
      $composableBuilder(column: $table.longitude, builder: (column) => column);
}

class $$StartingPointsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $StartingPointsTable,
    StartingPoint,
    $$StartingPointsTableFilterComposer,
    $$StartingPointsTableOrderingComposer,
    $$StartingPointsTableAnnotationComposer,
    $$StartingPointsTableCreateCompanionBuilder,
    $$StartingPointsTableUpdateCompanionBuilder,
    (
      StartingPoint,
      BaseReferences<_$AppDatabase, $StartingPointsTable, StartingPoint>
    ),
    StartingPoint,
    PrefetchHooks Function()> {
  $$StartingPointsTableTableManager(
      _$AppDatabase db, $StartingPointsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$StartingPointsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$StartingPointsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$StartingPointsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<double> latitude = const Value.absent(),
            Value<double> longitude = const Value.absent(),
          }) =>
              StartingPointsCompanion(
            id: id,
            name: name,
            latitude: latitude,
            longitude: longitude,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String name,
            required double latitude,
            required double longitude,
          }) =>
              StartingPointsCompanion.insert(
            id: id,
            name: name,
            latitude: latitude,
            longitude: longitude,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$StartingPointsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $StartingPointsTable,
    StartingPoint,
    $$StartingPointsTableFilterComposer,
    $$StartingPointsTableOrderingComposer,
    $$StartingPointsTableAnnotationComposer,
    $$StartingPointsTableCreateCompanionBuilder,
    $$StartingPointsTableUpdateCompanionBuilder,
    (
      StartingPoint,
      BaseReferences<_$AppDatabase, $StartingPointsTable, StartingPoint>
    ),
    StartingPoint,
    PrefetchHooks Function()>;
typedef $$UsersTableCreateCompanionBuilder = UsersCompanion Function({
  Value<int> id,
  required String username,
  required String fullName,
  required String email,
  required String role,
  Value<String> password,
  Value<DateTime?> dateOfBirth,
  Value<String?> location,
  Value<String?> phoneNumber,
  Value<String?> bio,
  Value<DateTime> createdAt,
  Value<String?> windowsSid,
  Value<DateTime?> lastLoginAt,
  Value<int> loginCount,
});
typedef $$UsersTableUpdateCompanionBuilder = UsersCompanion Function({
  Value<int> id,
  Value<String> username,
  Value<String> fullName,
  Value<String> email,
  Value<String> role,
  Value<String> password,
  Value<DateTime?> dateOfBirth,
  Value<String?> location,
  Value<String?> phoneNumber,
  Value<String?> bio,
  Value<DateTime> createdAt,
  Value<String?> windowsSid,
  Value<DateTime?> lastLoginAt,
  Value<int> loginCount,
});

class $$UsersTableFilterComposer extends Composer<_$AppDatabase, $UsersTable> {
  $$UsersTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get username => $composableBuilder(
      column: $table.username, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get fullName => $composableBuilder(
      column: $table.fullName, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get email => $composableBuilder(
      column: $table.email, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get role => $composableBuilder(
      column: $table.role, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get password => $composableBuilder(
      column: $table.password, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get dateOfBirth => $composableBuilder(
      column: $table.dateOfBirth, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get location => $composableBuilder(
      column: $table.location, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get phoneNumber => $composableBuilder(
      column: $table.phoneNumber, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get bio => $composableBuilder(
      column: $table.bio, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get windowsSid => $composableBuilder(
      column: $table.windowsSid, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get lastLoginAt => $composableBuilder(
      column: $table.lastLoginAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get loginCount => $composableBuilder(
      column: $table.loginCount, builder: (column) => ColumnFilters(column));
}

class $$UsersTableOrderingComposer
    extends Composer<_$AppDatabase, $UsersTable> {
  $$UsersTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get username => $composableBuilder(
      column: $table.username, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get fullName => $composableBuilder(
      column: $table.fullName, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get email => $composableBuilder(
      column: $table.email, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get role => $composableBuilder(
      column: $table.role, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get password => $composableBuilder(
      column: $table.password, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get dateOfBirth => $composableBuilder(
      column: $table.dateOfBirth, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get location => $composableBuilder(
      column: $table.location, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get phoneNumber => $composableBuilder(
      column: $table.phoneNumber, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get bio => $composableBuilder(
      column: $table.bio, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get windowsSid => $composableBuilder(
      column: $table.windowsSid, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get lastLoginAt => $composableBuilder(
      column: $table.lastLoginAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get loginCount => $composableBuilder(
      column: $table.loginCount, builder: (column) => ColumnOrderings(column));
}

class $$UsersTableAnnotationComposer
    extends Composer<_$AppDatabase, $UsersTable> {
  $$UsersTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get username =>
      $composableBuilder(column: $table.username, builder: (column) => column);

  GeneratedColumn<String> get fullName =>
      $composableBuilder(column: $table.fullName, builder: (column) => column);

  GeneratedColumn<String> get email =>
      $composableBuilder(column: $table.email, builder: (column) => column);

  GeneratedColumn<String> get role =>
      $composableBuilder(column: $table.role, builder: (column) => column);

  GeneratedColumn<String> get password =>
      $composableBuilder(column: $table.password, builder: (column) => column);

  GeneratedColumn<DateTime> get dateOfBirth => $composableBuilder(
      column: $table.dateOfBirth, builder: (column) => column);

  GeneratedColumn<String> get location =>
      $composableBuilder(column: $table.location, builder: (column) => column);

  GeneratedColumn<String> get phoneNumber => $composableBuilder(
      column: $table.phoneNumber, builder: (column) => column);

  GeneratedColumn<String> get bio =>
      $composableBuilder(column: $table.bio, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<String> get windowsSid => $composableBuilder(
      column: $table.windowsSid, builder: (column) => column);

  GeneratedColumn<DateTime> get lastLoginAt => $composableBuilder(
      column: $table.lastLoginAt, builder: (column) => column);

  GeneratedColumn<int> get loginCount => $composableBuilder(
      column: $table.loginCount, builder: (column) => column);
}

class $$UsersTableTableManager extends RootTableManager<
    _$AppDatabase,
    $UsersTable,
    User,
    $$UsersTableFilterComposer,
    $$UsersTableOrderingComposer,
    $$UsersTableAnnotationComposer,
    $$UsersTableCreateCompanionBuilder,
    $$UsersTableUpdateCompanionBuilder,
    (User, BaseReferences<_$AppDatabase, $UsersTable, User>),
    User,
    PrefetchHooks Function()> {
  $$UsersTableTableManager(_$AppDatabase db, $UsersTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$UsersTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$UsersTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$UsersTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> username = const Value.absent(),
            Value<String> fullName = const Value.absent(),
            Value<String> email = const Value.absent(),
            Value<String> role = const Value.absent(),
            Value<String> password = const Value.absent(),
            Value<DateTime?> dateOfBirth = const Value.absent(),
            Value<String?> location = const Value.absent(),
            Value<String?> phoneNumber = const Value.absent(),
            Value<String?> bio = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<String?> windowsSid = const Value.absent(),
            Value<DateTime?> lastLoginAt = const Value.absent(),
            Value<int> loginCount = const Value.absent(),
          }) =>
              UsersCompanion(
            id: id,
            username: username,
            fullName: fullName,
            email: email,
            role: role,
            password: password,
            dateOfBirth: dateOfBirth,
            location: location,
            phoneNumber: phoneNumber,
            bio: bio,
            createdAt: createdAt,
            windowsSid: windowsSid,
            lastLoginAt: lastLoginAt,
            loginCount: loginCount,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String username,
            required String fullName,
            required String email,
            required String role,
            Value<String> password = const Value.absent(),
            Value<DateTime?> dateOfBirth = const Value.absent(),
            Value<String?> location = const Value.absent(),
            Value<String?> phoneNumber = const Value.absent(),
            Value<String?> bio = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<String?> windowsSid = const Value.absent(),
            Value<DateTime?> lastLoginAt = const Value.absent(),
            Value<int> loginCount = const Value.absent(),
          }) =>
              UsersCompanion.insert(
            id: id,
            username: username,
            fullName: fullName,
            email: email,
            role: role,
            password: password,
            dateOfBirth: dateOfBirth,
            location: location,
            phoneNumber: phoneNumber,
            bio: bio,
            createdAt: createdAt,
            windowsSid: windowsSid,
            lastLoginAt: lastLoginAt,
            loginCount: loginCount,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$UsersTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $UsersTable,
    User,
    $$UsersTableFilterComposer,
    $$UsersTableOrderingComposer,
    $$UsersTableAnnotationComposer,
    $$UsersTableCreateCompanionBuilder,
    $$UsersTableUpdateCompanionBuilder,
    (User, BaseReferences<_$AppDatabase, $UsersTable, User>),
    User,
    PrefetchHooks Function()>;
typedef $$WeatherSnapshotTableCreateCompanionBuilder = WeatherSnapshotCompanion
    Function({
  Value<int> id,
  required String region,
  required int temperature,
  required String condition,
  required DateTime fetchedAt,
  required String source,
  Value<String?> zipCode,
});
typedef $$WeatherSnapshotTableUpdateCompanionBuilder = WeatherSnapshotCompanion
    Function({
  Value<int> id,
  Value<String> region,
  Value<int> temperature,
  Value<String> condition,
  Value<DateTime> fetchedAt,
  Value<String> source,
  Value<String?> zipCode,
});

class $$WeatherSnapshotTableFilterComposer
    extends Composer<_$AppDatabase, $WeatherSnapshotTable> {
  $$WeatherSnapshotTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get region => $composableBuilder(
      column: $table.region, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get temperature => $composableBuilder(
      column: $table.temperature, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get condition => $composableBuilder(
      column: $table.condition, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get fetchedAt => $composableBuilder(
      column: $table.fetchedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get source => $composableBuilder(
      column: $table.source, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get zipCode => $composableBuilder(
      column: $table.zipCode, builder: (column) => ColumnFilters(column));
}

class $$WeatherSnapshotTableOrderingComposer
    extends Composer<_$AppDatabase, $WeatherSnapshotTable> {
  $$WeatherSnapshotTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get region => $composableBuilder(
      column: $table.region, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get temperature => $composableBuilder(
      column: $table.temperature, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get condition => $composableBuilder(
      column: $table.condition, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get fetchedAt => $composableBuilder(
      column: $table.fetchedAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get source => $composableBuilder(
      column: $table.source, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get zipCode => $composableBuilder(
      column: $table.zipCode, builder: (column) => ColumnOrderings(column));
}

class $$WeatherSnapshotTableAnnotationComposer
    extends Composer<_$AppDatabase, $WeatherSnapshotTable> {
  $$WeatherSnapshotTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get region =>
      $composableBuilder(column: $table.region, builder: (column) => column);

  GeneratedColumn<int> get temperature => $composableBuilder(
      column: $table.temperature, builder: (column) => column);

  GeneratedColumn<String> get condition =>
      $composableBuilder(column: $table.condition, builder: (column) => column);

  GeneratedColumn<DateTime> get fetchedAt =>
      $composableBuilder(column: $table.fetchedAt, builder: (column) => column);

  GeneratedColumn<String> get source =>
      $composableBuilder(column: $table.source, builder: (column) => column);

  GeneratedColumn<String> get zipCode =>
      $composableBuilder(column: $table.zipCode, builder: (column) => column);
}

class $$WeatherSnapshotTableTableManager extends RootTableManager<
    _$AppDatabase,
    $WeatherSnapshotTable,
    WeatherSnapshotData,
    $$WeatherSnapshotTableFilterComposer,
    $$WeatherSnapshotTableOrderingComposer,
    $$WeatherSnapshotTableAnnotationComposer,
    $$WeatherSnapshotTableCreateCompanionBuilder,
    $$WeatherSnapshotTableUpdateCompanionBuilder,
    (
      WeatherSnapshotData,
      BaseReferences<_$AppDatabase, $WeatherSnapshotTable, WeatherSnapshotData>
    ),
    WeatherSnapshotData,
    PrefetchHooks Function()> {
  $$WeatherSnapshotTableTableManager(
      _$AppDatabase db, $WeatherSnapshotTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$WeatherSnapshotTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$WeatherSnapshotTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$WeatherSnapshotTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> region = const Value.absent(),
            Value<int> temperature = const Value.absent(),
            Value<String> condition = const Value.absent(),
            Value<DateTime> fetchedAt = const Value.absent(),
            Value<String> source = const Value.absent(),
            Value<String?> zipCode = const Value.absent(),
          }) =>
              WeatherSnapshotCompanion(
            id: id,
            region: region,
            temperature: temperature,
            condition: condition,
            fetchedAt: fetchedAt,
            source: source,
            zipCode: zipCode,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String region,
            required int temperature,
            required String condition,
            required DateTime fetchedAt,
            required String source,
            Value<String?> zipCode = const Value.absent(),
          }) =>
              WeatherSnapshotCompanion.insert(
            id: id,
            region: region,
            temperature: temperature,
            condition: condition,
            fetchedAt: fetchedAt,
            source: source,
            zipCode: zipCode,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$WeatherSnapshotTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $WeatherSnapshotTable,
    WeatherSnapshotData,
    $$WeatherSnapshotTableFilterComposer,
    $$WeatherSnapshotTableOrderingComposer,
    $$WeatherSnapshotTableAnnotationComposer,
    $$WeatherSnapshotTableCreateCompanionBuilder,
    $$WeatherSnapshotTableUpdateCompanionBuilder,
    (
      WeatherSnapshotData,
      BaseReferences<_$AppDatabase, $WeatherSnapshotTable, WeatherSnapshotData>
    ),
    WeatherSnapshotData,
    PrefetchHooks Function()>;
typedef $$TrafficSnapshotTableCreateCompanionBuilder = TrafficSnapshotCompanion
    Function({
  Value<int> id,
  required String routeLabel,
  required int etaMinutes,
  required String conditionLabel,
  required DateTime fetchedAt,
  required String source,
});
typedef $$TrafficSnapshotTableUpdateCompanionBuilder = TrafficSnapshotCompanion
    Function({
  Value<int> id,
  Value<String> routeLabel,
  Value<int> etaMinutes,
  Value<String> conditionLabel,
  Value<DateTime> fetchedAt,
  Value<String> source,
});

class $$TrafficSnapshotTableFilterComposer
    extends Composer<_$AppDatabase, $TrafficSnapshotTable> {
  $$TrafficSnapshotTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get routeLabel => $composableBuilder(
      column: $table.routeLabel, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get etaMinutes => $composableBuilder(
      column: $table.etaMinutes, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get conditionLabel => $composableBuilder(
      column: $table.conditionLabel,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get fetchedAt => $composableBuilder(
      column: $table.fetchedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get source => $composableBuilder(
      column: $table.source, builder: (column) => ColumnFilters(column));
}

class $$TrafficSnapshotTableOrderingComposer
    extends Composer<_$AppDatabase, $TrafficSnapshotTable> {
  $$TrafficSnapshotTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get routeLabel => $composableBuilder(
      column: $table.routeLabel, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get etaMinutes => $composableBuilder(
      column: $table.etaMinutes, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get conditionLabel => $composableBuilder(
      column: $table.conditionLabel,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get fetchedAt => $composableBuilder(
      column: $table.fetchedAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get source => $composableBuilder(
      column: $table.source, builder: (column) => ColumnOrderings(column));
}

class $$TrafficSnapshotTableAnnotationComposer
    extends Composer<_$AppDatabase, $TrafficSnapshotTable> {
  $$TrafficSnapshotTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get routeLabel => $composableBuilder(
      column: $table.routeLabel, builder: (column) => column);

  GeneratedColumn<int> get etaMinutes => $composableBuilder(
      column: $table.etaMinutes, builder: (column) => column);

  GeneratedColumn<String> get conditionLabel => $composableBuilder(
      column: $table.conditionLabel, builder: (column) => column);

  GeneratedColumn<DateTime> get fetchedAt =>
      $composableBuilder(column: $table.fetchedAt, builder: (column) => column);

  GeneratedColumn<String> get source =>
      $composableBuilder(column: $table.source, builder: (column) => column);
}

class $$TrafficSnapshotTableTableManager extends RootTableManager<
    _$AppDatabase,
    $TrafficSnapshotTable,
    TrafficSnapshotData,
    $$TrafficSnapshotTableFilterComposer,
    $$TrafficSnapshotTableOrderingComposer,
    $$TrafficSnapshotTableAnnotationComposer,
    $$TrafficSnapshotTableCreateCompanionBuilder,
    $$TrafficSnapshotTableUpdateCompanionBuilder,
    (
      TrafficSnapshotData,
      BaseReferences<_$AppDatabase, $TrafficSnapshotTable, TrafficSnapshotData>
    ),
    TrafficSnapshotData,
    PrefetchHooks Function()> {
  $$TrafficSnapshotTableTableManager(
      _$AppDatabase db, $TrafficSnapshotTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TrafficSnapshotTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TrafficSnapshotTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TrafficSnapshotTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> routeLabel = const Value.absent(),
            Value<int> etaMinutes = const Value.absent(),
            Value<String> conditionLabel = const Value.absent(),
            Value<DateTime> fetchedAt = const Value.absent(),
            Value<String> source = const Value.absent(),
          }) =>
              TrafficSnapshotCompanion(
            id: id,
            routeLabel: routeLabel,
            etaMinutes: etaMinutes,
            conditionLabel: conditionLabel,
            fetchedAt: fetchedAt,
            source: source,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String routeLabel,
            required int etaMinutes,
            required String conditionLabel,
            required DateTime fetchedAt,
            required String source,
          }) =>
              TrafficSnapshotCompanion.insert(
            id: id,
            routeLabel: routeLabel,
            etaMinutes: etaMinutes,
            conditionLabel: conditionLabel,
            fetchedAt: fetchedAt,
            source: source,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$TrafficSnapshotTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $TrafficSnapshotTable,
    TrafficSnapshotData,
    $$TrafficSnapshotTableFilterComposer,
    $$TrafficSnapshotTableOrderingComposer,
    $$TrafficSnapshotTableAnnotationComposer,
    $$TrafficSnapshotTableCreateCompanionBuilder,
    $$TrafficSnapshotTableUpdateCompanionBuilder,
    (
      TrafficSnapshotData,
      BaseReferences<_$AppDatabase, $TrafficSnapshotTable, TrafficSnapshotData>
    ),
    TrafficSnapshotData,
    PrefetchHooks Function()>;
typedef $$WorkCallsTableCreateCompanionBuilder = WorkCallsCompanion Function({
  Value<int> id,
  required String status,
  Value<DateTime?> scheduledAt,
  Value<DateTime?> completedAt,
  Value<String?> workOrderNumber,
});
typedef $$WorkCallsTableUpdateCompanionBuilder = WorkCallsCompanion Function({
  Value<int> id,
  Value<String> status,
  Value<DateTime?> scheduledAt,
  Value<DateTime?> completedAt,
  Value<String?> workOrderNumber,
});

class $$WorkCallsTableFilterComposer
    extends Composer<_$AppDatabase, $WorkCallsTable> {
  $$WorkCallsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get scheduledAt => $composableBuilder(
      column: $table.scheduledAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get completedAt => $composableBuilder(
      column: $table.completedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get workOrderNumber => $composableBuilder(
      column: $table.workOrderNumber,
      builder: (column) => ColumnFilters(column));
}

class $$WorkCallsTableOrderingComposer
    extends Composer<_$AppDatabase, $WorkCallsTable> {
  $$WorkCallsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get scheduledAt => $composableBuilder(
      column: $table.scheduledAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get completedAt => $composableBuilder(
      column: $table.completedAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get workOrderNumber => $composableBuilder(
      column: $table.workOrderNumber,
      builder: (column) => ColumnOrderings(column));
}

class $$WorkCallsTableAnnotationComposer
    extends Composer<_$AppDatabase, $WorkCallsTable> {
  $$WorkCallsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<DateTime> get scheduledAt => $composableBuilder(
      column: $table.scheduledAt, builder: (column) => column);

  GeneratedColumn<DateTime> get completedAt => $composableBuilder(
      column: $table.completedAt, builder: (column) => column);

  GeneratedColumn<String> get workOrderNumber => $composableBuilder(
      column: $table.workOrderNumber, builder: (column) => column);
}

class $$WorkCallsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $WorkCallsTable,
    WorkCall,
    $$WorkCallsTableFilterComposer,
    $$WorkCallsTableOrderingComposer,
    $$WorkCallsTableAnnotationComposer,
    $$WorkCallsTableCreateCompanionBuilder,
    $$WorkCallsTableUpdateCompanionBuilder,
    (WorkCall, BaseReferences<_$AppDatabase, $WorkCallsTable, WorkCall>),
    WorkCall,
    PrefetchHooks Function()> {
  $$WorkCallsTableTableManager(_$AppDatabase db, $WorkCallsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$WorkCallsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$WorkCallsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$WorkCallsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> status = const Value.absent(),
            Value<DateTime?> scheduledAt = const Value.absent(),
            Value<DateTime?> completedAt = const Value.absent(),
            Value<String?> workOrderNumber = const Value.absent(),
          }) =>
              WorkCallsCompanion(
            id: id,
            status: status,
            scheduledAt: scheduledAt,
            completedAt: completedAt,
            workOrderNumber: workOrderNumber,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String status,
            Value<DateTime?> scheduledAt = const Value.absent(),
            Value<DateTime?> completedAt = const Value.absent(),
            Value<String?> workOrderNumber = const Value.absent(),
          }) =>
              WorkCallsCompanion.insert(
            id: id,
            status: status,
            scheduledAt: scheduledAt,
            completedAt: completedAt,
            workOrderNumber: workOrderNumber,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$WorkCallsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $WorkCallsTable,
    WorkCall,
    $$WorkCallsTableFilterComposer,
    $$WorkCallsTableOrderingComposer,
    $$WorkCallsTableAnnotationComposer,
    $$WorkCallsTableCreateCompanionBuilder,
    $$WorkCallsTableUpdateCompanionBuilder,
    (WorkCall, BaseReferences<_$AppDatabase, $WorkCallsTable, WorkCall>),
    WorkCall,
    PrefetchHooks Function()>;
typedef $$IndustryBriefingTableCreateCompanionBuilder
    = IndustryBriefingCompanion Function({
  Value<int> id,
  required String title,
  required String source,
  Value<String?> previewImage,
  required DateTime publishedAt,
  required DateTime fetchedAt,
});
typedef $$IndustryBriefingTableUpdateCompanionBuilder
    = IndustryBriefingCompanion Function({
  Value<int> id,
  Value<String> title,
  Value<String> source,
  Value<String?> previewImage,
  Value<DateTime> publishedAt,
  Value<DateTime> fetchedAt,
});

class $$IndustryBriefingTableFilterComposer
    extends Composer<_$AppDatabase, $IndustryBriefingTable> {
  $$IndustryBriefingTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get title => $composableBuilder(
      column: $table.title, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get source => $composableBuilder(
      column: $table.source, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get previewImage => $composableBuilder(
      column: $table.previewImage, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get publishedAt => $composableBuilder(
      column: $table.publishedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get fetchedAt => $composableBuilder(
      column: $table.fetchedAt, builder: (column) => ColumnFilters(column));
}

class $$IndustryBriefingTableOrderingComposer
    extends Composer<_$AppDatabase, $IndustryBriefingTable> {
  $$IndustryBriefingTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get title => $composableBuilder(
      column: $table.title, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get source => $composableBuilder(
      column: $table.source, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get previewImage => $composableBuilder(
      column: $table.previewImage,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get publishedAt => $composableBuilder(
      column: $table.publishedAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get fetchedAt => $composableBuilder(
      column: $table.fetchedAt, builder: (column) => ColumnOrderings(column));
}

class $$IndustryBriefingTableAnnotationComposer
    extends Composer<_$AppDatabase, $IndustryBriefingTable> {
  $$IndustryBriefingTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get source =>
      $composableBuilder(column: $table.source, builder: (column) => column);

  GeneratedColumn<String> get previewImage => $composableBuilder(
      column: $table.previewImage, builder: (column) => column);

  GeneratedColumn<DateTime> get publishedAt => $composableBuilder(
      column: $table.publishedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get fetchedAt =>
      $composableBuilder(column: $table.fetchedAt, builder: (column) => column);
}

class $$IndustryBriefingTableTableManager extends RootTableManager<
    _$AppDatabase,
    $IndustryBriefingTable,
    IndustryBriefingData,
    $$IndustryBriefingTableFilterComposer,
    $$IndustryBriefingTableOrderingComposer,
    $$IndustryBriefingTableAnnotationComposer,
    $$IndustryBriefingTableCreateCompanionBuilder,
    $$IndustryBriefingTableUpdateCompanionBuilder,
    (
      IndustryBriefingData,
      BaseReferences<_$AppDatabase, $IndustryBriefingTable,
          IndustryBriefingData>
    ),
    IndustryBriefingData,
    PrefetchHooks Function()> {
  $$IndustryBriefingTableTableManager(
      _$AppDatabase db, $IndustryBriefingTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$IndustryBriefingTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$IndustryBriefingTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$IndustryBriefingTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> title = const Value.absent(),
            Value<String> source = const Value.absent(),
            Value<String?> previewImage = const Value.absent(),
            Value<DateTime> publishedAt = const Value.absent(),
            Value<DateTime> fetchedAt = const Value.absent(),
          }) =>
              IndustryBriefingCompanion(
            id: id,
            title: title,
            source: source,
            previewImage: previewImage,
            publishedAt: publishedAt,
            fetchedAt: fetchedAt,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String title,
            required String source,
            Value<String?> previewImage = const Value.absent(),
            required DateTime publishedAt,
            required DateTime fetchedAt,
          }) =>
              IndustryBriefingCompanion.insert(
            id: id,
            title: title,
            source: source,
            previewImage: previewImage,
            publishedAt: publishedAt,
            fetchedAt: fetchedAt,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$IndustryBriefingTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $IndustryBriefingTable,
    IndustryBriefingData,
    $$IndustryBriefingTableFilterComposer,
    $$IndustryBriefingTableOrderingComposer,
    $$IndustryBriefingTableAnnotationComposer,
    $$IndustryBriefingTableCreateCompanionBuilder,
    $$IndustryBriefingTableUpdateCompanionBuilder,
    (
      IndustryBriefingData,
      BaseReferences<_$AppDatabase, $IndustryBriefingTable,
          IndustryBriefingData>
    ),
    IndustryBriefingData,
    PrefetchHooks Function()>;
typedef $$CompanyAnnouncementsTableCreateCompanionBuilder
    = CompanyAnnouncementsCompanion Function({
  Value<int> id,
  required String category,
  required String title,
  required String body,
  Value<String?> actionLabel,
  Value<bool> active,
  required DateTime publishedAt,
  Value<bool> acknowledged,
  Value<DateTime?> acknowledgedAt,
});
typedef $$CompanyAnnouncementsTableUpdateCompanionBuilder
    = CompanyAnnouncementsCompanion Function({
  Value<int> id,
  Value<String> category,
  Value<String> title,
  Value<String> body,
  Value<String?> actionLabel,
  Value<bool> active,
  Value<DateTime> publishedAt,
  Value<bool> acknowledged,
  Value<DateTime?> acknowledgedAt,
});

class $$CompanyAnnouncementsTableFilterComposer
    extends Composer<_$AppDatabase, $CompanyAnnouncementsTable> {
  $$CompanyAnnouncementsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get category => $composableBuilder(
      column: $table.category, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get title => $composableBuilder(
      column: $table.title, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get body => $composableBuilder(
      column: $table.body, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get actionLabel => $composableBuilder(
      column: $table.actionLabel, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get active => $composableBuilder(
      column: $table.active, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get publishedAt => $composableBuilder(
      column: $table.publishedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get acknowledged => $composableBuilder(
      column: $table.acknowledged, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get acknowledgedAt => $composableBuilder(
      column: $table.acknowledgedAt,
      builder: (column) => ColumnFilters(column));
}

class $$CompanyAnnouncementsTableOrderingComposer
    extends Composer<_$AppDatabase, $CompanyAnnouncementsTable> {
  $$CompanyAnnouncementsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get category => $composableBuilder(
      column: $table.category, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get title => $composableBuilder(
      column: $table.title, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get body => $composableBuilder(
      column: $table.body, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get actionLabel => $composableBuilder(
      column: $table.actionLabel, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get active => $composableBuilder(
      column: $table.active, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get publishedAt => $composableBuilder(
      column: $table.publishedAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get acknowledged => $composableBuilder(
      column: $table.acknowledged,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get acknowledgedAt => $composableBuilder(
      column: $table.acknowledgedAt,
      builder: (column) => ColumnOrderings(column));
}

class $$CompanyAnnouncementsTableAnnotationComposer
    extends Composer<_$AppDatabase, $CompanyAnnouncementsTable> {
  $$CompanyAnnouncementsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get category =>
      $composableBuilder(column: $table.category, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get body =>
      $composableBuilder(column: $table.body, builder: (column) => column);

  GeneratedColumn<String> get actionLabel => $composableBuilder(
      column: $table.actionLabel, builder: (column) => column);

  GeneratedColumn<bool> get active =>
      $composableBuilder(column: $table.active, builder: (column) => column);

  GeneratedColumn<DateTime> get publishedAt => $composableBuilder(
      column: $table.publishedAt, builder: (column) => column);

  GeneratedColumn<bool> get acknowledged => $composableBuilder(
      column: $table.acknowledged, builder: (column) => column);

  GeneratedColumn<DateTime> get acknowledgedAt => $composableBuilder(
      column: $table.acknowledgedAt, builder: (column) => column);
}

class $$CompanyAnnouncementsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $CompanyAnnouncementsTable,
    CompanyAnnouncement,
    $$CompanyAnnouncementsTableFilterComposer,
    $$CompanyAnnouncementsTableOrderingComposer,
    $$CompanyAnnouncementsTableAnnotationComposer,
    $$CompanyAnnouncementsTableCreateCompanionBuilder,
    $$CompanyAnnouncementsTableUpdateCompanionBuilder,
    (
      CompanyAnnouncement,
      BaseReferences<_$AppDatabase, $CompanyAnnouncementsTable,
          CompanyAnnouncement>
    ),
    CompanyAnnouncement,
    PrefetchHooks Function()> {
  $$CompanyAnnouncementsTableTableManager(
      _$AppDatabase db, $CompanyAnnouncementsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CompanyAnnouncementsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CompanyAnnouncementsTableOrderingComposer(
                  $db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CompanyAnnouncementsTableAnnotationComposer(
                  $db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> category = const Value.absent(),
            Value<String> title = const Value.absent(),
            Value<String> body = const Value.absent(),
            Value<String?> actionLabel = const Value.absent(),
            Value<bool> active = const Value.absent(),
            Value<DateTime> publishedAt = const Value.absent(),
            Value<bool> acknowledged = const Value.absent(),
            Value<DateTime?> acknowledgedAt = const Value.absent(),
          }) =>
              CompanyAnnouncementsCompanion(
            id: id,
            category: category,
            title: title,
            body: body,
            actionLabel: actionLabel,
            active: active,
            publishedAt: publishedAt,
            acknowledged: acknowledged,
            acknowledgedAt: acknowledgedAt,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String category,
            required String title,
            required String body,
            Value<String?> actionLabel = const Value.absent(),
            Value<bool> active = const Value.absent(),
            required DateTime publishedAt,
            Value<bool> acknowledged = const Value.absent(),
            Value<DateTime?> acknowledgedAt = const Value.absent(),
          }) =>
              CompanyAnnouncementsCompanion.insert(
            id: id,
            category: category,
            title: title,
            body: body,
            actionLabel: actionLabel,
            active: active,
            publishedAt: publishedAt,
            acknowledged: acknowledged,
            acknowledgedAt: acknowledgedAt,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$CompanyAnnouncementsTableProcessedTableManager
    = ProcessedTableManager<
        _$AppDatabase,
        $CompanyAnnouncementsTable,
        CompanyAnnouncement,
        $$CompanyAnnouncementsTableFilterComposer,
        $$CompanyAnnouncementsTableOrderingComposer,
        $$CompanyAnnouncementsTableAnnotationComposer,
        $$CompanyAnnouncementsTableCreateCompanionBuilder,
        $$CompanyAnnouncementsTableUpdateCompanionBuilder,
        (
          CompanyAnnouncement,
          BaseReferences<_$AppDatabase, $CompanyAnnouncementsTable,
              CompanyAnnouncement>
        ),
        CompanyAnnouncement,
        PrefetchHooks Function()>;
typedef $$WorkOrdersTableCreateCompanionBuilder = WorkOrdersCompanion Function({
  Value<int> id,
  required int siteId,
  required String status,
  Value<String?> priority,
  Value<String?> descriptionOfWork,
  Value<String?> internalNotes,
  required DateTime createdAt,
  Value<DateTime?> closedAt,
  Value<String?> createdBy,
  Value<String?> assignedTechnician,
  Value<String?> completionNotes,
  Value<String?> resolution,
  Value<bool> repeatIssue,
  Value<String?> previousStatus,
  Value<int?> statusChangedBy,
  Value<DateTime?> statusChangedAt,
  Value<String> workflowState,
  Value<String?> approvalStatus,
  Value<int?> approvedBy,
  Value<DateTime?> approvedAt,
  Value<int> version,
  Value<DateTime?> expectedDate,
  Value<int?> expectedDurationMinutes,
  Value<String?> contactPerson,
  Value<String?> contactPhone,
  Value<String?> contactEmail,
  Value<String?> billingContactName,
  Value<String?> billingContactEmail,
  Value<String?> billingAddress,
  Value<String?> copsAccount,
  Value<String?> cmsAccount,
  Value<String?> alarmNetAccount,
  Value<String?> ictAccount,
  Value<String?> alarmDotComAccount,
  Value<String?> telguardAccount,
  Value<String?> openEyeLicense,
  Value<bool> onServiceContract,
  Value<String?> contractType,
  Value<String?> referenceNumber,
  Value<String?> poNumber,
});
typedef $$WorkOrdersTableUpdateCompanionBuilder = WorkOrdersCompanion Function({
  Value<int> id,
  Value<int> siteId,
  Value<String> status,
  Value<String?> priority,
  Value<String?> descriptionOfWork,
  Value<String?> internalNotes,
  Value<DateTime> createdAt,
  Value<DateTime?> closedAt,
  Value<String?> createdBy,
  Value<String?> assignedTechnician,
  Value<String?> completionNotes,
  Value<String?> resolution,
  Value<bool> repeatIssue,
  Value<String?> previousStatus,
  Value<int?> statusChangedBy,
  Value<DateTime?> statusChangedAt,
  Value<String> workflowState,
  Value<String?> approvalStatus,
  Value<int?> approvedBy,
  Value<DateTime?> approvedAt,
  Value<int> version,
  Value<DateTime?> expectedDate,
  Value<int?> expectedDurationMinutes,
  Value<String?> contactPerson,
  Value<String?> contactPhone,
  Value<String?> contactEmail,
  Value<String?> billingContactName,
  Value<String?> billingContactEmail,
  Value<String?> billingAddress,
  Value<String?> copsAccount,
  Value<String?> cmsAccount,
  Value<String?> alarmNetAccount,
  Value<String?> ictAccount,
  Value<String?> alarmDotComAccount,
  Value<String?> telguardAccount,
  Value<String?> openEyeLicense,
  Value<bool> onServiceContract,
  Value<String?> contractType,
  Value<String?> referenceNumber,
  Value<String?> poNumber,
});

class $$WorkOrdersTableFilterComposer
    extends Composer<_$AppDatabase, $WorkOrdersTable> {
  $$WorkOrdersTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get siteId => $composableBuilder(
      column: $table.siteId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get priority => $composableBuilder(
      column: $table.priority, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get descriptionOfWork => $composableBuilder(
      column: $table.descriptionOfWork,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get internalNotes => $composableBuilder(
      column: $table.internalNotes, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get closedAt => $composableBuilder(
      column: $table.closedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get createdBy => $composableBuilder(
      column: $table.createdBy, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get assignedTechnician => $composableBuilder(
      column: $table.assignedTechnician,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get completionNotes => $composableBuilder(
      column: $table.completionNotes,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get resolution => $composableBuilder(
      column: $table.resolution, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get repeatIssue => $composableBuilder(
      column: $table.repeatIssue, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get previousStatus => $composableBuilder(
      column: $table.previousStatus,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get statusChangedBy => $composableBuilder(
      column: $table.statusChangedBy,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get statusChangedAt => $composableBuilder(
      column: $table.statusChangedAt,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get workflowState => $composableBuilder(
      column: $table.workflowState, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get approvalStatus => $composableBuilder(
      column: $table.approvalStatus,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get approvedBy => $composableBuilder(
      column: $table.approvedBy, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get approvedAt => $composableBuilder(
      column: $table.approvedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get version => $composableBuilder(
      column: $table.version, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get expectedDate => $composableBuilder(
      column: $table.expectedDate, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get expectedDurationMinutes => $composableBuilder(
      column: $table.expectedDurationMinutes,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get contactPerson => $composableBuilder(
      column: $table.contactPerson, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get contactPhone => $composableBuilder(
      column: $table.contactPhone, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get contactEmail => $composableBuilder(
      column: $table.contactEmail, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get billingContactName => $composableBuilder(
      column: $table.billingContactName,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get billingContactEmail => $composableBuilder(
      column: $table.billingContactEmail,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get billingAddress => $composableBuilder(
      column: $table.billingAddress,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get copsAccount => $composableBuilder(
      column: $table.copsAccount, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get cmsAccount => $composableBuilder(
      column: $table.cmsAccount, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get alarmNetAccount => $composableBuilder(
      column: $table.alarmNetAccount,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get ictAccount => $composableBuilder(
      column: $table.ictAccount, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get alarmDotComAccount => $composableBuilder(
      column: $table.alarmDotComAccount,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get telguardAccount => $composableBuilder(
      column: $table.telguardAccount,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get openEyeLicense => $composableBuilder(
      column: $table.openEyeLicense,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get onServiceContract => $composableBuilder(
      column: $table.onServiceContract,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get contractType => $composableBuilder(
      column: $table.contractType, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get referenceNumber => $composableBuilder(
      column: $table.referenceNumber,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get poNumber => $composableBuilder(
      column: $table.poNumber, builder: (column) => ColumnFilters(column));
}

class $$WorkOrdersTableOrderingComposer
    extends Composer<_$AppDatabase, $WorkOrdersTable> {
  $$WorkOrdersTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get siteId => $composableBuilder(
      column: $table.siteId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get priority => $composableBuilder(
      column: $table.priority, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get descriptionOfWork => $composableBuilder(
      column: $table.descriptionOfWork,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get internalNotes => $composableBuilder(
      column: $table.internalNotes,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get closedAt => $composableBuilder(
      column: $table.closedAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get createdBy => $composableBuilder(
      column: $table.createdBy, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get assignedTechnician => $composableBuilder(
      column: $table.assignedTechnician,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get completionNotes => $composableBuilder(
      column: $table.completionNotes,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get resolution => $composableBuilder(
      column: $table.resolution, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get repeatIssue => $composableBuilder(
      column: $table.repeatIssue, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get previousStatus => $composableBuilder(
      column: $table.previousStatus,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get statusChangedBy => $composableBuilder(
      column: $table.statusChangedBy,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get statusChangedAt => $composableBuilder(
      column: $table.statusChangedAt,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get workflowState => $composableBuilder(
      column: $table.workflowState,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get approvalStatus => $composableBuilder(
      column: $table.approvalStatus,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get approvedBy => $composableBuilder(
      column: $table.approvedBy, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get approvedAt => $composableBuilder(
      column: $table.approvedAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get version => $composableBuilder(
      column: $table.version, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get expectedDate => $composableBuilder(
      column: $table.expectedDate,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get expectedDurationMinutes => $composableBuilder(
      column: $table.expectedDurationMinutes,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get contactPerson => $composableBuilder(
      column: $table.contactPerson,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get contactPhone => $composableBuilder(
      column: $table.contactPhone,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get contactEmail => $composableBuilder(
      column: $table.contactEmail,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get billingContactName => $composableBuilder(
      column: $table.billingContactName,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get billingContactEmail => $composableBuilder(
      column: $table.billingContactEmail,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get billingAddress => $composableBuilder(
      column: $table.billingAddress,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get copsAccount => $composableBuilder(
      column: $table.copsAccount, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get cmsAccount => $composableBuilder(
      column: $table.cmsAccount, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get alarmNetAccount => $composableBuilder(
      column: $table.alarmNetAccount,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get ictAccount => $composableBuilder(
      column: $table.ictAccount, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get alarmDotComAccount => $composableBuilder(
      column: $table.alarmDotComAccount,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get telguardAccount => $composableBuilder(
      column: $table.telguardAccount,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get openEyeLicense => $composableBuilder(
      column: $table.openEyeLicense,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get onServiceContract => $composableBuilder(
      column: $table.onServiceContract,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get contractType => $composableBuilder(
      column: $table.contractType,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get referenceNumber => $composableBuilder(
      column: $table.referenceNumber,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get poNumber => $composableBuilder(
      column: $table.poNumber, builder: (column) => ColumnOrderings(column));
}

class $$WorkOrdersTableAnnotationComposer
    extends Composer<_$AppDatabase, $WorkOrdersTable> {
  $$WorkOrdersTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get siteId =>
      $composableBuilder(column: $table.siteId, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<String> get priority =>
      $composableBuilder(column: $table.priority, builder: (column) => column);

  GeneratedColumn<String> get descriptionOfWork => $composableBuilder(
      column: $table.descriptionOfWork, builder: (column) => column);

  GeneratedColumn<String> get internalNotes => $composableBuilder(
      column: $table.internalNotes, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get closedAt =>
      $composableBuilder(column: $table.closedAt, builder: (column) => column);

  GeneratedColumn<String> get createdBy =>
      $composableBuilder(column: $table.createdBy, builder: (column) => column);

  GeneratedColumn<String> get assignedTechnician => $composableBuilder(
      column: $table.assignedTechnician, builder: (column) => column);

  GeneratedColumn<String> get completionNotes => $composableBuilder(
      column: $table.completionNotes, builder: (column) => column);

  GeneratedColumn<String> get resolution => $composableBuilder(
      column: $table.resolution, builder: (column) => column);

  GeneratedColumn<bool> get repeatIssue => $composableBuilder(
      column: $table.repeatIssue, builder: (column) => column);

  GeneratedColumn<String> get previousStatus => $composableBuilder(
      column: $table.previousStatus, builder: (column) => column);

  GeneratedColumn<int> get statusChangedBy => $composableBuilder(
      column: $table.statusChangedBy, builder: (column) => column);

  GeneratedColumn<DateTime> get statusChangedAt => $composableBuilder(
      column: $table.statusChangedAt, builder: (column) => column);

  GeneratedColumn<String> get workflowState => $composableBuilder(
      column: $table.workflowState, builder: (column) => column);

  GeneratedColumn<String> get approvalStatus => $composableBuilder(
      column: $table.approvalStatus, builder: (column) => column);

  GeneratedColumn<int> get approvedBy => $composableBuilder(
      column: $table.approvedBy, builder: (column) => column);

  GeneratedColumn<DateTime> get approvedAt => $composableBuilder(
      column: $table.approvedAt, builder: (column) => column);

  GeneratedColumn<int> get version =>
      $composableBuilder(column: $table.version, builder: (column) => column);

  GeneratedColumn<DateTime> get expectedDate => $composableBuilder(
      column: $table.expectedDate, builder: (column) => column);

  GeneratedColumn<int> get expectedDurationMinutes => $composableBuilder(
      column: $table.expectedDurationMinutes, builder: (column) => column);

  GeneratedColumn<String> get contactPerson => $composableBuilder(
      column: $table.contactPerson, builder: (column) => column);

  GeneratedColumn<String> get contactPhone => $composableBuilder(
      column: $table.contactPhone, builder: (column) => column);

  GeneratedColumn<String> get contactEmail => $composableBuilder(
      column: $table.contactEmail, builder: (column) => column);

  GeneratedColumn<String> get billingContactName => $composableBuilder(
      column: $table.billingContactName, builder: (column) => column);

  GeneratedColumn<String> get billingContactEmail => $composableBuilder(
      column: $table.billingContactEmail, builder: (column) => column);

  GeneratedColumn<String> get billingAddress => $composableBuilder(
      column: $table.billingAddress, builder: (column) => column);

  GeneratedColumn<String> get copsAccount => $composableBuilder(
      column: $table.copsAccount, builder: (column) => column);

  GeneratedColumn<String> get cmsAccount => $composableBuilder(
      column: $table.cmsAccount, builder: (column) => column);

  GeneratedColumn<String> get alarmNetAccount => $composableBuilder(
      column: $table.alarmNetAccount, builder: (column) => column);

  GeneratedColumn<String> get ictAccount => $composableBuilder(
      column: $table.ictAccount, builder: (column) => column);

  GeneratedColumn<String> get alarmDotComAccount => $composableBuilder(
      column: $table.alarmDotComAccount, builder: (column) => column);

  GeneratedColumn<String> get telguardAccount => $composableBuilder(
      column: $table.telguardAccount, builder: (column) => column);

  GeneratedColumn<String> get openEyeLicense => $composableBuilder(
      column: $table.openEyeLicense, builder: (column) => column);

  GeneratedColumn<bool> get onServiceContract => $composableBuilder(
      column: $table.onServiceContract, builder: (column) => column);

  GeneratedColumn<String> get contractType => $composableBuilder(
      column: $table.contractType, builder: (column) => column);

  GeneratedColumn<String> get referenceNumber => $composableBuilder(
      column: $table.referenceNumber, builder: (column) => column);

  GeneratedColumn<String> get poNumber =>
      $composableBuilder(column: $table.poNumber, builder: (column) => column);
}

class $$WorkOrdersTableTableManager extends RootTableManager<
    _$AppDatabase,
    $WorkOrdersTable,
    WorkOrder,
    $$WorkOrdersTableFilterComposer,
    $$WorkOrdersTableOrderingComposer,
    $$WorkOrdersTableAnnotationComposer,
    $$WorkOrdersTableCreateCompanionBuilder,
    $$WorkOrdersTableUpdateCompanionBuilder,
    (WorkOrder, BaseReferences<_$AppDatabase, $WorkOrdersTable, WorkOrder>),
    WorkOrder,
    PrefetchHooks Function()> {
  $$WorkOrdersTableTableManager(_$AppDatabase db, $WorkOrdersTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$WorkOrdersTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$WorkOrdersTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$WorkOrdersTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<int> siteId = const Value.absent(),
            Value<String> status = const Value.absent(),
            Value<String?> priority = const Value.absent(),
            Value<String?> descriptionOfWork = const Value.absent(),
            Value<String?> internalNotes = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime?> closedAt = const Value.absent(),
            Value<String?> createdBy = const Value.absent(),
            Value<String?> assignedTechnician = const Value.absent(),
            Value<String?> completionNotes = const Value.absent(),
            Value<String?> resolution = const Value.absent(),
            Value<bool> repeatIssue = const Value.absent(),
            Value<String?> previousStatus = const Value.absent(),
            Value<int?> statusChangedBy = const Value.absent(),
            Value<DateTime?> statusChangedAt = const Value.absent(),
            Value<String> workflowState = const Value.absent(),
            Value<String?> approvalStatus = const Value.absent(),
            Value<int?> approvedBy = const Value.absent(),
            Value<DateTime?> approvedAt = const Value.absent(),
            Value<int> version = const Value.absent(),
            Value<DateTime?> expectedDate = const Value.absent(),
            Value<int?> expectedDurationMinutes = const Value.absent(),
            Value<String?> contactPerson = const Value.absent(),
            Value<String?> contactPhone = const Value.absent(),
            Value<String?> contactEmail = const Value.absent(),
            Value<String?> billingContactName = const Value.absent(),
            Value<String?> billingContactEmail = const Value.absent(),
            Value<String?> billingAddress = const Value.absent(),
            Value<String?> copsAccount = const Value.absent(),
            Value<String?> cmsAccount = const Value.absent(),
            Value<String?> alarmNetAccount = const Value.absent(),
            Value<String?> ictAccount = const Value.absent(),
            Value<String?> alarmDotComAccount = const Value.absent(),
            Value<String?> telguardAccount = const Value.absent(),
            Value<String?> openEyeLicense = const Value.absent(),
            Value<bool> onServiceContract = const Value.absent(),
            Value<String?> contractType = const Value.absent(),
            Value<String?> referenceNumber = const Value.absent(),
            Value<String?> poNumber = const Value.absent(),
          }) =>
              WorkOrdersCompanion(
            id: id,
            siteId: siteId,
            status: status,
            priority: priority,
            descriptionOfWork: descriptionOfWork,
            internalNotes: internalNotes,
            createdAt: createdAt,
            closedAt: closedAt,
            createdBy: createdBy,
            assignedTechnician: assignedTechnician,
            completionNotes: completionNotes,
            resolution: resolution,
            repeatIssue: repeatIssue,
            previousStatus: previousStatus,
            statusChangedBy: statusChangedBy,
            statusChangedAt: statusChangedAt,
            workflowState: workflowState,
            approvalStatus: approvalStatus,
            approvedBy: approvedBy,
            approvedAt: approvedAt,
            version: version,
            expectedDate: expectedDate,
            expectedDurationMinutes: expectedDurationMinutes,
            contactPerson: contactPerson,
            contactPhone: contactPhone,
            contactEmail: contactEmail,
            billingContactName: billingContactName,
            billingContactEmail: billingContactEmail,
            billingAddress: billingAddress,
            copsAccount: copsAccount,
            cmsAccount: cmsAccount,
            alarmNetAccount: alarmNetAccount,
            ictAccount: ictAccount,
            alarmDotComAccount: alarmDotComAccount,
            telguardAccount: telguardAccount,
            openEyeLicense: openEyeLicense,
            onServiceContract: onServiceContract,
            contractType: contractType,
            referenceNumber: referenceNumber,
            poNumber: poNumber,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required int siteId,
            required String status,
            Value<String?> priority = const Value.absent(),
            Value<String?> descriptionOfWork = const Value.absent(),
            Value<String?> internalNotes = const Value.absent(),
            required DateTime createdAt,
            Value<DateTime?> closedAt = const Value.absent(),
            Value<String?> createdBy = const Value.absent(),
            Value<String?> assignedTechnician = const Value.absent(),
            Value<String?> completionNotes = const Value.absent(),
            Value<String?> resolution = const Value.absent(),
            Value<bool> repeatIssue = const Value.absent(),
            Value<String?> previousStatus = const Value.absent(),
            Value<int?> statusChangedBy = const Value.absent(),
            Value<DateTime?> statusChangedAt = const Value.absent(),
            Value<String> workflowState = const Value.absent(),
            Value<String?> approvalStatus = const Value.absent(),
            Value<int?> approvedBy = const Value.absent(),
            Value<DateTime?> approvedAt = const Value.absent(),
            Value<int> version = const Value.absent(),
            Value<DateTime?> expectedDate = const Value.absent(),
            Value<int?> expectedDurationMinutes = const Value.absent(),
            Value<String?> contactPerson = const Value.absent(),
            Value<String?> contactPhone = const Value.absent(),
            Value<String?> contactEmail = const Value.absent(),
            Value<String?> billingContactName = const Value.absent(),
            Value<String?> billingContactEmail = const Value.absent(),
            Value<String?> billingAddress = const Value.absent(),
            Value<String?> copsAccount = const Value.absent(),
            Value<String?> cmsAccount = const Value.absent(),
            Value<String?> alarmNetAccount = const Value.absent(),
            Value<String?> ictAccount = const Value.absent(),
            Value<String?> alarmDotComAccount = const Value.absent(),
            Value<String?> telguardAccount = const Value.absent(),
            Value<String?> openEyeLicense = const Value.absent(),
            Value<bool> onServiceContract = const Value.absent(),
            Value<String?> contractType = const Value.absent(),
            Value<String?> referenceNumber = const Value.absent(),
            Value<String?> poNumber = const Value.absent(),
          }) =>
              WorkOrdersCompanion.insert(
            id: id,
            siteId: siteId,
            status: status,
            priority: priority,
            descriptionOfWork: descriptionOfWork,
            internalNotes: internalNotes,
            createdAt: createdAt,
            closedAt: closedAt,
            createdBy: createdBy,
            assignedTechnician: assignedTechnician,
            completionNotes: completionNotes,
            resolution: resolution,
            repeatIssue: repeatIssue,
            previousStatus: previousStatus,
            statusChangedBy: statusChangedBy,
            statusChangedAt: statusChangedAt,
            workflowState: workflowState,
            approvalStatus: approvalStatus,
            approvedBy: approvedBy,
            approvedAt: approvedAt,
            version: version,
            expectedDate: expectedDate,
            expectedDurationMinutes: expectedDurationMinutes,
            contactPerson: contactPerson,
            contactPhone: contactPhone,
            contactEmail: contactEmail,
            billingContactName: billingContactName,
            billingContactEmail: billingContactEmail,
            billingAddress: billingAddress,
            copsAccount: copsAccount,
            cmsAccount: cmsAccount,
            alarmNetAccount: alarmNetAccount,
            ictAccount: ictAccount,
            alarmDotComAccount: alarmDotComAccount,
            telguardAccount: telguardAccount,
            openEyeLicense: openEyeLicense,
            onServiceContract: onServiceContract,
            contractType: contractType,
            referenceNumber: referenceNumber,
            poNumber: poNumber,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$WorkOrdersTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $WorkOrdersTable,
    WorkOrder,
    $$WorkOrdersTableFilterComposer,
    $$WorkOrdersTableOrderingComposer,
    $$WorkOrdersTableAnnotationComposer,
    $$WorkOrdersTableCreateCompanionBuilder,
    $$WorkOrdersTableUpdateCompanionBuilder,
    (WorkOrder, BaseReferences<_$AppDatabase, $WorkOrdersTable, WorkOrder>),
    WorkOrder,
    PrefetchHooks Function()>;
typedef $$AppointmentsTableCreateCompanionBuilder = AppointmentsCompanion
    Function({
  Value<int> id,
  required int workOrderId,
  required DateTime scheduledStart,
  Value<int?> expectedDurationMinutes,
  Value<String?> technician,
});
typedef $$AppointmentsTableUpdateCompanionBuilder = AppointmentsCompanion
    Function({
  Value<int> id,
  Value<int> workOrderId,
  Value<DateTime> scheduledStart,
  Value<int?> expectedDurationMinutes,
  Value<String?> technician,
});

class $$AppointmentsTableFilterComposer
    extends Composer<_$AppDatabase, $AppointmentsTable> {
  $$AppointmentsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get workOrderId => $composableBuilder(
      column: $table.workOrderId, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get scheduledStart => $composableBuilder(
      column: $table.scheduledStart,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get expectedDurationMinutes => $composableBuilder(
      column: $table.expectedDurationMinutes,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get technician => $composableBuilder(
      column: $table.technician, builder: (column) => ColumnFilters(column));
}

class $$AppointmentsTableOrderingComposer
    extends Composer<_$AppDatabase, $AppointmentsTable> {
  $$AppointmentsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get workOrderId => $composableBuilder(
      column: $table.workOrderId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get scheduledStart => $composableBuilder(
      column: $table.scheduledStart,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get expectedDurationMinutes => $composableBuilder(
      column: $table.expectedDurationMinutes,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get technician => $composableBuilder(
      column: $table.technician, builder: (column) => ColumnOrderings(column));
}

class $$AppointmentsTableAnnotationComposer
    extends Composer<_$AppDatabase, $AppointmentsTable> {
  $$AppointmentsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get workOrderId => $composableBuilder(
      column: $table.workOrderId, builder: (column) => column);

  GeneratedColumn<DateTime> get scheduledStart => $composableBuilder(
      column: $table.scheduledStart, builder: (column) => column);

  GeneratedColumn<int> get expectedDurationMinutes => $composableBuilder(
      column: $table.expectedDurationMinutes, builder: (column) => column);

  GeneratedColumn<String> get technician => $composableBuilder(
      column: $table.technician, builder: (column) => column);
}

class $$AppointmentsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $AppointmentsTable,
    Appointment,
    $$AppointmentsTableFilterComposer,
    $$AppointmentsTableOrderingComposer,
    $$AppointmentsTableAnnotationComposer,
    $$AppointmentsTableCreateCompanionBuilder,
    $$AppointmentsTableUpdateCompanionBuilder,
    (
      Appointment,
      BaseReferences<_$AppDatabase, $AppointmentsTable, Appointment>
    ),
    Appointment,
    PrefetchHooks Function()> {
  $$AppointmentsTableTableManager(_$AppDatabase db, $AppointmentsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AppointmentsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AppointmentsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$AppointmentsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<int> workOrderId = const Value.absent(),
            Value<DateTime> scheduledStart = const Value.absent(),
            Value<int?> expectedDurationMinutes = const Value.absent(),
            Value<String?> technician = const Value.absent(),
          }) =>
              AppointmentsCompanion(
            id: id,
            workOrderId: workOrderId,
            scheduledStart: scheduledStart,
            expectedDurationMinutes: expectedDurationMinutes,
            technician: technician,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required int workOrderId,
            required DateTime scheduledStart,
            Value<int?> expectedDurationMinutes = const Value.absent(),
            Value<String?> technician = const Value.absent(),
          }) =>
              AppointmentsCompanion.insert(
            id: id,
            workOrderId: workOrderId,
            scheduledStart: scheduledStart,
            expectedDurationMinutes: expectedDurationMinutes,
            technician: technician,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$AppointmentsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $AppointmentsTable,
    Appointment,
    $$AppointmentsTableFilterComposer,
    $$AppointmentsTableOrderingComposer,
    $$AppointmentsTableAnnotationComposer,
    $$AppointmentsTableCreateCompanionBuilder,
    $$AppointmentsTableUpdateCompanionBuilder,
    (
      Appointment,
      BaseReferences<_$AppDatabase, $AppointmentsTable, Appointment>
    ),
    Appointment,
    PrefetchHooks Function()>;
typedef $$EquipmentTableCreateCompanionBuilder = EquipmentCompanion Function({
  Value<int> id,
  required int siteId,
  required String equipmentType,
  Value<String?> manufacturer,
  Value<String?> model,
  Value<String?> serialNumber,
  Value<bool> underWarranty,
  Value<bool> underServiceContract,
  Value<String?> contractReference,
  Value<bool> active,
});
typedef $$EquipmentTableUpdateCompanionBuilder = EquipmentCompanion Function({
  Value<int> id,
  Value<int> siteId,
  Value<String> equipmentType,
  Value<String?> manufacturer,
  Value<String?> model,
  Value<String?> serialNumber,
  Value<bool> underWarranty,
  Value<bool> underServiceContract,
  Value<String?> contractReference,
  Value<bool> active,
});

class $$EquipmentTableFilterComposer
    extends Composer<_$AppDatabase, $EquipmentTable> {
  $$EquipmentTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get siteId => $composableBuilder(
      column: $table.siteId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get equipmentType => $composableBuilder(
      column: $table.equipmentType, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get manufacturer => $composableBuilder(
      column: $table.manufacturer, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get model => $composableBuilder(
      column: $table.model, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get serialNumber => $composableBuilder(
      column: $table.serialNumber, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get underWarranty => $composableBuilder(
      column: $table.underWarranty, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get underServiceContract => $composableBuilder(
      column: $table.underServiceContract,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get contractReference => $composableBuilder(
      column: $table.contractReference,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get active => $composableBuilder(
      column: $table.active, builder: (column) => ColumnFilters(column));
}

class $$EquipmentTableOrderingComposer
    extends Composer<_$AppDatabase, $EquipmentTable> {
  $$EquipmentTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get siteId => $composableBuilder(
      column: $table.siteId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get equipmentType => $composableBuilder(
      column: $table.equipmentType,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get manufacturer => $composableBuilder(
      column: $table.manufacturer,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get model => $composableBuilder(
      column: $table.model, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get serialNumber => $composableBuilder(
      column: $table.serialNumber,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get underWarranty => $composableBuilder(
      column: $table.underWarranty,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get underServiceContract => $composableBuilder(
      column: $table.underServiceContract,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get contractReference => $composableBuilder(
      column: $table.contractReference,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get active => $composableBuilder(
      column: $table.active, builder: (column) => ColumnOrderings(column));
}

class $$EquipmentTableAnnotationComposer
    extends Composer<_$AppDatabase, $EquipmentTable> {
  $$EquipmentTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get siteId =>
      $composableBuilder(column: $table.siteId, builder: (column) => column);

  GeneratedColumn<String> get equipmentType => $composableBuilder(
      column: $table.equipmentType, builder: (column) => column);

  GeneratedColumn<String> get manufacturer => $composableBuilder(
      column: $table.manufacturer, builder: (column) => column);

  GeneratedColumn<String> get model =>
      $composableBuilder(column: $table.model, builder: (column) => column);

  GeneratedColumn<String> get serialNumber => $composableBuilder(
      column: $table.serialNumber, builder: (column) => column);

  GeneratedColumn<bool> get underWarranty => $composableBuilder(
      column: $table.underWarranty, builder: (column) => column);

  GeneratedColumn<bool> get underServiceContract => $composableBuilder(
      column: $table.underServiceContract, builder: (column) => column);

  GeneratedColumn<String> get contractReference => $composableBuilder(
      column: $table.contractReference, builder: (column) => column);

  GeneratedColumn<bool> get active =>
      $composableBuilder(column: $table.active, builder: (column) => column);
}

class $$EquipmentTableTableManager extends RootTableManager<
    _$AppDatabase,
    $EquipmentTable,
    EquipmentData,
    $$EquipmentTableFilterComposer,
    $$EquipmentTableOrderingComposer,
    $$EquipmentTableAnnotationComposer,
    $$EquipmentTableCreateCompanionBuilder,
    $$EquipmentTableUpdateCompanionBuilder,
    (
      EquipmentData,
      BaseReferences<_$AppDatabase, $EquipmentTable, EquipmentData>
    ),
    EquipmentData,
    PrefetchHooks Function()> {
  $$EquipmentTableTableManager(_$AppDatabase db, $EquipmentTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$EquipmentTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$EquipmentTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$EquipmentTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<int> siteId = const Value.absent(),
            Value<String> equipmentType = const Value.absent(),
            Value<String?> manufacturer = const Value.absent(),
            Value<String?> model = const Value.absent(),
            Value<String?> serialNumber = const Value.absent(),
            Value<bool> underWarranty = const Value.absent(),
            Value<bool> underServiceContract = const Value.absent(),
            Value<String?> contractReference = const Value.absent(),
            Value<bool> active = const Value.absent(),
          }) =>
              EquipmentCompanion(
            id: id,
            siteId: siteId,
            equipmentType: equipmentType,
            manufacturer: manufacturer,
            model: model,
            serialNumber: serialNumber,
            underWarranty: underWarranty,
            underServiceContract: underServiceContract,
            contractReference: contractReference,
            active: active,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required int siteId,
            required String equipmentType,
            Value<String?> manufacturer = const Value.absent(),
            Value<String?> model = const Value.absent(),
            Value<String?> serialNumber = const Value.absent(),
            Value<bool> underWarranty = const Value.absent(),
            Value<bool> underServiceContract = const Value.absent(),
            Value<String?> contractReference = const Value.absent(),
            Value<bool> active = const Value.absent(),
          }) =>
              EquipmentCompanion.insert(
            id: id,
            siteId: siteId,
            equipmentType: equipmentType,
            manufacturer: manufacturer,
            model: model,
            serialNumber: serialNumber,
            underWarranty: underWarranty,
            underServiceContract: underServiceContract,
            contractReference: contractReference,
            active: active,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$EquipmentTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $EquipmentTable,
    EquipmentData,
    $$EquipmentTableFilterComposer,
    $$EquipmentTableOrderingComposer,
    $$EquipmentTableAnnotationComposer,
    $$EquipmentTableCreateCompanionBuilder,
    $$EquipmentTableUpdateCompanionBuilder,
    (
      EquipmentData,
      BaseReferences<_$AppDatabase, $EquipmentTable, EquipmentData>
    ),
    EquipmentData,
    PrefetchHooks Function()>;
typedef $$WorkOrderEquipmentTableCreateCompanionBuilder
    = WorkOrderEquipmentCompanion Function({
  required int workOrderId,
  required int equipmentId,
  Value<int> rowid,
});
typedef $$WorkOrderEquipmentTableUpdateCompanionBuilder
    = WorkOrderEquipmentCompanion Function({
  Value<int> workOrderId,
  Value<int> equipmentId,
  Value<int> rowid,
});

class $$WorkOrderEquipmentTableFilterComposer
    extends Composer<_$AppDatabase, $WorkOrderEquipmentTable> {
  $$WorkOrderEquipmentTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get workOrderId => $composableBuilder(
      column: $table.workOrderId, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get equipmentId => $composableBuilder(
      column: $table.equipmentId, builder: (column) => ColumnFilters(column));
}

class $$WorkOrderEquipmentTableOrderingComposer
    extends Composer<_$AppDatabase, $WorkOrderEquipmentTable> {
  $$WorkOrderEquipmentTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get workOrderId => $composableBuilder(
      column: $table.workOrderId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get equipmentId => $composableBuilder(
      column: $table.equipmentId, builder: (column) => ColumnOrderings(column));
}

class $$WorkOrderEquipmentTableAnnotationComposer
    extends Composer<_$AppDatabase, $WorkOrderEquipmentTable> {
  $$WorkOrderEquipmentTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get workOrderId => $composableBuilder(
      column: $table.workOrderId, builder: (column) => column);

  GeneratedColumn<int> get equipmentId => $composableBuilder(
      column: $table.equipmentId, builder: (column) => column);
}

class $$WorkOrderEquipmentTableTableManager extends RootTableManager<
    _$AppDatabase,
    $WorkOrderEquipmentTable,
    WorkOrderEquipmentData,
    $$WorkOrderEquipmentTableFilterComposer,
    $$WorkOrderEquipmentTableOrderingComposer,
    $$WorkOrderEquipmentTableAnnotationComposer,
    $$WorkOrderEquipmentTableCreateCompanionBuilder,
    $$WorkOrderEquipmentTableUpdateCompanionBuilder,
    (
      WorkOrderEquipmentData,
      BaseReferences<_$AppDatabase, $WorkOrderEquipmentTable,
          WorkOrderEquipmentData>
    ),
    WorkOrderEquipmentData,
    PrefetchHooks Function()> {
  $$WorkOrderEquipmentTableTableManager(
      _$AppDatabase db, $WorkOrderEquipmentTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$WorkOrderEquipmentTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$WorkOrderEquipmentTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$WorkOrderEquipmentTableAnnotationComposer(
                  $db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> workOrderId = const Value.absent(),
            Value<int> equipmentId = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              WorkOrderEquipmentCompanion(
            workOrderId: workOrderId,
            equipmentId: equipmentId,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required int workOrderId,
            required int equipmentId,
            Value<int> rowid = const Value.absent(),
          }) =>
              WorkOrderEquipmentCompanion.insert(
            workOrderId: workOrderId,
            equipmentId: equipmentId,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$WorkOrderEquipmentTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $WorkOrderEquipmentTable,
    WorkOrderEquipmentData,
    $$WorkOrderEquipmentTableFilterComposer,
    $$WorkOrderEquipmentTableOrderingComposer,
    $$WorkOrderEquipmentTableAnnotationComposer,
    $$WorkOrderEquipmentTableCreateCompanionBuilder,
    $$WorkOrderEquipmentTableUpdateCompanionBuilder,
    (
      WorkOrderEquipmentData,
      BaseReferences<_$AppDatabase, $WorkOrderEquipmentTable,
          WorkOrderEquipmentData>
    ),
    WorkOrderEquipmentData,
    PrefetchHooks Function()>;
typedef $$WorkPerformedTableCreateCompanionBuilder = WorkPerformedCompanion
    Function({
  Value<int> id,
  required int workOrderId,
  Value<int?> equipmentId,
  required String technician,
  required DateTime startedAt,
  Value<int?> durationMinutes,
  Value<String?> workDescription,
  Value<String?> resolution,
  Value<bool> repeatIssue,
});
typedef $$WorkPerformedTableUpdateCompanionBuilder = WorkPerformedCompanion
    Function({
  Value<int> id,
  Value<int> workOrderId,
  Value<int?> equipmentId,
  Value<String> technician,
  Value<DateTime> startedAt,
  Value<int?> durationMinutes,
  Value<String?> workDescription,
  Value<String?> resolution,
  Value<bool> repeatIssue,
});

class $$WorkPerformedTableFilterComposer
    extends Composer<_$AppDatabase, $WorkPerformedTable> {
  $$WorkPerformedTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get workOrderId => $composableBuilder(
      column: $table.workOrderId, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get equipmentId => $composableBuilder(
      column: $table.equipmentId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get technician => $composableBuilder(
      column: $table.technician, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get startedAt => $composableBuilder(
      column: $table.startedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get durationMinutes => $composableBuilder(
      column: $table.durationMinutes,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get workDescription => $composableBuilder(
      column: $table.workDescription,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get resolution => $composableBuilder(
      column: $table.resolution, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get repeatIssue => $composableBuilder(
      column: $table.repeatIssue, builder: (column) => ColumnFilters(column));
}

class $$WorkPerformedTableOrderingComposer
    extends Composer<_$AppDatabase, $WorkPerformedTable> {
  $$WorkPerformedTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get workOrderId => $composableBuilder(
      column: $table.workOrderId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get equipmentId => $composableBuilder(
      column: $table.equipmentId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get technician => $composableBuilder(
      column: $table.technician, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get startedAt => $composableBuilder(
      column: $table.startedAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get durationMinutes => $composableBuilder(
      column: $table.durationMinutes,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get workDescription => $composableBuilder(
      column: $table.workDescription,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get resolution => $composableBuilder(
      column: $table.resolution, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get repeatIssue => $composableBuilder(
      column: $table.repeatIssue, builder: (column) => ColumnOrderings(column));
}

class $$WorkPerformedTableAnnotationComposer
    extends Composer<_$AppDatabase, $WorkPerformedTable> {
  $$WorkPerformedTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get workOrderId => $composableBuilder(
      column: $table.workOrderId, builder: (column) => column);

  GeneratedColumn<int> get equipmentId => $composableBuilder(
      column: $table.equipmentId, builder: (column) => column);

  GeneratedColumn<String> get technician => $composableBuilder(
      column: $table.technician, builder: (column) => column);

  GeneratedColumn<DateTime> get startedAt =>
      $composableBuilder(column: $table.startedAt, builder: (column) => column);

  GeneratedColumn<int> get durationMinutes => $composableBuilder(
      column: $table.durationMinutes, builder: (column) => column);

  GeneratedColumn<String> get workDescription => $composableBuilder(
      column: $table.workDescription, builder: (column) => column);

  GeneratedColumn<String> get resolution => $composableBuilder(
      column: $table.resolution, builder: (column) => column);

  GeneratedColumn<bool> get repeatIssue => $composableBuilder(
      column: $table.repeatIssue, builder: (column) => column);
}

class $$WorkPerformedTableTableManager extends RootTableManager<
    _$AppDatabase,
    $WorkPerformedTable,
    WorkPerformedData,
    $$WorkPerformedTableFilterComposer,
    $$WorkPerformedTableOrderingComposer,
    $$WorkPerformedTableAnnotationComposer,
    $$WorkPerformedTableCreateCompanionBuilder,
    $$WorkPerformedTableUpdateCompanionBuilder,
    (
      WorkPerformedData,
      BaseReferences<_$AppDatabase, $WorkPerformedTable, WorkPerformedData>
    ),
    WorkPerformedData,
    PrefetchHooks Function()> {
  $$WorkPerformedTableTableManager(_$AppDatabase db, $WorkPerformedTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$WorkPerformedTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$WorkPerformedTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$WorkPerformedTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<int> workOrderId = const Value.absent(),
            Value<int?> equipmentId = const Value.absent(),
            Value<String> technician = const Value.absent(),
            Value<DateTime> startedAt = const Value.absent(),
            Value<int?> durationMinutes = const Value.absent(),
            Value<String?> workDescription = const Value.absent(),
            Value<String?> resolution = const Value.absent(),
            Value<bool> repeatIssue = const Value.absent(),
          }) =>
              WorkPerformedCompanion(
            id: id,
            workOrderId: workOrderId,
            equipmentId: equipmentId,
            technician: technician,
            startedAt: startedAt,
            durationMinutes: durationMinutes,
            workDescription: workDescription,
            resolution: resolution,
            repeatIssue: repeatIssue,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required int workOrderId,
            Value<int?> equipmentId = const Value.absent(),
            required String technician,
            required DateTime startedAt,
            Value<int?> durationMinutes = const Value.absent(),
            Value<String?> workDescription = const Value.absent(),
            Value<String?> resolution = const Value.absent(),
            Value<bool> repeatIssue = const Value.absent(),
          }) =>
              WorkPerformedCompanion.insert(
            id: id,
            workOrderId: workOrderId,
            equipmentId: equipmentId,
            technician: technician,
            startedAt: startedAt,
            durationMinutes: durationMinutes,
            workDescription: workDescription,
            resolution: resolution,
            repeatIssue: repeatIssue,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$WorkPerformedTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $WorkPerformedTable,
    WorkPerformedData,
    $$WorkPerformedTableFilterComposer,
    $$WorkPerformedTableOrderingComposer,
    $$WorkPerformedTableAnnotationComposer,
    $$WorkPerformedTableCreateCompanionBuilder,
    $$WorkPerformedTableUpdateCompanionBuilder,
    (
      WorkPerformedData,
      BaseReferences<_$AppDatabase, $WorkPerformedTable, WorkPerformedData>
    ),
    WorkPerformedData,
    PrefetchHooks Function()>;
typedef $$PartsUsedTableCreateCompanionBuilder = PartsUsedCompanion Function({
  Value<int> id,
  required int workPerformedId,
  Value<String?> partNumber,
  Value<String?> description,
  Value<int> quantity,
});
typedef $$PartsUsedTableUpdateCompanionBuilder = PartsUsedCompanion Function({
  Value<int> id,
  Value<int> workPerformedId,
  Value<String?> partNumber,
  Value<String?> description,
  Value<int> quantity,
});

class $$PartsUsedTableFilterComposer
    extends Composer<_$AppDatabase, $PartsUsedTable> {
  $$PartsUsedTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get workPerformedId => $composableBuilder(
      column: $table.workPerformedId,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get partNumber => $composableBuilder(
      column: $table.partNumber, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get quantity => $composableBuilder(
      column: $table.quantity, builder: (column) => ColumnFilters(column));
}

class $$PartsUsedTableOrderingComposer
    extends Composer<_$AppDatabase, $PartsUsedTable> {
  $$PartsUsedTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get workPerformedId => $composableBuilder(
      column: $table.workPerformedId,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get partNumber => $composableBuilder(
      column: $table.partNumber, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get quantity => $composableBuilder(
      column: $table.quantity, builder: (column) => ColumnOrderings(column));
}

class $$PartsUsedTableAnnotationComposer
    extends Composer<_$AppDatabase, $PartsUsedTable> {
  $$PartsUsedTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get workPerformedId => $composableBuilder(
      column: $table.workPerformedId, builder: (column) => column);

  GeneratedColumn<String> get partNumber => $composableBuilder(
      column: $table.partNumber, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => column);

  GeneratedColumn<int> get quantity =>
      $composableBuilder(column: $table.quantity, builder: (column) => column);
}

class $$PartsUsedTableTableManager extends RootTableManager<
    _$AppDatabase,
    $PartsUsedTable,
    PartsUsedData,
    $$PartsUsedTableFilterComposer,
    $$PartsUsedTableOrderingComposer,
    $$PartsUsedTableAnnotationComposer,
    $$PartsUsedTableCreateCompanionBuilder,
    $$PartsUsedTableUpdateCompanionBuilder,
    (
      PartsUsedData,
      BaseReferences<_$AppDatabase, $PartsUsedTable, PartsUsedData>
    ),
    PartsUsedData,
    PrefetchHooks Function()> {
  $$PartsUsedTableTableManager(_$AppDatabase db, $PartsUsedTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PartsUsedTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PartsUsedTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PartsUsedTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<int> workPerformedId = const Value.absent(),
            Value<String?> partNumber = const Value.absent(),
            Value<String?> description = const Value.absent(),
            Value<int> quantity = const Value.absent(),
          }) =>
              PartsUsedCompanion(
            id: id,
            workPerformedId: workPerformedId,
            partNumber: partNumber,
            description: description,
            quantity: quantity,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required int workPerformedId,
            Value<String?> partNumber = const Value.absent(),
            Value<String?> description = const Value.absent(),
            Value<int> quantity = const Value.absent(),
          }) =>
              PartsUsedCompanion.insert(
            id: id,
            workPerformedId: workPerformedId,
            partNumber: partNumber,
            description: description,
            quantity: quantity,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$PartsUsedTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $PartsUsedTable,
    PartsUsedData,
    $$PartsUsedTableFilterComposer,
    $$PartsUsedTableOrderingComposer,
    $$PartsUsedTableAnnotationComposer,
    $$PartsUsedTableCreateCompanionBuilder,
    $$PartsUsedTableUpdateCompanionBuilder,
    (
      PartsUsedData,
      BaseReferences<_$AppDatabase, $PartsUsedTable, PartsUsedData>
    ),
    PartsUsedData,
    PrefetchHooks Function()>;
typedef $$NotesTableCreateCompanionBuilder = NotesCompanion Function({
  Value<int> id,
  required int siteId,
  Value<int?> workOrderId,
  required String noteType,
  required String noteText,
  required DateTime createdAt,
  Value<String?> createdBy,
});
typedef $$NotesTableUpdateCompanionBuilder = NotesCompanion Function({
  Value<int> id,
  Value<int> siteId,
  Value<int?> workOrderId,
  Value<String> noteType,
  Value<String> noteText,
  Value<DateTime> createdAt,
  Value<String?> createdBy,
});

class $$NotesTableFilterComposer extends Composer<_$AppDatabase, $NotesTable> {
  $$NotesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get siteId => $composableBuilder(
      column: $table.siteId, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get workOrderId => $composableBuilder(
      column: $table.workOrderId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get noteType => $composableBuilder(
      column: $table.noteType, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get noteText => $composableBuilder(
      column: $table.noteText, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get createdBy => $composableBuilder(
      column: $table.createdBy, builder: (column) => ColumnFilters(column));
}

class $$NotesTableOrderingComposer
    extends Composer<_$AppDatabase, $NotesTable> {
  $$NotesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get siteId => $composableBuilder(
      column: $table.siteId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get workOrderId => $composableBuilder(
      column: $table.workOrderId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get noteType => $composableBuilder(
      column: $table.noteType, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get noteText => $composableBuilder(
      column: $table.noteText, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get createdBy => $composableBuilder(
      column: $table.createdBy, builder: (column) => ColumnOrderings(column));
}

class $$NotesTableAnnotationComposer
    extends Composer<_$AppDatabase, $NotesTable> {
  $$NotesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get siteId =>
      $composableBuilder(column: $table.siteId, builder: (column) => column);

  GeneratedColumn<int> get workOrderId => $composableBuilder(
      column: $table.workOrderId, builder: (column) => column);

  GeneratedColumn<String> get noteType =>
      $composableBuilder(column: $table.noteType, builder: (column) => column);

  GeneratedColumn<String> get noteText =>
      $composableBuilder(column: $table.noteText, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<String> get createdBy =>
      $composableBuilder(column: $table.createdBy, builder: (column) => column);
}

class $$NotesTableTableManager extends RootTableManager<
    _$AppDatabase,
    $NotesTable,
    Note,
    $$NotesTableFilterComposer,
    $$NotesTableOrderingComposer,
    $$NotesTableAnnotationComposer,
    $$NotesTableCreateCompanionBuilder,
    $$NotesTableUpdateCompanionBuilder,
    (Note, BaseReferences<_$AppDatabase, $NotesTable, Note>),
    Note,
    PrefetchHooks Function()> {
  $$NotesTableTableManager(_$AppDatabase db, $NotesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$NotesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$NotesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$NotesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<int> siteId = const Value.absent(),
            Value<int?> workOrderId = const Value.absent(),
            Value<String> noteType = const Value.absent(),
            Value<String> noteText = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<String?> createdBy = const Value.absent(),
          }) =>
              NotesCompanion(
            id: id,
            siteId: siteId,
            workOrderId: workOrderId,
            noteType: noteType,
            noteText: noteText,
            createdAt: createdAt,
            createdBy: createdBy,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required int siteId,
            Value<int?> workOrderId = const Value.absent(),
            required String noteType,
            required String noteText,
            required DateTime createdAt,
            Value<String?> createdBy = const Value.absent(),
          }) =>
              NotesCompanion.insert(
            id: id,
            siteId: siteId,
            workOrderId: workOrderId,
            noteType: noteType,
            noteText: noteText,
            createdAt: createdAt,
            createdBy: createdBy,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$NotesTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $NotesTable,
    Note,
    $$NotesTableFilterComposer,
    $$NotesTableOrderingComposer,
    $$NotesTableAnnotationComposer,
    $$NotesTableCreateCompanionBuilder,
    $$NotesTableUpdateCompanionBuilder,
    (Note, BaseReferences<_$AppDatabase, $NotesTable, Note>),
    Note,
    PrefetchHooks Function()>;
typedef $$DocumentsTableCreateCompanionBuilder = DocumentsCompanion Function({
  Value<int> id,
  Value<int?> workOrderId,
  Value<int?> siteId,
  required String fileName,
  required String filePath,
  required DateTime uploadedAt,
  Value<String?> uploadedBy,
});
typedef $$DocumentsTableUpdateCompanionBuilder = DocumentsCompanion Function({
  Value<int> id,
  Value<int?> workOrderId,
  Value<int?> siteId,
  Value<String> fileName,
  Value<String> filePath,
  Value<DateTime> uploadedAt,
  Value<String?> uploadedBy,
});

class $$DocumentsTableFilterComposer
    extends Composer<_$AppDatabase, $DocumentsTable> {
  $$DocumentsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get workOrderId => $composableBuilder(
      column: $table.workOrderId, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get siteId => $composableBuilder(
      column: $table.siteId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get fileName => $composableBuilder(
      column: $table.fileName, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get filePath => $composableBuilder(
      column: $table.filePath, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get uploadedAt => $composableBuilder(
      column: $table.uploadedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get uploadedBy => $composableBuilder(
      column: $table.uploadedBy, builder: (column) => ColumnFilters(column));
}

class $$DocumentsTableOrderingComposer
    extends Composer<_$AppDatabase, $DocumentsTable> {
  $$DocumentsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get workOrderId => $composableBuilder(
      column: $table.workOrderId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get siteId => $composableBuilder(
      column: $table.siteId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get fileName => $composableBuilder(
      column: $table.fileName, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get filePath => $composableBuilder(
      column: $table.filePath, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get uploadedAt => $composableBuilder(
      column: $table.uploadedAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get uploadedBy => $composableBuilder(
      column: $table.uploadedBy, builder: (column) => ColumnOrderings(column));
}

class $$DocumentsTableAnnotationComposer
    extends Composer<_$AppDatabase, $DocumentsTable> {
  $$DocumentsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get workOrderId => $composableBuilder(
      column: $table.workOrderId, builder: (column) => column);

  GeneratedColumn<int> get siteId =>
      $composableBuilder(column: $table.siteId, builder: (column) => column);

  GeneratedColumn<String> get fileName =>
      $composableBuilder(column: $table.fileName, builder: (column) => column);

  GeneratedColumn<String> get filePath =>
      $composableBuilder(column: $table.filePath, builder: (column) => column);

  GeneratedColumn<DateTime> get uploadedAt => $composableBuilder(
      column: $table.uploadedAt, builder: (column) => column);

  GeneratedColumn<String> get uploadedBy => $composableBuilder(
      column: $table.uploadedBy, builder: (column) => column);
}

class $$DocumentsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $DocumentsTable,
    Document,
    $$DocumentsTableFilterComposer,
    $$DocumentsTableOrderingComposer,
    $$DocumentsTableAnnotationComposer,
    $$DocumentsTableCreateCompanionBuilder,
    $$DocumentsTableUpdateCompanionBuilder,
    (Document, BaseReferences<_$AppDatabase, $DocumentsTable, Document>),
    Document,
    PrefetchHooks Function()> {
  $$DocumentsTableTableManager(_$AppDatabase db, $DocumentsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$DocumentsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$DocumentsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$DocumentsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<int?> workOrderId = const Value.absent(),
            Value<int?> siteId = const Value.absent(),
            Value<String> fileName = const Value.absent(),
            Value<String> filePath = const Value.absent(),
            Value<DateTime> uploadedAt = const Value.absent(),
            Value<String?> uploadedBy = const Value.absent(),
          }) =>
              DocumentsCompanion(
            id: id,
            workOrderId: workOrderId,
            siteId: siteId,
            fileName: fileName,
            filePath: filePath,
            uploadedAt: uploadedAt,
            uploadedBy: uploadedBy,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<int?> workOrderId = const Value.absent(),
            Value<int?> siteId = const Value.absent(),
            required String fileName,
            required String filePath,
            required DateTime uploadedAt,
            Value<String?> uploadedBy = const Value.absent(),
          }) =>
              DocumentsCompanion.insert(
            id: id,
            workOrderId: workOrderId,
            siteId: siteId,
            fileName: fileName,
            filePath: filePath,
            uploadedAt: uploadedAt,
            uploadedBy: uploadedBy,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$DocumentsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $DocumentsTable,
    Document,
    $$DocumentsTableFilterComposer,
    $$DocumentsTableOrderingComposer,
    $$DocumentsTableAnnotationComposer,
    $$DocumentsTableCreateCompanionBuilder,
    $$DocumentsTableUpdateCompanionBuilder,
    (Document, BaseReferences<_$AppDatabase, $DocumentsTable, Document>),
    Document,
    PrefetchHooks Function()>;
typedef $$KnowledgeEntriesTableCreateCompanionBuilder
    = KnowledgeEntriesCompanion Function({
  required String id,
  required String title,
  required String category,
  required String equipmentType,
  Value<String?> equipmentModel,
  required String content,
  required String sourceType,
  required String sourceFile,
  required String version,
  required String status,
  required DateTime createdAt,
  required DateTime updatedAt,
  Value<String> contentType,
  Value<String?> difficulty,
  Value<int?> estimatedTime,
  Value<String> keywords,
  Value<String?> summary,
  Value<String> preconditions,
  Value<String> tags,
  Value<DateTime?> lastReviewedAt,
  Value<bool> isDeprecated,
  Value<int> rowid,
});
typedef $$KnowledgeEntriesTableUpdateCompanionBuilder
    = KnowledgeEntriesCompanion Function({
  Value<String> id,
  Value<String> title,
  Value<String> category,
  Value<String> equipmentType,
  Value<String?> equipmentModel,
  Value<String> content,
  Value<String> sourceType,
  Value<String> sourceFile,
  Value<String> version,
  Value<String> status,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<String> contentType,
  Value<String?> difficulty,
  Value<int?> estimatedTime,
  Value<String> keywords,
  Value<String?> summary,
  Value<String> preconditions,
  Value<String> tags,
  Value<DateTime?> lastReviewedAt,
  Value<bool> isDeprecated,
  Value<int> rowid,
});

final class $$KnowledgeEntriesTableReferences extends BaseReferences<
    _$AppDatabase, $KnowledgeEntriesTable, KnowledgeEntry> {
  $$KnowledgeEntriesTableReferences(
      super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$KnowledgeProceduresTable,
      List<KnowledgeProcedure>> _knowledgeProceduresRefsTable(
          _$AppDatabase db) =>
      MultiTypedResultKey.fromTable(db.knowledgeProcedures,
          aliasName: $_aliasNameGenerator(
              db.knowledgeEntries.id, db.knowledgeProcedures.knowledgeEntryId));

  $$KnowledgeProceduresTableProcessedTableManager get knowledgeProceduresRefs {
    final manager =
        $$KnowledgeProceduresTableTableManager($_db, $_db.knowledgeProcedures)
            .filter((f) =>
                f.knowledgeEntryId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache =
        $_typedResult.readTableOrNull(_knowledgeProceduresRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }

  static MultiTypedResultKey<$KnowledgeTroubleshootingTable,
      List<KnowledgeTroubleshootingData>> _knowledgeTroubleshootingRefsTable(
          _$AppDatabase db) =>
      MultiTypedResultKey.fromTable(db.knowledgeTroubleshooting,
          aliasName: $_aliasNameGenerator(db.knowledgeEntries.id,
              db.knowledgeTroubleshooting.knowledgeEntryId));

  $$KnowledgeTroubleshootingTableProcessedTableManager
      get knowledgeTroubleshootingRefs {
    final manager = $$KnowledgeTroubleshootingTableTableManager(
            $_db, $_db.knowledgeTroubleshooting)
        .filter((f) =>
            f.knowledgeEntryId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache =
        $_typedResult.readTableOrNull(_knowledgeTroubleshootingRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }

  static MultiTypedResultKey<$EquipmentSpecsTable, List<EquipmentSpec>>
      _equipmentSpecsRefsTable(_$AppDatabase db) =>
          MultiTypedResultKey.fromTable(db.equipmentSpecs,
              aliasName: $_aliasNameGenerator(
                  db.knowledgeEntries.id, db.equipmentSpecs.knowledgeEntryId));

  $$EquipmentSpecsTableProcessedTableManager get equipmentSpecsRefs {
    final manager = $$EquipmentSpecsTableTableManager($_db, $_db.equipmentSpecs)
        .filter((f) =>
            f.knowledgeEntryId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_equipmentSpecsRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }

  static MultiTypedResultKey<$KnowledgeSearchIndexTable,
      List<KnowledgeSearchIndexData>> _knowledgeSearchIndexRefsTable(
          _$AppDatabase db) =>
      MultiTypedResultKey.fromTable(db.knowledgeSearchIndex,
          aliasName: $_aliasNameGenerator(db.knowledgeEntries.id,
              db.knowledgeSearchIndex.knowledgeEntryId));

  $$KnowledgeSearchIndexTableProcessedTableManager
      get knowledgeSearchIndexRefs {
    final manager =
        $$KnowledgeSearchIndexTableTableManager($_db, $_db.knowledgeSearchIndex)
            .filter((f) =>
                f.knowledgeEntryId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache =
        $_typedResult.readTableOrNull(_knowledgeSearchIndexRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }

  static MultiTypedResultKey<$KnowledgeQueryLogTable,
      List<KnowledgeQueryLogData>> _knowledgeQueryLogRefsTable(
          _$AppDatabase db) =>
      MultiTypedResultKey.fromTable(db.knowledgeQueryLog,
          aliasName: $_aliasNameGenerator(
              db.knowledgeEntries.id, db.knowledgeQueryLog.matchedEntryId));

  $$KnowledgeQueryLogTableProcessedTableManager get knowledgeQueryLogRefs {
    final manager = $$KnowledgeQueryLogTableTableManager(
            $_db, $_db.knowledgeQueryLog)
        .filter(
            (f) => f.matchedEntryId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache =
        $_typedResult.readTableOrNull(_knowledgeQueryLogRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }
}

class $$KnowledgeEntriesTableFilterComposer
    extends Composer<_$AppDatabase, $KnowledgeEntriesTable> {
  $$KnowledgeEntriesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get title => $composableBuilder(
      column: $table.title, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get category => $composableBuilder(
      column: $table.category, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get equipmentType => $composableBuilder(
      column: $table.equipmentType, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get equipmentModel => $composableBuilder(
      column: $table.equipmentModel,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get content => $composableBuilder(
      column: $table.content, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get sourceType => $composableBuilder(
      column: $table.sourceType, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get sourceFile => $composableBuilder(
      column: $table.sourceFile, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get version => $composableBuilder(
      column: $table.version, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get contentType => $composableBuilder(
      column: $table.contentType, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get difficulty => $composableBuilder(
      column: $table.difficulty, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get estimatedTime => $composableBuilder(
      column: $table.estimatedTime, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get keywords => $composableBuilder(
      column: $table.keywords, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get summary => $composableBuilder(
      column: $table.summary, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get preconditions => $composableBuilder(
      column: $table.preconditions, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get tags => $composableBuilder(
      column: $table.tags, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get lastReviewedAt => $composableBuilder(
      column: $table.lastReviewedAt,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isDeprecated => $composableBuilder(
      column: $table.isDeprecated, builder: (column) => ColumnFilters(column));

  Expression<bool> knowledgeProceduresRefs(
      Expression<bool> Function($$KnowledgeProceduresTableFilterComposer f) f) {
    final $$KnowledgeProceduresTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.knowledgeProcedures,
        getReferencedColumn: (t) => t.knowledgeEntryId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$KnowledgeProceduresTableFilterComposer(
              $db: $db,
              $table: $db.knowledgeProcedures,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<bool> knowledgeTroubleshootingRefs(
      Expression<bool> Function($$KnowledgeTroubleshootingTableFilterComposer f)
          f) {
    final $$KnowledgeTroubleshootingTableFilterComposer composer =
        $composerBuilder(
            composer: this,
            getCurrentColumn: (t) => t.id,
            referencedTable: $db.knowledgeTroubleshooting,
            getReferencedColumn: (t) => t.knowledgeEntryId,
            builder: (joinBuilder,
                    {$addJoinBuilderToRootComposer,
                    $removeJoinBuilderFromRootComposer}) =>
                $$KnowledgeTroubleshootingTableFilterComposer(
                  $db: $db,
                  $table: $db.knowledgeTroubleshooting,
                  $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                  joinBuilder: joinBuilder,
                  $removeJoinBuilderFromRootComposer:
                      $removeJoinBuilderFromRootComposer,
                ));
    return f(composer);
  }

  Expression<bool> equipmentSpecsRefs(
      Expression<bool> Function($$EquipmentSpecsTableFilterComposer f) f) {
    final $$EquipmentSpecsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.equipmentSpecs,
        getReferencedColumn: (t) => t.knowledgeEntryId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$EquipmentSpecsTableFilterComposer(
              $db: $db,
              $table: $db.equipmentSpecs,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<bool> knowledgeSearchIndexRefs(
      Expression<bool> Function($$KnowledgeSearchIndexTableFilterComposer f)
          f) {
    final $$KnowledgeSearchIndexTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.knowledgeSearchIndex,
        getReferencedColumn: (t) => t.knowledgeEntryId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$KnowledgeSearchIndexTableFilterComposer(
              $db: $db,
              $table: $db.knowledgeSearchIndex,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<bool> knowledgeQueryLogRefs(
      Expression<bool> Function($$KnowledgeQueryLogTableFilterComposer f) f) {
    final $$KnowledgeQueryLogTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.knowledgeQueryLog,
        getReferencedColumn: (t) => t.matchedEntryId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$KnowledgeQueryLogTableFilterComposer(
              $db: $db,
              $table: $db.knowledgeQueryLog,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$KnowledgeEntriesTableOrderingComposer
    extends Composer<_$AppDatabase, $KnowledgeEntriesTable> {
  $$KnowledgeEntriesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get title => $composableBuilder(
      column: $table.title, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get category => $composableBuilder(
      column: $table.category, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get equipmentType => $composableBuilder(
      column: $table.equipmentType,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get equipmentModel => $composableBuilder(
      column: $table.equipmentModel,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get content => $composableBuilder(
      column: $table.content, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get sourceType => $composableBuilder(
      column: $table.sourceType, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get sourceFile => $composableBuilder(
      column: $table.sourceFile, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get version => $composableBuilder(
      column: $table.version, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get contentType => $composableBuilder(
      column: $table.contentType, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get difficulty => $composableBuilder(
      column: $table.difficulty, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get estimatedTime => $composableBuilder(
      column: $table.estimatedTime,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get keywords => $composableBuilder(
      column: $table.keywords, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get summary => $composableBuilder(
      column: $table.summary, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get preconditions => $composableBuilder(
      column: $table.preconditions,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get tags => $composableBuilder(
      column: $table.tags, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get lastReviewedAt => $composableBuilder(
      column: $table.lastReviewedAt,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isDeprecated => $composableBuilder(
      column: $table.isDeprecated,
      builder: (column) => ColumnOrderings(column));
}

class $$KnowledgeEntriesTableAnnotationComposer
    extends Composer<_$AppDatabase, $KnowledgeEntriesTable> {
  $$KnowledgeEntriesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get category =>
      $composableBuilder(column: $table.category, builder: (column) => column);

  GeneratedColumn<String> get equipmentType => $composableBuilder(
      column: $table.equipmentType, builder: (column) => column);

  GeneratedColumn<String> get equipmentModel => $composableBuilder(
      column: $table.equipmentModel, builder: (column) => column);

  GeneratedColumn<String> get content =>
      $composableBuilder(column: $table.content, builder: (column) => column);

  GeneratedColumn<String> get sourceType => $composableBuilder(
      column: $table.sourceType, builder: (column) => column);

  GeneratedColumn<String> get sourceFile => $composableBuilder(
      column: $table.sourceFile, builder: (column) => column);

  GeneratedColumn<String> get version =>
      $composableBuilder(column: $table.version, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<String> get contentType => $composableBuilder(
      column: $table.contentType, builder: (column) => column);

  GeneratedColumn<String> get difficulty => $composableBuilder(
      column: $table.difficulty, builder: (column) => column);

  GeneratedColumn<int> get estimatedTime => $composableBuilder(
      column: $table.estimatedTime, builder: (column) => column);

  GeneratedColumn<String> get keywords =>
      $composableBuilder(column: $table.keywords, builder: (column) => column);

  GeneratedColumn<String> get summary =>
      $composableBuilder(column: $table.summary, builder: (column) => column);

  GeneratedColumn<String> get preconditions => $composableBuilder(
      column: $table.preconditions, builder: (column) => column);

  GeneratedColumn<String> get tags =>
      $composableBuilder(column: $table.tags, builder: (column) => column);

  GeneratedColumn<DateTime> get lastReviewedAt => $composableBuilder(
      column: $table.lastReviewedAt, builder: (column) => column);

  GeneratedColumn<bool> get isDeprecated => $composableBuilder(
      column: $table.isDeprecated, builder: (column) => column);

  Expression<T> knowledgeProceduresRefs<T extends Object>(
      Expression<T> Function($$KnowledgeProceduresTableAnnotationComposer a)
          f) {
    final $$KnowledgeProceduresTableAnnotationComposer composer =
        $composerBuilder(
            composer: this,
            getCurrentColumn: (t) => t.id,
            referencedTable: $db.knowledgeProcedures,
            getReferencedColumn: (t) => t.knowledgeEntryId,
            builder: (joinBuilder,
                    {$addJoinBuilderToRootComposer,
                    $removeJoinBuilderFromRootComposer}) =>
                $$KnowledgeProceduresTableAnnotationComposer(
                  $db: $db,
                  $table: $db.knowledgeProcedures,
                  $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                  joinBuilder: joinBuilder,
                  $removeJoinBuilderFromRootComposer:
                      $removeJoinBuilderFromRootComposer,
                ));
    return f(composer);
  }

  Expression<T> knowledgeTroubleshootingRefs<T extends Object>(
      Expression<T> Function(
              $$KnowledgeTroubleshootingTableAnnotationComposer a)
          f) {
    final $$KnowledgeTroubleshootingTableAnnotationComposer composer =
        $composerBuilder(
            composer: this,
            getCurrentColumn: (t) => t.id,
            referencedTable: $db.knowledgeTroubleshooting,
            getReferencedColumn: (t) => t.knowledgeEntryId,
            builder: (joinBuilder,
                    {$addJoinBuilderToRootComposer,
                    $removeJoinBuilderFromRootComposer}) =>
                $$KnowledgeTroubleshootingTableAnnotationComposer(
                  $db: $db,
                  $table: $db.knowledgeTroubleshooting,
                  $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                  joinBuilder: joinBuilder,
                  $removeJoinBuilderFromRootComposer:
                      $removeJoinBuilderFromRootComposer,
                ));
    return f(composer);
  }

  Expression<T> equipmentSpecsRefs<T extends Object>(
      Expression<T> Function($$EquipmentSpecsTableAnnotationComposer a) f) {
    final $$EquipmentSpecsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.equipmentSpecs,
        getReferencedColumn: (t) => t.knowledgeEntryId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$EquipmentSpecsTableAnnotationComposer(
              $db: $db,
              $table: $db.equipmentSpecs,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<T> knowledgeSearchIndexRefs<T extends Object>(
      Expression<T> Function($$KnowledgeSearchIndexTableAnnotationComposer a)
          f) {
    final $$KnowledgeSearchIndexTableAnnotationComposer composer =
        $composerBuilder(
            composer: this,
            getCurrentColumn: (t) => t.id,
            referencedTable: $db.knowledgeSearchIndex,
            getReferencedColumn: (t) => t.knowledgeEntryId,
            builder: (joinBuilder,
                    {$addJoinBuilderToRootComposer,
                    $removeJoinBuilderFromRootComposer}) =>
                $$KnowledgeSearchIndexTableAnnotationComposer(
                  $db: $db,
                  $table: $db.knowledgeSearchIndex,
                  $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                  joinBuilder: joinBuilder,
                  $removeJoinBuilderFromRootComposer:
                      $removeJoinBuilderFromRootComposer,
                ));
    return f(composer);
  }

  Expression<T> knowledgeQueryLogRefs<T extends Object>(
      Expression<T> Function($$KnowledgeQueryLogTableAnnotationComposer a) f) {
    final $$KnowledgeQueryLogTableAnnotationComposer composer =
        $composerBuilder(
            composer: this,
            getCurrentColumn: (t) => t.id,
            referencedTable: $db.knowledgeQueryLog,
            getReferencedColumn: (t) => t.matchedEntryId,
            builder: (joinBuilder,
                    {$addJoinBuilderToRootComposer,
                    $removeJoinBuilderFromRootComposer}) =>
                $$KnowledgeQueryLogTableAnnotationComposer(
                  $db: $db,
                  $table: $db.knowledgeQueryLog,
                  $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                  joinBuilder: joinBuilder,
                  $removeJoinBuilderFromRootComposer:
                      $removeJoinBuilderFromRootComposer,
                ));
    return f(composer);
  }
}

class $$KnowledgeEntriesTableTableManager extends RootTableManager<
    _$AppDatabase,
    $KnowledgeEntriesTable,
    KnowledgeEntry,
    $$KnowledgeEntriesTableFilterComposer,
    $$KnowledgeEntriesTableOrderingComposer,
    $$KnowledgeEntriesTableAnnotationComposer,
    $$KnowledgeEntriesTableCreateCompanionBuilder,
    $$KnowledgeEntriesTableUpdateCompanionBuilder,
    (KnowledgeEntry, $$KnowledgeEntriesTableReferences),
    KnowledgeEntry,
    PrefetchHooks Function(
        {bool knowledgeProceduresRefs,
        bool knowledgeTroubleshootingRefs,
        bool equipmentSpecsRefs,
        bool knowledgeSearchIndexRefs,
        bool knowledgeQueryLogRefs})> {
  $$KnowledgeEntriesTableTableManager(
      _$AppDatabase db, $KnowledgeEntriesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$KnowledgeEntriesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$KnowledgeEntriesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$KnowledgeEntriesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> title = const Value.absent(),
            Value<String> category = const Value.absent(),
            Value<String> equipmentType = const Value.absent(),
            Value<String?> equipmentModel = const Value.absent(),
            Value<String> content = const Value.absent(),
            Value<String> sourceType = const Value.absent(),
            Value<String> sourceFile = const Value.absent(),
            Value<String> version = const Value.absent(),
            Value<String> status = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
            Value<String> contentType = const Value.absent(),
            Value<String?> difficulty = const Value.absent(),
            Value<int?> estimatedTime = const Value.absent(),
            Value<String> keywords = const Value.absent(),
            Value<String?> summary = const Value.absent(),
            Value<String> preconditions = const Value.absent(),
            Value<String> tags = const Value.absent(),
            Value<DateTime?> lastReviewedAt = const Value.absent(),
            Value<bool> isDeprecated = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              KnowledgeEntriesCompanion(
            id: id,
            title: title,
            category: category,
            equipmentType: equipmentType,
            equipmentModel: equipmentModel,
            content: content,
            sourceType: sourceType,
            sourceFile: sourceFile,
            version: version,
            status: status,
            createdAt: createdAt,
            updatedAt: updatedAt,
            contentType: contentType,
            difficulty: difficulty,
            estimatedTime: estimatedTime,
            keywords: keywords,
            summary: summary,
            preconditions: preconditions,
            tags: tags,
            lastReviewedAt: lastReviewedAt,
            isDeprecated: isDeprecated,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String title,
            required String category,
            required String equipmentType,
            Value<String?> equipmentModel = const Value.absent(),
            required String content,
            required String sourceType,
            required String sourceFile,
            required String version,
            required String status,
            required DateTime createdAt,
            required DateTime updatedAt,
            Value<String> contentType = const Value.absent(),
            Value<String?> difficulty = const Value.absent(),
            Value<int?> estimatedTime = const Value.absent(),
            Value<String> keywords = const Value.absent(),
            Value<String?> summary = const Value.absent(),
            Value<String> preconditions = const Value.absent(),
            Value<String> tags = const Value.absent(),
            Value<DateTime?> lastReviewedAt = const Value.absent(),
            Value<bool> isDeprecated = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              KnowledgeEntriesCompanion.insert(
            id: id,
            title: title,
            category: category,
            equipmentType: equipmentType,
            equipmentModel: equipmentModel,
            content: content,
            sourceType: sourceType,
            sourceFile: sourceFile,
            version: version,
            status: status,
            createdAt: createdAt,
            updatedAt: updatedAt,
            contentType: contentType,
            difficulty: difficulty,
            estimatedTime: estimatedTime,
            keywords: keywords,
            summary: summary,
            preconditions: preconditions,
            tags: tags,
            lastReviewedAt: lastReviewedAt,
            isDeprecated: isDeprecated,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$KnowledgeEntriesTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: (
              {knowledgeProceduresRefs = false,
              knowledgeTroubleshootingRefs = false,
              equipmentSpecsRefs = false,
              knowledgeSearchIndexRefs = false,
              knowledgeQueryLogRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (knowledgeProceduresRefs) db.knowledgeProcedures,
                if (knowledgeTroubleshootingRefs) db.knowledgeTroubleshooting,
                if (equipmentSpecsRefs) db.equipmentSpecs,
                if (knowledgeSearchIndexRefs) db.knowledgeSearchIndex,
                if (knowledgeQueryLogRefs) db.knowledgeQueryLog
              ],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (knowledgeProceduresRefs)
                    await $_getPrefetchedData<KnowledgeEntry,
                            $KnowledgeEntriesTable, KnowledgeProcedure>(
                        currentTable: table,
                        referencedTable: $$KnowledgeEntriesTableReferences
                            ._knowledgeProceduresRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$KnowledgeEntriesTableReferences(db, table, p0)
                                .knowledgeProceduresRefs,
                        referencedItemsForCurrentItem:
                            (item, referencedItems) => referencedItems
                                .where((e) => e.knowledgeEntryId == item.id),
                        typedResults: items),
                  if (knowledgeTroubleshootingRefs)
                    await $_getPrefetchedData<
                            KnowledgeEntry,
                            $KnowledgeEntriesTable,
                            KnowledgeTroubleshootingData>(
                        currentTable: table,
                        referencedTable: $$KnowledgeEntriesTableReferences
                            ._knowledgeTroubleshootingRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$KnowledgeEntriesTableReferences(db, table, p0)
                                .knowledgeTroubleshootingRefs,
                        referencedItemsForCurrentItem:
                            (item, referencedItems) => referencedItems
                                .where((e) => e.knowledgeEntryId == item.id),
                        typedResults: items),
                  if (equipmentSpecsRefs)
                    await $_getPrefetchedData<KnowledgeEntry,
                            $KnowledgeEntriesTable, EquipmentSpec>(
                        currentTable: table,
                        referencedTable: $$KnowledgeEntriesTableReferences
                            ._equipmentSpecsRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$KnowledgeEntriesTableReferences(db, table, p0)
                                .equipmentSpecsRefs,
                        referencedItemsForCurrentItem:
                            (item, referencedItems) => referencedItems
                                .where((e) => e.knowledgeEntryId == item.id),
                        typedResults: items),
                  if (knowledgeSearchIndexRefs)
                    await $_getPrefetchedData<KnowledgeEntry,
                            $KnowledgeEntriesTable, KnowledgeSearchIndexData>(
                        currentTable: table,
                        referencedTable: $$KnowledgeEntriesTableReferences
                            ._knowledgeSearchIndexRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$KnowledgeEntriesTableReferences(db, table, p0)
                                .knowledgeSearchIndexRefs,
                        referencedItemsForCurrentItem:
                            (item, referencedItems) => referencedItems
                                .where((e) => e.knowledgeEntryId == item.id),
                        typedResults: items),
                  if (knowledgeQueryLogRefs)
                    await $_getPrefetchedData<KnowledgeEntry,
                            $KnowledgeEntriesTable, KnowledgeQueryLogData>(
                        currentTable: table,
                        referencedTable: $$KnowledgeEntriesTableReferences
                            ._knowledgeQueryLogRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$KnowledgeEntriesTableReferences(db, table, p0)
                                .knowledgeQueryLogRefs,
                        referencedItemsForCurrentItem:
                            (item, referencedItems) => referencedItems
                                .where((e) => e.matchedEntryId == item.id),
                        typedResults: items)
                ];
              },
            );
          },
        ));
}

typedef $$KnowledgeEntriesTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $KnowledgeEntriesTable,
    KnowledgeEntry,
    $$KnowledgeEntriesTableFilterComposer,
    $$KnowledgeEntriesTableOrderingComposer,
    $$KnowledgeEntriesTableAnnotationComposer,
    $$KnowledgeEntriesTableCreateCompanionBuilder,
    $$KnowledgeEntriesTableUpdateCompanionBuilder,
    (KnowledgeEntry, $$KnowledgeEntriesTableReferences),
    KnowledgeEntry,
    PrefetchHooks Function(
        {bool knowledgeProceduresRefs,
        bool knowledgeTroubleshootingRefs,
        bool equipmentSpecsRefs,
        bool knowledgeSearchIndexRefs,
        bool knowledgeQueryLogRefs})>;
typedef $$KnowledgeProceduresTableCreateCompanionBuilder
    = KnowledgeProceduresCompanion Function({
  Value<int> id,
  required String knowledgeEntryId,
  required int stepNumber,
  required String title,
  required String description,
  Value<String> warnings,
  Value<String?> expectedResult,
  Value<String?> commonMistakes,
});
typedef $$KnowledgeProceduresTableUpdateCompanionBuilder
    = KnowledgeProceduresCompanion Function({
  Value<int> id,
  Value<String> knowledgeEntryId,
  Value<int> stepNumber,
  Value<String> title,
  Value<String> description,
  Value<String> warnings,
  Value<String?> expectedResult,
  Value<String?> commonMistakes,
});

final class $$KnowledgeProceduresTableReferences extends BaseReferences<
    _$AppDatabase, $KnowledgeProceduresTable, KnowledgeProcedure> {
  $$KnowledgeProceduresTableReferences(
      super.$_db, super.$_table, super.$_typedResult);

  static $KnowledgeEntriesTable _knowledgeEntryIdTable(_$AppDatabase db) =>
      db.knowledgeEntries.createAlias($_aliasNameGenerator(
          db.knowledgeProcedures.knowledgeEntryId, db.knowledgeEntries.id));

  $$KnowledgeEntriesTableProcessedTableManager get knowledgeEntryId {
    final $_column = $_itemColumn<String>('knowledge_entry_id')!;

    final manager =
        $$KnowledgeEntriesTableTableManager($_db, $_db.knowledgeEntries)
            .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_knowledgeEntryIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }
}

class $$KnowledgeProceduresTableFilterComposer
    extends Composer<_$AppDatabase, $KnowledgeProceduresTable> {
  $$KnowledgeProceduresTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get stepNumber => $composableBuilder(
      column: $table.stepNumber, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get title => $composableBuilder(
      column: $table.title, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get warnings => $composableBuilder(
      column: $table.warnings, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get expectedResult => $composableBuilder(
      column: $table.expectedResult,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get commonMistakes => $composableBuilder(
      column: $table.commonMistakes,
      builder: (column) => ColumnFilters(column));

  $$KnowledgeEntriesTableFilterComposer get knowledgeEntryId {
    final $$KnowledgeEntriesTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.knowledgeEntryId,
        referencedTable: $db.knowledgeEntries,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$KnowledgeEntriesTableFilterComposer(
              $db: $db,
              $table: $db.knowledgeEntries,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$KnowledgeProceduresTableOrderingComposer
    extends Composer<_$AppDatabase, $KnowledgeProceduresTable> {
  $$KnowledgeProceduresTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get stepNumber => $composableBuilder(
      column: $table.stepNumber, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get title => $composableBuilder(
      column: $table.title, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get warnings => $composableBuilder(
      column: $table.warnings, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get expectedResult => $composableBuilder(
      column: $table.expectedResult,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get commonMistakes => $composableBuilder(
      column: $table.commonMistakes,
      builder: (column) => ColumnOrderings(column));

  $$KnowledgeEntriesTableOrderingComposer get knowledgeEntryId {
    final $$KnowledgeEntriesTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.knowledgeEntryId,
        referencedTable: $db.knowledgeEntries,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$KnowledgeEntriesTableOrderingComposer(
              $db: $db,
              $table: $db.knowledgeEntries,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$KnowledgeProceduresTableAnnotationComposer
    extends Composer<_$AppDatabase, $KnowledgeProceduresTable> {
  $$KnowledgeProceduresTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get stepNumber => $composableBuilder(
      column: $table.stepNumber, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => column);

  GeneratedColumn<String> get warnings =>
      $composableBuilder(column: $table.warnings, builder: (column) => column);

  GeneratedColumn<String> get expectedResult => $composableBuilder(
      column: $table.expectedResult, builder: (column) => column);

  GeneratedColumn<String> get commonMistakes => $composableBuilder(
      column: $table.commonMistakes, builder: (column) => column);

  $$KnowledgeEntriesTableAnnotationComposer get knowledgeEntryId {
    final $$KnowledgeEntriesTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.knowledgeEntryId,
        referencedTable: $db.knowledgeEntries,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$KnowledgeEntriesTableAnnotationComposer(
              $db: $db,
              $table: $db.knowledgeEntries,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$KnowledgeProceduresTableTableManager extends RootTableManager<
    _$AppDatabase,
    $KnowledgeProceduresTable,
    KnowledgeProcedure,
    $$KnowledgeProceduresTableFilterComposer,
    $$KnowledgeProceduresTableOrderingComposer,
    $$KnowledgeProceduresTableAnnotationComposer,
    $$KnowledgeProceduresTableCreateCompanionBuilder,
    $$KnowledgeProceduresTableUpdateCompanionBuilder,
    (KnowledgeProcedure, $$KnowledgeProceduresTableReferences),
    KnowledgeProcedure,
    PrefetchHooks Function({bool knowledgeEntryId})> {
  $$KnowledgeProceduresTableTableManager(
      _$AppDatabase db, $KnowledgeProceduresTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$KnowledgeProceduresTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$KnowledgeProceduresTableOrderingComposer(
                  $db: db, $table: table),
          createComputedFieldComposer: () =>
              $$KnowledgeProceduresTableAnnotationComposer(
                  $db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> knowledgeEntryId = const Value.absent(),
            Value<int> stepNumber = const Value.absent(),
            Value<String> title = const Value.absent(),
            Value<String> description = const Value.absent(),
            Value<String> warnings = const Value.absent(),
            Value<String?> expectedResult = const Value.absent(),
            Value<String?> commonMistakes = const Value.absent(),
          }) =>
              KnowledgeProceduresCompanion(
            id: id,
            knowledgeEntryId: knowledgeEntryId,
            stepNumber: stepNumber,
            title: title,
            description: description,
            warnings: warnings,
            expectedResult: expectedResult,
            commonMistakes: commonMistakes,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String knowledgeEntryId,
            required int stepNumber,
            required String title,
            required String description,
            Value<String> warnings = const Value.absent(),
            Value<String?> expectedResult = const Value.absent(),
            Value<String?> commonMistakes = const Value.absent(),
          }) =>
              KnowledgeProceduresCompanion.insert(
            id: id,
            knowledgeEntryId: knowledgeEntryId,
            stepNumber: stepNumber,
            title: title,
            description: description,
            warnings: warnings,
            expectedResult: expectedResult,
            commonMistakes: commonMistakes,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$KnowledgeProceduresTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: ({knowledgeEntryId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins: <
                  T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic>>(state) {
                if (knowledgeEntryId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.knowledgeEntryId,
                    referencedTable: $$KnowledgeProceduresTableReferences
                        ._knowledgeEntryIdTable(db),
                    referencedColumn: $$KnowledgeProceduresTableReferences
                        ._knowledgeEntryIdTable(db)
                        .id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ));
}

typedef $$KnowledgeProceduresTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $KnowledgeProceduresTable,
    KnowledgeProcedure,
    $$KnowledgeProceduresTableFilterComposer,
    $$KnowledgeProceduresTableOrderingComposer,
    $$KnowledgeProceduresTableAnnotationComposer,
    $$KnowledgeProceduresTableCreateCompanionBuilder,
    $$KnowledgeProceduresTableUpdateCompanionBuilder,
    (KnowledgeProcedure, $$KnowledgeProceduresTableReferences),
    KnowledgeProcedure,
    PrefetchHooks Function({bool knowledgeEntryId})>;
typedef $$KnowledgeTroubleshootingTableCreateCompanionBuilder
    = KnowledgeTroubleshootingCompanion Function({
  Value<int> id,
  required String knowledgeEntryId,
  required String symptom,
  required String rootCause,
  Value<String> diagnosticSteps,
  required String resolution,
  Value<String?> preventionTips,
  Value<String> relatedIssues,
});
typedef $$KnowledgeTroubleshootingTableUpdateCompanionBuilder
    = KnowledgeTroubleshootingCompanion Function({
  Value<int> id,
  Value<String> knowledgeEntryId,
  Value<String> symptom,
  Value<String> rootCause,
  Value<String> diagnosticSteps,
  Value<String> resolution,
  Value<String?> preventionTips,
  Value<String> relatedIssues,
});

final class $$KnowledgeTroubleshootingTableReferences extends BaseReferences<
    _$AppDatabase,
    $KnowledgeTroubleshootingTable,
    KnowledgeTroubleshootingData> {
  $$KnowledgeTroubleshootingTableReferences(
      super.$_db, super.$_table, super.$_typedResult);

  static $KnowledgeEntriesTable _knowledgeEntryIdTable(_$AppDatabase db) =>
      db.knowledgeEntries.createAlias($_aliasNameGenerator(
          db.knowledgeTroubleshooting.knowledgeEntryId,
          db.knowledgeEntries.id));

  $$KnowledgeEntriesTableProcessedTableManager get knowledgeEntryId {
    final $_column = $_itemColumn<String>('knowledge_entry_id')!;

    final manager =
        $$KnowledgeEntriesTableTableManager($_db, $_db.knowledgeEntries)
            .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_knowledgeEntryIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }
}

class $$KnowledgeTroubleshootingTableFilterComposer
    extends Composer<_$AppDatabase, $KnowledgeTroubleshootingTable> {
  $$KnowledgeTroubleshootingTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get symptom => $composableBuilder(
      column: $table.symptom, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get rootCause => $composableBuilder(
      column: $table.rootCause, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get diagnosticSteps => $composableBuilder(
      column: $table.diagnosticSteps,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get resolution => $composableBuilder(
      column: $table.resolution, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get preventionTips => $composableBuilder(
      column: $table.preventionTips,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get relatedIssues => $composableBuilder(
      column: $table.relatedIssues, builder: (column) => ColumnFilters(column));

  $$KnowledgeEntriesTableFilterComposer get knowledgeEntryId {
    final $$KnowledgeEntriesTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.knowledgeEntryId,
        referencedTable: $db.knowledgeEntries,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$KnowledgeEntriesTableFilterComposer(
              $db: $db,
              $table: $db.knowledgeEntries,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$KnowledgeTroubleshootingTableOrderingComposer
    extends Composer<_$AppDatabase, $KnowledgeTroubleshootingTable> {
  $$KnowledgeTroubleshootingTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get symptom => $composableBuilder(
      column: $table.symptom, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get rootCause => $composableBuilder(
      column: $table.rootCause, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get diagnosticSteps => $composableBuilder(
      column: $table.diagnosticSteps,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get resolution => $composableBuilder(
      column: $table.resolution, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get preventionTips => $composableBuilder(
      column: $table.preventionTips,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get relatedIssues => $composableBuilder(
      column: $table.relatedIssues,
      builder: (column) => ColumnOrderings(column));

  $$KnowledgeEntriesTableOrderingComposer get knowledgeEntryId {
    final $$KnowledgeEntriesTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.knowledgeEntryId,
        referencedTable: $db.knowledgeEntries,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$KnowledgeEntriesTableOrderingComposer(
              $db: $db,
              $table: $db.knowledgeEntries,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$KnowledgeTroubleshootingTableAnnotationComposer
    extends Composer<_$AppDatabase, $KnowledgeTroubleshootingTable> {
  $$KnowledgeTroubleshootingTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get symptom =>
      $composableBuilder(column: $table.symptom, builder: (column) => column);

  GeneratedColumn<String> get rootCause =>
      $composableBuilder(column: $table.rootCause, builder: (column) => column);

  GeneratedColumn<String> get diagnosticSteps => $composableBuilder(
      column: $table.diagnosticSteps, builder: (column) => column);

  GeneratedColumn<String> get resolution => $composableBuilder(
      column: $table.resolution, builder: (column) => column);

  GeneratedColumn<String> get preventionTips => $composableBuilder(
      column: $table.preventionTips, builder: (column) => column);

  GeneratedColumn<String> get relatedIssues => $composableBuilder(
      column: $table.relatedIssues, builder: (column) => column);

  $$KnowledgeEntriesTableAnnotationComposer get knowledgeEntryId {
    final $$KnowledgeEntriesTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.knowledgeEntryId,
        referencedTable: $db.knowledgeEntries,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$KnowledgeEntriesTableAnnotationComposer(
              $db: $db,
              $table: $db.knowledgeEntries,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$KnowledgeTroubleshootingTableTableManager extends RootTableManager<
    _$AppDatabase,
    $KnowledgeTroubleshootingTable,
    KnowledgeTroubleshootingData,
    $$KnowledgeTroubleshootingTableFilterComposer,
    $$KnowledgeTroubleshootingTableOrderingComposer,
    $$KnowledgeTroubleshootingTableAnnotationComposer,
    $$KnowledgeTroubleshootingTableCreateCompanionBuilder,
    $$KnowledgeTroubleshootingTableUpdateCompanionBuilder,
    (KnowledgeTroubleshootingData, $$KnowledgeTroubleshootingTableReferences),
    KnowledgeTroubleshootingData,
    PrefetchHooks Function({bool knowledgeEntryId})> {
  $$KnowledgeTroubleshootingTableTableManager(
      _$AppDatabase db, $KnowledgeTroubleshootingTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$KnowledgeTroubleshootingTableFilterComposer(
                  $db: db, $table: table),
          createOrderingComposer: () =>
              $$KnowledgeTroubleshootingTableOrderingComposer(
                  $db: db, $table: table),
          createComputedFieldComposer: () =>
              $$KnowledgeTroubleshootingTableAnnotationComposer(
                  $db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> knowledgeEntryId = const Value.absent(),
            Value<String> symptom = const Value.absent(),
            Value<String> rootCause = const Value.absent(),
            Value<String> diagnosticSteps = const Value.absent(),
            Value<String> resolution = const Value.absent(),
            Value<String?> preventionTips = const Value.absent(),
            Value<String> relatedIssues = const Value.absent(),
          }) =>
              KnowledgeTroubleshootingCompanion(
            id: id,
            knowledgeEntryId: knowledgeEntryId,
            symptom: symptom,
            rootCause: rootCause,
            diagnosticSteps: diagnosticSteps,
            resolution: resolution,
            preventionTips: preventionTips,
            relatedIssues: relatedIssues,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String knowledgeEntryId,
            required String symptom,
            required String rootCause,
            Value<String> diagnosticSteps = const Value.absent(),
            required String resolution,
            Value<String?> preventionTips = const Value.absent(),
            Value<String> relatedIssues = const Value.absent(),
          }) =>
              KnowledgeTroubleshootingCompanion.insert(
            id: id,
            knowledgeEntryId: knowledgeEntryId,
            symptom: symptom,
            rootCause: rootCause,
            diagnosticSteps: diagnosticSteps,
            resolution: resolution,
            preventionTips: preventionTips,
            relatedIssues: relatedIssues,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$KnowledgeTroubleshootingTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: ({knowledgeEntryId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins: <
                  T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic>>(state) {
                if (knowledgeEntryId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.knowledgeEntryId,
                    referencedTable: $$KnowledgeTroubleshootingTableReferences
                        ._knowledgeEntryIdTable(db),
                    referencedColumn: $$KnowledgeTroubleshootingTableReferences
                        ._knowledgeEntryIdTable(db)
                        .id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ));
}

typedef $$KnowledgeTroubleshootingTableProcessedTableManager
    = ProcessedTableManager<
        _$AppDatabase,
        $KnowledgeTroubleshootingTable,
        KnowledgeTroubleshootingData,
        $$KnowledgeTroubleshootingTableFilterComposer,
        $$KnowledgeTroubleshootingTableOrderingComposer,
        $$KnowledgeTroubleshootingTableAnnotationComposer,
        $$KnowledgeTroubleshootingTableCreateCompanionBuilder,
        $$KnowledgeTroubleshootingTableUpdateCompanionBuilder,
        (
          KnowledgeTroubleshootingData,
          $$KnowledgeTroubleshootingTableReferences
        ),
        KnowledgeTroubleshootingData,
        PrefetchHooks Function({bool knowledgeEntryId})>;
typedef $$EquipmentSpecsTableCreateCompanionBuilder = EquipmentSpecsCompanion
    Function({
  Value<int> id,
  required String knowledgeEntryId,
  required String equipmentType,
  Value<String?> manufacturer,
  required String model,
  Value<String?> serialNumberPattern,
  Value<String> specifications,
  Value<String> compatibility,
  Value<DateTime?> eolDate,
  Value<String?> supportUrl,
});
typedef $$EquipmentSpecsTableUpdateCompanionBuilder = EquipmentSpecsCompanion
    Function({
  Value<int> id,
  Value<String> knowledgeEntryId,
  Value<String> equipmentType,
  Value<String?> manufacturer,
  Value<String> model,
  Value<String?> serialNumberPattern,
  Value<String> specifications,
  Value<String> compatibility,
  Value<DateTime?> eolDate,
  Value<String?> supportUrl,
});

final class $$EquipmentSpecsTableReferences
    extends BaseReferences<_$AppDatabase, $EquipmentSpecsTable, EquipmentSpec> {
  $$EquipmentSpecsTableReferences(
      super.$_db, super.$_table, super.$_typedResult);

  static $KnowledgeEntriesTable _knowledgeEntryIdTable(_$AppDatabase db) =>
      db.knowledgeEntries.createAlias($_aliasNameGenerator(
          db.equipmentSpecs.knowledgeEntryId, db.knowledgeEntries.id));

  $$KnowledgeEntriesTableProcessedTableManager get knowledgeEntryId {
    final $_column = $_itemColumn<String>('knowledge_entry_id')!;

    final manager =
        $$KnowledgeEntriesTableTableManager($_db, $_db.knowledgeEntries)
            .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_knowledgeEntryIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }
}

class $$EquipmentSpecsTableFilterComposer
    extends Composer<_$AppDatabase, $EquipmentSpecsTable> {
  $$EquipmentSpecsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get equipmentType => $composableBuilder(
      column: $table.equipmentType, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get manufacturer => $composableBuilder(
      column: $table.manufacturer, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get model => $composableBuilder(
      column: $table.model, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get serialNumberPattern => $composableBuilder(
      column: $table.serialNumberPattern,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get specifications => $composableBuilder(
      column: $table.specifications,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get compatibility => $composableBuilder(
      column: $table.compatibility, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get eolDate => $composableBuilder(
      column: $table.eolDate, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get supportUrl => $composableBuilder(
      column: $table.supportUrl, builder: (column) => ColumnFilters(column));

  $$KnowledgeEntriesTableFilterComposer get knowledgeEntryId {
    final $$KnowledgeEntriesTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.knowledgeEntryId,
        referencedTable: $db.knowledgeEntries,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$KnowledgeEntriesTableFilterComposer(
              $db: $db,
              $table: $db.knowledgeEntries,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$EquipmentSpecsTableOrderingComposer
    extends Composer<_$AppDatabase, $EquipmentSpecsTable> {
  $$EquipmentSpecsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get equipmentType => $composableBuilder(
      column: $table.equipmentType,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get manufacturer => $composableBuilder(
      column: $table.manufacturer,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get model => $composableBuilder(
      column: $table.model, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get serialNumberPattern => $composableBuilder(
      column: $table.serialNumberPattern,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get specifications => $composableBuilder(
      column: $table.specifications,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get compatibility => $composableBuilder(
      column: $table.compatibility,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get eolDate => $composableBuilder(
      column: $table.eolDate, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get supportUrl => $composableBuilder(
      column: $table.supportUrl, builder: (column) => ColumnOrderings(column));

  $$KnowledgeEntriesTableOrderingComposer get knowledgeEntryId {
    final $$KnowledgeEntriesTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.knowledgeEntryId,
        referencedTable: $db.knowledgeEntries,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$KnowledgeEntriesTableOrderingComposer(
              $db: $db,
              $table: $db.knowledgeEntries,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$EquipmentSpecsTableAnnotationComposer
    extends Composer<_$AppDatabase, $EquipmentSpecsTable> {
  $$EquipmentSpecsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get equipmentType => $composableBuilder(
      column: $table.equipmentType, builder: (column) => column);

  GeneratedColumn<String> get manufacturer => $composableBuilder(
      column: $table.manufacturer, builder: (column) => column);

  GeneratedColumn<String> get model =>
      $composableBuilder(column: $table.model, builder: (column) => column);

  GeneratedColumn<String> get serialNumberPattern => $composableBuilder(
      column: $table.serialNumberPattern, builder: (column) => column);

  GeneratedColumn<String> get specifications => $composableBuilder(
      column: $table.specifications, builder: (column) => column);

  GeneratedColumn<String> get compatibility => $composableBuilder(
      column: $table.compatibility, builder: (column) => column);

  GeneratedColumn<DateTime> get eolDate =>
      $composableBuilder(column: $table.eolDate, builder: (column) => column);

  GeneratedColumn<String> get supportUrl => $composableBuilder(
      column: $table.supportUrl, builder: (column) => column);

  $$KnowledgeEntriesTableAnnotationComposer get knowledgeEntryId {
    final $$KnowledgeEntriesTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.knowledgeEntryId,
        referencedTable: $db.knowledgeEntries,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$KnowledgeEntriesTableAnnotationComposer(
              $db: $db,
              $table: $db.knowledgeEntries,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$EquipmentSpecsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $EquipmentSpecsTable,
    EquipmentSpec,
    $$EquipmentSpecsTableFilterComposer,
    $$EquipmentSpecsTableOrderingComposer,
    $$EquipmentSpecsTableAnnotationComposer,
    $$EquipmentSpecsTableCreateCompanionBuilder,
    $$EquipmentSpecsTableUpdateCompanionBuilder,
    (EquipmentSpec, $$EquipmentSpecsTableReferences),
    EquipmentSpec,
    PrefetchHooks Function({bool knowledgeEntryId})> {
  $$EquipmentSpecsTableTableManager(
      _$AppDatabase db, $EquipmentSpecsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$EquipmentSpecsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$EquipmentSpecsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$EquipmentSpecsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> knowledgeEntryId = const Value.absent(),
            Value<String> equipmentType = const Value.absent(),
            Value<String?> manufacturer = const Value.absent(),
            Value<String> model = const Value.absent(),
            Value<String?> serialNumberPattern = const Value.absent(),
            Value<String> specifications = const Value.absent(),
            Value<String> compatibility = const Value.absent(),
            Value<DateTime?> eolDate = const Value.absent(),
            Value<String?> supportUrl = const Value.absent(),
          }) =>
              EquipmentSpecsCompanion(
            id: id,
            knowledgeEntryId: knowledgeEntryId,
            equipmentType: equipmentType,
            manufacturer: manufacturer,
            model: model,
            serialNumberPattern: serialNumberPattern,
            specifications: specifications,
            compatibility: compatibility,
            eolDate: eolDate,
            supportUrl: supportUrl,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String knowledgeEntryId,
            required String equipmentType,
            Value<String?> manufacturer = const Value.absent(),
            required String model,
            Value<String?> serialNumberPattern = const Value.absent(),
            Value<String> specifications = const Value.absent(),
            Value<String> compatibility = const Value.absent(),
            Value<DateTime?> eolDate = const Value.absent(),
            Value<String?> supportUrl = const Value.absent(),
          }) =>
              EquipmentSpecsCompanion.insert(
            id: id,
            knowledgeEntryId: knowledgeEntryId,
            equipmentType: equipmentType,
            manufacturer: manufacturer,
            model: model,
            serialNumberPattern: serialNumberPattern,
            specifications: specifications,
            compatibility: compatibility,
            eolDate: eolDate,
            supportUrl: supportUrl,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$EquipmentSpecsTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: ({knowledgeEntryId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins: <
                  T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic>>(state) {
                if (knowledgeEntryId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.knowledgeEntryId,
                    referencedTable: $$EquipmentSpecsTableReferences
                        ._knowledgeEntryIdTable(db),
                    referencedColumn: $$EquipmentSpecsTableReferences
                        ._knowledgeEntryIdTable(db)
                        .id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ));
}

typedef $$EquipmentSpecsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $EquipmentSpecsTable,
    EquipmentSpec,
    $$EquipmentSpecsTableFilterComposer,
    $$EquipmentSpecsTableOrderingComposer,
    $$EquipmentSpecsTableAnnotationComposer,
    $$EquipmentSpecsTableCreateCompanionBuilder,
    $$EquipmentSpecsTableUpdateCompanionBuilder,
    (EquipmentSpec, $$EquipmentSpecsTableReferences),
    EquipmentSpec,
    PrefetchHooks Function({bool knowledgeEntryId})>;
typedef $$KnowledgeRelationshipsTableCreateCompanionBuilder
    = KnowledgeRelationshipsCompanion Function({
  Value<int> id,
  required String fromEntryId,
  required String toEntryId,
  required String relationshipType,
  Value<String?> description,
});
typedef $$KnowledgeRelationshipsTableUpdateCompanionBuilder
    = KnowledgeRelationshipsCompanion Function({
  Value<int> id,
  Value<String> fromEntryId,
  Value<String> toEntryId,
  Value<String> relationshipType,
  Value<String?> description,
});

final class $$KnowledgeRelationshipsTableReferences extends BaseReferences<
    _$AppDatabase, $KnowledgeRelationshipsTable, KnowledgeRelationship> {
  $$KnowledgeRelationshipsTableReferences(
      super.$_db, super.$_table, super.$_typedResult);

  static $KnowledgeEntriesTable _fromEntryIdTable(_$AppDatabase db) =>
      db.knowledgeEntries.createAlias($_aliasNameGenerator(
          db.knowledgeRelationships.fromEntryId, db.knowledgeEntries.id));

  $$KnowledgeEntriesTableProcessedTableManager get fromEntryId {
    final $_column = $_itemColumn<String>('from_entry_id')!;

    final manager =
        $$KnowledgeEntriesTableTableManager($_db, $_db.knowledgeEntries)
            .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_fromEntryIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }

  static $KnowledgeEntriesTable _toEntryIdTable(_$AppDatabase db) =>
      db.knowledgeEntries.createAlias($_aliasNameGenerator(
          db.knowledgeRelationships.toEntryId, db.knowledgeEntries.id));

  $$KnowledgeEntriesTableProcessedTableManager get toEntryId {
    final $_column = $_itemColumn<String>('to_entry_id')!;

    final manager =
        $$KnowledgeEntriesTableTableManager($_db, $_db.knowledgeEntries)
            .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_toEntryIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }
}

class $$KnowledgeRelationshipsTableFilterComposer
    extends Composer<_$AppDatabase, $KnowledgeRelationshipsTable> {
  $$KnowledgeRelationshipsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get relationshipType => $composableBuilder(
      column: $table.relationshipType,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => ColumnFilters(column));

  $$KnowledgeEntriesTableFilterComposer get fromEntryId {
    final $$KnowledgeEntriesTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.fromEntryId,
        referencedTable: $db.knowledgeEntries,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$KnowledgeEntriesTableFilterComposer(
              $db: $db,
              $table: $db.knowledgeEntries,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$KnowledgeEntriesTableFilterComposer get toEntryId {
    final $$KnowledgeEntriesTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.toEntryId,
        referencedTable: $db.knowledgeEntries,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$KnowledgeEntriesTableFilterComposer(
              $db: $db,
              $table: $db.knowledgeEntries,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$KnowledgeRelationshipsTableOrderingComposer
    extends Composer<_$AppDatabase, $KnowledgeRelationshipsTable> {
  $$KnowledgeRelationshipsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get relationshipType => $composableBuilder(
      column: $table.relationshipType,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => ColumnOrderings(column));

  $$KnowledgeEntriesTableOrderingComposer get fromEntryId {
    final $$KnowledgeEntriesTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.fromEntryId,
        referencedTable: $db.knowledgeEntries,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$KnowledgeEntriesTableOrderingComposer(
              $db: $db,
              $table: $db.knowledgeEntries,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$KnowledgeEntriesTableOrderingComposer get toEntryId {
    final $$KnowledgeEntriesTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.toEntryId,
        referencedTable: $db.knowledgeEntries,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$KnowledgeEntriesTableOrderingComposer(
              $db: $db,
              $table: $db.knowledgeEntries,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$KnowledgeRelationshipsTableAnnotationComposer
    extends Composer<_$AppDatabase, $KnowledgeRelationshipsTable> {
  $$KnowledgeRelationshipsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get relationshipType => $composableBuilder(
      column: $table.relationshipType, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => column);

  $$KnowledgeEntriesTableAnnotationComposer get fromEntryId {
    final $$KnowledgeEntriesTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.fromEntryId,
        referencedTable: $db.knowledgeEntries,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$KnowledgeEntriesTableAnnotationComposer(
              $db: $db,
              $table: $db.knowledgeEntries,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$KnowledgeEntriesTableAnnotationComposer get toEntryId {
    final $$KnowledgeEntriesTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.toEntryId,
        referencedTable: $db.knowledgeEntries,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$KnowledgeEntriesTableAnnotationComposer(
              $db: $db,
              $table: $db.knowledgeEntries,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$KnowledgeRelationshipsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $KnowledgeRelationshipsTable,
    KnowledgeRelationship,
    $$KnowledgeRelationshipsTableFilterComposer,
    $$KnowledgeRelationshipsTableOrderingComposer,
    $$KnowledgeRelationshipsTableAnnotationComposer,
    $$KnowledgeRelationshipsTableCreateCompanionBuilder,
    $$KnowledgeRelationshipsTableUpdateCompanionBuilder,
    (KnowledgeRelationship, $$KnowledgeRelationshipsTableReferences),
    KnowledgeRelationship,
    PrefetchHooks Function({bool fromEntryId, bool toEntryId})> {
  $$KnowledgeRelationshipsTableTableManager(
      _$AppDatabase db, $KnowledgeRelationshipsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$KnowledgeRelationshipsTableFilterComposer(
                  $db: db, $table: table),
          createOrderingComposer: () =>
              $$KnowledgeRelationshipsTableOrderingComposer(
                  $db: db, $table: table),
          createComputedFieldComposer: () =>
              $$KnowledgeRelationshipsTableAnnotationComposer(
                  $db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> fromEntryId = const Value.absent(),
            Value<String> toEntryId = const Value.absent(),
            Value<String> relationshipType = const Value.absent(),
            Value<String?> description = const Value.absent(),
          }) =>
              KnowledgeRelationshipsCompanion(
            id: id,
            fromEntryId: fromEntryId,
            toEntryId: toEntryId,
            relationshipType: relationshipType,
            description: description,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String fromEntryId,
            required String toEntryId,
            required String relationshipType,
            Value<String?> description = const Value.absent(),
          }) =>
              KnowledgeRelationshipsCompanion.insert(
            id: id,
            fromEntryId: fromEntryId,
            toEntryId: toEntryId,
            relationshipType: relationshipType,
            description: description,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$KnowledgeRelationshipsTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: ({fromEntryId = false, toEntryId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins: <
                  T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic>>(state) {
                if (fromEntryId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.fromEntryId,
                    referencedTable: $$KnowledgeRelationshipsTableReferences
                        ._fromEntryIdTable(db),
                    referencedColumn: $$KnowledgeRelationshipsTableReferences
                        ._fromEntryIdTable(db)
                        .id,
                  ) as T;
                }
                if (toEntryId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.toEntryId,
                    referencedTable: $$KnowledgeRelationshipsTableReferences
                        ._toEntryIdTable(db),
                    referencedColumn: $$KnowledgeRelationshipsTableReferences
                        ._toEntryIdTable(db)
                        .id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ));
}

typedef $$KnowledgeRelationshipsTableProcessedTableManager
    = ProcessedTableManager<
        _$AppDatabase,
        $KnowledgeRelationshipsTable,
        KnowledgeRelationship,
        $$KnowledgeRelationshipsTableFilterComposer,
        $$KnowledgeRelationshipsTableOrderingComposer,
        $$KnowledgeRelationshipsTableAnnotationComposer,
        $$KnowledgeRelationshipsTableCreateCompanionBuilder,
        $$KnowledgeRelationshipsTableUpdateCompanionBuilder,
        (KnowledgeRelationship, $$KnowledgeRelationshipsTableReferences),
        KnowledgeRelationship,
        PrefetchHooks Function({bool fromEntryId, bool toEntryId})>;
typedef $$KnowledgeSearchIndexTableCreateCompanionBuilder
    = KnowledgeSearchIndexCompanion Function({
  Value<int> id,
  required String knowledgeEntryId,
  required String queryVariation,
  Value<String> synonyms,
  Value<String?> context,
  Value<double> weight,
});
typedef $$KnowledgeSearchIndexTableUpdateCompanionBuilder
    = KnowledgeSearchIndexCompanion Function({
  Value<int> id,
  Value<String> knowledgeEntryId,
  Value<String> queryVariation,
  Value<String> synonyms,
  Value<String?> context,
  Value<double> weight,
});

final class $$KnowledgeSearchIndexTableReferences extends BaseReferences<
    _$AppDatabase, $KnowledgeSearchIndexTable, KnowledgeSearchIndexData> {
  $$KnowledgeSearchIndexTableReferences(
      super.$_db, super.$_table, super.$_typedResult);

  static $KnowledgeEntriesTable _knowledgeEntryIdTable(_$AppDatabase db) =>
      db.knowledgeEntries.createAlias($_aliasNameGenerator(
          db.knowledgeSearchIndex.knowledgeEntryId, db.knowledgeEntries.id));

  $$KnowledgeEntriesTableProcessedTableManager get knowledgeEntryId {
    final $_column = $_itemColumn<String>('knowledge_entry_id')!;

    final manager =
        $$KnowledgeEntriesTableTableManager($_db, $_db.knowledgeEntries)
            .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_knowledgeEntryIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }
}

class $$KnowledgeSearchIndexTableFilterComposer
    extends Composer<_$AppDatabase, $KnowledgeSearchIndexTable> {
  $$KnowledgeSearchIndexTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get queryVariation => $composableBuilder(
      column: $table.queryVariation,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get synonyms => $composableBuilder(
      column: $table.synonyms, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get context => $composableBuilder(
      column: $table.context, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get weight => $composableBuilder(
      column: $table.weight, builder: (column) => ColumnFilters(column));

  $$KnowledgeEntriesTableFilterComposer get knowledgeEntryId {
    final $$KnowledgeEntriesTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.knowledgeEntryId,
        referencedTable: $db.knowledgeEntries,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$KnowledgeEntriesTableFilterComposer(
              $db: $db,
              $table: $db.knowledgeEntries,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$KnowledgeSearchIndexTableOrderingComposer
    extends Composer<_$AppDatabase, $KnowledgeSearchIndexTable> {
  $$KnowledgeSearchIndexTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get queryVariation => $composableBuilder(
      column: $table.queryVariation,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get synonyms => $composableBuilder(
      column: $table.synonyms, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get context => $composableBuilder(
      column: $table.context, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get weight => $composableBuilder(
      column: $table.weight, builder: (column) => ColumnOrderings(column));

  $$KnowledgeEntriesTableOrderingComposer get knowledgeEntryId {
    final $$KnowledgeEntriesTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.knowledgeEntryId,
        referencedTable: $db.knowledgeEntries,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$KnowledgeEntriesTableOrderingComposer(
              $db: $db,
              $table: $db.knowledgeEntries,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$KnowledgeSearchIndexTableAnnotationComposer
    extends Composer<_$AppDatabase, $KnowledgeSearchIndexTable> {
  $$KnowledgeSearchIndexTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get queryVariation => $composableBuilder(
      column: $table.queryVariation, builder: (column) => column);

  GeneratedColumn<String> get synonyms =>
      $composableBuilder(column: $table.synonyms, builder: (column) => column);

  GeneratedColumn<String> get context =>
      $composableBuilder(column: $table.context, builder: (column) => column);

  GeneratedColumn<double> get weight =>
      $composableBuilder(column: $table.weight, builder: (column) => column);

  $$KnowledgeEntriesTableAnnotationComposer get knowledgeEntryId {
    final $$KnowledgeEntriesTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.knowledgeEntryId,
        referencedTable: $db.knowledgeEntries,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$KnowledgeEntriesTableAnnotationComposer(
              $db: $db,
              $table: $db.knowledgeEntries,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$KnowledgeSearchIndexTableTableManager extends RootTableManager<
    _$AppDatabase,
    $KnowledgeSearchIndexTable,
    KnowledgeSearchIndexData,
    $$KnowledgeSearchIndexTableFilterComposer,
    $$KnowledgeSearchIndexTableOrderingComposer,
    $$KnowledgeSearchIndexTableAnnotationComposer,
    $$KnowledgeSearchIndexTableCreateCompanionBuilder,
    $$KnowledgeSearchIndexTableUpdateCompanionBuilder,
    (KnowledgeSearchIndexData, $$KnowledgeSearchIndexTableReferences),
    KnowledgeSearchIndexData,
    PrefetchHooks Function({bool knowledgeEntryId})> {
  $$KnowledgeSearchIndexTableTableManager(
      _$AppDatabase db, $KnowledgeSearchIndexTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$KnowledgeSearchIndexTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$KnowledgeSearchIndexTableOrderingComposer(
                  $db: db, $table: table),
          createComputedFieldComposer: () =>
              $$KnowledgeSearchIndexTableAnnotationComposer(
                  $db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> knowledgeEntryId = const Value.absent(),
            Value<String> queryVariation = const Value.absent(),
            Value<String> synonyms = const Value.absent(),
            Value<String?> context = const Value.absent(),
            Value<double> weight = const Value.absent(),
          }) =>
              KnowledgeSearchIndexCompanion(
            id: id,
            knowledgeEntryId: knowledgeEntryId,
            queryVariation: queryVariation,
            synonyms: synonyms,
            context: context,
            weight: weight,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String knowledgeEntryId,
            required String queryVariation,
            Value<String> synonyms = const Value.absent(),
            Value<String?> context = const Value.absent(),
            Value<double> weight = const Value.absent(),
          }) =>
              KnowledgeSearchIndexCompanion.insert(
            id: id,
            knowledgeEntryId: knowledgeEntryId,
            queryVariation: queryVariation,
            synonyms: synonyms,
            context: context,
            weight: weight,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$KnowledgeSearchIndexTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: ({knowledgeEntryId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins: <
                  T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic>>(state) {
                if (knowledgeEntryId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.knowledgeEntryId,
                    referencedTable: $$KnowledgeSearchIndexTableReferences
                        ._knowledgeEntryIdTable(db),
                    referencedColumn: $$KnowledgeSearchIndexTableReferences
                        ._knowledgeEntryIdTable(db)
                        .id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ));
}

typedef $$KnowledgeSearchIndexTableProcessedTableManager
    = ProcessedTableManager<
        _$AppDatabase,
        $KnowledgeSearchIndexTable,
        KnowledgeSearchIndexData,
        $$KnowledgeSearchIndexTableFilterComposer,
        $$KnowledgeSearchIndexTableOrderingComposer,
        $$KnowledgeSearchIndexTableAnnotationComposer,
        $$KnowledgeSearchIndexTableCreateCompanionBuilder,
        $$KnowledgeSearchIndexTableUpdateCompanionBuilder,
        (KnowledgeSearchIndexData, $$KnowledgeSearchIndexTableReferences),
        KnowledgeSearchIndexData,
        PrefetchHooks Function({bool knowledgeEntryId})>;
typedef $$KnowledgeQueryLogTableCreateCompanionBuilder
    = KnowledgeQueryLogCompanion Function({
  Value<int> id,
  required String query,
  Value<String?> matchedEntryId,
  Value<bool?> wasHelpful,
  Value<int?> timeSpentSeconds,
  required DateTime queriedAt,
  Value<int?> userId,
});
typedef $$KnowledgeQueryLogTableUpdateCompanionBuilder
    = KnowledgeQueryLogCompanion Function({
  Value<int> id,
  Value<String> query,
  Value<String?> matchedEntryId,
  Value<bool?> wasHelpful,
  Value<int?> timeSpentSeconds,
  Value<DateTime> queriedAt,
  Value<int?> userId,
});

final class $$KnowledgeQueryLogTableReferences extends BaseReferences<
    _$AppDatabase, $KnowledgeQueryLogTable, KnowledgeQueryLogData> {
  $$KnowledgeQueryLogTableReferences(
      super.$_db, super.$_table, super.$_typedResult);

  static $KnowledgeEntriesTable _matchedEntryIdTable(_$AppDatabase db) =>
      db.knowledgeEntries.createAlias($_aliasNameGenerator(
          db.knowledgeQueryLog.matchedEntryId, db.knowledgeEntries.id));

  $$KnowledgeEntriesTableProcessedTableManager? get matchedEntryId {
    final $_column = $_itemColumn<String>('matched_entry_id');
    if ($_column == null) return null;
    final manager =
        $$KnowledgeEntriesTableTableManager($_db, $_db.knowledgeEntries)
            .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_matchedEntryIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }
}

class $$KnowledgeQueryLogTableFilterComposer
    extends Composer<_$AppDatabase, $KnowledgeQueryLogTable> {
  $$KnowledgeQueryLogTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get query => $composableBuilder(
      column: $table.query, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get wasHelpful => $composableBuilder(
      column: $table.wasHelpful, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get timeSpentSeconds => $composableBuilder(
      column: $table.timeSpentSeconds,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get queriedAt => $composableBuilder(
      column: $table.queriedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get userId => $composableBuilder(
      column: $table.userId, builder: (column) => ColumnFilters(column));

  $$KnowledgeEntriesTableFilterComposer get matchedEntryId {
    final $$KnowledgeEntriesTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.matchedEntryId,
        referencedTable: $db.knowledgeEntries,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$KnowledgeEntriesTableFilterComposer(
              $db: $db,
              $table: $db.knowledgeEntries,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$KnowledgeQueryLogTableOrderingComposer
    extends Composer<_$AppDatabase, $KnowledgeQueryLogTable> {
  $$KnowledgeQueryLogTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get query => $composableBuilder(
      column: $table.query, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get wasHelpful => $composableBuilder(
      column: $table.wasHelpful, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get timeSpentSeconds => $composableBuilder(
      column: $table.timeSpentSeconds,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get queriedAt => $composableBuilder(
      column: $table.queriedAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get userId => $composableBuilder(
      column: $table.userId, builder: (column) => ColumnOrderings(column));

  $$KnowledgeEntriesTableOrderingComposer get matchedEntryId {
    final $$KnowledgeEntriesTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.matchedEntryId,
        referencedTable: $db.knowledgeEntries,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$KnowledgeEntriesTableOrderingComposer(
              $db: $db,
              $table: $db.knowledgeEntries,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$KnowledgeQueryLogTableAnnotationComposer
    extends Composer<_$AppDatabase, $KnowledgeQueryLogTable> {
  $$KnowledgeQueryLogTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get query =>
      $composableBuilder(column: $table.query, builder: (column) => column);

  GeneratedColumn<bool> get wasHelpful => $composableBuilder(
      column: $table.wasHelpful, builder: (column) => column);

  GeneratedColumn<int> get timeSpentSeconds => $composableBuilder(
      column: $table.timeSpentSeconds, builder: (column) => column);

  GeneratedColumn<DateTime> get queriedAt =>
      $composableBuilder(column: $table.queriedAt, builder: (column) => column);

  GeneratedColumn<int> get userId =>
      $composableBuilder(column: $table.userId, builder: (column) => column);

  $$KnowledgeEntriesTableAnnotationComposer get matchedEntryId {
    final $$KnowledgeEntriesTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.matchedEntryId,
        referencedTable: $db.knowledgeEntries,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$KnowledgeEntriesTableAnnotationComposer(
              $db: $db,
              $table: $db.knowledgeEntries,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$KnowledgeQueryLogTableTableManager extends RootTableManager<
    _$AppDatabase,
    $KnowledgeQueryLogTable,
    KnowledgeQueryLogData,
    $$KnowledgeQueryLogTableFilterComposer,
    $$KnowledgeQueryLogTableOrderingComposer,
    $$KnowledgeQueryLogTableAnnotationComposer,
    $$KnowledgeQueryLogTableCreateCompanionBuilder,
    $$KnowledgeQueryLogTableUpdateCompanionBuilder,
    (KnowledgeQueryLogData, $$KnowledgeQueryLogTableReferences),
    KnowledgeQueryLogData,
    PrefetchHooks Function({bool matchedEntryId})> {
  $$KnowledgeQueryLogTableTableManager(
      _$AppDatabase db, $KnowledgeQueryLogTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$KnowledgeQueryLogTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$KnowledgeQueryLogTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$KnowledgeQueryLogTableAnnotationComposer(
                  $db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> query = const Value.absent(),
            Value<String?> matchedEntryId = const Value.absent(),
            Value<bool?> wasHelpful = const Value.absent(),
            Value<int?> timeSpentSeconds = const Value.absent(),
            Value<DateTime> queriedAt = const Value.absent(),
            Value<int?> userId = const Value.absent(),
          }) =>
              KnowledgeQueryLogCompanion(
            id: id,
            query: query,
            matchedEntryId: matchedEntryId,
            wasHelpful: wasHelpful,
            timeSpentSeconds: timeSpentSeconds,
            queriedAt: queriedAt,
            userId: userId,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String query,
            Value<String?> matchedEntryId = const Value.absent(),
            Value<bool?> wasHelpful = const Value.absent(),
            Value<int?> timeSpentSeconds = const Value.absent(),
            required DateTime queriedAt,
            Value<int?> userId = const Value.absent(),
          }) =>
              KnowledgeQueryLogCompanion.insert(
            id: id,
            query: query,
            matchedEntryId: matchedEntryId,
            wasHelpful: wasHelpful,
            timeSpentSeconds: timeSpentSeconds,
            queriedAt: queriedAt,
            userId: userId,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$KnowledgeQueryLogTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: ({matchedEntryId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins: <
                  T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic>>(state) {
                if (matchedEntryId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.matchedEntryId,
                    referencedTable: $$KnowledgeQueryLogTableReferences
                        ._matchedEntryIdTable(db),
                    referencedColumn: $$KnowledgeQueryLogTableReferences
                        ._matchedEntryIdTable(db)
                        .id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ));
}

typedef $$KnowledgeQueryLogTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $KnowledgeQueryLogTable,
    KnowledgeQueryLogData,
    $$KnowledgeQueryLogTableFilterComposer,
    $$KnowledgeQueryLogTableOrderingComposer,
    $$KnowledgeQueryLogTableAnnotationComposer,
    $$KnowledgeQueryLogTableCreateCompanionBuilder,
    $$KnowledgeQueryLogTableUpdateCompanionBuilder,
    (KnowledgeQueryLogData, $$KnowledgeQueryLogTableReferences),
    KnowledgeQueryLogData,
    PrefetchHooks Function({bool matchedEntryId})>;
typedef $$ChatChannelsTableCreateCompanionBuilder = ChatChannelsCompanion
    Function({
  required String id,
  required String name,
  Value<String?> description,
  required DateTime updatedAt,
  Value<int> rowid,
});
typedef $$ChatChannelsTableUpdateCompanionBuilder = ChatChannelsCompanion
    Function({
  Value<String> id,
  Value<String> name,
  Value<String?> description,
  Value<DateTime> updatedAt,
  Value<int> rowid,
});

final class $$ChatChannelsTableReferences
    extends BaseReferences<_$AppDatabase, $ChatChannelsTable, ChatChannel> {
  $$ChatChannelsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$ChatMessagesTable, List<ChatMessage>>
      _chatMessagesRefsTable(_$AppDatabase db) =>
          MultiTypedResultKey.fromTable(db.chatMessages,
              aliasName: $_aliasNameGenerator(
                  db.chatChannels.id, db.chatMessages.channelId));

  $$ChatMessagesTableProcessedTableManager get chatMessagesRefs {
    final manager = $$ChatMessagesTableTableManager($_db, $_db.chatMessages)
        .filter((f) => f.channelId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_chatMessagesRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }
}

class $$ChatChannelsTableFilterComposer
    extends Composer<_$AppDatabase, $ChatChannelsTable> {
  $$ChatChannelsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));

  Expression<bool> chatMessagesRefs(
      Expression<bool> Function($$ChatMessagesTableFilterComposer f) f) {
    final $$ChatMessagesTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.chatMessages,
        getReferencedColumn: (t) => t.channelId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ChatMessagesTableFilterComposer(
              $db: $db,
              $table: $db.chatMessages,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$ChatChannelsTableOrderingComposer
    extends Composer<_$AppDatabase, $ChatChannelsTable> {
  $$ChatChannelsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));
}

class $$ChatChannelsTableAnnotationComposer
    extends Composer<_$AppDatabase, $ChatChannelsTable> {
  $$ChatChannelsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  Expression<T> chatMessagesRefs<T extends Object>(
      Expression<T> Function($$ChatMessagesTableAnnotationComposer a) f) {
    final $$ChatMessagesTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.chatMessages,
        getReferencedColumn: (t) => t.channelId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ChatMessagesTableAnnotationComposer(
              $db: $db,
              $table: $db.chatMessages,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$ChatChannelsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $ChatChannelsTable,
    ChatChannel,
    $$ChatChannelsTableFilterComposer,
    $$ChatChannelsTableOrderingComposer,
    $$ChatChannelsTableAnnotationComposer,
    $$ChatChannelsTableCreateCompanionBuilder,
    $$ChatChannelsTableUpdateCompanionBuilder,
    (ChatChannel, $$ChatChannelsTableReferences),
    ChatChannel,
    PrefetchHooks Function({bool chatMessagesRefs})> {
  $$ChatChannelsTableTableManager(_$AppDatabase db, $ChatChannelsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ChatChannelsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ChatChannelsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ChatChannelsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<String?> description = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              ChatChannelsCompanion(
            id: id,
            name: name,
            description: description,
            updatedAt: updatedAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String name,
            Value<String?> description = const Value.absent(),
            required DateTime updatedAt,
            Value<int> rowid = const Value.absent(),
          }) =>
              ChatChannelsCompanion.insert(
            id: id,
            name: name,
            description: description,
            updatedAt: updatedAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$ChatChannelsTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: ({chatMessagesRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (chatMessagesRefs) db.chatMessages],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (chatMessagesRefs)
                    await $_getPrefetchedData<ChatChannel, $ChatChannelsTable,
                            ChatMessage>(
                        currentTable: table,
                        referencedTable: $$ChatChannelsTableReferences
                            ._chatMessagesRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$ChatChannelsTableReferences(db, table, p0)
                                .chatMessagesRefs,
                        referencedItemsForCurrentItem:
                            (item, referencedItems) => referencedItems
                                .where((e) => e.channelId == item.id),
                        typedResults: items)
                ];
              },
            );
          },
        ));
}

typedef $$ChatChannelsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $ChatChannelsTable,
    ChatChannel,
    $$ChatChannelsTableFilterComposer,
    $$ChatChannelsTableOrderingComposer,
    $$ChatChannelsTableAnnotationComposer,
    $$ChatChannelsTableCreateCompanionBuilder,
    $$ChatChannelsTableUpdateCompanionBuilder,
    (ChatChannel, $$ChatChannelsTableReferences),
    ChatChannel,
    PrefetchHooks Function({bool chatMessagesRefs})>;
typedef $$ChatMessagesTableCreateCompanionBuilder = ChatMessagesCompanion
    Function({
  required String id,
  required String channelId,
  required String senderId,
  Value<String?> senderName,
  required String content,
  required DateTime createdAt,
  Value<String> attachmentsJson,
  Value<String> reactionsJson,
  Value<bool> isSynced,
  Value<int> rowid,
});
typedef $$ChatMessagesTableUpdateCompanionBuilder = ChatMessagesCompanion
    Function({
  Value<String> id,
  Value<String> channelId,
  Value<String> senderId,
  Value<String?> senderName,
  Value<String> content,
  Value<DateTime> createdAt,
  Value<String> attachmentsJson,
  Value<String> reactionsJson,
  Value<bool> isSynced,
  Value<int> rowid,
});

final class $$ChatMessagesTableReferences
    extends BaseReferences<_$AppDatabase, $ChatMessagesTable, ChatMessage> {
  $$ChatMessagesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $ChatChannelsTable _channelIdTable(_$AppDatabase db) =>
      db.chatChannels.createAlias(
          $_aliasNameGenerator(db.chatMessages.channelId, db.chatChannels.id));

  $$ChatChannelsTableProcessedTableManager get channelId {
    final $_column = $_itemColumn<String>('channel_id')!;

    final manager = $$ChatChannelsTableTableManager($_db, $_db.chatChannels)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_channelIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }
}

class $$ChatMessagesTableFilterComposer
    extends Composer<_$AppDatabase, $ChatMessagesTable> {
  $$ChatMessagesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get senderId => $composableBuilder(
      column: $table.senderId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get senderName => $composableBuilder(
      column: $table.senderName, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get content => $composableBuilder(
      column: $table.content, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get attachmentsJson => $composableBuilder(
      column: $table.attachmentsJson,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get reactionsJson => $composableBuilder(
      column: $table.reactionsJson, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isSynced => $composableBuilder(
      column: $table.isSynced, builder: (column) => ColumnFilters(column));

  $$ChatChannelsTableFilterComposer get channelId {
    final $$ChatChannelsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.channelId,
        referencedTable: $db.chatChannels,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ChatChannelsTableFilterComposer(
              $db: $db,
              $table: $db.chatChannels,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$ChatMessagesTableOrderingComposer
    extends Composer<_$AppDatabase, $ChatMessagesTable> {
  $$ChatMessagesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get senderId => $composableBuilder(
      column: $table.senderId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get senderName => $composableBuilder(
      column: $table.senderName, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get content => $composableBuilder(
      column: $table.content, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get attachmentsJson => $composableBuilder(
      column: $table.attachmentsJson,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get reactionsJson => $composableBuilder(
      column: $table.reactionsJson,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isSynced => $composableBuilder(
      column: $table.isSynced, builder: (column) => ColumnOrderings(column));

  $$ChatChannelsTableOrderingComposer get channelId {
    final $$ChatChannelsTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.channelId,
        referencedTable: $db.chatChannels,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ChatChannelsTableOrderingComposer(
              $db: $db,
              $table: $db.chatChannels,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$ChatMessagesTableAnnotationComposer
    extends Composer<_$AppDatabase, $ChatMessagesTable> {
  $$ChatMessagesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get senderId =>
      $composableBuilder(column: $table.senderId, builder: (column) => column);

  GeneratedColumn<String> get senderName => $composableBuilder(
      column: $table.senderName, builder: (column) => column);

  GeneratedColumn<String> get content =>
      $composableBuilder(column: $table.content, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<String> get attachmentsJson => $composableBuilder(
      column: $table.attachmentsJson, builder: (column) => column);

  GeneratedColumn<String> get reactionsJson => $composableBuilder(
      column: $table.reactionsJson, builder: (column) => column);

  GeneratedColumn<bool> get isSynced =>
      $composableBuilder(column: $table.isSynced, builder: (column) => column);

  $$ChatChannelsTableAnnotationComposer get channelId {
    final $$ChatChannelsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.channelId,
        referencedTable: $db.chatChannels,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ChatChannelsTableAnnotationComposer(
              $db: $db,
              $table: $db.chatChannels,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$ChatMessagesTableTableManager extends RootTableManager<
    _$AppDatabase,
    $ChatMessagesTable,
    ChatMessage,
    $$ChatMessagesTableFilterComposer,
    $$ChatMessagesTableOrderingComposer,
    $$ChatMessagesTableAnnotationComposer,
    $$ChatMessagesTableCreateCompanionBuilder,
    $$ChatMessagesTableUpdateCompanionBuilder,
    (ChatMessage, $$ChatMessagesTableReferences),
    ChatMessage,
    PrefetchHooks Function({bool channelId})> {
  $$ChatMessagesTableTableManager(_$AppDatabase db, $ChatMessagesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ChatMessagesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ChatMessagesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ChatMessagesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> channelId = const Value.absent(),
            Value<String> senderId = const Value.absent(),
            Value<String?> senderName = const Value.absent(),
            Value<String> content = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<String> attachmentsJson = const Value.absent(),
            Value<String> reactionsJson = const Value.absent(),
            Value<bool> isSynced = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              ChatMessagesCompanion(
            id: id,
            channelId: channelId,
            senderId: senderId,
            senderName: senderName,
            content: content,
            createdAt: createdAt,
            attachmentsJson: attachmentsJson,
            reactionsJson: reactionsJson,
            isSynced: isSynced,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String channelId,
            required String senderId,
            Value<String?> senderName = const Value.absent(),
            required String content,
            required DateTime createdAt,
            Value<String> attachmentsJson = const Value.absent(),
            Value<String> reactionsJson = const Value.absent(),
            Value<bool> isSynced = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              ChatMessagesCompanion.insert(
            id: id,
            channelId: channelId,
            senderId: senderId,
            senderName: senderName,
            content: content,
            createdAt: createdAt,
            attachmentsJson: attachmentsJson,
            reactionsJson: reactionsJson,
            isSynced: isSynced,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$ChatMessagesTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: ({channelId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins: <
                  T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic>>(state) {
                if (channelId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.channelId,
                    referencedTable:
                        $$ChatMessagesTableReferences._channelIdTable(db),
                    referencedColumn:
                        $$ChatMessagesTableReferences._channelIdTable(db).id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ));
}

typedef $$ChatMessagesTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $ChatMessagesTable,
    ChatMessage,
    $$ChatMessagesTableFilterComposer,
    $$ChatMessagesTableOrderingComposer,
    $$ChatMessagesTableAnnotationComposer,
    $$ChatMessagesTableCreateCompanionBuilder,
    $$ChatMessagesTableUpdateCompanionBuilder,
    (ChatMessage, $$ChatMessagesTableReferences),
    ChatMessage,
    PrefetchHooks Function({bool channelId})>;
typedef $$ContinuingEducationCoursesTableCreateCompanionBuilder
    = ContinuingEducationCoursesCompanion Function({
  Value<int> id,
  required String title,
  required String provider,
  Value<String?> description,
  required String category,
  Value<int?> durationHours,
  Value<String?> externalUrl,
});
typedef $$ContinuingEducationCoursesTableUpdateCompanionBuilder
    = ContinuingEducationCoursesCompanion Function({
  Value<int> id,
  Value<String> title,
  Value<String> provider,
  Value<String?> description,
  Value<String> category,
  Value<int?> durationHours,
  Value<String?> externalUrl,
});

class $$ContinuingEducationCoursesTableFilterComposer
    extends Composer<_$AppDatabase, $ContinuingEducationCoursesTable> {
  $$ContinuingEducationCoursesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get title => $composableBuilder(
      column: $table.title, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get provider => $composableBuilder(
      column: $table.provider, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get category => $composableBuilder(
      column: $table.category, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get durationHours => $composableBuilder(
      column: $table.durationHours, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get externalUrl => $composableBuilder(
      column: $table.externalUrl, builder: (column) => ColumnFilters(column));
}

class $$ContinuingEducationCoursesTableOrderingComposer
    extends Composer<_$AppDatabase, $ContinuingEducationCoursesTable> {
  $$ContinuingEducationCoursesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get title => $composableBuilder(
      column: $table.title, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get provider => $composableBuilder(
      column: $table.provider, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get category => $composableBuilder(
      column: $table.category, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get durationHours => $composableBuilder(
      column: $table.durationHours,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get externalUrl => $composableBuilder(
      column: $table.externalUrl, builder: (column) => ColumnOrderings(column));
}

class $$ContinuingEducationCoursesTableAnnotationComposer
    extends Composer<_$AppDatabase, $ContinuingEducationCoursesTable> {
  $$ContinuingEducationCoursesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get provider =>
      $composableBuilder(column: $table.provider, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => column);

  GeneratedColumn<String> get category =>
      $composableBuilder(column: $table.category, builder: (column) => column);

  GeneratedColumn<int> get durationHours => $composableBuilder(
      column: $table.durationHours, builder: (column) => column);

  GeneratedColumn<String> get externalUrl => $composableBuilder(
      column: $table.externalUrl, builder: (column) => column);
}

class $$ContinuingEducationCoursesTableTableManager extends RootTableManager<
    _$AppDatabase,
    $ContinuingEducationCoursesTable,
    ContinuingEducationCourse,
    $$ContinuingEducationCoursesTableFilterComposer,
    $$ContinuingEducationCoursesTableOrderingComposer,
    $$ContinuingEducationCoursesTableAnnotationComposer,
    $$ContinuingEducationCoursesTableCreateCompanionBuilder,
    $$ContinuingEducationCoursesTableUpdateCompanionBuilder,
    (
      ContinuingEducationCourse,
      BaseReferences<_$AppDatabase, $ContinuingEducationCoursesTable,
          ContinuingEducationCourse>
    ),
    ContinuingEducationCourse,
    PrefetchHooks Function()> {
  $$ContinuingEducationCoursesTableTableManager(
      _$AppDatabase db, $ContinuingEducationCoursesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ContinuingEducationCoursesTableFilterComposer(
                  $db: db, $table: table),
          createOrderingComposer: () =>
              $$ContinuingEducationCoursesTableOrderingComposer(
                  $db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ContinuingEducationCoursesTableAnnotationComposer(
                  $db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> title = const Value.absent(),
            Value<String> provider = const Value.absent(),
            Value<String?> description = const Value.absent(),
            Value<String> category = const Value.absent(),
            Value<int?> durationHours = const Value.absent(),
            Value<String?> externalUrl = const Value.absent(),
          }) =>
              ContinuingEducationCoursesCompanion(
            id: id,
            title: title,
            provider: provider,
            description: description,
            category: category,
            durationHours: durationHours,
            externalUrl: externalUrl,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String title,
            required String provider,
            Value<String?> description = const Value.absent(),
            required String category,
            Value<int?> durationHours = const Value.absent(),
            Value<String?> externalUrl = const Value.absent(),
          }) =>
              ContinuingEducationCoursesCompanion.insert(
            id: id,
            title: title,
            provider: provider,
            description: description,
            category: category,
            durationHours: durationHours,
            externalUrl: externalUrl,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$ContinuingEducationCoursesTableProcessedTableManager
    = ProcessedTableManager<
        _$AppDatabase,
        $ContinuingEducationCoursesTable,
        ContinuingEducationCourse,
        $$ContinuingEducationCoursesTableFilterComposer,
        $$ContinuingEducationCoursesTableOrderingComposer,
        $$ContinuingEducationCoursesTableAnnotationComposer,
        $$ContinuingEducationCoursesTableCreateCompanionBuilder,
        $$ContinuingEducationCoursesTableUpdateCompanionBuilder,
        (
          ContinuingEducationCourse,
          BaseReferences<_$AppDatabase, $ContinuingEducationCoursesTable,
              ContinuingEducationCourse>
        ),
        ContinuingEducationCourse,
        PrefetchHooks Function()>;
typedef $$UserCourseEnrollmentsTableCreateCompanionBuilder
    = UserCourseEnrollmentsCompanion Function({
  Value<int> id,
  required int userId,
  required int courseId,
  required DateTime enrolledAt,
  Value<DateTime?> completedAt,
  required String status,
});
typedef $$UserCourseEnrollmentsTableUpdateCompanionBuilder
    = UserCourseEnrollmentsCompanion Function({
  Value<int> id,
  Value<int> userId,
  Value<int> courseId,
  Value<DateTime> enrolledAt,
  Value<DateTime?> completedAt,
  Value<String> status,
});

class $$UserCourseEnrollmentsTableFilterComposer
    extends Composer<_$AppDatabase, $UserCourseEnrollmentsTable> {
  $$UserCourseEnrollmentsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get userId => $composableBuilder(
      column: $table.userId, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get courseId => $composableBuilder(
      column: $table.courseId, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get enrolledAt => $composableBuilder(
      column: $table.enrolledAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get completedAt => $composableBuilder(
      column: $table.completedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnFilters(column));
}

class $$UserCourseEnrollmentsTableOrderingComposer
    extends Composer<_$AppDatabase, $UserCourseEnrollmentsTable> {
  $$UserCourseEnrollmentsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get userId => $composableBuilder(
      column: $table.userId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get courseId => $composableBuilder(
      column: $table.courseId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get enrolledAt => $composableBuilder(
      column: $table.enrolledAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get completedAt => $composableBuilder(
      column: $table.completedAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnOrderings(column));
}

class $$UserCourseEnrollmentsTableAnnotationComposer
    extends Composer<_$AppDatabase, $UserCourseEnrollmentsTable> {
  $$UserCourseEnrollmentsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get userId =>
      $composableBuilder(column: $table.userId, builder: (column) => column);

  GeneratedColumn<int> get courseId =>
      $composableBuilder(column: $table.courseId, builder: (column) => column);

  GeneratedColumn<DateTime> get enrolledAt => $composableBuilder(
      column: $table.enrolledAt, builder: (column) => column);

  GeneratedColumn<DateTime> get completedAt => $composableBuilder(
      column: $table.completedAt, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);
}

class $$UserCourseEnrollmentsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $UserCourseEnrollmentsTable,
    UserCourseEnrollment,
    $$UserCourseEnrollmentsTableFilterComposer,
    $$UserCourseEnrollmentsTableOrderingComposer,
    $$UserCourseEnrollmentsTableAnnotationComposer,
    $$UserCourseEnrollmentsTableCreateCompanionBuilder,
    $$UserCourseEnrollmentsTableUpdateCompanionBuilder,
    (
      UserCourseEnrollment,
      BaseReferences<_$AppDatabase, $UserCourseEnrollmentsTable,
          UserCourseEnrollment>
    ),
    UserCourseEnrollment,
    PrefetchHooks Function()> {
  $$UserCourseEnrollmentsTableTableManager(
      _$AppDatabase db, $UserCourseEnrollmentsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$UserCourseEnrollmentsTableFilterComposer(
                  $db: db, $table: table),
          createOrderingComposer: () =>
              $$UserCourseEnrollmentsTableOrderingComposer(
                  $db: db, $table: table),
          createComputedFieldComposer: () =>
              $$UserCourseEnrollmentsTableAnnotationComposer(
                  $db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<int> userId = const Value.absent(),
            Value<int> courseId = const Value.absent(),
            Value<DateTime> enrolledAt = const Value.absent(),
            Value<DateTime?> completedAt = const Value.absent(),
            Value<String> status = const Value.absent(),
          }) =>
              UserCourseEnrollmentsCompanion(
            id: id,
            userId: userId,
            courseId: courseId,
            enrolledAt: enrolledAt,
            completedAt: completedAt,
            status: status,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required int userId,
            required int courseId,
            required DateTime enrolledAt,
            Value<DateTime?> completedAt = const Value.absent(),
            required String status,
          }) =>
              UserCourseEnrollmentsCompanion.insert(
            id: id,
            userId: userId,
            courseId: courseId,
            enrolledAt: enrolledAt,
            completedAt: completedAt,
            status: status,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$UserCourseEnrollmentsTableProcessedTableManager
    = ProcessedTableManager<
        _$AppDatabase,
        $UserCourseEnrollmentsTable,
        UserCourseEnrollment,
        $$UserCourseEnrollmentsTableFilterComposer,
        $$UserCourseEnrollmentsTableOrderingComposer,
        $$UserCourseEnrollmentsTableAnnotationComposer,
        $$UserCourseEnrollmentsTableCreateCompanionBuilder,
        $$UserCourseEnrollmentsTableUpdateCompanionBuilder,
        (
          UserCourseEnrollment,
          BaseReferences<_$AppDatabase, $UserCourseEnrollmentsTable,
              UserCourseEnrollment>
        ),
        UserCourseEnrollment,
        PrefetchHooks Function()>;
typedef $$ExpensesTableCreateCompanionBuilder = ExpensesCompanion Function({
  Value<int> id,
  required int userId,
  required DateTime expenseDate,
  required String category,
  required double amount,
  Value<String?> description,
  Value<String?> receiptPath,
  Value<int?> workOrderId,
});
typedef $$ExpensesTableUpdateCompanionBuilder = ExpensesCompanion Function({
  Value<int> id,
  Value<int> userId,
  Value<DateTime> expenseDate,
  Value<String> category,
  Value<double> amount,
  Value<String?> description,
  Value<String?> receiptPath,
  Value<int?> workOrderId,
});

class $$ExpensesTableFilterComposer
    extends Composer<_$AppDatabase, $ExpensesTable> {
  $$ExpensesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get userId => $composableBuilder(
      column: $table.userId, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get expenseDate => $composableBuilder(
      column: $table.expenseDate, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get category => $composableBuilder(
      column: $table.category, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get amount => $composableBuilder(
      column: $table.amount, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get receiptPath => $composableBuilder(
      column: $table.receiptPath, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get workOrderId => $composableBuilder(
      column: $table.workOrderId, builder: (column) => ColumnFilters(column));
}

class $$ExpensesTableOrderingComposer
    extends Composer<_$AppDatabase, $ExpensesTable> {
  $$ExpensesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get userId => $composableBuilder(
      column: $table.userId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get expenseDate => $composableBuilder(
      column: $table.expenseDate, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get category => $composableBuilder(
      column: $table.category, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get amount => $composableBuilder(
      column: $table.amount, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get receiptPath => $composableBuilder(
      column: $table.receiptPath, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get workOrderId => $composableBuilder(
      column: $table.workOrderId, builder: (column) => ColumnOrderings(column));
}

class $$ExpensesTableAnnotationComposer
    extends Composer<_$AppDatabase, $ExpensesTable> {
  $$ExpensesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get userId =>
      $composableBuilder(column: $table.userId, builder: (column) => column);

  GeneratedColumn<DateTime> get expenseDate => $composableBuilder(
      column: $table.expenseDate, builder: (column) => column);

  GeneratedColumn<String> get category =>
      $composableBuilder(column: $table.category, builder: (column) => column);

  GeneratedColumn<double> get amount =>
      $composableBuilder(column: $table.amount, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => column);

  GeneratedColumn<String> get receiptPath => $composableBuilder(
      column: $table.receiptPath, builder: (column) => column);

  GeneratedColumn<int> get workOrderId => $composableBuilder(
      column: $table.workOrderId, builder: (column) => column);
}

class $$ExpensesTableTableManager extends RootTableManager<
    _$AppDatabase,
    $ExpensesTable,
    Expense,
    $$ExpensesTableFilterComposer,
    $$ExpensesTableOrderingComposer,
    $$ExpensesTableAnnotationComposer,
    $$ExpensesTableCreateCompanionBuilder,
    $$ExpensesTableUpdateCompanionBuilder,
    (Expense, BaseReferences<_$AppDatabase, $ExpensesTable, Expense>),
    Expense,
    PrefetchHooks Function()> {
  $$ExpensesTableTableManager(_$AppDatabase db, $ExpensesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ExpensesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ExpensesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ExpensesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<int> userId = const Value.absent(),
            Value<DateTime> expenseDate = const Value.absent(),
            Value<String> category = const Value.absent(),
            Value<double> amount = const Value.absent(),
            Value<String?> description = const Value.absent(),
            Value<String?> receiptPath = const Value.absent(),
            Value<int?> workOrderId = const Value.absent(),
          }) =>
              ExpensesCompanion(
            id: id,
            userId: userId,
            expenseDate: expenseDate,
            category: category,
            amount: amount,
            description: description,
            receiptPath: receiptPath,
            workOrderId: workOrderId,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required int userId,
            required DateTime expenseDate,
            required String category,
            required double amount,
            Value<String?> description = const Value.absent(),
            Value<String?> receiptPath = const Value.absent(),
            Value<int?> workOrderId = const Value.absent(),
          }) =>
              ExpensesCompanion.insert(
            id: id,
            userId: userId,
            expenseDate: expenseDate,
            category: category,
            amount: amount,
            description: description,
            receiptPath: receiptPath,
            workOrderId: workOrderId,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$ExpensesTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $ExpensesTable,
    Expense,
    $$ExpensesTableFilterComposer,
    $$ExpensesTableOrderingComposer,
    $$ExpensesTableAnnotationComposer,
    $$ExpensesTableCreateCompanionBuilder,
    $$ExpensesTableUpdateCompanionBuilder,
    (Expense, BaseReferences<_$AppDatabase, $ExpensesTable, Expense>),
    Expense,
    PrefetchHooks Function()>;
typedef $$WorkOrderAuditLogTableCreateCompanionBuilder
    = WorkOrderAuditLogCompanion Function({
  Value<int> id,
  required int workOrderId,
  required int userId,
  required String action,
  Value<String?> fieldChanged,
  Value<String?> oldValue,
  Value<String?> newValue,
  Value<String?> changeReason,
  Value<String?> ipAddress,
  Value<DateTime> changedAt,
});
typedef $$WorkOrderAuditLogTableUpdateCompanionBuilder
    = WorkOrderAuditLogCompanion Function({
  Value<int> id,
  Value<int> workOrderId,
  Value<int> userId,
  Value<String> action,
  Value<String?> fieldChanged,
  Value<String?> oldValue,
  Value<String?> newValue,
  Value<String?> changeReason,
  Value<String?> ipAddress,
  Value<DateTime> changedAt,
});

class $$WorkOrderAuditLogTableFilterComposer
    extends Composer<_$AppDatabase, $WorkOrderAuditLogTable> {
  $$WorkOrderAuditLogTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get workOrderId => $composableBuilder(
      column: $table.workOrderId, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get userId => $composableBuilder(
      column: $table.userId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get action => $composableBuilder(
      column: $table.action, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get fieldChanged => $composableBuilder(
      column: $table.fieldChanged, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get oldValue => $composableBuilder(
      column: $table.oldValue, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get newValue => $composableBuilder(
      column: $table.newValue, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get changeReason => $composableBuilder(
      column: $table.changeReason, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get ipAddress => $composableBuilder(
      column: $table.ipAddress, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get changedAt => $composableBuilder(
      column: $table.changedAt, builder: (column) => ColumnFilters(column));
}

class $$WorkOrderAuditLogTableOrderingComposer
    extends Composer<_$AppDatabase, $WorkOrderAuditLogTable> {
  $$WorkOrderAuditLogTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get workOrderId => $composableBuilder(
      column: $table.workOrderId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get userId => $composableBuilder(
      column: $table.userId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get action => $composableBuilder(
      column: $table.action, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get fieldChanged => $composableBuilder(
      column: $table.fieldChanged,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get oldValue => $composableBuilder(
      column: $table.oldValue, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get newValue => $composableBuilder(
      column: $table.newValue, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get changeReason => $composableBuilder(
      column: $table.changeReason,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get ipAddress => $composableBuilder(
      column: $table.ipAddress, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get changedAt => $composableBuilder(
      column: $table.changedAt, builder: (column) => ColumnOrderings(column));
}

class $$WorkOrderAuditLogTableAnnotationComposer
    extends Composer<_$AppDatabase, $WorkOrderAuditLogTable> {
  $$WorkOrderAuditLogTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get workOrderId => $composableBuilder(
      column: $table.workOrderId, builder: (column) => column);

  GeneratedColumn<int> get userId =>
      $composableBuilder(column: $table.userId, builder: (column) => column);

  GeneratedColumn<String> get action =>
      $composableBuilder(column: $table.action, builder: (column) => column);

  GeneratedColumn<String> get fieldChanged => $composableBuilder(
      column: $table.fieldChanged, builder: (column) => column);

  GeneratedColumn<String> get oldValue =>
      $composableBuilder(column: $table.oldValue, builder: (column) => column);

  GeneratedColumn<String> get newValue =>
      $composableBuilder(column: $table.newValue, builder: (column) => column);

  GeneratedColumn<String> get changeReason => $composableBuilder(
      column: $table.changeReason, builder: (column) => column);

  GeneratedColumn<String> get ipAddress =>
      $composableBuilder(column: $table.ipAddress, builder: (column) => column);

  GeneratedColumn<DateTime> get changedAt =>
      $composableBuilder(column: $table.changedAt, builder: (column) => column);
}

class $$WorkOrderAuditLogTableTableManager extends RootTableManager<
    _$AppDatabase,
    $WorkOrderAuditLogTable,
    WorkOrderAuditLogData,
    $$WorkOrderAuditLogTableFilterComposer,
    $$WorkOrderAuditLogTableOrderingComposer,
    $$WorkOrderAuditLogTableAnnotationComposer,
    $$WorkOrderAuditLogTableCreateCompanionBuilder,
    $$WorkOrderAuditLogTableUpdateCompanionBuilder,
    (
      WorkOrderAuditLogData,
      BaseReferences<_$AppDatabase, $WorkOrderAuditLogTable,
          WorkOrderAuditLogData>
    ),
    WorkOrderAuditLogData,
    PrefetchHooks Function()> {
  $$WorkOrderAuditLogTableTableManager(
      _$AppDatabase db, $WorkOrderAuditLogTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$WorkOrderAuditLogTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$WorkOrderAuditLogTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$WorkOrderAuditLogTableAnnotationComposer(
                  $db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<int> workOrderId = const Value.absent(),
            Value<int> userId = const Value.absent(),
            Value<String> action = const Value.absent(),
            Value<String?> fieldChanged = const Value.absent(),
            Value<String?> oldValue = const Value.absent(),
            Value<String?> newValue = const Value.absent(),
            Value<String?> changeReason = const Value.absent(),
            Value<String?> ipAddress = const Value.absent(),
            Value<DateTime> changedAt = const Value.absent(),
          }) =>
              WorkOrderAuditLogCompanion(
            id: id,
            workOrderId: workOrderId,
            userId: userId,
            action: action,
            fieldChanged: fieldChanged,
            oldValue: oldValue,
            newValue: newValue,
            changeReason: changeReason,
            ipAddress: ipAddress,
            changedAt: changedAt,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required int workOrderId,
            required int userId,
            required String action,
            Value<String?> fieldChanged = const Value.absent(),
            Value<String?> oldValue = const Value.absent(),
            Value<String?> newValue = const Value.absent(),
            Value<String?> changeReason = const Value.absent(),
            Value<String?> ipAddress = const Value.absent(),
            Value<DateTime> changedAt = const Value.absent(),
          }) =>
              WorkOrderAuditLogCompanion.insert(
            id: id,
            workOrderId: workOrderId,
            userId: userId,
            action: action,
            fieldChanged: fieldChanged,
            oldValue: oldValue,
            newValue: newValue,
            changeReason: changeReason,
            ipAddress: ipAddress,
            changedAt: changedAt,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$WorkOrderAuditLogTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $WorkOrderAuditLogTable,
    WorkOrderAuditLogData,
    $$WorkOrderAuditLogTableFilterComposer,
    $$WorkOrderAuditLogTableOrderingComposer,
    $$WorkOrderAuditLogTableAnnotationComposer,
    $$WorkOrderAuditLogTableCreateCompanionBuilder,
    $$WorkOrderAuditLogTableUpdateCompanionBuilder,
    (
      WorkOrderAuditLogData,
      BaseReferences<_$AppDatabase, $WorkOrderAuditLogTable,
          WorkOrderAuditLogData>
    ),
    WorkOrderAuditLogData,
    PrefetchHooks Function()>;
typedef $$WorkOrderStatusTransitionsTableCreateCompanionBuilder
    = WorkOrderStatusTransitionsCompanion Function({
  Value<int> id,
  required int workOrderId,
  required String fromStatus,
  required String toStatus,
  required int changedBy,
  Value<String?> notes,
  Value<DateTime> transitionedAt,
});
typedef $$WorkOrderStatusTransitionsTableUpdateCompanionBuilder
    = WorkOrderStatusTransitionsCompanion Function({
  Value<int> id,
  Value<int> workOrderId,
  Value<String> fromStatus,
  Value<String> toStatus,
  Value<int> changedBy,
  Value<String?> notes,
  Value<DateTime> transitionedAt,
});

class $$WorkOrderStatusTransitionsTableFilterComposer
    extends Composer<_$AppDatabase, $WorkOrderStatusTransitionsTable> {
  $$WorkOrderStatusTransitionsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get workOrderId => $composableBuilder(
      column: $table.workOrderId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get fromStatus => $composableBuilder(
      column: $table.fromStatus, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get toStatus => $composableBuilder(
      column: $table.toStatus, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get changedBy => $composableBuilder(
      column: $table.changedBy, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get notes => $composableBuilder(
      column: $table.notes, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get transitionedAt => $composableBuilder(
      column: $table.transitionedAt,
      builder: (column) => ColumnFilters(column));
}

class $$WorkOrderStatusTransitionsTableOrderingComposer
    extends Composer<_$AppDatabase, $WorkOrderStatusTransitionsTable> {
  $$WorkOrderStatusTransitionsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get workOrderId => $composableBuilder(
      column: $table.workOrderId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get fromStatus => $composableBuilder(
      column: $table.fromStatus, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get toStatus => $composableBuilder(
      column: $table.toStatus, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get changedBy => $composableBuilder(
      column: $table.changedBy, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get notes => $composableBuilder(
      column: $table.notes, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get transitionedAt => $composableBuilder(
      column: $table.transitionedAt,
      builder: (column) => ColumnOrderings(column));
}

class $$WorkOrderStatusTransitionsTableAnnotationComposer
    extends Composer<_$AppDatabase, $WorkOrderStatusTransitionsTable> {
  $$WorkOrderStatusTransitionsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get workOrderId => $composableBuilder(
      column: $table.workOrderId, builder: (column) => column);

  GeneratedColumn<String> get fromStatus => $composableBuilder(
      column: $table.fromStatus, builder: (column) => column);

  GeneratedColumn<String> get toStatus =>
      $composableBuilder(column: $table.toStatus, builder: (column) => column);

  GeneratedColumn<int> get changedBy =>
      $composableBuilder(column: $table.changedBy, builder: (column) => column);

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<DateTime> get transitionedAt => $composableBuilder(
      column: $table.transitionedAt, builder: (column) => column);
}

class $$WorkOrderStatusTransitionsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $WorkOrderStatusTransitionsTable,
    WorkOrderStatusTransition,
    $$WorkOrderStatusTransitionsTableFilterComposer,
    $$WorkOrderStatusTransitionsTableOrderingComposer,
    $$WorkOrderStatusTransitionsTableAnnotationComposer,
    $$WorkOrderStatusTransitionsTableCreateCompanionBuilder,
    $$WorkOrderStatusTransitionsTableUpdateCompanionBuilder,
    (
      WorkOrderStatusTransition,
      BaseReferences<_$AppDatabase, $WorkOrderStatusTransitionsTable,
          WorkOrderStatusTransition>
    ),
    WorkOrderStatusTransition,
    PrefetchHooks Function()> {
  $$WorkOrderStatusTransitionsTableTableManager(
      _$AppDatabase db, $WorkOrderStatusTransitionsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$WorkOrderStatusTransitionsTableFilterComposer(
                  $db: db, $table: table),
          createOrderingComposer: () =>
              $$WorkOrderStatusTransitionsTableOrderingComposer(
                  $db: db, $table: table),
          createComputedFieldComposer: () =>
              $$WorkOrderStatusTransitionsTableAnnotationComposer(
                  $db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<int> workOrderId = const Value.absent(),
            Value<String> fromStatus = const Value.absent(),
            Value<String> toStatus = const Value.absent(),
            Value<int> changedBy = const Value.absent(),
            Value<String?> notes = const Value.absent(),
            Value<DateTime> transitionedAt = const Value.absent(),
          }) =>
              WorkOrderStatusTransitionsCompanion(
            id: id,
            workOrderId: workOrderId,
            fromStatus: fromStatus,
            toStatus: toStatus,
            changedBy: changedBy,
            notes: notes,
            transitionedAt: transitionedAt,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required int workOrderId,
            required String fromStatus,
            required String toStatus,
            required int changedBy,
            Value<String?> notes = const Value.absent(),
            Value<DateTime> transitionedAt = const Value.absent(),
          }) =>
              WorkOrderStatusTransitionsCompanion.insert(
            id: id,
            workOrderId: workOrderId,
            fromStatus: fromStatus,
            toStatus: toStatus,
            changedBy: changedBy,
            notes: notes,
            transitionedAt: transitionedAt,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$WorkOrderStatusTransitionsTableProcessedTableManager
    = ProcessedTableManager<
        _$AppDatabase,
        $WorkOrderStatusTransitionsTable,
        WorkOrderStatusTransition,
        $$WorkOrderStatusTransitionsTableFilterComposer,
        $$WorkOrderStatusTransitionsTableOrderingComposer,
        $$WorkOrderStatusTransitionsTableAnnotationComposer,
        $$WorkOrderStatusTransitionsTableCreateCompanionBuilder,
        $$WorkOrderStatusTransitionsTableUpdateCompanionBuilder,
        (
          WorkOrderStatusTransition,
          BaseReferences<_$AppDatabase, $WorkOrderStatusTransitionsTable,
              WorkOrderStatusTransition>
        ),
        WorkOrderStatusTransition,
        PrefetchHooks Function()>;
typedef $$ProvenanceLogTableCreateCompanionBuilder = ProvenanceLogCompanion
    Function({
  Value<int> id,
  required String recordType,
  required int recordId,
  required String action,
  required String contentHash,
  Value<String?> previousHash,
  required String userSid,
  required String userName,
  Value<DateTime> timestamp,
  Value<String?> changeMetadata,
});
typedef $$ProvenanceLogTableUpdateCompanionBuilder = ProvenanceLogCompanion
    Function({
  Value<int> id,
  Value<String> recordType,
  Value<int> recordId,
  Value<String> action,
  Value<String> contentHash,
  Value<String?> previousHash,
  Value<String> userSid,
  Value<String> userName,
  Value<DateTime> timestamp,
  Value<String?> changeMetadata,
});

class $$ProvenanceLogTableFilterComposer
    extends Composer<_$AppDatabase, $ProvenanceLogTable> {
  $$ProvenanceLogTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get recordType => $composableBuilder(
      column: $table.recordType, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get recordId => $composableBuilder(
      column: $table.recordId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get action => $composableBuilder(
      column: $table.action, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get contentHash => $composableBuilder(
      column: $table.contentHash, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get previousHash => $composableBuilder(
      column: $table.previousHash, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get userSid => $composableBuilder(
      column: $table.userSid, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get userName => $composableBuilder(
      column: $table.userName, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get timestamp => $composableBuilder(
      column: $table.timestamp, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get changeMetadata => $composableBuilder(
      column: $table.changeMetadata,
      builder: (column) => ColumnFilters(column));
}

class $$ProvenanceLogTableOrderingComposer
    extends Composer<_$AppDatabase, $ProvenanceLogTable> {
  $$ProvenanceLogTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get recordType => $composableBuilder(
      column: $table.recordType, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get recordId => $composableBuilder(
      column: $table.recordId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get action => $composableBuilder(
      column: $table.action, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get contentHash => $composableBuilder(
      column: $table.contentHash, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get previousHash => $composableBuilder(
      column: $table.previousHash,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get userSid => $composableBuilder(
      column: $table.userSid, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get userName => $composableBuilder(
      column: $table.userName, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get timestamp => $composableBuilder(
      column: $table.timestamp, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get changeMetadata => $composableBuilder(
      column: $table.changeMetadata,
      builder: (column) => ColumnOrderings(column));
}

class $$ProvenanceLogTableAnnotationComposer
    extends Composer<_$AppDatabase, $ProvenanceLogTable> {
  $$ProvenanceLogTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get recordType => $composableBuilder(
      column: $table.recordType, builder: (column) => column);

  GeneratedColumn<int> get recordId =>
      $composableBuilder(column: $table.recordId, builder: (column) => column);

  GeneratedColumn<String> get action =>
      $composableBuilder(column: $table.action, builder: (column) => column);

  GeneratedColumn<String> get contentHash => $composableBuilder(
      column: $table.contentHash, builder: (column) => column);

  GeneratedColumn<String> get previousHash => $composableBuilder(
      column: $table.previousHash, builder: (column) => column);

  GeneratedColumn<String> get userSid =>
      $composableBuilder(column: $table.userSid, builder: (column) => column);

  GeneratedColumn<String> get userName =>
      $composableBuilder(column: $table.userName, builder: (column) => column);

  GeneratedColumn<DateTime> get timestamp =>
      $composableBuilder(column: $table.timestamp, builder: (column) => column);

  GeneratedColumn<String> get changeMetadata => $composableBuilder(
      column: $table.changeMetadata, builder: (column) => column);
}

class $$ProvenanceLogTableTableManager extends RootTableManager<
    _$AppDatabase,
    $ProvenanceLogTable,
    ProvenanceLogData,
    $$ProvenanceLogTableFilterComposer,
    $$ProvenanceLogTableOrderingComposer,
    $$ProvenanceLogTableAnnotationComposer,
    $$ProvenanceLogTableCreateCompanionBuilder,
    $$ProvenanceLogTableUpdateCompanionBuilder,
    (
      ProvenanceLogData,
      BaseReferences<_$AppDatabase, $ProvenanceLogTable, ProvenanceLogData>
    ),
    ProvenanceLogData,
    PrefetchHooks Function()> {
  $$ProvenanceLogTableTableManager(_$AppDatabase db, $ProvenanceLogTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ProvenanceLogTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ProvenanceLogTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ProvenanceLogTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> recordType = const Value.absent(),
            Value<int> recordId = const Value.absent(),
            Value<String> action = const Value.absent(),
            Value<String> contentHash = const Value.absent(),
            Value<String?> previousHash = const Value.absent(),
            Value<String> userSid = const Value.absent(),
            Value<String> userName = const Value.absent(),
            Value<DateTime> timestamp = const Value.absent(),
            Value<String?> changeMetadata = const Value.absent(),
          }) =>
              ProvenanceLogCompanion(
            id: id,
            recordType: recordType,
            recordId: recordId,
            action: action,
            contentHash: contentHash,
            previousHash: previousHash,
            userSid: userSid,
            userName: userName,
            timestamp: timestamp,
            changeMetadata: changeMetadata,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String recordType,
            required int recordId,
            required String action,
            required String contentHash,
            Value<String?> previousHash = const Value.absent(),
            required String userSid,
            required String userName,
            Value<DateTime> timestamp = const Value.absent(),
            Value<String?> changeMetadata = const Value.absent(),
          }) =>
              ProvenanceLogCompanion.insert(
            id: id,
            recordType: recordType,
            recordId: recordId,
            action: action,
            contentHash: contentHash,
            previousHash: previousHash,
            userSid: userSid,
            userName: userName,
            timestamp: timestamp,
            changeMetadata: changeMetadata,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$ProvenanceLogTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $ProvenanceLogTable,
    ProvenanceLogData,
    $$ProvenanceLogTableFilterComposer,
    $$ProvenanceLogTableOrderingComposer,
    $$ProvenanceLogTableAnnotationComposer,
    $$ProvenanceLogTableCreateCompanionBuilder,
    $$ProvenanceLogTableUpdateCompanionBuilder,
    (
      ProvenanceLogData,
      BaseReferences<_$AppDatabase, $ProvenanceLogTable, ProvenanceLogData>
    ),
    ProvenanceLogData,
    PrefetchHooks Function()>;
typedef $$EncryptionKeyStoreTableCreateCompanionBuilder
    = EncryptionKeyStoreCompanion Function({
  Value<int> id,
  required String keyPurpose,
  required String encryptedKey,
  required String keyFingerprint,
  Value<DateTime> createdAt,
  Value<DateTime?> lastAccessedAt,
  Value<int> accessCount,
});
typedef $$EncryptionKeyStoreTableUpdateCompanionBuilder
    = EncryptionKeyStoreCompanion Function({
  Value<int> id,
  Value<String> keyPurpose,
  Value<String> encryptedKey,
  Value<String> keyFingerprint,
  Value<DateTime> createdAt,
  Value<DateTime?> lastAccessedAt,
  Value<int> accessCount,
});

class $$EncryptionKeyStoreTableFilterComposer
    extends Composer<_$AppDatabase, $EncryptionKeyStoreTable> {
  $$EncryptionKeyStoreTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get keyPurpose => $composableBuilder(
      column: $table.keyPurpose, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get encryptedKey => $composableBuilder(
      column: $table.encryptedKey, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get keyFingerprint => $composableBuilder(
      column: $table.keyFingerprint,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get lastAccessedAt => $composableBuilder(
      column: $table.lastAccessedAt,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get accessCount => $composableBuilder(
      column: $table.accessCount, builder: (column) => ColumnFilters(column));
}

class $$EncryptionKeyStoreTableOrderingComposer
    extends Composer<_$AppDatabase, $EncryptionKeyStoreTable> {
  $$EncryptionKeyStoreTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get keyPurpose => $composableBuilder(
      column: $table.keyPurpose, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get encryptedKey => $composableBuilder(
      column: $table.encryptedKey,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get keyFingerprint => $composableBuilder(
      column: $table.keyFingerprint,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get lastAccessedAt => $composableBuilder(
      column: $table.lastAccessedAt,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get accessCount => $composableBuilder(
      column: $table.accessCount, builder: (column) => ColumnOrderings(column));
}

class $$EncryptionKeyStoreTableAnnotationComposer
    extends Composer<_$AppDatabase, $EncryptionKeyStoreTable> {
  $$EncryptionKeyStoreTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get keyPurpose => $composableBuilder(
      column: $table.keyPurpose, builder: (column) => column);

  GeneratedColumn<String> get encryptedKey => $composableBuilder(
      column: $table.encryptedKey, builder: (column) => column);

  GeneratedColumn<String> get keyFingerprint => $composableBuilder(
      column: $table.keyFingerprint, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get lastAccessedAt => $composableBuilder(
      column: $table.lastAccessedAt, builder: (column) => column);

  GeneratedColumn<int> get accessCount => $composableBuilder(
      column: $table.accessCount, builder: (column) => column);
}

class $$EncryptionKeyStoreTableTableManager extends RootTableManager<
    _$AppDatabase,
    $EncryptionKeyStoreTable,
    EncryptionKeyStoreData,
    $$EncryptionKeyStoreTableFilterComposer,
    $$EncryptionKeyStoreTableOrderingComposer,
    $$EncryptionKeyStoreTableAnnotationComposer,
    $$EncryptionKeyStoreTableCreateCompanionBuilder,
    $$EncryptionKeyStoreTableUpdateCompanionBuilder,
    (
      EncryptionKeyStoreData,
      BaseReferences<_$AppDatabase, $EncryptionKeyStoreTable,
          EncryptionKeyStoreData>
    ),
    EncryptionKeyStoreData,
    PrefetchHooks Function()> {
  $$EncryptionKeyStoreTableTableManager(
      _$AppDatabase db, $EncryptionKeyStoreTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$EncryptionKeyStoreTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$EncryptionKeyStoreTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$EncryptionKeyStoreTableAnnotationComposer(
                  $db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> keyPurpose = const Value.absent(),
            Value<String> encryptedKey = const Value.absent(),
            Value<String> keyFingerprint = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime?> lastAccessedAt = const Value.absent(),
            Value<int> accessCount = const Value.absent(),
          }) =>
              EncryptionKeyStoreCompanion(
            id: id,
            keyPurpose: keyPurpose,
            encryptedKey: encryptedKey,
            keyFingerprint: keyFingerprint,
            createdAt: createdAt,
            lastAccessedAt: lastAccessedAt,
            accessCount: accessCount,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String keyPurpose,
            required String encryptedKey,
            required String keyFingerprint,
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime?> lastAccessedAt = const Value.absent(),
            Value<int> accessCount = const Value.absent(),
          }) =>
              EncryptionKeyStoreCompanion.insert(
            id: id,
            keyPurpose: keyPurpose,
            encryptedKey: encryptedKey,
            keyFingerprint: keyFingerprint,
            createdAt: createdAt,
            lastAccessedAt: lastAccessedAt,
            accessCount: accessCount,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$EncryptionKeyStoreTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $EncryptionKeyStoreTable,
    EncryptionKeyStoreData,
    $$EncryptionKeyStoreTableFilterComposer,
    $$EncryptionKeyStoreTableOrderingComposer,
    $$EncryptionKeyStoreTableAnnotationComposer,
    $$EncryptionKeyStoreTableCreateCompanionBuilder,
    $$EncryptionKeyStoreTableUpdateCompanionBuilder,
    (
      EncryptionKeyStoreData,
      BaseReferences<_$AppDatabase, $EncryptionKeyStoreTable,
          EncryptionKeyStoreData>
    ),
    EncryptionKeyStoreData,
    PrefetchHooks Function()>;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$ClientsTableTableManager get clients =>
      $$ClientsTableTableManager(_db, _db.clients);
  $$SitesTableTableManager get sites =>
      $$SitesTableTableManager(_db, _db.sites);
  $$StartingPointsTableTableManager get startingPoints =>
      $$StartingPointsTableTableManager(_db, _db.startingPoints);
  $$UsersTableTableManager get users =>
      $$UsersTableTableManager(_db, _db.users);
  $$WeatherSnapshotTableTableManager get weatherSnapshot =>
      $$WeatherSnapshotTableTableManager(_db, _db.weatherSnapshot);
  $$TrafficSnapshotTableTableManager get trafficSnapshot =>
      $$TrafficSnapshotTableTableManager(_db, _db.trafficSnapshot);
  $$WorkCallsTableTableManager get workCalls =>
      $$WorkCallsTableTableManager(_db, _db.workCalls);
  $$IndustryBriefingTableTableManager get industryBriefing =>
      $$IndustryBriefingTableTableManager(_db, _db.industryBriefing);
  $$CompanyAnnouncementsTableTableManager get companyAnnouncements =>
      $$CompanyAnnouncementsTableTableManager(_db, _db.companyAnnouncements);
  $$WorkOrdersTableTableManager get workOrders =>
      $$WorkOrdersTableTableManager(_db, _db.workOrders);
  $$AppointmentsTableTableManager get appointments =>
      $$AppointmentsTableTableManager(_db, _db.appointments);
  $$EquipmentTableTableManager get equipment =>
      $$EquipmentTableTableManager(_db, _db.equipment);
  $$WorkOrderEquipmentTableTableManager get workOrderEquipment =>
      $$WorkOrderEquipmentTableTableManager(_db, _db.workOrderEquipment);
  $$WorkPerformedTableTableManager get workPerformed =>
      $$WorkPerformedTableTableManager(_db, _db.workPerformed);
  $$PartsUsedTableTableManager get partsUsed =>
      $$PartsUsedTableTableManager(_db, _db.partsUsed);
  $$NotesTableTableManager get notes =>
      $$NotesTableTableManager(_db, _db.notes);
  $$DocumentsTableTableManager get documents =>
      $$DocumentsTableTableManager(_db, _db.documents);
  $$KnowledgeEntriesTableTableManager get knowledgeEntries =>
      $$KnowledgeEntriesTableTableManager(_db, _db.knowledgeEntries);
  $$KnowledgeProceduresTableTableManager get knowledgeProcedures =>
      $$KnowledgeProceduresTableTableManager(_db, _db.knowledgeProcedures);
  $$KnowledgeTroubleshootingTableTableManager get knowledgeTroubleshooting =>
      $$KnowledgeTroubleshootingTableTableManager(
          _db, _db.knowledgeTroubleshooting);
  $$EquipmentSpecsTableTableManager get equipmentSpecs =>
      $$EquipmentSpecsTableTableManager(_db, _db.equipmentSpecs);
  $$KnowledgeRelationshipsTableTableManager get knowledgeRelationships =>
      $$KnowledgeRelationshipsTableTableManager(
          _db, _db.knowledgeRelationships);
  $$KnowledgeSearchIndexTableTableManager get knowledgeSearchIndex =>
      $$KnowledgeSearchIndexTableTableManager(_db, _db.knowledgeSearchIndex);
  $$KnowledgeQueryLogTableTableManager get knowledgeQueryLog =>
      $$KnowledgeQueryLogTableTableManager(_db, _db.knowledgeQueryLog);
  $$ChatChannelsTableTableManager get chatChannels =>
      $$ChatChannelsTableTableManager(_db, _db.chatChannels);
  $$ChatMessagesTableTableManager get chatMessages =>
      $$ChatMessagesTableTableManager(_db, _db.chatMessages);
  $$ContinuingEducationCoursesTableTableManager
      get continuingEducationCourses =>
          $$ContinuingEducationCoursesTableTableManager(
              _db, _db.continuingEducationCourses);
  $$UserCourseEnrollmentsTableTableManager get userCourseEnrollments =>
      $$UserCourseEnrollmentsTableTableManager(_db, _db.userCourseEnrollments);
  $$ExpensesTableTableManager get expenses =>
      $$ExpensesTableTableManager(_db, _db.expenses);
  $$WorkOrderAuditLogTableTableManager get workOrderAuditLog =>
      $$WorkOrderAuditLogTableTableManager(_db, _db.workOrderAuditLog);
  $$WorkOrderStatusTransitionsTableTableManager
      get workOrderStatusTransitions =>
          $$WorkOrderStatusTransitionsTableTableManager(
              _db, _db.workOrderStatusTransitions);
  $$ProvenanceLogTableTableManager get provenanceLog =>
      $$ProvenanceLogTableTableManager(_db, _db.provenanceLog);
  $$EncryptionKeyStoreTableTableManager get encryptionKeyStore =>
      $$EncryptionKeyStoreTableTableManager(_db, _db.encryptionKeyStore);
}
