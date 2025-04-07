import 'dart:convert';

class CustomerRegisterCovenantModel {
  final int? CodigoInterno_Convenio;
  final String? Codigo_Convenio;
  final String? Cnpj_Convenio;
  final String? InscricaoEstadual_Convenio;
  final String? Nome_Convenio;
  final String? NomeFantasia_Convenio;
  final String? DataCadastro_Convenio;
  final String? EMail_Convenio;
  final String? Contato_Convenio;
  final String? DataNascimentoContato_Convenio;
  final String? Logradouro_Convenio;
  final String? NumEndereco_Convenio;
  final String? Cep_Convenio;
  final String? Cidade_Convenio;
  final String? Bairro_Convenio;
  final String? Estado_Convenio;
  final String? Complemento_Convenio;
  final String? Referencia_Convenio;
  final String? LogradouroEntrega_Convenio;
  final String? NumEnderecoEntrega_Convenio;
  final String? CepEntrega_Convenio;
  final String? CidadeEntrega_Convenio;
  final String? BairroEntrega_Convenio;
  final String? EstadoEntrega_Convenio;
  final String? ComplementoEntrega_Convenio;
  final String? ReferenciaEntrega_Convenio;
  final String? LogradouroCobranca_Convenio;
  final String? NumEnderecoCobranca_Convenio;
  final String? CepCobranca_Convenio;
  final String? CidadeCobranca_Convenio;
  final String? BairroCobranca_Convenio;
  final String? EstadoCobranca_Convenio;
  final String? ComplementoCobranca_Convenio;
  final String? ReferenciaCobranca_Convenio;
  final int? CodigoInterno_GrupoFinanReceita;
  final int? CodigoInterno_CategFinanReceita;
  final int? CodigoInterno_SubCategFinanReceita;
  final String? CodigoAreaTel1_Convenio;
  final String? Telefone1_Convenio;
  final String? CodigoAreaTel2_Convenio;
  final String? Telefone2_Convenio;
  final String? CodigoAreaTel3_Convenio;
  final String? Telefone3_Convenio;
  final int? CodigoInterno_InstFinan;
  final String? NumeroConta_Convenio;
  final String? NomeConta_Convenio;
  final String? DigitoConta_Convenio;
  final String? AgenciaInstFinan_Convenio;
  final String? DigitoAgenciaInstFinan_Convenio;
  final int? FlagCodigoPersonalizado_Convenio;
  final int? FlagObrigaMatriculaConvd_Convenio;
  final int? FlagPermCompraAdicional_Convenio;
  final String? CodigoLegado_Convenio;
  final int? FlagEnderecoContemNum_Convenio;
  final int? FlagEnderecoContemNumEntrega_Convenio;
  final int? FlagEnderecoContemNumCobranca_Convenio;

  CustomerRegisterCovenantModel({
    required this.CodigoInterno_Convenio,
    required this.Codigo_Convenio,
    required this.Cnpj_Convenio,
    required this.InscricaoEstadual_Convenio,
    required this.Nome_Convenio,
    required this.NomeFantasia_Convenio,
    required this.DataCadastro_Convenio,
    required this.EMail_Convenio,
    required this.Contato_Convenio,
    required this.DataNascimentoContato_Convenio,
    required this.Logradouro_Convenio,
    required this.NumEndereco_Convenio,
    required this.Cep_Convenio,
    required this.Cidade_Convenio,
    required this.Bairro_Convenio,
    required this.Estado_Convenio,
    required this.Complemento_Convenio,
    required this.Referencia_Convenio,
    required this.LogradouroEntrega_Convenio,
    required this.NumEnderecoEntrega_Convenio,
    required this.CepEntrega_Convenio,
    required this.CidadeEntrega_Convenio,
    required this.BairroEntrega_Convenio,
    required this.EstadoEntrega_Convenio,
    required this.ComplementoEntrega_Convenio,
    required this.ReferenciaEntrega_Convenio,
    required this.LogradouroCobranca_Convenio,
    required this.NumEnderecoCobranca_Convenio,
    required this.CepCobranca_Convenio,
    required this.CidadeCobranca_Convenio,
    required this.BairroCobranca_Convenio,
    required this.EstadoCobranca_Convenio,
    required this.ComplementoCobranca_Convenio,
    required this.ReferenciaCobranca_Convenio,
    required this.CodigoInterno_GrupoFinanReceita,
    required this.CodigoInterno_CategFinanReceita,
    required this.CodigoInterno_SubCategFinanReceita,
    required this.CodigoAreaTel1_Convenio,
    required this.Telefone1_Convenio,
    required this.CodigoAreaTel2_Convenio,
    required this.Telefone2_Convenio,
    required this.CodigoAreaTel3_Convenio,
    required this.Telefone3_Convenio,
    required this.CodigoInterno_InstFinan,
    required this.NumeroConta_Convenio,
    required this.NomeConta_Convenio,
    required this.DigitoConta_Convenio,
    required this.AgenciaInstFinan_Convenio,
    required this.DigitoAgenciaInstFinan_Convenio,
    required this.FlagCodigoPersonalizado_Convenio,
    required this.FlagObrigaMatriculaConvd_Convenio,
    required this.FlagPermCompraAdicional_Convenio,
    required this.CodigoLegado_Convenio,
    required this.FlagEnderecoContemNum_Convenio,
    required this.FlagEnderecoContemNumEntrega_Convenio,
    required this.FlagEnderecoContemNumCobranca_Convenio,
  });

