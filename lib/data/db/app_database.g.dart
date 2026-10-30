// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $ProfilesTable extends Profiles
    with TableInfo<$ProfilesTable, ProfileRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ProfilesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _pazienteNomeMeta = const VerificationMeta(
    'pazienteNome',
  );
  @override
  late final GeneratedColumn<String> pazienteNome = GeneratedColumn<String>(
    'paziente_nome',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _pazienteCfMeta = const VerificationMeta(
    'pazienteCf',
  );
  @override
  late final GeneratedColumn<String> pazienteCf = GeneratedColumn<String>(
    'paziente_cf',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _medicoNomeMeta = const VerificationMeta(
    'medicoNome',
  );
  @override
  late final GeneratedColumn<String> medicoNome = GeneratedColumn<String>(
    'medico_nome',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _medicoTelefonoMeta = const VerificationMeta(
    'medicoTelefono',
  );
  @override
  late final GeneratedColumn<String> medicoTelefono = GeneratedColumn<String>(
    'medico_telefono',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _medicoEmailMeta = const VerificationMeta(
    'medicoEmail',
  );
  @override
  late final GeneratedColumn<String> medicoEmail = GeneratedColumn<String>(
    'medico_email',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _secondoIndirizzoMeta = const VerificationMeta(
    'secondoIndirizzo',
  );
  @override
  late final GeneratedColumn<String> secondoIndirizzo = GeneratedColumn<String>(
    'secondo_indirizzo',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _messaggioTestaMeta = const VerificationMeta(
    'messaggioTesta',
  );
  @override
  late final GeneratedColumn<String> messaggioTesta = GeneratedColumn<String>(
    'messaggio_testa',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(defaultMessaggioTesta),
  );
  static const VerificationMeta _messaggioCodaMeta = const VerificationMeta(
    'messaggioCoda',
  );
  @override
  late final GeneratedColumn<String> messaggioCoda = GeneratedColumn<String>(
    'messaggio_coda',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(defaultMessaggioCoda),
  );
  static const VerificationMeta _tipoInvioMeta = const VerificationMeta(
    'tipoInvio',
  );
  @override
  late final GeneratedColumn<int> tipoInvio = GeneratedColumn<int>(
    'tipo_invio',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _notificheAttiveMeta = const VerificationMeta(
    'notificheAttive',
  );
  @override
  late final GeneratedColumn<bool> notificheAttive = GeneratedColumn<bool>(
    'notifiche_attive',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("notifiche_attive" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _descrizioneNotificaMeta =
      const VerificationMeta('descrizioneNotifica');
  @override
  late final GeneratedColumn<String> descrizioneNotifica =
      GeneratedColumn<String>(
        'descrizione_notifica',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
        defaultValue: const Constant(defaultDescrizioneNotifica),
      );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    pazienteNome,
    pazienteCf,
    medicoNome,
    medicoTelefono,
    medicoEmail,
    secondoIndirizzo,
    messaggioTesta,
    messaggioCoda,
    tipoInvio,
    notificheAttive,
    descrizioneNotifica,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'profiles';
  @override
  VerificationContext validateIntegrity(
    Insertable<ProfileRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('paziente_nome')) {
      context.handle(
        _pazienteNomeMeta,
        pazienteNome.isAcceptableOrUnknown(
          data['paziente_nome']!,
          _pazienteNomeMeta,
        ),
      );
    }
    if (data.containsKey('paziente_cf')) {
      context.handle(
        _pazienteCfMeta,
        pazienteCf.isAcceptableOrUnknown(data['paziente_cf']!, _pazienteCfMeta),
      );
    }
    if (data.containsKey('medico_nome')) {
      context.handle(
        _medicoNomeMeta,
        medicoNome.isAcceptableOrUnknown(data['medico_nome']!, _medicoNomeMeta),
      );
    }
    if (data.containsKey('medico_telefono')) {
      context.handle(
        _medicoTelefonoMeta,
        medicoTelefono.isAcceptableOrUnknown(
          data['medico_telefono']!,
          _medicoTelefonoMeta,
        ),
      );
    }
    if (data.containsKey('medico_email')) {
      context.handle(
        _medicoEmailMeta,
        medicoEmail.isAcceptableOrUnknown(
          data['medico_email']!,
          _medicoEmailMeta,
        ),
      );
    }
    if (data.containsKey('secondo_indirizzo')) {
      context.handle(
        _secondoIndirizzoMeta,
        secondoIndirizzo.isAcceptableOrUnknown(
          data['secondo_indirizzo']!,
          _secondoIndirizzoMeta,
        ),
      );
    }
    if (data.containsKey('messaggio_testa')) {
      context.handle(
        _messaggioTestaMeta,
        messaggioTesta.isAcceptableOrUnknown(
          data['messaggio_testa']!,
          _messaggioTestaMeta,
        ),
      );
    }
    if (data.containsKey('messaggio_coda')) {
      context.handle(
        _messaggioCodaMeta,
        messaggioCoda.isAcceptableOrUnknown(
          data['messaggio_coda']!,
          _messaggioCodaMeta,
        ),
      );
    }
    if (data.containsKey('tipo_invio')) {
      context.handle(
        _tipoInvioMeta,
        tipoInvio.isAcceptableOrUnknown(data['tipo_invio']!, _tipoInvioMeta),
      );
    }
    if (data.containsKey('notifiche_attive')) {
      context.handle(
        _notificheAttiveMeta,
        notificheAttive.isAcceptableOrUnknown(
          data['notifiche_attive']!,
          _notificheAttiveMeta,
        ),
      );
    }
    if (data.containsKey('descrizione_notifica')) {
      context.handle(
        _descrizioneNotificaMeta,
        descrizioneNotifica.isAcceptableOrUnknown(
          data['descrizione_notifica']!,
          _descrizioneNotificaMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ProfileRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ProfileRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      pazienteNome: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}paziente_nome'],
      )!,
      pazienteCf: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}paziente_cf'],
      )!,
      medicoNome: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}medico_nome'],
      )!,
      medicoTelefono: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}medico_telefono'],
      )!,
      medicoEmail: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}medico_email'],
      )!,
      secondoIndirizzo: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}secondo_indirizzo'],
      )!,
      messaggioTesta: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}messaggio_testa'],
      )!,
      messaggioCoda: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}messaggio_coda'],
      )!,
      tipoInvio: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}tipo_invio'],
      )!,
      notificheAttive: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}notifiche_attive'],
      )!,
      descrizioneNotifica: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}descrizione_notifica'],
      )!,
    );
  }

  @override
  $ProfilesTable createAlias(String alias) {
    return $ProfilesTable(attachedDatabase, alias);
  }
}

class ProfileRow extends DataClass implements Insertable<ProfileRow> {
  final String id;
  final String pazienteNome;
  final String pazienteCf;
  final String medicoNome;
  final String medicoTelefono;
  final String medicoEmail;
  final String secondoIndirizzo;
  final String messaggioTesta;
  final String messaggioCoda;

  /// 0 = WhatsApp, 1 = SMS, 2 = Email (vedi SendChannel).
  final int tipoInvio;
  final bool notificheAttive;
  final String descrizioneNotifica;
  const ProfileRow({
    required this.id,
    required this.pazienteNome,
    required this.pazienteCf,
    required this.medicoNome,
    required this.medicoTelefono,
    required this.medicoEmail,
    required this.secondoIndirizzo,
    required this.messaggioTesta,
    required this.messaggioCoda,
    required this.tipoInvio,
    required this.notificheAttive,
    required this.descrizioneNotifica,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['paziente_nome'] = Variable<String>(pazienteNome);
    map['paziente_cf'] = Variable<String>(pazienteCf);
    map['medico_nome'] = Variable<String>(medicoNome);
    map['medico_telefono'] = Variable<String>(medicoTelefono);
    map['medico_email'] = Variable<String>(medicoEmail);
    map['secondo_indirizzo'] = Variable<String>(secondoIndirizzo);
    map['messaggio_testa'] = Variable<String>(messaggioTesta);
    map['messaggio_coda'] = Variable<String>(messaggioCoda);
    map['tipo_invio'] = Variable<int>(tipoInvio);
    map['notifiche_attive'] = Variable<bool>(notificheAttive);
    map['descrizione_notifica'] = Variable<String>(descrizioneNotifica);
    return map;
  }

  ProfilesCompanion toCompanion(bool nullToAbsent) {
    return ProfilesCompanion(
      id: Value(id),
      pazienteNome: Value(pazienteNome),
      pazienteCf: Value(pazienteCf),
      medicoNome: Value(medicoNome),
      medicoTelefono: Value(medicoTelefono),
      medicoEmail: Value(medicoEmail),
      secondoIndirizzo: Value(secondoIndirizzo),
      messaggioTesta: Value(messaggioTesta),
      messaggioCoda: Value(messaggioCoda),
      tipoInvio: Value(tipoInvio),
      notificheAttive: Value(notificheAttive),
      descrizioneNotifica: Value(descrizioneNotifica),
    );
  }

  factory ProfileRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ProfileRow(
      id: serializer.fromJson<String>(json['id']),
      pazienteNome: serializer.fromJson<String>(json['pazienteNome']),
      pazienteCf: serializer.fromJson<String>(json['pazienteCf']),
      medicoNome: serializer.fromJson<String>(json['medicoNome']),
      medicoTelefono: serializer.fromJson<String>(json['medicoTelefono']),
      medicoEmail: serializer.fromJson<String>(json['medicoEmail']),
      secondoIndirizzo: serializer.fromJson<String>(json['secondoIndirizzo']),
      messaggioTesta: serializer.fromJson<String>(json['messaggioTesta']),
      messaggioCoda: serializer.fromJson<String>(json['messaggioCoda']),
      tipoInvio: serializer.fromJson<int>(json['tipoInvio']),
      notificheAttive: serializer.fromJson<bool>(json['notificheAttive']),
      descrizioneNotifica: serializer.fromJson<String>(
        json['descrizioneNotifica'],
      ),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'pazienteNome': serializer.toJson<String>(pazienteNome),
      'pazienteCf': serializer.toJson<String>(pazienteCf),
      'medicoNome': serializer.toJson<String>(medicoNome),
      'medicoTelefono': serializer.toJson<String>(medicoTelefono),
      'medicoEmail': serializer.toJson<String>(medicoEmail),
      'secondoIndirizzo': serializer.toJson<String>(secondoIndirizzo),
      'messaggioTesta': serializer.toJson<String>(messaggioTesta),
      'messaggioCoda': serializer.toJson<String>(messaggioCoda),
      'tipoInvio': serializer.toJson<int>(tipoInvio),
      'notificheAttive': serializer.toJson<bool>(notificheAttive),
      'descrizioneNotifica': serializer.toJson<String>(descrizioneNotifica),
    };
  }

