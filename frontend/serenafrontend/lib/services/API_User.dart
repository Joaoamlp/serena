import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:math';

class UserService {
  static const String baseUrl = "http://10.0.2.2:5223/api/User";

  // LOGIN (retorna Map com dados do usuário ou null)
  static Future<Map<String, dynamic>?> loginUser(String email, String password) async {
    try {
      print("🔹 Tentando login...");
      print("Email: $email");

      final response = await http.post(
        Uri.parse("$baseUrl/login"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"email": email, "password": password}),
      );

      print("🔹 StatusCode do login: ${response.statusCode}");
      print("🔹 Response body: ${response.body}");

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        // Garante que todos os campos são Strings, mesmo que nulos
        data['name'] = data['name']?.toString() ?? '';
        data['email'] = data['email']?.toString() ?? '';
        data['cpf'] = data['cpf']?.toString() ?? '';
        data['rg'] = data['rg']?.toString() ?? '';
        data['telefone'] = data['telefone']?.toString() ?? '';
        data['dataNascimento'] = data['dataNascimento']?.toString() ?? '';
        data['endereco'] = data['endereco'] ?? {};

        print("✅ Login bem-sucedido: $data");
        return data;
      }

      print("❌ Login falhou. Status: ${response.statusCode}");
      return null;
    } catch (e) {
      print("🔥 Erro no LOGIN: $e");
      return null;
    }
  }
  

  // RESET DE SENHA
  static Future<bool> resetPassword(String email, String newPassword) async {
    try {
      print("🔹 Tentando resetar senha para: $email");

      final response = await http.post(
        Uri.parse("$baseUrl/reset-password"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"email": email, "newPassword": newPassword}),
      );

      print("🔹 StatusCode reset password: ${response.statusCode}");
      print("🔹 Response body: ${response.body}");

      return response.statusCode == 200;
    } catch (e) {
      print("🔥 Erro no RESET: $e");
      return false;
    }
  }

  // CRIAR USUÁRIO
  static Future<bool> createUser({
    required String nome,
    required String email,
    required String password,
    required String cpf,
    required String telefone,
  }) async {
    try {
     String gerarRgFake() {
          List<int> numeros = List.generate(9, (_) => Random().nextInt(10));
          return numeros.join();
        } ; 
     final body = jsonEncode({
        "Name": nome,
        "Email": email,
        "Password": password,
        "Cpf": cpf,
        "Rg": gerarRgFake(),
        "Telefone": telefone,
        "Endereco": {"Rua": ""}
      });

      print("🔹 Enviando POST para criar usuário:");
      print("URL: $baseUrl");
      print("Body: $body");

      final response = await http.post(
        Uri.parse(baseUrl),
        headers: {"Content-Type": "application/json"},
        body: body,
      );

      print("🔹 StatusCode: ${response.statusCode}");
      print("🔹 Response body: ${response.body}");

      return response.statusCode == 201;
    } catch (e) {
      print("🔥 Erro ao criar usuário: $e");
      return false;
    }
  }

  // BUSCAR USUÁRIO POR ID
  static Future<Map<String, dynamic>?> getUserById(int id) async {
    try {
      print("🔹 Buscando usuário pelo ID: $id");

      final response = await http.get(Uri.parse("$baseUrl/$id"));
      print("🔹 StatusCode getUserById: ${response.statusCode}");
      print("🔹 Response body: ${response.body}");

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        print("✅ Usuário encontrado: $data");
        return data;
      }

      print("❌ Usuário não encontrado. Status: ${response.statusCode}");
      return null;
    } catch (e) {
      print("🔥 Erro ao buscar usuário: $e");
      return null;
    }
  }

 static Future<bool> updateUser({
    required int id,
    required String nome,
    required String email,
    required String telefone,
  }) async {
    try {
      print("🔹 Tentando atualizar usuário ID: $id");

      // 1️⃣ Buscar o usuário atual para obter IDs existentes
      final user = await getUserById(id);
      if (user == null) return false;

      print("🔹 Preparando dados para atualização...");

      // 2️⃣ Endereço existente ou novo
      final endereco = user['endereco'] ?? {"id": 0};
      endereco['rua'] = "Rua Atualizada ${Random().nextInt(1000)}";
      endereco['numero'] = endereco['numero'] ?? "${Random().nextInt(9999) + 1}";
      endereco['complemento'] = endereco['complemento'] ?? "Apto ${Random().nextInt(100)}";
      endereco['bairro'] = endereco['bairro'] ?? "Bairro ${Random().nextInt(50)}";
      endereco['cidade'] = endereco['cidade'] ?? "Cidade ${Random().nextInt(50)}";
      endereco['estado'] = endereco['estado'] ?? "Estado ${Random().nextInt(50)}";
      endereco['cep'] = endereco['cep'] ?? "${Random().nextInt(89999) + 10000}";

      print("🔹 Endereço preparado: $endereco");

      // 3️⃣ Apoios existentes ou criar 1 novo
      List apoios = user['apoios'] ?? [];
      if (apoios.isEmpty) {
        apoios = [
          {
            "id": 0,
            "nome": "Apoio ${Random().nextInt(100)}",
            "telefone": "${Random().nextInt(899999999) + 100000000}"
          }
        ];
      }

      print("🔹 Apoios preparados: $apoios");

      // 4️⃣ Montar corpo da requisição
      final body = jsonEncode({
        "id": id,
        "name": nome,
        "email": email,
        "telefone": telefone,
        "emailAddress": email,
        "dataNascimento": user['dataNascimento'] ?? DateTime.now().toIso8601String(),
        "endereco": endereco,
        "apoios": apoios
      });

      print("🔹 Body da atualização:\n$body");

      // 5️⃣ Enviar PUT para API
      final response = await http.put(
        Uri.parse("$baseUrl/$id"),
        headers: {"Content-Type": "application/json"},
        body: body,
      );

      print("🔹 StatusCode updateUser: ${response.statusCode}");
      print("🔹 Response body: ${response.body}");

      if (response.statusCode == 200) {
        print("✅ Usuário atualizado com sucesso!");
        return true;
      } else {
        print("❌ Falha ao atualizar usuário.");
        return false;
      }
    } catch (e) {
      print("🔥 Erro ao atualizar usuário: $e");
      return false;
    }
  }
   // DELETAR USUÁRIO
  static Future<bool> deleteUser(int id) async {
    try {
      print("🔹 Tentando deletar usuário ID: $id");

      final response = await http.delete(Uri.parse("$baseUrl/$id"));

      print("🔹 StatusCode deleteUser: ${response.statusCode}");
      print("🔹 Response body: ${response.body}");

      if (response.statusCode == 200) {
        print("✅ Usuário deletado com sucesso!");
        return true;
      } else {
        print("❌ Falha ao deletar usuário.");
        return false;
      }
    } catch (e) {
      print("🔥 Erro ao deletar usuário: $e");
      return false;
    }
  }
}


 

