# using SendGrid's Ruby Library
# https://github.com/sendgrid/sendgrid-ruby
require 'sendgrid-ruby'
include SendGrid



def send_email(to, body)
  from = Email.new(email: 'bovada.rb@bt-bets.com')
  to = Email.new(email: to)
  subject = 'New Bets!'
  content = Content.new(type: 'text/html', value: body)
  mail = Mail.new(from, subject, to, content)
  
  sg = SendGrid::API.new(api_key: "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")
  response = sg.client.mail._('send').post(request_body: mail.to_json)
  puts response.status_code
  puts response.body
  puts response.headers
end