require 'mail'
require 'dotenv/load' if ENV['RACK_ENV'] != 'production'

class EmailSender
  def initialize
    Mail.defaults do
      delivery_method :smtp, {
        address: 'smtp.gmail.com',
        port: 587,
        user_name: ENV['GMAIL_USERNAME'],
        password: ENV['GMAIL_APP_PASSWORD'],
        authentication: :plain,
        enable_starttls_auto: true
      }
    end
  end

  def send_epub(epub_path, date, to_email, articles = [])
    print "  - Sending email with EPUB attachment... "
    
    html_body = generate_html_body(date, articles)
    text_body = generate_text_body(date, articles)
    
    mail = Mail.new do
      from    ENV['GMAIL_USERNAME']
      to      to_email
      subject "Morning Reads - #{date}"
      charset = 'UTF-8'
      
      text_part do
        content_type 'text/plain; charset=UTF-8'
        body text_body
      end
      
      html_part do
        content_type 'text/html; charset=UTF-8'
        body html_body
      end
      
      add_file epub_path
    end

    mail.deliver!
    puts "done"
  rescue => e
    puts "\n⚠️  Error sending email: #{e.message}"
  end

  private

  def generate_html_body(date, articles)
    <<~HTML
      <html>
        <head>
          <meta charset="UTF-8">
          <style>
            body {
              font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, sans-serif;
              line-height: 1.5;
              color: #333;
              max-width: 800px;
              margin: 0 auto;
              padding: 20px;
            }
            h1 { color: #2c3e50; margin-bottom: 30px; }
            h2 { color: #34495e; margin-top: 30px; text-transform: uppercase; }
            h3 { margin-bottom: 5px; }
            .article {
              margin-bottom: 25px;
              padding-bottom: 20px;
              border-bottom: 1px solid #eee;
            }
            .article:last-child { border-bottom: none; }
            a { color: #3498db; text-decoration: none; }
            a:hover { text-decoration: underline; }
            .content { margin-top: 10px; }
          </style>
        </head>
        <body>
          <h1>Morning Reads for #{date}</h1>
          
          #{articles.group_by { |a| a[:category] }.map { |category, category_articles|
            <<~CATEGORY
              <h2>#{category.upcase}</h2>
              #{category_articles.map { |article|
                <<~ARTICLE
                  <div class="article">
                    <h3><a href="#{article[:url]}">#{article[:title]}</a></h3>
                    <div class="content">#{article[:content]}</div>
                  </div>
                ARTICLE
              }.join}
            CATEGORY
          }.join}
          
          <p style="margin-top: 30px; color: #666;">
            Your EPUB version is attached to this email for offline reading.
          </p>
        </body>
      </html>
    HTML
  end

  def generate_text_body(date, articles)
    text = ["Morning Reads for #{date}\n\n"]
    
    articles.group_by { |a| a[:category] }.each do |category, category_articles|
      text << "#{category.upcase}\n#{'=' * category.length}\n\n"
      
      category_articles.each do |article|
        text << "#{article[:title]}"
        text << "#{article[:url]}\n"
        text << "#{article[:content]}\n\n"
      end
    end
    
    text << "Your EPUB version is attached to this email for offline reading."
    text.join("\n")
  end
end
