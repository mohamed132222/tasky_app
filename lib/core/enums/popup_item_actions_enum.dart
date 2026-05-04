enum PopupItemActionsEnum {
  isMarkDone(name: "IsMarkDone"),
  edit(name: "Edit"),
  delete(name: "Delete");

  final String name;

  const PopupItemActionsEnum({required this.name});
}
