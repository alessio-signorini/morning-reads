# Morning Reads

A Ruby application that scrapes TLDR articles, creates an EPUB file, and emails it daily.

## Setup

1. Install Ruby 3.2.2
2. Install dependencies:
   ```
   bundle install
   ```
3. Copy `.env.example` to `.env` and fill in your Gmail credentials
4. Set up the cron job:
   ```
   whenever --update-crontab
   ```

## Usage

### As a Web Service

Run the Sinatra app:
```
bundle exec rackup
```

The service will be available at http://localhost:9292

### As a Command Line Tool

Generate and send morning reads manually:
```
bundle exec rake morning_reads:generate
```

## Features

- Scrapes TLDR articles from tech, AI, and infosec categories
- Generates a beautifully formatted EPUB file
- Automatically emails the EPUB file every weekday at 5:00 AM PT
- Can be run as both a web service and command line tool

## Deployment

The app is configured for deployment on Fly.io. Follow their documentation for Ruby deployment.
