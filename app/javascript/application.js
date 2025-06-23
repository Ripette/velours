// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import "@hotwired/turbo-rails"
import "controllers"

// Alternative simple pour gérer les liens DELETE sans UJS complet
document.addEventListener('turbo:load', () => {
  // Gérer les liens avec method delete
  document.querySelectorAll('a[data-turbo-method="delete"]').forEach(link => {
    link.addEventListener('click', (e) => {
      e.preventDefault();

      const form = document.createElement('form');
      form.method = 'POST';
      form.action = link.href;
      form.style.display = 'none';

      const methodInput = document.createElement('input');
      methodInput.type = 'hidden';
      methodInput.name = '_method';
      methodInput.value = 'delete';

      const tokenInput = document.createElement('input');
      tokenInput.type = 'hidden';
      tokenInput.name = 'authenticity_token';
      tokenInput.value = document.querySelector('meta[name="csrf-token"]').content;

      form.appendChild(methodInput);
      form.appendChild(tokenInput);
      document.body.appendChild(form);
      form.submit();
    });
  });
});
