document.addEventListener('turbolinks:load', function () {
  // Show the HTML tab on page load if no tabs are active. We can't hardcode
  // an active tab in CE as it will break the active tab in Pro set by Word.
  if (
    document.querySelector('body.export.index') &&
    !document.querySelectorAll('[data-bs-toggle~=tab].active').length
  ) {
    const htmlTab = document.querySelector(
      '[data-bs-toggle~=tab][href="#plugin-html_export"]'
    );
    new bootstrap.Tab(htmlTab);
    bootstrap.Tab.getInstance(htmlTab).show();
  }
});
