function notify(title, content) {
  notification = $('#notification');
  notification.data("toggle", "popover");
  notification.data("placement", "top");
  notification.data("title", title);
  notification.data("content", content);
  notification.popover('show');
}
