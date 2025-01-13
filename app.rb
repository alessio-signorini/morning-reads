require 'sinatra'
require 'date'
require 'json'
require_relative 'lib/scrapers/tldr_scraper'
require_relative 'lib/epub_builder'
require_relative 'lib/email_sender'

class MorningReadsApp < Sinatra::Base
  set :port, ENV['PORT'] || 3000
  set :bind, '0.0.0.0'

  get '/' do
    'Morning Reads API is running!'
  end

  get '/generate' do
    content_type :json
    
    date = params[:date] ? Date.parse(params[:date]) : Date.today
    date_str = date.strftime('%Y-%m-%d')
    email = params[:email] || 'alessio1@pbsync.com'
    
    begin
      # Scrape articles
      scraper = TLDRScraper.new
      articles = scraper.scrape_all(date_str)
      
      if articles.empty?
        return { error: "No articles found for #{date_str}" }.to_json
      end
      
      # Generate EPUB
      epub_builder = EPUBBuilder.new
      epub_file = epub_builder.build(articles, date_str, 'tmp')
      
      # Send email
      email_sender = EmailSender.new
      email_sender.send_epub(epub_file, date_str, email, articles)
      
      {
        success: true,
        message: "Morning reads for #{date_str} sent to #{email}",
        stats: {
          date: date_str,
          articles_count: articles.length,
          categories: articles.group_by { |a| a[:category] }.transform_values(&:count)
        }
      }.to_json
    rescue Date::Error
      status 400
      { error: "Invalid date format. Please use YYYY-MM-DD" }.to_json
    rescue => e
      status 500
      { error: e.message }.to_json
    end
  end
end
