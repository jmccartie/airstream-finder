class Mailer

  attr_accessor :entries

  def initialize(entries)
    @entries = entries
  end

  def deliver
    content = self.body_content

    mail = Mail.deliver do
      to ENV['MAIL_TO']
      from ENV['MAIL_FROM']
      subject 'New Airstreams Found'

      html_part do
        content_type 'text/html; charset=UTF-8'
        body content
      end
    end
  end

  def body_content
    str = ""
    entries.each do |entry|
      str << "<div>"
        str << "<h3>#{entry[:title]} - $#{entry[:price]},000</h3>"
        str << "<p>" + entry[:description] + "</p>"
        str << "<a href='#{entry[:link]}'>#{entry[:link]}</a>"
      str << "</div>"
    end
    str
  end

end
