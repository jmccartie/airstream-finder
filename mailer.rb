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
      end

      mail.text_part = self.body_content
      mail.deliver
    else
      puts self.body_content
    end
  end

  def body_content
    str = ""
    entries.each do |entry|
      str << "#{entry[:title]} - $#{entry[:price]},000\n"
      str << "----------------\n"
      str << entry[:description] + "\n"
      str << entry[:link]
      str << "\n\n\n"
    end
    str
  end

end
