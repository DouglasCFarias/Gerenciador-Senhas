import Foundation

struct Pessoa: Codable {
    var usuarios: [String] = []
    var senhas: [String] = []
    var urls: [String] = []
}
class ViewModel{
    // protocolo é conjunto de regras que indica que quem assina o protocolo tem que implementar as regras
    static let fileManager = FileManager.default
    // static é pra acessar sem instanciar ("acesso global") n muda com instancia
    static  var documentsDirectory: URL {
        return ViewModel.fileManager.urls(for: .documentDirectory, in: .allDomainsMask).first!
    }
    static var jsonURL: URL {
        return ViewModel.documentsDirectory.appendingPathComponent("senhas.json")
    }
    var pessoa: Pessoa
    
    init() {
        self.pessoa = Pessoa()
    }
    func decodar (){
        let decoder = JSONDecoder()
        do{
            let data = try Data(contentsOf: ViewModel.jsonURL)
            let objectDecode = try decoder.decode(Pessoa.self, from: data)
            self.pessoa.usuarios = objectDecode.usuarios
            self.pessoa.senhas = objectDecode.senhas
            self.pessoa.urls = objectDecode.urls
            //                let dado = try Data(contentsOf: ViewModel.jsonURL)
            //                let objectDecode = try decoder.decode(Pessoa.self, from: dado)
            //
            //                Pessoa.usuarios = objectDecode.usuarios
        } catch {
            print("Erro no JSON")
        }
    }
    func cadastro(){
        print("Digite o nome de usuario:")
        if let usuario = readLine(){
            pessoa.usuarios.append(usuario)
            
            print("Digite sua senha:")
            if let senha = readLine(){
                pessoa.senhas.append(senha)
                
                print("Digite o url:")
                if let url = readLine(){
                    pessoa.urls.append(url)
                    print("Senha cadastrada com sucesso!\n")
                } else {
                    print("Erro ao cadastrar senha.\n")
                }
            }
        }
    }
    
    func conferirSenha(){
        if pessoa.senhas.isEmpty {
            print("Nenhuma senha cadastrada.\n")
        } else {
            print("Senhas cadastradas:\n")
            for i in 0..<pessoa.usuarios.count {
                print("cadastro \(i+1):")
                print("usuário: ",pessoa.usuarios[i])
                print("senha: ",pessoa.senhas[i])
                print("url: ",pessoa.urls[i],"\n")
            }
        }
    }
    
    func editarSenha(){
        if pessoa.senhas.isEmpty {
            print("Nenhuma senha cadastrada.\n")
        } else {
            print("Digite o usuario que você deseja editar a senha")
            if let busca = readLine(){
                for i in 0..<pessoa.usuarios.count{
                    if busca == pessoa.usuarios[i]{
                        print("Digite nova senha:")
                        if let novaSenha = readLine(){
                            pessoa.senhas[i] = novaSenha
                            print("Senha editada com sucesso!\n")
                        }
                    }
                }
            } else {
                print("Usuario inválido.\n")
            }
        }
    }
    
    func menu(){
        var userInput: String?
        print("Escolha uma opção:")
        print("1. Cadastrar nova senha")
        print("2. Editar senha existente")
        print("3. Verificar senhas cadastradas")
        print("4. Sair")
        
        userInput = readLine()
        if let input = userInput, let choice = Int(input){
            switch choice {
            case 1:
                cadastro()
                break
            case 2:
                editarSenha()
                break
            case 3:
                conferirSenha()
                break
            case 4:
                print("Programa encerrado.")
                exit(0)
            default:
                print("Opção inválida.")
            }
        }
    }
    
    func encodeAndSave() {
            let encoder = JSONEncoder()
            encoder.outputFormatting = .prettyPrinted
            
            do {
                let data = try encoder.encode(pessoa)
                try data.write(to: ViewModel.jsonURL)
            } catch {
                print("Não foi possível salvar os dados.")
            }
        }
    }
let viewModel = ViewModel()
viewModel.decodar()
    
    while true{
        viewModel.menu()
        viewModel.encodeAndSave()
    }


