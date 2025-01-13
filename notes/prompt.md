# Morning Reads Project Prompt

Create a Ruby application that scrapes articles from TLDR Tech (tldr.tech) and generates a daily digest in both EPUB format and email format. The application should have both a CLI interface and a web API.

## Core Requirements

1. Scrape articles from tldr.tech for these categories:
   - tech
   - ai
   - infosec

2. Generate an EPUB file that:
   - Has proper metadata (title, date, creator)
   - Includes a cover page
   - Has a table of contents organized by category
   - Makes article titles clickable links to source
   - Uses clean, modern styling
   - Handles special characters properly

3. Send an email that:
   - Has both HTML and plain text versions
   - Shows articles organized by category
   - Makes titles clickable
   - Includes the EPUB as an attachment
   - Uses Gmail SMTP with environment variables for credentials

4. Provide a CLI interface with these options:
   - --date DATE: Generate for specific date (YYYY-MM-DD)
   - --skip-email: Save EPUB locally without sending
   - --output-dir DIR: Specify save location
   - --email EMAIL: Send to specific email
   - --help: Show usage examples

5. Provide a web API that:
   - Has a GET /generate endpoint
   - Accepts date and email parameters
   - Returns JSON with article statistics
   - Handles errors properly

## Implementation Requirements

1. Project Structure:
   ```
   morning-reads/
   ├── app.rb
   ├── bin/
   │   └── morning-reads
   ├── lib/
   │   ├── scrapers/
   │   │   └── tldr_scraper.rb
   │   ├── epub_builder.rb
   │   └── email_sender.rb
   ├── notes/
   │   └── prompt.md
   └── .env.example
   ```

2. Dependencies:
   ```ruby
   source 'https://rubygems.org'
   
   ruby '3.2.2'
   
   gem 'nokogiri'
   gem 'httparty'
   gem 'gepub'
   gem 'mail'
   gem 'rake'
   gem 'rackup'
   gem 'sinatra'
   gem 'puma'
   
   group :development, :test do
     gem 'dotenv'
   end
   ```

3. Environment Configuration:
   - Development/Test: Load configuration from .env file
   - Production: Use system environment variables
   - Set RACK_ENV appropriately for each environment

4. Progress Indicators:
   Show clean progress with emoji:
   ```
   📥 Scraping TLDR articles...
     ✓ Found 15 articles across tech, ai, infosec categories
   
   📚 Generating EPUB file...
     ✓ EPUB file generated at tmp/morning-reads-2025-01-10.epub
   
   📧 Sending email...
     ✓ Email sent successfully to user@email.com
   
   ✨ All done! Your morning reads have been generated and sent.
   ```

5. Error Handling:
   - Invalid dates
   - Network failures
   - Email sending issues
   - File system errors
   - XML parsing errors

## Code Style Requirements

1. Clean, modular code organization
2. Proper error handling with descriptive messages
3. Clear progress indicators
4. Consistent formatting
5. Good documentation
6. Environment-aware configuration

## Additional Notes

1. Environment Variables:
   ```bash
   # Development (.env file)
   GMAIL_USERNAME=your.email@gmail.com
   GMAIL_APP_PASSWORD=your-app-specific-password
   
   # Production (set in deployment platform)
   export GMAIL_USERNAME=your.email@gmail.com
   export GMAIL_APP_PASSWORD=your-app-specific-password
   ```

2. The EPUB should have this structure:
   - Cover page with date
   - Table of contents by category
   - Articles organized by category
   - Clickable titles linking to source

3. Both HTML email and EPUB should have clean, modern styling with:
   - Sans-serif fonts
   - Good spacing
   - Clear hierarchy
   - Readable text size
   - Proper margins

4. Progress messages should be:
   - Clear and concise
   - Show relative paths
   - Include emoji indicators
   - Show success/error clearly

Please implement this project following all the requirements above. The code should be production-ready, well-documented, and handle all error cases gracefully. Remember to properly handle environment-specific configurations.
