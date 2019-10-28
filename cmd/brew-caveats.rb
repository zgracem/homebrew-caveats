#!/usr/bin/env ruby

require "formula"

formulae_with_caveats =
  Formula.installed.sort.map(&:to_hash).select { |f| f["caveats"].present? }

formulae_with_caveats.each do |formula|
  ohai formula["name"]
  puts formula["caveats"]
end
