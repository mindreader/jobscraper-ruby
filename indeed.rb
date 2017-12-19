class Indeed
  @@listurl = 'https://www.indeed.com/jobs?q=developer&l=Louisville%2C+KY'
  @@baseurl = 'https://www.indeed.com/'
  Foo   = :indeed
  attr_accessor :pagenum

  def initialize()
    @jobs = {}
    @pagenum = 0
  end

  def jobs(howmany)
    loops = 0

    loop do
      break if @jobs.length >= howmany or loops > 15

      url = @@listurl + (@pagenum > 0 ? "&start=#{@pagenum}" : "")
      parsed_page = Nokogiri::HTML(HTTParty.get(url))

      unsponsored = parsed_page.css('div > h2 > a.turnstileLink').to_a
      sponsored = parsed_page.css('div > a.jobtitle').to_a

      unsponsored.map do |elem|
        company = (elem.parent.parent.css('span.company').text.strip)
        Job.new(elem.attr('title'), company, @@baseurl + elem.attr('href'))
      end.concat(sponsored.map do |elem|
        company = elem.parent.css('span > a').text.lines.map do |e| e.strip end.select do |e| e != "" end.first
        Job.new(elem.attr('title'), company, elem.attr('href'), sponsored: true)
      end).each do |job|
        @jobs[[job.title, job.company]] = job
      end

      loops += 1
      nextpage
    end

    @jobs.values
  end

#  def self.jobbody(url)
#    page = HTTParty.get(@@baseurl + url)
#    Nokogiri::HTML(page)
#  end

  def nextpage()
    @pagenum += 1
  end

  def setpage(num)
    @pagenum = num
    return self
  end
end


