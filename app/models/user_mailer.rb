class UserMailer < ActionMailer::Base
  def signup_notification(user)
    setup_email(user)
    @subject    += 'Please activate your new account'
    @body[:url]  = "http://#{APP_CONFIG[:domain]}/activate/#{user.activation_code}"
  
  end
  
  def activation(user)
    setup_email(user)
    @subject    += 'Your account has been activated!'
    @body[:url]  = "http://#{APP_CONFIG[:domain]}/"
  end
  
  def unsubscribe_request(user)
    setup_email(user)
    @subject    += 'You have requested to unsubscribe'
  end
  
  protected
    def setup_email(user)
      @recipients  = "#{user.email}"
      @from        = "contacto@#{APP_CONFIG[:domain]}"
      @subject     = "[Winnamoney] "
      @sent_on     = Time.now
      @body[:user] = user
    end
end
