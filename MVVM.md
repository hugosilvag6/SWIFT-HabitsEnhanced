# MVVM

## < Model

- É o modelo de dados que vai ser transposto para a viewModel
- O viewmodel pode pedir ações para o model, que pede para o localStorage ou DB por exemplo, e expões para a viewModel, que por sua vez, ao mudar, muda a view, já que é observada por ela.

## < View

- É responsável por desenhar elementos na tela;
- Toda view possui elementos de view (some View):

```
struct SplashView: View {
    <elementos de view, ou seja, some view
    var body: some view {
        Text("oi")
    }
}
```

- O código aqui é estático, não está sendo executável. É dinâmico a partir do ponto que é influenciado e determinado pela viewModel
- Precisa de uma referência, precisa enxergar o viewModel:

```
struct SplashView: View {

    // a linha abaixo define essa "referência"
    @ObservedObject var viewModel: SplashViewModel
    
    var body: some View {
```
- É importante lembrar que ela observa todos os estados que tem @Published

## < ViewModel

- É basicamente uma classe (class) observada (observed);
- Os EVENTOS de ações, botões, onAppear, etc, acontecem na viewModel, ou seja, é a viewmodel que toma ações baseadas no que o usuário ou sistema operacional faz
- Ela mantém eventos de ação; 
- É responsável por formatar o que será exibido na tela, como por exemplo, traduzir um texto recebido do banco de dados
- Enquanto a view observa a viewModel, a viewModel é observada, então precisamos dizer que é observável:

```
// dizemos que essa classe é observável
class SplashViewModel: ObservableObject {
    
    // e essa é a variável observada. Quando muda, "avisa" a view que precisa fazer algo
    @Published var uiState: SplashUIState = .loading
```
