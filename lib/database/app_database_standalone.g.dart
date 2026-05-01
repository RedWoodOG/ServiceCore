// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database_standalone.dart';

// ignore_for_file: type=lint
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
        updatedAt
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
      required this.updatedAt});
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
          DateTime? updatedAt}) =>
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
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
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
      updatedAt);
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
          other.updatedAt == this.updatedAt);
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
          ..write('rowid: $rowid')
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

abstract class _$StandaloneDatabase extends GeneratedDatabase {
  _$StandaloneDatabase(QueryExecutor e) : super(e);
  $StandaloneDatabaseManager get managers => $StandaloneDatabaseManager(this);
  late final $KnowledgeEntriesTable knowledgeEntries =
      $KnowledgeEntriesTable(this);
  late final $CompanyAnnouncementsTable companyAnnouncements =
      $CompanyAnnouncementsTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities =>
      [knowledgeEntries, companyAnnouncements];
}

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
  Value<int> rowid,
});

class $$KnowledgeEntriesTableFilterComposer
    extends Composer<_$StandaloneDatabase, $KnowledgeEntriesTable> {
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
}

class $$KnowledgeEntriesTableOrderingComposer
    extends Composer<_$StandaloneDatabase, $KnowledgeEntriesTable> {
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
}

class $$KnowledgeEntriesTableAnnotationComposer
    extends Composer<_$StandaloneDatabase, $KnowledgeEntriesTable> {
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
}

class $$KnowledgeEntriesTableTableManager extends RootTableManager<
    _$StandaloneDatabase,
    $KnowledgeEntriesTable,
    KnowledgeEntry,
    $$KnowledgeEntriesTableFilterComposer,
    $$KnowledgeEntriesTableOrderingComposer,
    $$KnowledgeEntriesTableAnnotationComposer,
    $$KnowledgeEntriesTableCreateCompanionBuilder,
    $$KnowledgeEntriesTableUpdateCompanionBuilder,
    (
      KnowledgeEntry,
      BaseReferences<_$StandaloneDatabase, $KnowledgeEntriesTable,
          KnowledgeEntry>
    ),
    KnowledgeEntry,
    PrefetchHooks Function()> {
  $$KnowledgeEntriesTableTableManager(
      _$StandaloneDatabase db, $KnowledgeEntriesTable table)
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
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$KnowledgeEntriesTableProcessedTableManager = ProcessedTableManager<
    _$StandaloneDatabase,
    $KnowledgeEntriesTable,
    KnowledgeEntry,
    $$KnowledgeEntriesTableFilterComposer,
    $$KnowledgeEntriesTableOrderingComposer,
    $$KnowledgeEntriesTableAnnotationComposer,
    $$KnowledgeEntriesTableCreateCompanionBuilder,
    $$KnowledgeEntriesTableUpdateCompanionBuilder,
    (
      KnowledgeEntry,
      BaseReferences<_$StandaloneDatabase, $KnowledgeEntriesTable,
          KnowledgeEntry>
    ),
    KnowledgeEntry,
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
    extends Composer<_$StandaloneDatabase, $CompanyAnnouncementsTable> {
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
    extends Composer<_$StandaloneDatabase, $CompanyAnnouncementsTable> {
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
    extends Composer<_$StandaloneDatabase, $CompanyAnnouncementsTable> {
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
    _$StandaloneDatabase,
    $CompanyAnnouncementsTable,
    CompanyAnnouncement,
    $$CompanyAnnouncementsTableFilterComposer,
    $$CompanyAnnouncementsTableOrderingComposer,
    $$CompanyAnnouncementsTableAnnotationComposer,
    $$CompanyAnnouncementsTableCreateCompanionBuilder,
    $$CompanyAnnouncementsTableUpdateCompanionBuilder,
    (
      CompanyAnnouncement,
      BaseReferences<_$StandaloneDatabase, $CompanyAnnouncementsTable,
          CompanyAnnouncement>
    ),
    CompanyAnnouncement,
    PrefetchHooks Function()> {
  $$CompanyAnnouncementsTableTableManager(
      _$StandaloneDatabase db, $CompanyAnnouncementsTable table)
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
        _$StandaloneDatabase,
        $CompanyAnnouncementsTable,
        CompanyAnnouncement,
        $$CompanyAnnouncementsTableFilterComposer,
        $$CompanyAnnouncementsTableOrderingComposer,
        $$CompanyAnnouncementsTableAnnotationComposer,
        $$CompanyAnnouncementsTableCreateCompanionBuilder,
        $$CompanyAnnouncementsTableUpdateCompanionBuilder,
        (
          CompanyAnnouncement,
          BaseReferences<_$StandaloneDatabase, $CompanyAnnouncementsTable,
              CompanyAnnouncement>
        ),
        CompanyAnnouncement,
        PrefetchHooks Function()>;

class $StandaloneDatabaseManager {
  final _$StandaloneDatabase _db;
  $StandaloneDatabaseManager(this._db);
  $$KnowledgeEntriesTableTableManager get knowledgeEntries =>
      $$KnowledgeEntriesTableTableManager(_db, _db.knowledgeEntries);
  $$CompanyAnnouncementsTableTableManager get companyAnnouncements =>
      $$CompanyAnnouncementsTableTableManager(_db, _db.companyAnnouncements);
}
