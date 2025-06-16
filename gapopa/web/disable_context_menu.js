// This script disables the default context menu in web browsers
// Add this to the index.html file in the web directory

document.addEventListener('contextmenu', function(event) {
  event.preventDefault();
  return false;
}, true);
