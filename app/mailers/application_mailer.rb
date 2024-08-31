class ApplicationMailer < ActionMailer::Base
  default from: "#{HackumassWeb::Application::DONOTREPLY_EMAIL}"
  layout 'mailer'
end
