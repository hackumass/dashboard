class UserMailer < ApplicationMailer

  default from: "#{HackumassWeb::Application::NOREPLY_EMAIL}"

  def welcome_email(user)
    @user = user;
    mail(to: @user.email, subject: "Thank you for signing up for #{HackumassWeb::Application::HACKATHON_NAME} #{HackumassWeb::Application::HACKATHON_VERSION}!")
  end

  def submit_email(user)
    @user = user;
    mail(to: @user.email, subject: "Thank you for submitting your #{HackumassWeb::Application::HACKATHON_NAME} #{HackumassWeb::Application::HACKATHON_VERSION} application!")
  end

  def accepted_email(user)
    @user = user;
    mail(to: @user.email, subject: "Congratulations! Welcome to #{HackumassWeb::Application::HACKATHON_NAME}!")
  end

  def denied_email(user)
    @user = user;
    mail(to: @user.email, subject: "#{HackumassWeb::Application::HACKATHON_NAME} #{HackumassWeb::Application::HACKATHON_VERSION} Application Status Update")
  end

  def waitlisted_email(user)
    @user = user;
    mail(to: @user.email, subject: "#{HackumassWeb::Application::HACKATHON_NAME} #{HackumassWeb::Application::HACKATHON_VERSION} Application Status Update")
  end

  def reminder_email(user, subject, message)
    @user = user
    @message = message
    @subject = subject
    mail(to: @user.email, subject: @subject)
  end

  def template_email(user, subject)
    @user = user
    @subject = subject
    mail(to: @user.email, subject: @subject)
  end

end
