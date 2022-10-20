class ReceiptModel {
  final int CodigoInterno_ProcRecebDoc;
  final int CodigoInterno_Empresa;
  final String Numero_ProcRecebDoc;
  final String EmitterName;
  dynamic Status; //ele vem como inteiro mas preciso tratar como string

  ReceiptModel({
    required this.CodigoInterno_ProcRecebDoc,
    required this.CodigoInterno_Empresa,
    required this.Numero_ProcRecebDoc,
    required this.EmitterName,
    required this.Status,
  });
}
