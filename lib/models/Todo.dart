class Todo {
  String titulo;
  String descricao;
  String status;

  Todo();

  Todo.fromTituloDescricao(String titulo, String descricao) {
    this.titulo = titulo;
    this.descricao = descricao;
    this.status = "A";
  }

  //Para converter para json
  Todo.fromJson(Map<String, dynamic> json)
      : titulo = json['titulo'],
        descricao = json['descricao'],
        status = json['status'];

  Map toJson() => {
        'titulo': titulo,
        'descricao': descricao,
        'status': status,
      };
}
