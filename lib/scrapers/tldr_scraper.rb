require 'httparty'
require 'nokogiri'
require 'cgi'

class TLDRScraper
  CATEGORIES = ['tech', 'ai', 'infosec']
  BASE_URL = 'https://tldr.tech'

  def scrape_all(date)
    articles = []
    CATEGORIES.each do |category|
      print "  - Scraping #{category} articles... "
      url = "#{BASE_URL}/#{category}/#{date}"
      category_articles = scrape_category(url, category)
      articles.concat(category_articles)
      puts "found #{category_articles.length} articles"
    end
    articles
  end

  private

  def scrape_category(url, category)
    response = HTTParty.get(url)
    return [] unless response.success?

    doc = Nokogiri::HTML(response.body)
    articles = []

    doc.css('article.mt-3').each do |article|
      title = clean_text(article.css('h3').text.strip)
      content = clean_text(article.css('.newsletter-html').text.strip)
      source_url = article.css('a.font-bold').first['href'].split('?').first # Remove UTM parameters

      articles << {
        title: title,
        content: content,
        category: category,
        url: source_url
      }
    end

    articles
  rescue => e
    puts "\n⚠️  Error scraping #{url}: #{e.message}"
    []
  end

  def clean_text(text)
    # Just decode HTML entities, Nokogiri will handle XML escaping
    CGI.unescapeHTML(text.strip)
  end
end
