# Assumptions
* The code is written in Ruby
* Framework is Sinatra
* It will be deployed on Fly.io
* It should be possible to run the code as command line application.
   * When doing so, the code should give feedback on the operation it is performing.
   * A flag can be used to disable email sending and save the file locally

# Code Architecture / Modules
* Scrapers
    * TLDR
    * Blinkist
* EPUB Builder
* Email Sender (GMail SMTP)

# Requirements
* Start automatically every weekday at 5:00 AM PT
* Scrape a set of URLs of TLDR based on the date
* Build a one EPUB file from the TLDR articles
* Email the EPUB file to alessio@signorini.us

### TLDR URLs
   * https://tldr.tech/tech/<YYYY-MM-DD>
   * https://tldr.tech/ai/<YYYY-MM-DD>
   * https://tldr.tech/infosec/<YYYY-MM-DD>