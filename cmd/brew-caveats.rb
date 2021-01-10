#!/usr/bin/env ruby

#:  * `caveats` <[formula ...]>:
#:    Prints installation caveats for Homebrew formulae.
#:
#:    `brew caveats`
#:    List caveats for all installed formulae.
#:
#:    `brew caveats` <formula> <[...]>
#:    List caveats for all listed formulae (whether installed or not).

require "caveats"
require "dev-cmd/irb"

(ARGV.map(&:f).presence || Formula.installed.select(&:caveats).sort).each do |f|
  caveats = Caveats.new(f)

  if caveats.present?
    ohai f.name, caveats.to_s
  else
    opoo "No caveats for #{f.name}!"
  end
end
