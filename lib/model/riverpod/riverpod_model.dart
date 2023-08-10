class GithubState {
  final List<dynamic> github;
  final int currentPage;
  final bool endOfPage;
  final bool isThirty;
   final bool hasConnection;

  GithubState( {

    required this.github,
    required this.currentPage,
    required this.endOfPage,
    required this.isThirty,
    required this.hasConnection,
  });

  GithubState copyWith({
    List<dynamic>? github,
    int? currentPage,
    bool? endOfPage,
    bool? isThirty,
    bool? hasConnection,

  }) {
    return GithubState(
      github: github ?? this.github,
      currentPage: currentPage ?? this.currentPage,
      endOfPage: endOfPage ?? this.endOfPage,
      isThirty: isThirty ?? this.isThirty, 
      hasConnection: hasConnection ?? this.hasConnection,
    );
  }
}