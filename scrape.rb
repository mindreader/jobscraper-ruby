require 'httparty'
require 'nokogiri'
require 'pry'
require 'tty-prompt'

require_relative 'indeed'
require_relative 'stackoverflow'

class Job
  @@firefox = "firefox-bin"

  attr_reader :title, :link, :company, :sponsored
  def initialize(title, company, link, sponsored: false)
    @title = title
    @company = company
    @link = link
    @sponsored = sponsored
  end

  def open()
    link = Shellwords.escape(@link)
    system "#{@@firefox} #{link}"
  end
end

class Interactive
  @@prompt = TTY::Prompt.new
  @@indeed = Indeed.new

  @@modules = [Stackoverflow, Indeed]

  def self.main()
    loop do
      res = @@prompt.select("Which site?", default: 2) do |menu|
        menu.choice('QUIT', :quit)

        @@modules.each do |mod|
          menu.choice(mod, mod)
        end
      end

      case res
      when :quit
        puts "Quitting!"
        Kernel.exit(false)
      else Interactive::ask(name: res, count: 30)
      end
    end
  end

  def self.ask(name:, count:)
    numindeeds = @@prompt.ask("How many jobs from #{name}?") do |q|
      q.required true
      q.default count
    end.to_i

    default_idx = 1

    loop do
      jobs = @@indeed.jobs(numindeeds)

      # this shouldn't be necessary but I had problems without it.
      height = (`stty size`).split(' ')[0].to_i

      res = @@prompt.select("Which of these?", default: default_idx, per_page: height - 3) do |menu|
        menu.choice('BACK', :back)
        menu.choice('QUIT', :quit)
        i = 3
        jobs.each do |job|
          menu.choice(job.title + " at " + job.company + (job.sponsored ? '(sponsored)' : ''), {:job => job, :idx => i})
          i += 1
        end
      end

      case res

      when :quit
        Kernel.exit(false)

      when :back
        return

      else
        default_idx = res[:idx]
        res[:job].open
      end
    end

  end
end

# Pry.start(binding)
Interactive.main
