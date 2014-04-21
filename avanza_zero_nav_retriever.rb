#!/usr/bin/env ruby
# encoding: utf-8

require 'bundler/setup' rescue nil

class AvanzaZeroNAVGetter
  class << self
    def latest
      require 'net/http'
      require 'nokogiri'

      uri = URI.parse('https://www.avanza.se/fonder/om-fonden.html/41567/avanza-zero')
      http = Net::HTTP.new(uri.host, uri.port)
      http.use_ssl = (uri.scheme == 'https')
      http.ssl_version = :TLSv1
      res = http.request_get(uri.path)
      doc = Nokogiri.parse(res.body)
      date = doc.xpath('//*[@id="surface"]/div[2]/div/div/div/div/ul/li[9]/span[2]').text.strip
      nav = doc.xpath('//*[@id="surface"]/div[2]/div/div/div/div/ul/li[2]/div[2]').text.gsub(',', '.').strip
      'P %s ZERO %s SEK' % [date, nav]
    end
  end
end

price_db = '%s/Documents/ledger/prices/price-db' % ENV['HOME']
our_last = `grep ZERO "#{price_db}" | tail -1`.strip
theirs = AvanzaZeroNAVGetter.latest
if our_last != theirs
  File.open(price_db, 'a') { |io| io.puts theirs }
  cmd = <<-SHELL
    pushd #{File.dirname(price_db)} && \
    git add price-db && \
    git commit -m 'Update #{theirs[/P ([^ ]+)/, 1]}' && \
    git push && \
    popd
  SHELL
  system cmd or raise 'Avanze Zero NAV repo update failed'
end
