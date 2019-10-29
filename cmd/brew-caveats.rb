#!/usr/bin/env ruby

require "caveats"
require "formula"

Formula.installed.sort.select(&:caveats).each do |f|
  caveats = Caveats.new(f)
  ohai f.name, caveats.to_s unless caveats.empty?
end
