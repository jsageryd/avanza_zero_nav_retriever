#!/usr/bin/env ruby
# encoding: utf-8

class AvanzaZeroNAVGetter
  class << self
    def latest
      require 'net/http'
      require 'nokogiri'

      uri = URI.parse('https://www.avanza.se/fonder/om-fonden.html/41567/avanza-zero')
      res = Net::HTTP.get_response(uri)
      doc = Nokogiri.parse(res.body)
      date = doc.xpath('//*[@id="surface"]/div[2]/div/div/div/div/ul/li[9]/span[2]').text.strip
      nav = doc.xpath('//*[@id="surface"]/div[2]/div/div/div/div/ul/li[2]/div[2]').text.gsub(',', '.').strip
      'P %s ZERO %s SEK' % [date, nav]
    end
  end
end

price_db = '%s/Dropbox/Ledger/prices/price-db' % ENV['HOME']
our_last = `grep ZERO "#{price_db}" | tail -1`.strip
theirs = AvanzaZeroNAVGetter.latest
File.open(price_db, 'a') { |io| io.puts theirs } if our_last != theirs
