class Mailer

  attr_accessor :entries

  def initialize(entries)
    @entries = entries
  end

  def deliver
    if ENV["RACK_ENV"] == "production"
      mail = Mail.new do
        to ENV['MAIL_TO']
        from ENV['MAIL_FROM']
        subject 'New Airstreams Found'

        text_part do
          body 'This is plain text'
        end
      end

      mail.body = self.body_content
      mail.deliver
    else
      puts self.body_content
    end
  end

  def body_content
    str = ""
    entries.each do |entry|
      str << "<div>"
        str << "<h3>#{entry[:title]} - $#{entry[:price]},000</h3>"
        str << "<p>" + entry[:description] + "</p>"
        str << "<br />" + entry[:link]
        str << "\n\n\n"
      str << "</div>"
    end
    str
  end

end
