require 'nokogiri'

$PORT = 5001
$DOMAIN = 'https://webdev.dartlang.org/'
$LOCALHOST = "http://localhost:#{$PORT}/"

puts "Parsing current sitemap.xml for all current URLs"
sitemap = File.open("publish/sitemap.xml") { |f| Nokogiri::XML(f) }
$NEW_URLS = sitemap.xpath("//xmlns:loc").map { |node| node.content }
$NEW_URLS.sort!

# Change webdev.dartlang.org to localhost
$LOCALHOST_NEW_URLS = $NEW_URLS.map { |url| url.sub($DOMAIN, $LOCALHOST) }