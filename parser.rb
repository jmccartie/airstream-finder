class Parser

  def self.search(min_price, max_price, search)
    url = "http://www.airstreamclassifieds.com/ad-category/airstream-trailers-for-sale/ads_sort/new_first/"
    wrapper = ".content_left .post-block-out"
    entries = []
    list = Parser.get_list()

    if ENV["RACK_ENV"] == "production"
      @doc = Nokogiri::HTML(open(url))
    else
      @doc = Nokogiri::HTML(File.open("./test/vcr.txt"))
    end

    @doc.css(wrapper).each do |node|
      price = node.css(".post-price").first.content.gsub("$", "").to_i
      title = node.css("h3").first.content.gsub("\n", "")

      if (min_price..max_price).to_a.include?(price) && title =~ /#{search}/
        url = node.css("h3 a").first["href"]
        next if list.include?(url)
        entries << {
          price: price,
          title: title,
          link: node.css("h3 a").first["href"],
          description: node.css(".post-desc").first.content
        }
        list << url
      end
    end

    Parser.set_list(list)
    entries
  end

  def self.get_list
    JSON.parse(REDIS.get("urls") || "[]")
  end

  def self.set_list(arr)
    arr.uniq!
    REDIS.set("urls", arr)
  end

end