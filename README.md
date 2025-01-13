# Morning Reads 📚

A Ruby application that generates a daily digest of TLDR Tech articles in both EPUB and email formats. Articles are scraped from [tldr.tech](https://tldr.tech) across tech, AI, and infosec categories.

## Features ✨

- 📱 Scrapes articles from TLDR Tech (tech, ai, infosec categories)
- 📖 Generates beautifully formatted EPUB files
- 📧 Sends HTML emails with article summaries
- 🖥️ Provides both CLI and API interfaces
- 📅 Supports custom dates for historical digests
- 📬 Configurable email recipients

## Installation 🛠️

1. Clone the repository:
```bash
git clone https://github.com/yourusername/morning-reads.git
cd morning-reads
```

2. Install dependencies:
```bash
bundle install
```

3. Set up environment variables:

For development and testing, create a `.env` file:
```bash
GMAIL_USERNAME=your.email@gmail.com
GMAIL_APP_PASSWORD=your-app-specific-password
```

For production, set these environment variables directly in your deployment platform.

Note: You'll need to create an App Password in your Google Account settings. Never use your regular Gmail password.

## Usage 🚀

### Command Line Interface

Generate and email today's digest:
```bash
./bin/morning-reads
```

Available options:
```bash
Options:
  -d, --date DATE      Date to fetch articles for (YYYY-MM-DD)
  -s, --skip-email     Skip sending email and save EPUB locally
  -o, --output-dir DIR Directory to save the EPUB file
  -e, --email EMAIL    Email address to send to
  -h, --help          Show this help message
```

Examples:
```bash
# Generate digest for specific date
./bin/morning-reads --date 2025-01-10

# Save locally without sending email
./bin/morning-reads --skip-email

# Save to Downloads folder
./bin/morning-reads --output-dir ~/Downloads

# Send to specific email
./bin/morning-reads --email user@email.com
```

### Web API

Start the server:
```bash
rake server
```

The server will be available at `http://localhost:3000` or `http://127.0.0.1:3000`.

Generate and send digest:
```bash
# Today's digest
curl "http://localhost:3000/generate"

# Specific date
curl "http://localhost:3000/generate?date=2025-01-10"

# Custom email
curl "http://localhost:3000/generate?email=user@email.com"
```

## Output Format 📱

### EPUB Structure
- Cover page with date
- Table of contents by category
- Articles organized by category
- Clickable titles linking to source
- Clean, modern styling

### Email Format
- HTML version with styling
- Plain text fallback
- Articles organized by category
- Clickable links
- EPUB attachment

## Development 🔧

The application uses different configurations based on the environment:

- **Development/Test**: Uses `.env` file for configuration
- **Production**: Uses system environment variables

Set the environment using `RACK_ENV`:
```bash
RACK_ENV=development # Uses .env file
RACK_ENV=production  # Uses system environment variables
```

## Error Handling ⚠️

The application handles various error cases:
- Invalid dates
- Network failures
- Email sending issues
- File system errors
- XML/HTML parsing errors

## Contributing 🤝

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## License 📄

This project is licensed under the MIT License - see the LICENSE file for details.

## Acknowledgments 🙏

- [TLDR Tech](https://tldr.tech) for providing the source content
- [GEPUB](https://github.com/skoji/gepub) for EPUB generation
- [Nokogiri](https://nokogiri.org/) for HTML parsing
- [Mail](https://github.com/mikel/mail) for email handling
- [Sinatra](http://sinatrarb.com/) for the web API
