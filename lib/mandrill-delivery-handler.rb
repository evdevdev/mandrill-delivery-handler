class MandrillDeliveryHandler
  attr_accessor :settings

  def initialize(options = {})
    self.settings = {:track_opens => true,
                     :track_clicks => true,
                     :from_name => 'Mandrill Email Delivery Handler'}.merge(options)
  end

  def deliver!(message)

    message_payload = {
      :track_opens => settings[:track_opens],
      :track_clicks => settings[:track_clicks],
      :message => {
        :subject => message.subject,
        :from_name => settings[:from_name],
        :from_email => message.from.first,
        :to => message.to
      }
    }

    [:html, :text].each do |format|
      content = get_content_for(message, format)
      message_payload[:message][format] = content if content
    end

    message_payload[:tags] = settings[:tags] if settings[:tags]

    api_key = message.header['api-key'].blank? ? settings[:api_key] : message.header['api-key']

    # Mailchimp::Mandrill.new(api_key).messages_send(message_payload)
    mandrill = Mandrill::API.new('api-key')

    mandrill.messages :send, message_payload
  end

  private

  def get_content_for(message, format)
    mime_types = {
      :html => "text/html",
      :text => "text/plain"
    }

    content = message.send(:"#{format.to_s}_part")
    content ||= message.body if message.mime_type == mime_types[format]
    content
  end

end

if defined?(ActionMailer)
  ActionMailer::Base.add_delivery_method(:mandrill, MandrillDeliveryHandler)
end

