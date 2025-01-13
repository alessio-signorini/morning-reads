require 'gepub'
require 'fileutils'
require 'securerandom'
require 'nokogiri'
require 'pathname'

class EPUBBuilder
  def build(articles, date, output_dir = 'tmp')
    puts "  - Creating EPUB structure..."
    
    book = GEPUB::Book.new
    book.primary_identifier("urn:uuid:#{SecureRandom.uuid}")
    book.language = 'en'
    
    # Add metadata
    book.add_title("Morning Reads - #{date}", title_type: GEPUB::TITLE_TYPE::MAIN)
    book.add_creator("Morning Reads App")
    book.add_date(Time.now.iso8601)
    book.add_contributor("Morning Reads App")
    
    # Add CSS
    book.add_item('style.css', content: StringIO.new(stylesheet))
    
    # Add cover page
    book.add_item('cover.xhtml', content: StringIO.new(cover_page(date))).add_property('nav')
    
    # Add table of contents
    nav_content = table_of_contents(articles, date)
    book.add_ordered_item('nav.xhtml', content: StringIO.new(nav_content), id: 'nav').add_property('nav')
    
    # Add articles by category
    articles.group_by { |a| a[:category] }.each do |category, category_articles|
      print "  - Adding #{category} section... "
      
      category_content = generate_category_page(category, category_articles, date)
      book.add_ordered_item("#{category}.xhtml", 
                          content: StringIO.new(category_content),
                          toc_text: category.upcase)
      
      puts "#{category_articles.length} articles added"
    end
    
    output_path = File.join(output_dir, "morning-reads-#{date}.epub")
    FileUtils.mkdir_p(output_dir)
    
    print "  - Generating final EPUB file... "
    book.generate_epub(output_path)
    puts "done"
    
    output_path
  end
  
  private
  
  def stylesheet
    <<~CSS
      body {
        margin: 2em;
        font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, sans-serif;
        line-height: 1.5;
      }
      h1, h2, h3 {
        color: #333;
        margin-top: 1.5em;
      }
      .article {
        margin-bottom: 2em;
        padding-bottom: 1em;
        border-bottom: 1px solid #eee;
      }
      .article h3 a {
        color: #0366d6;
        text-decoration: none;
      }
      .article h3 a:hover {
        text-decoration: underline;
      }
      .content {
        margin-top: 1em;
      }
      .toc {
        margin: 2em 0;
      }
      .toc a {
        color: #0366d6;
        text-decoration: none;
      }
    CSS
  end
  
  def create_xml_doc
    builder = Nokogiri::XML::Builder.new(encoding: 'UTF-8') do |xml|
      xml.doc.create_internal_subset(
        'html',
        "-//W3C//DTD XHTML 1.1//EN",
        "http://www.w3.org/TR/xhtml11/DTD/xhtml11.dtd"
      )
    end
    builder
  end
  
  def cover_page(date)
    builder = create_xml_doc
    builder.html(xmlns: "http://www.w3.org/1999/xhtml", "xmlns:epub": "http://www.idpf.org/2007/ops") do |html|
      html.head do |head|
        head.title "Morning Reads - #{date}"
        head.link(rel: 'stylesheet', type: 'text/css', href: 'style.css')
      end
      html.body do |body|
        body.h1 "Morning Reads"
        body.h2 date
        body.p "Your daily tech digest from TLDR"
      end
    end
    builder.to_xml
  end
  
  def table_of_contents(articles, date)
    builder = create_xml_doc
    builder.html(xmlns: "http://www.w3.org/1999/xhtml", "xmlns:epub": "http://www.idpf.org/2007/ops") do |html|
      html.head do |head|
        head.title "Table of Contents"
        head.link(rel: 'stylesheet', type: 'text/css', href: 'style.css')
      end
      html.body do |body|
        body.h1 "Table of Contents"
        body.nav("epub:type": "toc", class: "toc") do |nav|
          nav.ol do |ol|
            articles.group_by { |a| a[:category] }.each do |category, _|
              ol.li do |li|
                li.a(href: "#{category}.xhtml") { |a| a.text category.upcase }
              end
            end
          end
        end
      end
    end
    builder.to_xml
  end
  
  def generate_category_page(category, articles, date)
    builder = create_xml_doc
    builder.html(xmlns: "http://www.w3.org/1999/xhtml", "xmlns:epub": "http://www.idpf.org/2007/ops") do |html|
      html.head do |head|
        head.title "#{category.upcase} - #{date}"
        head.link(rel: 'stylesheet', type: 'text/css', href: 'style.css')
      end
      html.body do |body|
        body.h1 category.upcase
        articles.each do |article|
          body.div(class: "article") do |div|
            div.h3 do |h3|
              h3.a(href: article[:url]) { |a| a.text article[:title] }
            end
            div.div(class: "content") { |d| d.text article[:content] }
          end
        end
      end
    end
    builder.to_xml
  end
end
