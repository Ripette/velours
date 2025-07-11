class ApplicationController < ActionController::Base
  before_action :authenticate_user!

  # Méthode pour envoyer une notification OneSignal
  def send_notification(title, message, url = nil)
    require 'net/http'
    require 'json'

    # Configuration OneSignal
    app_id = "12a609ee-318e-4423-8e34-062dc14bb6e9"
    rest_api_key = Rails.application.credentials.onesignal[:rest_api_key]

    # Préparer la requête
    uri = URI("https://onesignal.com/api/v1/notifications")
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true

    # Headers
    headers = {
      'Content-Type' => 'application/json',
      'Authorization' => "Basic #{rest_api_key}"
    }

    # Body de la notification
    notification_data = {
      app_id: app_id,
      included_segments: ["All"],
      headings: { en: title },
      contents: { en: message },
      url: url,
      chrome_web_icon: "https://velours-app.herokuapp.com/assets/velours_logo-1234567890.png"
    }

    # Envoyer la requête
    request = Net::HTTP::Post.new(uri, headers)
    request.body = notification_data.to_json

    response = http.request(request)

    if response.code == "200"
      Rails.logger.info "Notification OneSignal envoyée avec succès"
      return true
    else
      Rails.logger.error "Erreur OneSignal: #{response.code} - #{response.body}"
      return false
    end
  rescue => e
    Rails.logger.error "Erreur lors de l'envoi de notification: #{e.message}"
    return false
  end

  # Méthode pour tester l'envoi de notifications
  def test_notification
    if send_notification(
      "Test Velours",
      "Ceci est un test de notification ! 🎉",
      root_url
    )
      render json: { success: true, message: "Notification de test envoyée" }
    else
      render json: { success: false, message: "Erreur lors de l'envoi" }, status: 500
    end
  end
end
