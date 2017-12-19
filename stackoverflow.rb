class Stackoverflow
  @@listurl = 'https://stackoverflow.com/jobs?sort=i&q=(((%5Bhaskell%5D+or+%5Bscala%5D+or+%5Berlang%5D+or+%5Belixir%5D)+and+remote%3Atrue)+or+(%5Bphp%5D+and+remote%3Atrue+and+salary%3A75000)'
  @@baseurl = 'https://stackoverflow.com/job/'

  @@name = :stackoverflow
  def initialize()
    @jobs = {}
    @pagenum = 0  # TODO additional pages
  end

  def jobs(howmany)
    loops = 0

#    loop do
#      break if @jobs.length >= howmany or loops > 15

      url = @@listurl
      parsed_page = Nokogiri::HTML(HTTParty.get(url))

      jobs = parsed_page.css('div.listResults > div')
#      pp (jobs.length)

      # TODO There is more to do here, stackoverflow returns arbitrary results
      # when it can't find anymore that match your criteria.
 
#      jobs = parsed_page.css('div.listResults > div').to_a.take_while do |e|
#        e.attr('data-jobid')
#      end
#      pp jobs
#      unsponsored = parsed_page.css('a.job-link') # .attr('title').value
#      unsponsored.each do |e|
#        pp (unsponsored[0].parent.parent.parent.css('div.-name').text.lines.map do |e| e.strip end.select do |e| e != "" end.first)
#        Kernel.exit(1)
#      end
      # sponsored = parsed_page.css('div > a.jobtitle').to_a


#      unsponsored.map do |elem|
#        company = (elem.parent.parent.css('span.company').text.strip)
#        Job.new(elem.attr('title'), company, @@baseurl + elem.attr('href'))
#      end.concat(sponsored.map do |elem|
#        company = elem.parent.css('span > a').text.lines.map do |e| e.strip end.select do |e| e != "" end.first
#        Job.new(elem.attr('title'), company, elem.attr('href'), sponsored: true)
#      end).each do |job|
#        @jobs[[job.title, job.company]] = job
#      end
#
#      loops += 1
#      nextpage
#    end

    @jobs.values
  end

end


