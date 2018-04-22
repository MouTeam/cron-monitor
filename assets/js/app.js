require('bootstrap')

console.log('hello world')

$(document).ready(function () {
  $('[data-toggle="popover"]').popover();
  $('[data-toggle="tooltip"]').tooltip()
});
