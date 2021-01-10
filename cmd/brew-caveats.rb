#!/usr/bin/env ruby

require "caveats"
require "dev-cmd/irb"

formulae = ARGV.map(&:f).presence || Formula.installed.select(&:caveats).sort

formulae.each do |f|
  caveats = Caveats.new(f)
  if caveats.present?
    ohai f.name, caveats.to_s
  else
    opoo "No caveats for #{f.name}!"
  end
end
