/// Canale di invio della richiesta al medico.
/// Nel JSON di backup e' salvato come intero: 0 = WhatsApp, 1 = SMS, 2 = Email.
enum SendChannel {
  whatsapp(0),
  sms(1),
  email(2);

  const SendChannel(this.code);

  final int code;

  /// Valori sconosciuti diventano WhatsApp (il valore predefinito dell'app).
  static SendChannel fromCode(int code) {
    for (final value in SendChannel.values) {
      if (value.code == code) return value;
    }
    return SendChannel.whatsapp;
  }
}

/// Unita' della frequenza di ripetizione della notifica.
/// Nel JSON di backup e' salvata come testo: "ORE" oppure "GIORNI".
enum FrequencyUnit {
  ore('ORE'),
  giorni('GIORNI');

  const FrequencyUnit(this.code);

  final String code;

  /// Valori sconosciuti diventano GIORNI (come nell'app Kotlin, dove
  /// qualunque valore diverso da "ORE" era trattato come giorni).
  static FrequencyUnit fromCode(String code) =>
      code == 'ORE' ? FrequencyUnit.ore : FrequencyUnit.giorni;
}
