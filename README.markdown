# mailchimp

This a very simple ActionMailer delivery handler for sending messages through MailChimp's Mandrill. It is a partial fork (the now disappeared) https://github.com/mailchimp/mailchimp-gem/

At the core, it uses https://github.com/tatemae-consultancy/mandrill.

##Usage

Tell ActionMailer to send mail using Mandrill by adding the follow to to your config/application.rb or to the proper environment (eg. config/production.rb) :

    config.action_mailer.delivery_method = :mandrill
    config.action_mailer.mandrill_settings = {
          :api_key => "your_mailchimp_mandrill_apikey",
          :track_clicks => true,
          :track_opens  => true,
          :from_name    => "Change Me"
     }

These setting will allow you to use ActionMailer as you normally would, any calls to mail() will be sent using Mandrill

If your application will specify the API Key on a per email basis, you can configure your application like so:

    config.action_mailer.delivery_method = :mailchimp_mandrill
    config.action_mailer.mailchimp_mandrill_settings = {
          :track_clicks => true,
          :track_opens  => true,
          :from_name    => "Change Me"
    }

Once this is specified, be sure to include the api_key in ActionMailer.mail()'s options:

    class ExampleMailer < ActionMailer::Base
      default from: "no-reply@example.com"

      def test_email(object_with_api_key)

        mail(to: object_with_api_key.email,
             subject: "This is an example Mandrill Email",
             api_key: object_with_api_key.api_key)
      end
    end

And the Mandrill Delivery Hander will read the api key from the email message object, instead of the application configuration