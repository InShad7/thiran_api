class GithubState {
  final List<dynamic> github;
  final int currentPage;
  final bool endOfPage;
  final bool isThirty;

  GithubState({
    required this.github,
    required this.currentPage,
    required this.endOfPage,
    required this.isThirty,
  });

  GithubState copyWith({
    List<dynamic>? github,
    int? currentPage,
    bool? endOfPage,
    bool? isThirty,
  }) {
    return GithubState(
      github: github ?? this.github,
      currentPage: currentPage ?? this.currentPage,
      endOfPage: endOfPage ?? this.endOfPage,
      isThirty: isThirty ?? this.isThirty,
    );
  }
}