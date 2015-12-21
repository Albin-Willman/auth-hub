class UserMailer < ActionMailer::Base
  
  default from: 'salbin.reminders@gmail.com'

  def activation_email(user)
    @link = ActivationLinkBuilder.new(root_url, user)

    mail(to: user.email, subject: 'Activation link')
  end
end
