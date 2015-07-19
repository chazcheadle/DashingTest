require 'net/http'
require 'nokogiri'
require 'open-uri'
require 'uri'

SCHEDULER.every '30s' do
  uri = URI('http://feed.entertainment.tv.theplatform.com/f/HNK2IC/prod_msnbc_listing')
  params = { :byEndTime => "2015-04-28T08:00:00-04:00~2015-04-28T18:00:00-04:00" }
  uri.query = URI.encode_www_form( params )
  xmldoc =  uri.open.read
  doc = Nokogiri::HTML(xmldoc)

  shows = []

  doc.xpath('//item').each do |show|
    shows << { "Title" => show.xpath("program/title").text,
      "Description" => show.xpath("program/description").text, 
      "Starttime" => show.xpath("starttime").text,
      "Endtime" => show.xpath("endtime").text }
  end
#  p Shows
  send_event('epg', { shows: shows[0..4] })
end
