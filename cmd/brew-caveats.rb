#!/usr/bin/env ruby

require "formula"

Formula.installed.sort.map(&:to_hash)
       .select { |f| f["caveats"].present? }
       .each { |f| ohai f["name"], f["caveats"] }
