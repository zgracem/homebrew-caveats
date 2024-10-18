#!/usr/bin/env ruby
# frozen_string_literal: true

require "abstract_command"
require "caveats"

module Homebrew
  module Cmd
    class Caveats < AbstractCommand
      cmd_args do
        description <<~HELP
          Display caveats for an installed <formula> or <cask>,
          or for all installed formulae and casks if no argument is provided.
        HELP
        switch "--formula", "--formulae",
               description: "Treat all named arguments as formulae."
        switch "--cask", "--casks",
               description: "Treat all named arguments as casks."

        conflicts "--formula", "--cask"

        named_args %i[formula cask]
      end

      def run
        targets = args.named.to_formulae_and_casks.presence || all_caveats_installed

        targets.each do |target|
          caveats = target.caveats
          target_name = [target.name].flatten.first

          if caveats.present?
            ohai target_name, caveats.to_s
          else
            opoo "No caveats for #{target_name}!"
          end
        end
      end

      private

      def all_caveats_installed
        if args.formulae?
          all_formulae_with_caveats
        elsif args.casks?
          all_casks_with_caveats
        else
          all_formulae_with_caveats + all_casks_with_caveats
        end
      end

      def all_formulae_with_caveats
        Formula.installed.select { |f| f.caveats.present? }
      end

      def all_casks_with_caveats
        Cask::Caskroom.casks.select { |c| c.caveats.present? }
      end
    end
  end
end