  factory CustomerRegisterCovenantModel.fromJson(Map json) =>
      CustomerRegisterCovenantModel(
        CodigoInterno_Convenio: json["CodigoInterno_Convenio"],
        Codigo_Convenio: json["Codigo_Convenio"],
        Cnpj_Convenio: json["Cnpj_Convenio"],
        InscricaoEstadual_Convenio: json["InscricaoEstadual_Convenio"],
        Nome_Convenio: json["Nome_Convenio"],
        NomeFantasia_Convenio: json["NomeFantasia_Convenio"],
        DataCadastro_Convenio: json["DataCadastro_Convenio"],
        EMail_Convenio: json["EMail_Convenio"],
        Contato_Convenio: json["Contato_Convenio"],
        DataNascimentoContato_Convenio: json["DataNascimentoContato_Convenio"],
        Logradouro_Convenio: json["Logradouro_Convenio"],
        NumEndereco_Convenio: json["NumEndereco_Convenio"],
        Cep_Convenio: json["Cep_Convenio"],
        Cidade_Convenio: json["Cidade_Convenio"],
        Bairro_Convenio: json["Bairro_Convenio"],
        Estado_Convenio: json["Estado_Convenio"],
        Complemento_Convenio: json["Complemento_Convenio"],
        Referencia_Convenio: json["Referencia_Convenio"],
        LogradouroEntrega_Convenio: json["LogradouroEntrega_Convenio"],
        NumEnderecoEntrega_Convenio: json["NumEnderecoEntrega_Convenio"],
        CepEntrega_Convenio: json["CepEntrega_Convenio"],
        CidadeEntrega_Convenio: json["CidadeEntrega_Convenio"],
        BairroEntrega_Convenio: json["BairroEntrega_Convenio"],
        EstadoEntrega_Convenio: json["EstadoEntrega_Convenio"],
        ComplementoEntrega_Convenio: json["ComplementoEntrega_Convenio"],
        ReferenciaEntrega_Convenio: json["ReferenciaEntrega_Convenio"],
        LogradouroCobranca_Convenio: json["LogradouroCobranca_Convenio"],
        NumEnderecoCobranca_Convenio: json["NumEnderecoCobranca_Convenio"],
        CepCobranca_Convenio: json["CepCobranca_Convenio"],
        CidadeCobranca_Convenio: json["CidadeCobranca_Convenio"],
        BairroCobranca_Convenio: json["BairroCobranca_Convenio"],
        EstadoCobranca_Convenio: json["EstadoCobranca_Convenio"],
        ComplementoCobranca_Convenio: json["ComplementoCobranca_Convenio"],
        ReferenciaCobranca_Convenio: json["ReferenciaCobranca_Convenio"],
        CodigoInterno_GrupoFinanReceita:
            json["CodigoInterno_GrupoFinanReceita"],
        CodigoInterno_CategFinanReceita:
            json["CodigoInterno_CategFinanReceita"],
        CodigoInterno_SubCategFinanReceita:
            json["CodigoInterno_SubCategFinanReceita"],
        CodigoAreaTel1_Convenio: json["CodigoAreaTel1_Convenio"],
        Telefone1_Convenio: json["Telefone1_Convenio"],
        CodigoAreaTel2_Convenio: json["CodigoAreaTel2_Convenio"],
        Telefone2_Convenio: json["Telefone2_Convenio"],
        CodigoAreaTel3_Convenio: json["CodigoAreaTel3_Convenio"],
        Telefone3_Convenio: json["Telefone3_Convenio"],
        CodigoInterno_InstFinan: json["CodigoInterno_InstFinan"],
        NumeroConta_Convenio: json["NumeroConta_Convenio"],
        NomeConta_Convenio: json["NomeConta_Convenio"],
        DigitoConta_Convenio: json["DigitoConta_Convenio"],
        AgenciaInstFinan_Convenio: json["AgenciaInstFinan_Convenio"],
        DigitoAgenciaInstFinan_Convenio:
            json["DigitoAgenciaInstFinan_Convenio"],
        FlagCodigoPersonalizado_Convenio:
            json["FlagCodigoPersonalizado_Convenio"],
        FlagObrigaMatriculaConvd_Convenio:
            json["FlagObrigaMatriculaConvd_Convenio"],
        FlagPermCompraAdicional_Convenio:
            json["FlagPermCompraAdicional_Convenio"],
        CodigoLegado_Convenio: json["CodigoLegado_Convenio"],
        FlagEnderecoContemNum_Convenio: json["FlagEnderecoContemNum_Convenio"],
        FlagEnderecoContemNumEntrega_Convenio:
            json["FlagEnderecoContemNumEntrega_Convenio"],
        FlagEnderecoContemNumCobranca_Convenio:
            json["FlagEnderecoContemNumCobranca_Convenio"],
      );

