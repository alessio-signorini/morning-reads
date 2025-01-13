# Morning Reads Project

A Ruby application that scrapes TLDR Tech articles and generates a daily digest in EPUB format, which can be either emailed or saved locally. The application provides both a CLI interface and a web API.

## Features

- Scrapes articles from TLDR Tech (tech, ai, infosec categories)
- Generates EPUB files with proper formatting and metadata
- Sends formatted HTML emails with article summaries
- Provides both CLI and API interfaces
- Supports custom dates and email addresses
- Clean progress indicators and error handling

## Project Structure

```
morning-reads/
├── app.rb                  # Sinatra web API
├── bin/
│   └── morning-reads       # CLI executable
├── lib/
│   ├── scrapers/
│   │   └── tldr_scraper.rb # TLDR website scraper
│   ├── epub_builder.rb     # EPUB file generator
│   └── email_sender.rb     # Email service
├── tmp/                    # Generated EPUB files
└── .env                    # Environment variables
```

## Dependencies

Add these to your Gemfile:

```ruby
source 'https://rubygems.org'

gem 'nokogiri'      # HTML parsing
gem 'httparty'      # HTTP requests
gem 'gepub'         # EPUB generation
gem 'mail'          # Email sending
gem 'sinatra'       # Web API
gem 'dotenv'        # Environment variables
gem 'optparse'      # CLI argument parsing
```

## Environment Variables

Create a `.env` file with:

```shell
GMAIL_USERNAME=your.email@gmail.com
GMAIL_APP_PASSWORD=your-app-specific-password
```

Note: Use an App Password from Google Account settings, not your regular password.

## Implementation Steps

### 1. TLDR Scraper

Create `lib/scrapers/tldr_scraper.rb`:
- Implement scraping for tech, ai, and infosec categories
- Clean and format article text
- Handle network errors and invalid responses
- Return articles with title, content, category, and source URL

### 2. EPUB Builder

Create `lib/epub_builder.rb`:
- Generate EPUB with proper metadata (UUID, title, date)
- Create cover page and table of contents
- Organize articles by category
- Add CSS styling for better readability
- Make article titles clickable
- Handle special characters and XML entities

### 3. Email Sender

Create `lib/email_sender.rb`:
- Configure SMTP for Gmail
- Create HTML and plain text email versions
- Format articles in email body
- Handle email sending errors
- Support custom recipient addresses

### 4. CLI Interface

Create `bin/morning-reads`:
- Parse command line arguments:
  - `--date DATE` (YYYY-MM-DD)
  - `--skip-email` (save locally)
  - `--output-dir DIR` (custom save location)
  - `--email EMAIL` (custom recipient)
- Show progress indicators
- Handle errors gracefully
- Display help and examples

### 5. Web API

Create `app.rb`:
- Implement GET /generate endpoint
- Support date and email parameters
- Return JSON responses
- Include article statistics
- Handle errors with proper status codes

## Usage Examples

### CLI

```bash
# Generate and email today's digest
morning-reads

# Generate digest for specific date
morning-reads --date 2025-01-10

# Save locally without sending
morning-reads --skip-email

# Save to custom directory
morning-reads --output-dir ~/Downloads

# Send to specific email
morning-reads --email user@email.com
```

### API

```bash
# Get today's digest
curl "http://localhost:3000/generate"

# Get digest for specific date
curl "http://localhost:3000/generate?date=2025-01-10"

# Send to specific email
curl "http://localhost:3000/generate?email=user@email.com"
```

## Error Handling

The application handles various error cases:
- Invalid dates
- Network failures
- Email sending issues
- File system errors
- XML/HTML parsing errors

## Output Format

### EPUB Structure
- Cover page with date
- Table of contents by category
- Articles organized by category
- Clickable article titles
- Clean typography and styling

### Email Format
- HTML version with styling
- Plain text fallback
- Articles organized by category
- Clickable links
- EPUB attachment

## Development Notes

1. Test the scraper with different dates to ensure consistent parsing
2. Verify EPUB compatibility with various readers
3. Test email formatting in different clients
4. Handle special characters and encoding properly
5. Ensure proper error messages for all failure cases

## Future Improvements

1. Add more news sources
2. Implement article caching
3. Add user preferences (categories, formatting)
4. Support more output formats
5. Add rate limiting and monitoring
