class ApplicationMailer < ActionMailer::Base
  default from: 'confirm@brokebooks.herokuapp.com'
  layout 'mailer'
end
