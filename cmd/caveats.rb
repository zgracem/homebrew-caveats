#!/usr/bin/env ruby
# frozen_string_literal: true

require "caveats"
require "cli/parser"
require "dev-cmd/irb"
require "formula"

module Homebrew
  module_function

  def caveats_args
    Homebrew::CLI::Parser.new do
      usage_banner <<~USAGE
        `caveats` [<formula> ...]

        Show existing caveats for a formula. If no formulae are given, print
        caveats for all installed formulae.
      USAGE
    end
  end

  def caveats
    args = caveats_args.parse
    formulae = args.named.map(&:f).presence || all_caveats_installed

    formulae.each do |f|
      caveats = Caveats.new(f)

      if caveats.present?
        ohai f.name, caveats.to_s
      else
        opoo "No caveats for #{f.name}!"
      end
    end
  end

  def all_caveats_installed
    Formula.installed.select(&:caveats).sort
  end
end