  ProfileRow copyWith({
    String? id,
    String? pazienteNome,
    String? pazienteCf,
    String? medicoNome,
    String? medicoTelefono,
    String? medicoEmail,
    String? secondoIndirizzo,
    String? messaggioTesta,
    String? messaggioCoda,
    int? tipoInvio,
    bool? notificheAttive,
    String? descrizioneNotifica,
  }) => ProfileRow(
    id: id ?? this.id,
    pazienteNome: pazienteNome ?? this.pazienteNome,
    pazienteCf: pazienteCf ?? this.pazienteCf,
    medicoNome: medicoNome ?? this.medicoNome,
    medicoTelefono: medicoTelefono ?? this.medicoTelefono,
    medicoEmail: medicoEmail ?? this.medicoEmail,
    secondoIndirizzo: secondoIndirizzo ?? this.secondoIndirizzo,
    messaggioTesta: messaggioTesta ?? this.messaggioTesta,
    messaggioCoda: messaggioCoda ?? this.messaggioCoda,
    tipoInvio: tipoInvio ?? this.tipoInvio,
    notificheAttive: notificheAttive ?? this.notificheAttive,
    descrizioneNotifica: descrizioneNotifica ?? this.descrizioneNotifica,
  );
  ProfileRow copyWithCompanion(ProfilesCompanion data) {
    return ProfileRow(
      id: data.id.present ? data.id.value : this.id,
      pazienteNome: data.pazienteNome.present
          ? data.pazienteNome.value
          : this.pazienteNome,
      pazienteCf: data.pazienteCf.present
          ? data.pazienteCf.value
          : this.pazienteCf,
      medicoNome: data.medicoNome.present
          ? data.medicoNome.value
          : this.medicoNome,
      medicoTelefono: data.medicoTelefono.present
          ? data.medicoTelefono.value
          : this.medicoTelefono,
      medicoEmail: data.medicoEmail.present
          ? data.medicoEmail.value
          : this.medicoEmail,
      secondoIndirizzo: data.secondoIndirizzo.present
          ? data.secondoIndirizzo.value
          : this.secondoIndirizzo,
      messaggioTesta: data.messaggioTesta.present
          ? data.messaggioTesta.value
          : this.messaggioTesta,
      messaggioCoda: data.messaggioCoda.present
          ? data.messaggioCoda.value
          : this.messaggioCoda,
      tipoInvio: data.tipoInvio.present ? data.tipoInvio.value : this.tipoInvio,
      notificheAttive: data.notificheAttive.present
          ? data.notificheAttive.value
          : this.notificheAttive,
      descrizioneNotifica: data.descrizioneNotifica.present
          ? data.descrizioneNotifica.value
          : this.descrizioneNotifica,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ProfileRow(')
          ..write('id: $id, ')
          ..write('pazienteNome: $pazienteNome, ')
          ..write('pazienteCf: $pazienteCf, ')
          ..write('medicoNome: $medicoNome, ')
          ..write('medicoTelefono: $medicoTelefono, ')
          ..write('medicoEmail: $medicoEmail, ')
          ..write('secondoIndirizzo: $secondoIndirizzo, ')
          ..write('messaggioTesta: $messaggioTesta, ')
          ..write('messaggioCoda: $messaggioCoda, ')
          ..write('tipoInvio: $tipoInvio, ')
          ..write('notificheAttive: $notificheAttive, ')
          ..write('descrizioneNotifica: $descrizioneNotifica')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    pazienteNome,
    pazienteCf,
    medicoNome,
    medicoTelefono,
    medicoEmail,
    secondoIndirizzo,
    messaggioTesta,
    messaggioCoda,
    tipoInvio,
    notificheAttive,
    descrizioneNotifica,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ProfileRow &&
          other.id == this.id &&
          other.pazienteNome == this.pazienteNome &&
          other.pazienteCf == this.pazienteCf &&
          other.medicoNome == this.medicoNome &&
          other.medicoTelefono == this.medicoTelefono &&
          other.medicoEmail == this.medicoEmail &&
          other.secondoIndirizzo == this.secondoIndirizzo &&
          other.messaggioTesta == this.messaggioTesta &&
          other.messaggioCoda == this.messaggioCoda &&
          other.tipoInvio == this.tipoInvio &&
          other.notificheAttive == this.notificheAttive &&
          other.descrizioneNotifica == this.descrizioneNotifica);
}

class ProfilesCompanion extends UpdateCompanion<ProfileRow> {
  final Value<String> id;
  final Value<String> pazienteNome;
  final Value<String> pazienteCf;
  final Value<String> medicoNome;
  final Value<String> medicoTelefono;
  final Value<String> medicoEmail;
  final Value<String> secondoIndirizzo;
  final Value<String> messaggioTesta;
  final Value<String> messaggioCoda;
  final Value<int> tipoInvio;
  final Value<bool> notificheAttive;
  final Value<String> descrizioneNotifica;
  final Value<int> rowid;
  const ProfilesCompanion({
    this.id = const Value.absent(),
    this.pazienteNome = const Value.absent(),
    this.pazienteCf = const Value.absent(),
    this.medicoNome = const Value.absent(),
    this.medicoTelefono = const Value.absent(),
    this.medicoEmail = const Value.absent(),
    this.secondoIndirizzo = const Value.absent(),
    this.messaggioTesta = const Value.absent(),
    this.messaggioCoda = const Value.absent(),
    this.tipoInvio = const Value.absent(),
    this.notificheAttive = const Value.absent(),
    this.descrizioneNotifica = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ProfilesCompanion.insert({
    required String id,
    this.pazienteNome = const Value.absent(),
    this.pazienteCf = const Value.absent(),
    this.medicoNome = const Value.absent(),
    this.medicoTelefono = const Value.absent(),
    this.medicoEmail = const Value.absent(),
    this.secondoIndirizzo = const Value.absent(),
    this.messaggioTesta = const Value.absent(),
    this.messaggioCoda = const Value.absent(),
    this.tipoInvio = const Value.absent(),
    this.notificheAttive = const Value.absent(),
    this.descrizioneNotifica = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id);
  static Insertable<ProfileRow> custom({
    Expression<String>? id,
    Expression<String>? pazienteNome,
    Expression<String>? pazienteCf,
    Expression<String>? medicoNome,
    Expression<String>? medicoTelefono,
    Expression<String>? medicoEmail,
    Expression<String>? secondoIndirizzo,
    Expression<String>? messaggioTesta,
    Expression<String>? messaggioCoda,
    Expression<int>? tipoInvio,
    Expression<bool>? notificheAttive,
    Expression<String>? descrizioneNotifica,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (pazienteNome != null) 'paziente_nome': pazienteNome,
      if (pazienteCf != null) 'paziente_cf': pazienteCf,
      if (medicoNome != null) 'medico_nome': medicoNome,
      if (medicoTelefono != null) 'medico_telefono': medicoTelefono,
      if (medicoEmail != null) 'medico_email': medicoEmail,
      if (secondoIndirizzo != null) 'secondo_indirizzo': secondoIndirizzo,
      if (messaggioTesta != null) 'messaggio_testa': messaggioTesta,
      if (messaggioCoda != null) 'messaggio_coda': messaggioCoda,
      if (tipoInvio != null) 'tipo_invio': tipoInvio,
      if (notificheAttive != null) 'notifiche_attive': notificheAttive,
      if (descrizioneNotifica != null)
        'descrizione_notifica': descrizioneNotifica,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ProfilesCompanion copyWith({
    Value<String>? id,
    Value<String>? pazienteNome,
    Value<String>? pazienteCf,
    Value<String>? medicoNome,
    Value<String>? medicoTelefono,
    Value<String>? medicoEmail,
    Value<String>? secondoIndirizzo,
    Value<String>? messaggioTesta,
    Value<String>? messaggioCoda,
    Value<int>? tipoInvio,
    Value<bool>? notificheAttive,
    Value<String>? descrizioneNotifica,
    Value<int>? rowid,
  }) {
    return ProfilesCompanion(
      id: id ?? this.id,
      pazienteNome: pazienteNome ?? this.pazienteNome,
      pazienteCf: pazienteCf ?? this.pazienteCf,
      medicoNome: medicoNome ?? this.medicoNome,
      medicoTelefono: medicoTelefono ?? this.medicoTelefono,
      medicoEmail: medicoEmail ?? this.medicoEmail,
      secondoIndirizzo: secondoIndirizzo ?? this.secondoIndirizzo,
      messaggioTesta: messaggioTesta ?? this.messaggioTesta,
      messaggioCoda: messaggioCoda ?? this.messaggioCoda,
      tipoInvio: tipoInvio ?? this.tipoInvio,
      notificheAttive: notificheAttive ?? this.notificheAttive,
      descrizioneNotifica: descrizioneNotifica ?? this.descrizioneNotifica,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (pazienteNome.present) {
      map['paziente_nome'] = Variable<String>(pazienteNome.value);
    }
    if (pazienteCf.present) {
      map['paziente_cf'] = Variable<String>(pazienteCf.value);
    }
    if (medicoNome.present) {
      map['medico_nome'] = Variable<String>(medicoNome.value);
    }
    if (medicoTelefono.present) {
      map['medico_telefono'] = Variable<String>(medicoTelefono.value);
    }
    if (medicoEmail.present) {
      map['medico_email'] = Variable<String>(medicoEmail.value);
    }
    if (secondoIndirizzo.present) {
      map['secondo_indirizzo'] = Variable<String>(secondoIndirizzo.value);
    }
    if (messaggioTesta.present) {
      map['messaggio_testa'] = Variable<String>(messaggioTesta.value);
    }
    if (messaggioCoda.present) {
      map['messaggio_coda'] = Variable<String>(messaggioCoda.value);
    }
    if (tipoInvio.present) {
      map['tipo_invio'] = Variable<int>(tipoInvio.value);
    }
    if (notificheAttive.present) {
      map['notifiche_attive'] = Variable<bool>(notificheAttive.value);
    }
    if (descrizioneNotifica.present) {
      map['descrizione_notifica'] = Variable<String>(descrizioneNotifica.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ProfilesCompanion(')
          ..write('id: $id, ')
          ..write('pazienteNome: $pazienteNome, ')
          ..write('pazienteCf: $pazienteCf, ')
          ..write('medicoNome: $medicoNome, ')
          ..write('medicoTelefono: $medicoTelefono, ')
          ..write('medicoEmail: $medicoEmail, ')
          ..write('secondoIndirizzo: $secondoIndirizzo, ')
          ..write('messaggioTesta: $messaggioTesta, ')
          ..write('messaggioCoda: $messaggioCoda, ')
          ..write('tipoInvio: $tipoInvio, ')
          ..write('notificheAttive: $notificheAttive, ')
          ..write('descrizioneNotifica: $descrizioneNotifica, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $MedicationsTable extends Medications
    with TableInfo<$MedicationsTable, MedicationRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $MedicationsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _profileIdMeta = const VerificationMeta(
    'profileId',
  );
  @override
  late final GeneratedColumn<String> profileId = GeneratedColumn<String>(
    'profile_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES profiles (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _nomeMeta = const VerificationMeta('nome');
  @override
  late final GeneratedColumn<String> nome = GeneratedColumn<String>(
    'nome',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _scatoleMeta = const VerificationMeta(
    'scatole',
  );
  @override
  late final GeneratedColumn<int> scatole = GeneratedColumn<int>(
    'scatole',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(1),
  );
  static const VerificationMeta _noteMeta = const VerificationMeta('note');
  @override
  late final GeneratedColumn<String> note = GeneratedColumn<String>(
    'note',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _inPausaMeta = const VerificationMeta(
    'inPausa',
  );
  @override
  late final GeneratedColumn<bool> inPausa = GeneratedColumn<bool>(
    'in_pausa',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("in_pausa" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _notificaAttivaMeta = const VerificationMeta(
    'notificaAttiva',
  );
  @override
  late final GeneratedColumn<bool> notificaAttiva = GeneratedColumn<bool>(
    'notifica_attiva',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("notifica_attiva" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _orarioNotificaMeta = const VerificationMeta(
    'orarioNotifica',
  );
  @override
  late final GeneratedColumn<String> orarioNotifica = GeneratedColumn<String>(
    'orario_notifica',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(defaultOrarioNotifica),
  );
  static const VerificationMeta _frequenzaValoreMeta = const VerificationMeta(
    'frequenzaValore',
  );
  @override
  late final GeneratedColumn<int> frequenzaValore = GeneratedColumn<int>(
    'frequenza_valore',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(1),
  );
  static const VerificationMeta _frequenzaTipoMeta = const VerificationMeta(
    'frequenzaTipo',
  );
  @override
  late final GeneratedColumn<String> frequenzaTipo = GeneratedColumn<String>(
    'frequenza_tipo',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('GIORNI'),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    profileId,
    nome,
    scatole,
    note,
    inPausa,
    notificaAttiva,
    orarioNotifica,
    frequenzaValore,
    frequenzaTipo,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'medications';
  @override
  VerificationContext validateIntegrity(
    Insertable<MedicationRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('profile_id')) {
      context.handle(
        _profileIdMeta,
        profileId.isAcceptableOrUnknown(data['profile_id']!, _profileIdMeta),
      );
    } else if (isInserting) {
      context.missing(_profileIdMeta);
    }
    if (data.containsKey('nome')) {
      context.handle(
        _nomeMeta,
        nome.isAcceptableOrUnknown(data['nome']!, _nomeMeta),
      );
    } else if (isInserting) {
      context.missing(_nomeMeta);
    }
    if (data.containsKey('scatole')) {
      context.handle(
        _scatoleMeta,
        scatole.isAcceptableOrUnknown(data['scatole']!, _scatoleMeta),
      );
    }
    if (data.containsKey('note')) {
      context.handle(
        _noteMeta,
        note.isAcceptableOrUnknown(data['note']!, _noteMeta),
      );
    }
    if (data.containsKey('in_pausa')) {
      context.handle(
        _inPausaMeta,
        inPausa.isAcceptableOrUnknown(data['in_pausa']!, _inPausaMeta),
      );
    }
    if (data.containsKey('notifica_attiva')) {
      context.handle(
        _notificaAttivaMeta,
        notificaAttiva.isAcceptableOrUnknown(
          data['notifica_attiva']!,
          _notificaAttivaMeta,
        ),
      );
    }
    if (data.containsKey('orario_notifica')) {
      context.handle(
        _orarioNotificaMeta,
        orarioNotifica.isAcceptableOrUnknown(
          data['orario_notifica']!,
          _orarioNotificaMeta,
        ),
      );
    }
    if (data.containsKey('frequenza_valore')) {
      context.handle(
        _frequenzaValoreMeta,
        frequenzaValore.isAcceptableOrUnknown(
          data['frequenza_valore']!,
          _frequenzaValoreMeta,
        ),
      );
    }
    if (data.containsKey('frequenza_tipo')) {
      context.handle(
        _frequenzaTipoMeta,
        frequenzaTipo.isAcceptableOrUnknown(
          data['frequenza_tipo']!,
          _frequenzaTipoMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  MedicationRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return MedicationRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      profileId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}profile_id'],
      )!,
      nome: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}nome'],
      )!,
      scatole: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}scatole'],
      )!,
      note: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}note'],
      )!,
      inPausa: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}in_pausa'],
      )!,
      notificaAttiva: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}notifica_attiva'],
      )!,
      orarioNotifica: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}orario_notifica'],
      )!,
      frequenzaValore: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}frequenza_valore'],
      )!,
      frequenzaTipo: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}frequenza_tipo'],
      )!,
    );
  }

  @override
  $MedicationsTable createAlias(String alias) {
    return $MedicationsTable(attachedDatabase, alias);
  }
}

class MedicationRow extends DataClass implements Insertable<MedicationRow> {
  final String id;
  final String profileId;
  final String nome;
  final int scatole;
  final String note;
  final bool inPausa;
  final bool notificaAttiva;
  final String orarioNotifica;
  final int frequenzaValore;

  /// "ORE" oppure "GIORNI" (vedi FrequencyUnit).
  final String frequenzaTipo;
  const MedicationRow({
    required this.id,
    required this.profileId,
    required this.nome,
    required this.scatole,
    required this.note,
    required this.inPausa,
    required this.notificaAttiva,
    required this.orarioNotifica,
    required this.frequenzaValore,
    required this.frequenzaTipo,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['profile_id'] = Variable<String>(profileId);
    map['nome'] = Variable<String>(nome);
    map['scatole'] = Variable<int>(scatole);
    map['note'] = Variable<String>(note);
    map['in_pausa'] = Variable<bool>(inPausa);
    map['notifica_attiva'] = Variable<bool>(notificaAttiva);
    map['orario_notifica'] = Variable<String>(orarioNotifica);
    map['frequenza_valore'] = Variable<int>(frequenzaValore);
    map['frequenza_tipo'] = Variable<String>(frequenzaTipo);
    return map;
  }

  MedicationsCompanion toCompanion(bool nullToAbsent) {
    return MedicationsCompanion(
      id: Value(id),
      profileId: Value(profileId),
      nome: Value(nome),
      scatole: Value(scatole),
      note: Value(note),
      inPausa: Value(inPausa),
      notificaAttiva: Value(notificaAttiva),
      orarioNotifica: Value(orarioNotifica),
      frequenzaValore: Value(frequenzaValore),
      frequenzaTipo: Value(frequenzaTipo),
    );
  }

  factory MedicationRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return MedicationRow(
      id: serializer.fromJson<String>(json['id']),
      profileId: serializer.fromJson<String>(json['profileId']),
      nome: serializer.fromJson<String>(json['nome']),
      scatole: serializer.fromJson<int>(json['scatole']),
      note: serializer.fromJson<String>(json['note']),
      inPausa: serializer.fromJson<bool>(json['inPausa']),
      notificaAttiva: serializer.fromJson<bool>(json['notificaAttiva']),
      orarioNotifica: serializer.fromJson<String>(json['orarioNotifica']),
      frequenzaValore: serializer.fromJson<int>(json['frequenzaValore']),
      frequenzaTipo: serializer.fromJson<String>(json['frequenzaTipo']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'profileId': serializer.toJson<String>(profileId),
      'nome': serializer.toJson<String>(nome),
      'scatole': serializer.toJson<int>(scatole),
      'note': serializer.toJson<String>(note),
      'inPausa': serializer.toJson<bool>(inPausa),
      'notificaAttiva': serializer.toJson<bool>(notificaAttiva),
      'orarioNotifica': serializer.toJson<String>(orarioNotifica),
      'frequenzaValore': serializer.toJson<int>(frequenzaValore),
      'frequenzaTipo': serializer.toJson<String>(frequenzaTipo),
    };
  }

  MedicationRow copyWith({
    String? id,
    String? profileId,
    String? nome,
    int? scatole,
    String? note,
    bool? inPausa,
    bool? notificaAttiva,
    String? orarioNotifica,
    int? frequenzaValore,
    String? frequenzaTipo,
  }) => MedicationRow(
    id: id ?? this.id,
    profileId: profileId ?? this.profileId,
    nome: nome ?? this.nome,
    scatole: scatole ?? this.scatole,
    note: note ?? this.note,
    inPausa: inPausa ?? this.inPausa,
    notificaAttiva: notificaAttiva ?? this.notificaAttiva,
    orarioNotifica: orarioNotifica ?? this.orarioNotifica,
    frequenzaValore: frequenzaValore ?? this.frequenzaValore,
    frequenzaTipo: frequenzaTipo ?? this.frequenzaTipo,
  );
  MedicationRow copyWithCompanion(MedicationsCompanion data) {
    return MedicationRow(
      id: data.id.present ? data.id.value : this.id,
      profileId: data.profileId.present ? data.profileId.value : this.profileId,
      nome: data.nome.present ? data.nome.value : this.nome,
      scatole: data.scatole.present ? data.scatole.value : this.scatole,
      note: data.note.present ? data.note.value : this.note,
      inPausa: data.inPausa.present ? data.inPausa.value : this.inPausa,
      notificaAttiva: data.notificaAttiva.present
          ? data.notificaAttiva.value
          : this.notificaAttiva,
      orarioNotifica: data.orarioNotifica.present
          ? data.orarioNotifica.value
          : this.orarioNotifica,
      frequenzaValore: data.frequenzaValore.present
          ? data.frequenzaValore.value
          : this.frequenzaValore,
      frequenzaTipo: data.frequenzaTipo.present
          ? data.frequenzaTipo.value
          : this.frequenzaTipo,
    );
  }

  @override
  String toString() {
    return (StringBuffer('MedicationRow(')
          ..write('id: $id, ')
          ..write('profileId: $profileId, ')
          ..write('nome: $nome, ')
          ..write('scatole: $scatole, ')
          ..write('note: $note, ')
          ..write('inPausa: $inPausa, ')
          ..write('notificaAttiva: $notificaAttiva, ')
          ..write('orarioNotifica: $orarioNotifica, ')
          ..write('frequenzaValore: $frequenzaValore, ')
          ..write('frequenzaTipo: $frequenzaTipo')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    profileId,
    nome,
    scatole,
    note,
    inPausa,
    notificaAttiva,
    orarioNotifica,
    frequenzaValore,
    frequenzaTipo,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is MedicationRow &&
          other.id == this.id &&
          other.profileId == this.profileId &&
          other.nome == this.nome &&
          other.scatole == this.scatole &&
          other.note == this.note &&
          other.inPausa == this.inPausa &&
          other.notificaAttiva == this.notificaAttiva &&
          other.orarioNotifica == this.orarioNotifica &&
          other.frequenzaValore == this.frequenzaValore &&
          other.frequenzaTipo == this.frequenzaTipo);
}

class MedicationsCompanion extends UpdateCompanion<MedicationRow> {
  final Value<String> id;
  final Value<String> profileId;
  final Value<String> nome;
  final Value<int> scatole;
  final Value<String> note;
  final Value<bool> inPausa;
  final Value<bool> notificaAttiva;
  final Value<String> orarioNotifica;
  final Value<int> frequenzaValore;
  final Value<String> frequenzaTipo;
  final Value<int> rowid;
  const MedicationsCompanion({
    this.id = const Value.absent(),
    this.profileId = const Value.absent(),
    this.nome = const Value.absent(),
    this.scatole = const Value.absent(),
    this.note = const Value.absent(),
    this.inPausa = const Value.absent(),
    this.notificaAttiva = const Value.absent(),
    this.orarioNotifica = const Value.absent(),
    this.frequenzaValore = const Value.absent(),
    this.frequenzaTipo = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  MedicationsCompanion.insert({
    required String id,
    required String profileId,
    required String nome,
    this.scatole = const Value.absent(),
    this.note = const Value.absent(),
    this.inPausa = const Value.absent(),
    this.notificaAttiva = const Value.absent(),
    this.orarioNotifica = const Value.absent(),
    this.frequenzaValore = const Value.absent(),
    this.frequenzaTipo = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       profileId = Value(profileId),
       nome = Value(nome);
  static Insertable<MedicationRow> custom({
    Expression<String>? id,
    Expression<String>? profileId,
    Expression<String>? nome,
    Expression<int>? scatole,
    Expression<String>? note,
    Expression<bool>? inPausa,
    Expression<bool>? notificaAttiva,
    Expression<String>? orarioNotifica,
    Expression<int>? frequenzaValore,
    Expression<String>? frequenzaTipo,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (profileId != null) 'profile_id': profileId,
      if (nome != null) 'nome': nome,
      if (scatole != null) 'scatole': scatole,
      if (note != null) 'note': note,
      if (inPausa != null) 'in_pausa': inPausa,
      if (notificaAttiva != null) 'notifica_attiva': notificaAttiva,
      if (orarioNotifica != null) 'orario_notifica': orarioNotifica,
      if (frequenzaValore != null) 'frequenza_valore': frequenzaValore,
      if (frequenzaTipo != null) 'frequenza_tipo': frequenzaTipo,
      if (rowid != null) 'rowid': rowid,
    });
  }

  MedicationsCompanion copyWith({
    Value<String>? id,
    Value<String>? profileId,
    Value<String>? nome,
    Value<int>? scatole,
    Value<String>? note,
    Value<bool>? inPausa,
    Value<bool>? notificaAttiva,
    Value<String>? orarioNotifica,
    Value<int>? frequenzaValore,
    Value<String>? frequenzaTipo,
    Value<int>? rowid,
  }) {
    return MedicationsCompanion(
      id: id ?? this.id,
      profileId: profileId ?? this.profileId,
      nome: nome ?? this.nome,
      scatole: scatole ?? this.scatole,
      note: note ?? this.note,
      inPausa: inPausa ?? this.inPausa,
      notificaAttiva: notificaAttiva ?? this.notificaAttiva,
      orarioNotifica: orarioNotifica ?? this.orarioNotifica,
      frequenzaValore: frequenzaValore ?? this.frequenzaValore,
      frequenzaTipo: frequenzaTipo ?? this.frequenzaTipo,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (profileId.present) {
      map['profile_id'] = Variable<String>(profileId.value);
    }
    if (nome.present) {
      map['nome'] = Variable<String>(nome.value);
    }
    if (scatole.present) {
      map['scatole'] = Variable<int>(scatole.value);
    }
    if (note.present) {
      map['note'] = Variable<String>(note.value);
    }
    if (inPausa.present) {
      map['in_pausa'] = Variable<bool>(inPausa.value);
    }
    if (notificaAttiva.present) {
      map['notifica_attiva'] = Variable<bool>(notificaAttiva.value);
    }
    if (orarioNotifica.present) {
      map['orario_notifica'] = Variable<String>(orarioNotifica.value);
    }
    if (frequenzaValore.present) {
      map['frequenza_valore'] = Variable<int>(frequenzaValore.value);
    }
    if (frequenzaTipo.present) {
      map['frequenza_tipo'] = Variable<String>(frequenzaTipo.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('MedicationsCompanion(')
          ..write('id: $id, ')
          ..write('profileId: $profileId, ')
          ..write('nome: $nome, ')
          ..write('scatole: $scatole, ')
          ..write('note: $note, ')
          ..write('inPausa: $inPausa, ')
          ..write('notificaAttiva: $notificaAttiva, ')
          ..write('orarioNotifica: $orarioNotifica, ')
          ..write('frequenzaValore: $frequenzaValore, ')
          ..write('frequenzaTipo: $frequenzaTipo, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $SentRequestsTable extends SentRequests
    with TableInfo<$SentRequestsTable, SentRequestRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SentRequestsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _profileIdMeta = const VerificationMeta(
    'profileId',
  );
  @override
  late final GeneratedColumn<String> profileId = GeneratedColumn<String>(
    'profile_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES profiles (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _sentAtMeta = const VerificationMeta('sentAt');
  @override
  late final GeneratedColumn<DateTime> sentAt = GeneratedColumn<DateTime>(
    'sent_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _pazienteNomeMeta = const VerificationMeta(
    'pazienteNome',
  );
  @override
  late final GeneratedColumn<String> pazienteNome = GeneratedColumn<String>(
    'paziente_nome',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _medicoNomeMeta = const VerificationMeta(
    'medicoNome',
  );
  @override
  late final GeneratedColumn<String> medicoNome = GeneratedColumn<String>(
    'medico_nome',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _farmaciJsonMeta = const VerificationMeta(
    'farmaciJson',
  );
  @override
  late final GeneratedColumn<String> farmaciJson = GeneratedColumn<String>(
    'farmaci_json',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('[]'),
  );
  static const VerificationMeta _testoCompletoMeta = const VerificationMeta(
    'testoCompleto',
  );
  @override
  late final GeneratedColumn<String> testoCompleto = GeneratedColumn<String>(
    'testo_completo',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    profileId,
    sentAt,
    pazienteNome,
    medicoNome,
    farmaciJson,
    testoCompleto,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'sent_requests';
  @override
  VerificationContext validateIntegrity(
    Insertable<SentRequestRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('profile_id')) {
      context.handle(
        _profileIdMeta,
        profileId.isAcceptableOrUnknown(data['profile_id']!, _profileIdMeta),
      );
    } else if (isInserting) {
      context.missing(_profileIdMeta);
    }
    if (data.containsKey('sent_at')) {
      context.handle(
        _sentAtMeta,
        sentAt.isAcceptableOrUnknown(data['sent_at']!, _sentAtMeta),
      );
    } else if (isInserting) {
      context.missing(_sentAtMeta);
    }
    if (data.containsKey('paziente_nome')) {
      context.handle(
        _pazienteNomeMeta,
        pazienteNome.isAcceptableOrUnknown(
          data['paziente_nome']!,
          _pazienteNomeMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_pazienteNomeMeta);
    }
    if (data.containsKey('medico_nome')) {
      context.handle(
        _medicoNomeMeta,
        medicoNome.isAcceptableOrUnknown(data['medico_nome']!, _medicoNomeMeta),
      );
    } else if (isInserting) {
      context.missing(_medicoNomeMeta);
    }
    if (data.containsKey('farmaci_json')) {
      context.handle(
        _farmaciJsonMeta,
        farmaciJson.isAcceptableOrUnknown(
          data['farmaci_json']!,
          _farmaciJsonMeta,
        ),
      );
    }
    if (data.containsKey('testo_completo')) {
      context.handle(
        _testoCompletoMeta,
        testoCompleto.isAcceptableOrUnknown(
          data['testo_completo']!,
          _testoCompletoMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_testoCompletoMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  SentRequestRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SentRequestRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      profileId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}profile_id'],
      )!,
      sentAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}sent_at'],
      )!,
      pazienteNome: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}paziente_nome'],
      )!,
      medicoNome: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}medico_nome'],
      )!,
      farmaciJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}farmaci_json'],
      )!,
      testoCompleto: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}testo_completo'],
      )!,
    );
  }

  @override
  $SentRequestsTable createAlias(String alias) {
    return $SentRequestsTable(attachedDatabase, alias);
  }
}

class SentRequestRow extends DataClass implements Insertable<SentRequestRow> {
  final String id;
  final String profileId;

  /// Momento reale dell'invio: permette un ordinamento corretto.
  final DateTime sentAt;
  final String pazienteNome;
  final String medicoNome;

  /// Elenco dei farmaci inviati, in JSON.
  final String farmaciJson;
  final String testoCompleto;
  const SentRequestRow({
    required this.id,
    required this.profileId,
    required this.sentAt,
    required this.pazienteNome,
    required this.medicoNome,
    required this.farmaciJson,
    required this.testoCompleto,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['profile_id'] = Variable<String>(profileId);
    map['sent_at'] = Variable<DateTime>(sentAt);
    map['paziente_nome'] = Variable<String>(pazienteNome);
    map['medico_nome'] = Variable<String>(medicoNome);
    map['farmaci_json'] = Variable<String>(farmaciJson);
    map['testo_completo'] = Variable<String>(testoCompleto);
    return map;
  }

  SentRequestsCompanion toCompanion(bool nullToAbsent) {
    return SentRequestsCompanion(
      id: Value(id),
      profileId: Value(profileId),
      sentAt: Value(sentAt),
      pazienteNome: Value(pazienteNome),
      medicoNome: Value(medicoNome),
      farmaciJson: Value(farmaciJson),
      testoCompleto: Value(testoCompleto),
    );
  }

  factory SentRequestRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SentRequestRow(
      id: serializer.fromJson<String>(json['id']),
      profileId: serializer.fromJson<String>(json['profileId']),
      sentAt: serializer.fromJson<DateTime>(json['sentAt']),
      pazienteNome: serializer.fromJson<String>(json['pazienteNome']),
      medicoNome: serializer.fromJson<String>(json['medicoNome']),
      farmaciJson: serializer.fromJson<String>(json['farmaciJson']),
      testoCompleto: serializer.fromJson<String>(json['testoCompleto']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'profileId': serializer.toJson<String>(profileId),
      'sentAt': serializer.toJson<DateTime>(sentAt),
      'pazienteNome': serializer.toJson<String>(pazienteNome),
      'medicoNome': serializer.toJson<String>(medicoNome),
      'farmaciJson': serializer.toJson<String>(farmaciJson),
      'testoCompleto': serializer.toJson<String>(testoCompleto),
    };
  }

  SentRequestRow copyWith({
    String? id,
    String? profileId,
    DateTime? sentAt,
    String? pazienteNome,
    String? medicoNome,
    String? farmaciJson,
    String? testoCompleto,
  }) => SentRequestRow(
    id: id ?? this.id,
    profileId: profileId ?? this.profileId,
    sentAt: sentAt ?? this.sentAt,
    pazienteNome: pazienteNome ?? this.pazienteNome,
    medicoNome: medicoNome ?? this.medicoNome,
    farmaciJson: farmaciJson ?? this.farmaciJson,
    testoCompleto: testoCompleto ?? this.testoCompleto,
  );
  SentRequestRow copyWithCompanion(SentRequestsCompanion data) {
    return SentRequestRow(
      id: data.id.present ? data.id.value : this.id,
      profileId: data.profileId.present ? data.profileId.value : this.profileId,
      sentAt: data.sentAt.present ? data.sentAt.value : this.sentAt,
      pazienteNome: data.pazienteNome.present
          ? data.pazienteNome.value
          : this.pazienteNome,
      medicoNome: data.medicoNome.present
          ? data.medicoNome.value
          : this.medicoNome,
      farmaciJson: data.farmaciJson.present
          ? data.farmaciJson.value
          : this.farmaciJson,
      testoCompleto: data.testoCompleto.present
          ? data.testoCompleto.value
          : this.testoCompleto,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SentRequestRow(')
          ..write('id: $id, ')
          ..write('profileId: $profileId, ')
          ..write('sentAt: $sentAt, ')
          ..write('pazienteNome: $pazienteNome, ')
          ..write('medicoNome: $medicoNome, ')
          ..write('farmaciJson: $farmaciJson, ')
          ..write('testoCompleto: $testoCompleto')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    profileId,
    sentAt,
    pazienteNome,
    medicoNome,
    farmaciJson,
    testoCompleto,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SentRequestRow &&
          other.id == this.id &&
          other.profileId == this.profileId &&
          other.sentAt == this.sentAt &&
          other.pazienteNome == this.pazienteNome &&
          other.medicoNome == this.medicoNome &&
          other.farmaciJson == this.farmaciJson &&
          other.testoCompleto == this.testoCompleto);
}

class SentRequestsCompanion extends UpdateCompanion<SentRequestRow> {
  final Value<String> id;
  final Value<String> profileId;
  final Value<DateTime> sentAt;
  final Value<String> pazienteNome;
  final Value<String> medicoNome;
  final Value<String> farmaciJson;
  final Value<String> testoCompleto;
  final Value<int> rowid;
  const SentRequestsCompanion({
    this.id = const Value.absent(),
    this.profileId = const Value.absent(),
    this.sentAt = const Value.absent(),
    this.pazienteNome = const Value.absent(),
    this.medicoNome = const Value.absent(),
    this.farmaciJson = const Value.absent(),
    this.testoCompleto = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SentRequestsCompanion.insert({
    required String id,
    required String profileId,
    required DateTime sentAt,
    required String pazienteNome,
    required String medicoNome,
    this.farmaciJson = const Value.absent(),
    required String testoCompleto,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       profileId = Value(profileId),
       sentAt = Value(sentAt),
       pazienteNome = Value(pazienteNome),
       medicoNome = Value(medicoNome),
       testoCompleto = Value(testoCompleto);
  static Insertable<SentRequestRow> custom({
    Expression<String>? id,
    Expression<String>? profileId,
    Expression<DateTime>? sentAt,
    Expression<String>? pazienteNome,
    Expression<String>? medicoNome,
    Expression<String>? farmaciJson,
    Expression<String>? testoCompleto,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (profileId != null) 'profile_id': profileId,
      if (sentAt != null) 'sent_at': sentAt,
      if (pazienteNome != null) 'paziente_nome': pazienteNome,
      if (medicoNome != null) 'medico_nome': medicoNome,
      if (farmaciJson != null) 'farmaci_json': farmaciJson,
      if (testoCompleto != null) 'testo_completo': testoCompleto,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SentRequestsCompanion copyWith({
    Value<String>? id,
    Value<String>? profileId,
    Value<DateTime>? sentAt,
    Value<String>? pazienteNome,
    Value<String>? medicoNome,
    Value<String>? farmaciJson,
    Value<String>? testoCompleto,
    Value<int>? rowid,
  }) {
    return SentRequestsCompanion(
      id: id ?? this.id,
      profileId: profileId ?? this.profileId,
      sentAt: sentAt ?? this.sentAt,
      pazienteNome: pazienteNome ?? this.pazienteNome,
      medicoNome: medicoNome ?? this.medicoNome,
      farmaciJson: farmaciJson ?? this.farmaciJson,
      testoCompleto: testoCompleto ?? this.testoCompleto,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (profileId.present) {
      map['profile_id'] = Variable<String>(profileId.value);
    }
    if (sentAt.present) {
      map['sent_at'] = Variable<DateTime>(sentAt.value);
    }
    if (pazienteNome.present) {
      map['paziente_nome'] = Variable<String>(pazienteNome.value);
    }
    if (medicoNome.present) {
      map['medico_nome'] = Variable<String>(medicoNome.value);
    }
    if (farmaciJson.present) {
      map['farmaci_json'] = Variable<String>(farmaciJson.value);
    }
    if (testoCompleto.present) {
      map['testo_completo'] = Variable<String>(testoCompleto.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SentRequestsCompanion(')
          ..write('id: $id, ')
          ..write('profileId: $profileId, ')
          ..write('sentAt: $sentAt, ')
          ..write('pazienteNome: $pazienteNome, ')
          ..write('medicoNome: $medicoNome, ')
          ..write('farmaciJson: $farmaciJson, ')
          ..write('testoCompleto: $testoCompleto, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $ProfilesTable profiles = $ProfilesTable(this);
  late final $MedicationsTable medications = $MedicationsTable(this);
  late final $SentRequestsTable sentRequests = $SentRequestsTable(this);
  late final Index indexMedicationsProfileId = Index(
    'index_medications_profileId',
    'CREATE INDEX index_medications_profileId ON medications (profile_id)',
  );
  late final Index indexSentRequestsProfileId = Index(
    'index_sent_requests_profileId',
    'CREATE INDEX index_sent_requests_profileId ON sent_requests (profile_id)',
  );
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    profiles,
    medications,
    sentRequests,
    indexMedicationsProfileId,
    indexSentRequestsProfileId,
  ];
  @override
  StreamQueryUpdateRules get streamUpdateRules => const StreamQueryUpdateRules([
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'profiles',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('medications', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'profiles',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('sent_requests', kind: UpdateKind.delete)],
    ),
  ]);
}

typedef $$ProfilesTableCreateCompanionBuilder = ProfilesCompanion Function({
  required String id,
  Value<String> pazienteNome,
  Value<String> pazienteCf,
  Value<String> medicoNome,
  Value<String> medicoTelefono,
  Value<String> medicoEmail,
  Value<String> secondoIndirizzo,
  Value<String> messaggioTesta,
  Value<String> messaggioCoda,
  Value<int> tipoInvio,
  Value<bool> notificheAttive,
  Value<String> descrizioneNotifica,
  Value<int> rowid,
});
typedef $$ProfilesTableUpdateCompanionBuilder = ProfilesCompanion Function({
  Value<String> id,
  Value<String> pazienteNome,
  Value<String> pazienteCf,
  Value<String> medicoNome,
  Value<String> medicoTelefono,
  Value<String> medicoEmail,
  Value<String> secondoIndirizzo,
  Value<String> messaggioTesta,
  Value<String> messaggioCoda,
  Value<int> tipoInvio,
  Value<bool> notificheAttive,
  Value<String> descrizioneNotifica,
  Value<int> rowid,
});

final class $$ProfilesTableReferences
    extends BaseReferences<_$AppDatabase, $ProfilesTable, ProfileRow> {
  $$ProfilesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$MedicationsTable, List<MedicationRow>>
  _medicationsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.medications,
    aliasName: 'profiles__id__medications__profile_id',
  );

  $$MedicationsTableProcessedTableManager get medicationsRefs {
    final manager = $$MedicationsTableTableManager(
      $_db,
      $_db.medications,
    ).filter((f) => f.profileId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_medicationsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$SentRequestsTable, List<SentRequestRow>>
  _sentRequestsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.sentRequests,
    aliasName: 'profiles__id__sent_requests__profile_id',
  );

  $$SentRequestsTableProcessedTableManager get sentRequestsRefs {
    final manager = $$SentRequestsTableTableManager(
      $_db,
      $_db.sentRequests,
    ).filter((f) => f.profileId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_sentRequestsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$ProfilesTableFilterComposer
    extends Composer<_$AppDatabase, $ProfilesTable> {
  $$ProfilesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get pazienteNome => $composableBuilder(
    column: $table.pazienteNome,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get pazienteCf => $composableBuilder(
    column: $table.pazienteCf,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get medicoNome => $composableBuilder(
    column: $table.medicoNome,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get medicoTelefono => $composableBuilder(
    column: $table.medicoTelefono,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get medicoEmail => $composableBuilder(
    column: $table.medicoEmail,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get secondoIndirizzo => $composableBuilder(
    column: $table.secondoIndirizzo,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get messaggioTesta => $composableBuilder(
    column: $table.messaggioTesta,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get messaggioCoda => $composableBuilder(
    column: $table.messaggioCoda,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get tipoInvio => $composableBuilder(
    column: $table.tipoInvio,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get notificheAttive => $composableBuilder(
    column: $table.notificheAttive,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get descrizioneNotifica => $composableBuilder(
    column: $table.descrizioneNotifica,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> medicationsRefs(
    Expression<bool> Function($$MedicationsTableFilterComposer f) f,
  ) {
    final $$MedicationsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.medications,
      getReferencedColumn: (t) => t.profileId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MedicationsTableFilterComposer(
            $db: $db,
            $table: $db.medications,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> sentRequestsRefs(
    Expression<bool> Function($$SentRequestsTableFilterComposer f) f,
  ) {
    final $$SentRequestsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.sentRequests,
      getReferencedColumn: (t) => t.profileId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SentRequestsTableFilterComposer(
            $db: $db,
            $table: $db.sentRequests,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$ProfilesTableOrderingComposer
    extends Composer<_$AppDatabase, $ProfilesTable> {
  $$ProfilesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get pazienteNome => $composableBuilder(
    column: $table.pazienteNome,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get pazienteCf => $composableBuilder(
    column: $table.pazienteCf,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get medicoNome => $composableBuilder(
    column: $table.medicoNome,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get medicoTelefono => $composableBuilder(
    column: $table.medicoTelefono,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get medicoEmail => $composableBuilder(
    column: $table.medicoEmail,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get secondoIndirizzo => $composableBuilder(
    column: $table.secondoIndirizzo,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get messaggioTesta => $composableBuilder(
    column: $table.messaggioTesta,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get messaggioCoda => $composableBuilder(
    column: $table.messaggioCoda,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get tipoInvio => $composableBuilder(
    column: $table.tipoInvio,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get notificheAttive => $composableBuilder(
    column: $table.notificheAttive,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get descrizioneNotifica => $composableBuilder(
    column: $table.descrizioneNotifica,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ProfilesTableAnnotationComposer
    extends Composer<_$AppDatabase, $ProfilesTable> {
  $$ProfilesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get pazienteNome => $composableBuilder(
    column: $table.pazienteNome,
    builder: (column) => column,
  );

  GeneratedColumn<String> get pazienteCf => $composableBuilder(
    column: $table.pazienteCf,
    builder: (column) => column,
  );

  GeneratedColumn<String> get medicoNome => $composableBuilder(
    column: $table.medicoNome,
    builder: (column) => column,
  );

  GeneratedColumn<String> get medicoTelefono => $composableBuilder(
    column: $table.medicoTelefono,
    builder: (column) => column,
  );

  GeneratedColumn<String> get medicoEmail => $composableBuilder(
    column: $table.medicoEmail,
    builder: (column) => column,
  );

  GeneratedColumn<String> get secondoIndirizzo => $composableBuilder(
    column: $table.secondoIndirizzo,
    builder: (column) => column,
  );

  GeneratedColumn<String> get messaggioTesta => $composableBuilder(
    column: $table.messaggioTesta,
    builder: (column) => column,
  );

  GeneratedColumn<String> get messaggioCoda => $composableBuilder(
    column: $table.messaggioCoda,
    builder: (column) => column,
  );

  GeneratedColumn<int> get tipoInvio =>
      $composableBuilder(column: $table.tipoInvio, builder: (column) => column);

  GeneratedColumn<bool> get notificheAttive => $composableBuilder(
    column: $table.notificheAttive,
    builder: (column) => column,
  );

  GeneratedColumn<String> get descrizioneNotifica => $composableBuilder(
    column: $table.descrizioneNotifica,
    builder: (column) => column,
  );

  Expression<T> medicationsRefs<T extends Object>(
    Expression<T> Function($$MedicationsTableAnnotationComposer a) f,
  ) {
    final $$MedicationsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.medications,
      getReferencedColumn: (t) => t.profileId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MedicationsTableAnnotationComposer(
            $db: $db,
            $table: $db.medications,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> sentRequestsRefs<T extends Object>(
    Expression<T> Function($$SentRequestsTableAnnotationComposer a) f,
  ) {
    final $$SentRequestsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.sentRequests,
      getReferencedColumn: (t) => t.profileId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SentRequestsTableAnnotationComposer(
            $db: $db,
            $table: $db.sentRequests,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$ProfilesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ProfilesTable,
          ProfileRow,
          $$ProfilesTableFilterComposer,
          $$ProfilesTableOrderingComposer,
          $$ProfilesTableAnnotationComposer,
          $$ProfilesTableCreateCompanionBuilder,
          $$ProfilesTableUpdateCompanionBuilder,
          (ProfileRow, $$ProfilesTableReferences),
          ProfileRow,
          PrefetchHooks Function({bool medicationsRefs, bool sentRequestsRefs})
        > {
  $$ProfilesTableTableManager(_$AppDatabase db, $ProfilesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ProfilesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ProfilesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ProfilesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> pazienteNome = const Value.absent(),
                Value<String> pazienteCf = const Value.absent(),
                Value<String> medicoNome = const Value.absent(),
                Value<String> medicoTelefono = const Value.absent(),
                Value<String> medicoEmail = const Value.absent(),
                Value<String> secondoIndirizzo = const Value.absent(),
                Value<String> messaggioTesta = const Value.absent(),
                Value<String> messaggioCoda = const Value.absent(),
                Value<int> tipoInvio = const Value.absent(),
                Value<bool> notificheAttive = const Value.absent(),
                Value<String> descrizioneNotifica = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ProfilesCompanion(
                id: id,
                pazienteNome: pazienteNome,
                pazienteCf: pazienteCf,
                medicoNome: medicoNome,
                medicoTelefono: medicoTelefono,
                medicoEmail: medicoEmail,
                secondoIndirizzo: secondoIndirizzo,
                messaggioTesta: messaggioTesta,
                messaggioCoda: messaggioCoda,
                tipoInvio: tipoInvio,
                notificheAttive: notificheAttive,
                descrizioneNotifica: descrizioneNotifica,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                Value<String> pazienteNome = const Value.absent(),
                Value<String> pazienteCf = const Value.absent(),
                Value<String> medicoNome = const Value.absent(),
                Value<String> medicoTelefono = const Value.absent(),
                Value<String> medicoEmail = const Value.absent(),
                Value<String> secondoIndirizzo = const Value.absent(),
                Value<String> messaggioTesta = const Value.absent(),
                Value<String> messaggioCoda = const Value.absent(),
                Value<int> tipoInvio = const Value.absent(),
                Value<bool> notificheAttive = const Value.absent(),
                Value<String> descrizioneNotifica = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ProfilesCompanion.insert(
                id: id,
                pazienteNome: pazienteNome,
                pazienteCf: pazienteCf,
                medicoNome: medicoNome,
                medicoTelefono: medicoTelefono,
                medicoEmail: medicoEmail,
                secondoIndirizzo: secondoIndirizzo,
                messaggioTesta: messaggioTesta,
                messaggioCoda: messaggioCoda,
                tipoInvio: tipoInvio,
                notificheAttive: notificheAttive,
                descrizioneNotifica: descrizioneNotifica,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$ProfilesTable, ProfileRow>(table),
                  $$ProfilesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({medicationsRefs = false, sentRequestsRefs = false}) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (medicationsRefs) db.medications,
                    if (sentRequestsRefs) db.sentRequests,
                  ],
                  addJoins: null,
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (medicationsRefs)
                        await $_getPrefetchedDataByColumns<
                          ProfileRow,
                          $ProfilesTable,
                          MedicationRow,
                          $MedicationsTable
                        >(
                          currentTable: table,
                          referencedTable: $$ProfilesTableReferences
                              ._medicationsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$ProfilesTableReferences(
                                db,
                                table,
                                p0,
                              ).medicationsRefs,
                          currentColumn: 'id',
                          referencedColumn: 'profile_id',
                          typedResults: items,
                        ),
                      if (sentRequestsRefs)
                        await $_getPrefetchedDataByColumns<
                          ProfileRow,
                          $ProfilesTable,
                          SentRequestRow,
                          $SentRequestsTable
                        >(
                          currentTable: table,
                          referencedTable: $$ProfilesTableReferences
                              ._sentRequestsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$ProfilesTableReferences(
                                db,
                                table,
                                p0,
                              ).sentRequestsRefs,
                          currentColumn: 'id',
                          referencedColumn: 'profile_id',
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$ProfilesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ProfilesTable,
      ProfileRow,
      $$ProfilesTableFilterComposer,
      $$ProfilesTableOrderingComposer,
      $$ProfilesTableAnnotationComposer,
      $$ProfilesTableCreateCompanionBuilder,
      $$ProfilesTableUpdateCompanionBuilder,
      (ProfileRow, $$ProfilesTableReferences),
      ProfileRow,
      PrefetchHooks Function({bool medicationsRefs, bool sentRequestsRefs})
    >;
typedef $$MedicationsTableCreateCompanionBuilder =
    MedicationsCompanion Function({
      required String id,
      required String profileId,
      required String nome,
      Value<int> scatole,
      Value<String> note,
      Value<bool> inPausa,
      Value<bool> notificaAttiva,
      Value<String> orarioNotifica,
      Value<int> frequenzaValore,
      Value<String> frequenzaTipo,
      Value<int> rowid,
    });
typedef $$MedicationsTableUpdateCompanionBuilder =
    MedicationsCompanion Function({
      Value<String> id,
      Value<String> profileId,
      Value<String> nome,
      Value<int> scatole,
      Value<String> note,
      Value<bool> inPausa,
      Value<bool> notificaAttiva,
      Value<String> orarioNotifica,
      Value<int> frequenzaValore,
      Value<String> frequenzaTipo,
      Value<int> rowid,
    });

final class $$MedicationsTableReferences
    extends BaseReferences<_$AppDatabase, $MedicationsTable, MedicationRow> {
  $$MedicationsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $ProfilesTable _profileIdTable(_$AppDatabase db) =>
      db.profiles.createAlias('medications__profile_id__profiles__id');

  $$ProfilesTableProcessedTableManager get profileId {
    final $_column = $_itemColumn<String>('profile_id')!;

    final manager = $$ProfilesTableTableManager(
      $_db,
      $_db.profiles,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_profileIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$MedicationsTableFilterComposer
    extends Composer<_$AppDatabase, $MedicationsTable> {
  $$MedicationsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get nome => $composableBuilder(
    column: $table.nome,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get scatole => $composableBuilder(
    column: $table.scatole,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get inPausa => $composableBuilder(
    column: $table.inPausa,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get notificaAttiva => $composableBuilder(
    column: $table.notificaAttiva,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get orarioNotifica => $composableBuilder(
    column: $table.orarioNotifica,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get frequenzaValore => $composableBuilder(
    column: $table.frequenzaValore,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get frequenzaTipo => $composableBuilder(
    column: $table.frequenzaTipo,
    builder: (column) => ColumnFilters(column),
  );

  $$ProfilesTableFilterComposer get profileId {
    final $$ProfilesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.profileId,
      referencedTable: $db.profiles,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProfilesTableFilterComposer(
            $db: $db,
            $table: $db.profiles,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$MedicationsTableOrderingComposer
    extends Composer<_$AppDatabase, $MedicationsTable> {
  $$MedicationsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get nome => $composableBuilder(
    column: $table.nome,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get scatole => $composableBuilder(
    column: $table.scatole,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get inPausa => $composableBuilder(
    column: $table.inPausa,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get notificaAttiva => $composableBuilder(
    column: $table.notificaAttiva,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get orarioNotifica => $composableBuilder(
    column: $table.orarioNotifica,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get frequenzaValore => $composableBuilder(
    column: $table.frequenzaValore,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get frequenzaTipo => $composableBuilder(
    column: $table.frequenzaTipo,
    builder: (column) => ColumnOrderings(column),
  );

  $$ProfilesTableOrderingComposer get profileId {
    final $$ProfilesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.profileId,
      referencedTable: $db.profiles,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProfilesTableOrderingComposer(
            $db: $db,
            $table: $db.profiles,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$MedicationsTableAnnotationComposer
    extends Composer<_$AppDatabase, $MedicationsTable> {
  $$MedicationsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get nome =>
      $composableBuilder(column: $table.nome, builder: (column) => column);

  GeneratedColumn<int> get scatole =>
      $composableBuilder(column: $table.scatole, builder: (column) => column);

  GeneratedColumn<String> get note =>
      $composableBuilder(column: $table.note, builder: (column) => column);

  GeneratedColumn<bool> get inPausa =>
      $composableBuilder(column: $table.inPausa, builder: (column) => column);

  GeneratedColumn<bool> get notificaAttiva => $composableBuilder(
    column: $table.notificaAttiva,
    builder: (column) => column,
  );

  GeneratedColumn<String> get orarioNotifica => $composableBuilder(
    column: $table.orarioNotifica,
    builder: (column) => column,
  );

  GeneratedColumn<int> get frequenzaValore => $composableBuilder(
    column: $table.frequenzaValore,
    builder: (column) => column,
  );

  GeneratedColumn<String> get frequenzaTipo => $composableBuilder(
    column: $table.frequenzaTipo,
    builder: (column) => column,
  );

  $$ProfilesTableAnnotationComposer get profileId {
    final $$ProfilesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.profileId,
      referencedTable: $db.profiles,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProfilesTableAnnotationComposer(
            $db: $db,
            $table: $db.profiles,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$MedicationsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $MedicationsTable,
          MedicationRow,
          $$MedicationsTableFilterComposer,
          $$MedicationsTableOrderingComposer,
          $$MedicationsTableAnnotationComposer,
          $$MedicationsTableCreateCompanionBuilder,
          $$MedicationsTableUpdateCompanionBuilder,
          (MedicationRow, $$MedicationsTableReferences),
          MedicationRow,
          PrefetchHooks Function({bool profileId})
        > {
  $$MedicationsTableTableManager(_$AppDatabase db, $MedicationsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$MedicationsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$MedicationsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$MedicationsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> profileId = const Value.absent(),
                Value<String> nome = const Value.absent(),
                Value<int> scatole = const Value.absent(),
                Value<String> note = const Value.absent(),
                Value<bool> inPausa = const Value.absent(),
                Value<bool> notificaAttiva = const Value.absent(),
                Value<String> orarioNotifica = const Value.absent(),
                Value<int> frequenzaValore = const Value.absent(),
                Value<String> frequenzaTipo = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => MedicationsCompanion(
                id: id,
                profileId: profileId,
                nome: nome,
                scatole: scatole,
                note: note,
                inPausa: inPausa,
                notificaAttiva: notificaAttiva,
                orarioNotifica: orarioNotifica,
                frequenzaValore: frequenzaValore,
                frequenzaTipo: frequenzaTipo,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String profileId,
                required String nome,
                Value<int> scatole = const Value.absent(),
                Value<String> note = const Value.absent(),
                Value<bool> inPausa = const Value.absent(),
                Value<bool> notificaAttiva = const Value.absent(),
                Value<String> orarioNotifica = const Value.absent(),
                Value<int> frequenzaValore = const Value.absent(),
                Value<String> frequenzaTipo = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => MedicationsCompanion.insert(
                id: id,
                profileId: profileId,
                nome: nome,
                scatole: scatole,
                note: note,
                inPausa: inPausa,
                notificaAttiva: notificaAttiva,
                orarioNotifica: orarioNotifica,
                frequenzaValore: frequenzaValore,
                frequenzaTipo: frequenzaTipo,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$MedicationsTable, MedicationRow>(table),
                  $$MedicationsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({profileId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
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
                      dynamic
                    >
                  >(state) {
                    if (profileId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.profileId,
                        referencedTable: $$MedicationsTableReferences
                            ._profileIdTable(db),
                        referencedColumn: $$MedicationsTableReferences
                            ._profileIdTable(db)
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
        ),
      );
}

typedef $$MedicationsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $MedicationsTable,
      MedicationRow,
      $$MedicationsTableFilterComposer,
      $$MedicationsTableOrderingComposer,
      $$MedicationsTableAnnotationComposer,
      $$MedicationsTableCreateCompanionBuilder,
      $$MedicationsTableUpdateCompanionBuilder,
      (MedicationRow, $$MedicationsTableReferences),
      MedicationRow,
      PrefetchHooks Function({bool profileId})
    >;
typedef $$SentRequestsTableCreateCompanionBuilder =
    SentRequestsCompanion Function({
      required String id,
      required String profileId,
      required DateTime sentAt,
      required String pazienteNome,
      required String medicoNome,
      Value<String> farmaciJson,
      required String testoCompleto,
      Value<int> rowid,
    });
typedef $$SentRequestsTableUpdateCompanionBuilder =
    SentRequestsCompanion Function({
      Value<String> id,
      Value<String> profileId,
      Value<DateTime> sentAt,
      Value<String> pazienteNome,
      Value<String> medicoNome,
      Value<String> farmaciJson,
      Value<String> testoCompleto,
      Value<int> rowid,
    });

final class $$SentRequestsTableReferences
    extends BaseReferences<_$AppDatabase, $SentRequestsTable, SentRequestRow> {
  $$SentRequestsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $ProfilesTable _profileIdTable(_$AppDatabase db) =>
      db.profiles.createAlias('sent_requests__profile_id__profiles__id');

  $$ProfilesTableProcessedTableManager get profileId {
    final $_column = $_itemColumn<String>('profile_id')!;

    final manager = $$ProfilesTableTableManager(
      $_db,
      $_db.profiles,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_profileIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$SentRequestsTableFilterComposer
    extends Composer<_$AppDatabase, $SentRequestsTable> {
  $$SentRequestsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get sentAt => $composableBuilder(
    column: $table.sentAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get pazienteNome => $composableBuilder(
    column: $table.pazienteNome,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get medicoNome => $composableBuilder(
    column: $table.medicoNome,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get farmaciJson => $composableBuilder(
    column: $table.farmaciJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get testoCompleto => $composableBuilder(
    column: $table.testoCompleto,
    builder: (column) => ColumnFilters(column),
  );

  $$ProfilesTableFilterComposer get profileId {
    final $$ProfilesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.profileId,
      referencedTable: $db.profiles,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProfilesTableFilterComposer(
            $db: $db,
            $table: $db.profiles,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$SentRequestsTableOrderingComposer
    extends Composer<_$AppDatabase, $SentRequestsTable> {
  $$SentRequestsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get sentAt => $composableBuilder(
    column: $table.sentAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get pazienteNome => $composableBuilder(
    column: $table.pazienteNome,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get medicoNome => $composableBuilder(
    column: $table.medicoNome,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get farmaciJson => $composableBuilder(
    column: $table.farmaciJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get testoCompleto => $composableBuilder(
    column: $table.testoCompleto,
    builder: (column) => ColumnOrderings(column),
  );

  $$ProfilesTableOrderingComposer get profileId {
    final $$ProfilesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.profileId,
      referencedTable: $db.profiles,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProfilesTableOrderingComposer(
            $db: $db,
            $table: $db.profiles,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$SentRequestsTableAnnotationComposer
    extends Composer<_$AppDatabase, $SentRequestsTable> {
  $$SentRequestsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get sentAt =>
      $composableBuilder(column: $table.sentAt, builder: (column) => column);

  GeneratedColumn<String> get pazienteNome => $composableBuilder(
    column: $table.pazienteNome,
    builder: (column) => column,
  );

  GeneratedColumn<String> get medicoNome => $composableBuilder(
    column: $table.medicoNome,
    builder: (column) => column,
  );

  GeneratedColumn<String> get farmaciJson => $composableBuilder(
    column: $table.farmaciJson,
    builder: (column) => column,
  );

  GeneratedColumn<String> get testoCompleto => $composableBuilder(
    column: $table.testoCompleto,
    builder: (column) => column,
  );

  $$ProfilesTableAnnotationComposer get profileId {
    final $$ProfilesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.profileId,
      referencedTable: $db.profiles,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProfilesTableAnnotationComposer(
            $db: $db,
            $table: $db.profiles,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$SentRequestsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SentRequestsTable,
          SentRequestRow,
          $$SentRequestsTableFilterComposer,
          $$SentRequestsTableOrderingComposer,
          $$SentRequestsTableAnnotationComposer,
          $$SentRequestsTableCreateCompanionBuilder,
          $$SentRequestsTableUpdateCompanionBuilder,
          (SentRequestRow, $$SentRequestsTableReferences),
          SentRequestRow,
          PrefetchHooks Function({bool profileId})
        > {
  $$SentRequestsTableTableManager(_$AppDatabase db, $SentRequestsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SentRequestsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SentRequestsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SentRequestsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> profileId = const Value.absent(),
                Value<DateTime> sentAt = const Value.absent(),
                Value<String> pazienteNome = const Value.absent(),
                Value<String> medicoNome = const Value.absent(),
                Value<String> farmaciJson = const Value.absent(),
                Value<String> testoCompleto = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SentRequestsCompanion(
                id: id,
                profileId: profileId,
                sentAt: sentAt,
                pazienteNome: pazienteNome,
                medicoNome: medicoNome,
                farmaciJson: farmaciJson,
                testoCompleto: testoCompleto,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String profileId,
                required DateTime sentAt,
                required String pazienteNome,
                required String medicoNome,
                Value<String> farmaciJson = const Value.absent(),
                required String testoCompleto,
                Value<int> rowid = const Value.absent(),
              }) => SentRequestsCompanion.insert(
                id: id,
                profileId: profileId,
                sentAt: sentAt,
                pazienteNome: pazienteNome,
                medicoNome: medicoNome,
                farmaciJson: farmaciJson,
                testoCompleto: testoCompleto,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$SentRequestsTable, SentRequestRow>(table),
                  $$SentRequestsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({profileId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
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
                      dynamic
                    >
                  >(state) {
                    if (profileId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.profileId,
                        referencedTable: $$SentRequestsTableReferences
                            ._profileIdTable(db),
                        referencedColumn: $$SentRequestsTableReferences
                            ._profileIdTable(db)
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
        ),
      );
}

typedef $$SentRequestsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SentRequestsTable,
      SentRequestRow,
      $$SentRequestsTableFilterComposer,
      $$SentRequestsTableOrderingComposer,
      $$SentRequestsTableAnnotationComposer,
      $$SentRequestsTableCreateCompanionBuilder,
      $$SentRequestsTableUpdateCompanionBuilder,
      (SentRequestRow, $$SentRequestsTableReferences),
      SentRequestRow,
      PrefetchHooks Function({bool profileId})
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$ProfilesTableTableManager get profiles =>
      $$ProfilesTableTableManager(_db, _db.profiles);
  $$MedicationsTableTableManager get medications =>
      $$MedicationsTableTableManager(_db, _db.medications);
  $$SentRequestsTableTableManager get sentRequests =>
      $$SentRequestsTableTableManager(_db, _db.sentRequests);
}
