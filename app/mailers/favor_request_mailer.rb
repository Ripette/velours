class FavorRequestMailer < ApplicationMailer
  def new_favor_request(favor_request)
    @favor_request = favor_request
    mail(to: @favor_request.receiver.email, subject: 'Nouvelle demande de faveur reçue !')
  end
end
