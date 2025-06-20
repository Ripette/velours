class ApplicationMailer < ActionMailer::Base
  default from: 'no-reply@velours.app'
  layout 'mailer'
end