  Map<String, dynamic> toJson() => {
        "CodigoInterno_Convenio": CodigoInterno_Convenio,
        "Codigo_Convenio": Codigo_Convenio,
        "Cnpj_Convenio": Cnpj_Convenio,
        "InscricaoEstadual_Convenio": InscricaoEstadual_Convenio,
        "Nome_Convenio": Nome_Convenio,
        "NomeFantasia_Convenio": NomeFantasia_Convenio,
        "DataCadastro_Convenio": DataCadastro_Convenio,
        "EMail_Convenio": EMail_Convenio,
        "Contato_Convenio": Contato_Convenio,
        "DataNascimentoContato_Convenio": DataNascimentoContato_Convenio,
        "Logradouro_Convenio": Logradouro_Convenio,
        "NumEndereco_Convenio": NumEndereco_Convenio,
        "Cep_Convenio": Cep_Convenio,
        "Cidade_Convenio": Cidade_Convenio,
        "Bairro_Convenio": Bairro_Convenio,
        "Estado_Convenio": Estado_Convenio,
        "Complemento_Convenio": Complemento_Convenio,
        "Referencia_Convenio": Referencia_Convenio,
        "LogradouroEntrega_Convenio": LogradouroEntrega_Convenio,
        "NumEnderecoEntrega_Convenio": NumEnderecoEntrega_Convenio,
        "CepEntrega_Convenio": CepEntrega_Convenio,
        "CidadeEntrega_Convenio": CidadeEntrega_Convenio,
        "BairroEntrega_Convenio": BairroEntrega_Convenio,
        "EstadoEntrega_Convenio": EstadoEntrega_Convenio,
        "ComplementoEntrega_Convenio": ComplementoEntrega_Convenio,
        "ReferenciaEntrega_Convenio": ReferenciaEntrega_Convenio,
        "LogradouroCobranca_Convenio": LogradouroCobranca_Convenio,
        "NumEnderecoCobranca_Convenio": NumEnderecoCobranca_Convenio,
        "CepCobranca_Convenio": CepCobranca_Convenio,
        "CidadeCobranca_Convenio": CidadeCobranca_Convenio,
        "BairroCobranca_Convenio": BairroCobranca_Convenio,
        "EstadoCobranca_Convenio": EstadoCobranca_Convenio,
        "ComplementoCobranca_Convenio": ComplementoCobranca_Convenio,
        "ReferenciaCobranca_Convenio": ReferenciaCobranca_Convenio,
        "CodigoInterno_GrupoFinanReceita": CodigoInterno_GrupoFinanReceita,
        "CodigoInterno_CategFinanReceita": CodigoInterno_CategFinanReceita,
        "CodigoInterno_SubCategFinanReceita":
            CodigoInterno_SubCategFinanReceita,
        "CodigoAreaTel1_Convenio": CodigoAreaTel1_Convenio,
        "Telefone1_Convenio": Telefone1_Convenio,
        "CodigoAreaTel2_Convenio": CodigoAreaTel2_Convenio,
        "Telefone2_Convenio": Telefone2_Convenio,
        "CodigoAreaTel3_Convenio": CodigoAreaTel3_Convenio,
        "Telefone3_Convenio": Telefone3_Convenio,
        "CodigoInterno_InstFinan": CodigoInterno_InstFinan,
        "NumeroConta_Convenio": NumeroConta_Convenio,
        "NomeConta_Convenio": NomeConta_Convenio,
        "DigitoConta_Convenio": DigitoConta_Convenio,
        "AgenciaInstFinan_Convenio": AgenciaInstFinan_Convenio,
        "DigitoAgenciaInstFinan_Convenio": DigitoAgenciaInstFinan_Convenio,
        "FlagCodigoPersonalizado_Convenio": FlagCodigoPersonalizado_Convenio,
        "FlagObrigaMatriculaConvd_Convenio": FlagObrigaMatriculaConvd_Convenio,
        "FlagPermCompraAdicional_Convenio": FlagPermCompraAdicional_Convenio,
        "CodigoLegado_Convenio": CodigoLegado_Convenio,
        "FlagEnderecoContemNum_Convenio": FlagEnderecoContemNum_Convenio,
        "FlagEnderecoContemNumEntrega_Convenio":
            FlagEnderecoContemNumEntrega_Convenio,
        "FlagEnderecoContemNumCobranca_Convenio":
            FlagEnderecoContemNumCobranca_Convenio,
      };

  static void responseAsStringToModel({
    required List<CustomerRegisterCovenantModel> listToAdd,
    required String response,
  }) {
    try {
      final List decoded = json.decode(response);
      listToAdd.addAll(
        decoded.map((e) => CustomerRegisterCovenantModel.fromJson(e)).toList(),
      );
    } catch (e) {
      throw Exception();
    }
  }
}
