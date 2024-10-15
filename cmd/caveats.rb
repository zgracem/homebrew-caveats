#!/usr/bin/env ruby
# frozen_string_literal: true

require "abstract_command"
require "caveats"

module Homebrew
  module Cmd
    class Caveats < AbstractCommand
      cmd_args do
        description <<~HELP
          Display caveats for an installed <formula>, or for all installed
          formulae if no argument is provided.
        HELP
        switch "--formula", "--formulae",
               description: "Treat all named arguments as formulae."
        switch "--cask", "--casks",
               description: "Treat all named arguments as casks."

        conflicts "--formula", "--cask"

        named_args [:formula, :cask]
      end

      def run
        formulae = args.named.to_formulae_and_casks.presence || all_caveats_installed

        formulae.each do |f|
          caveats = ::Caveats.new(f)

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
  end
end
