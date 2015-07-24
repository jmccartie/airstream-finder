class Parser

  def self.search(price, search)
    url = "http://www.airstreamclassifieds.com/airstream-trailer-search/Late-Model-Airstream-Trailers-For-Sale/year/1988-2014/ads_sort/new_first"
    wrapper = ".content_left .post-block-out"
    entries = []

    if ENV["RACK_ENV"] == "production"
      @doc = Nokogiri::HTML(open(url))
    else
      @doc = Nokogiri::HTML(File.open("./test/vcr.txt"))
    end

    @doc.css(wrapper).each do |node|
      price = node.css(".post-price").first.content.gsub("$", "").to_i
      title = node.css("h3").first.content.gsub("\n", "")

      if price <= price && title =~ /#{search}/
        entries << {
          price: price,
          title: title,
          link: node.css("h3 a").first["href"],
          description: node.css(".post-desc").first.content
        }
      end
    end

    entries
  end

end