require 'rubygems'
require 'autotest'
require 'rbconfig'
require File.join(File.dirname(__FILE__), 'result')

##
# Autotest::Blink1
#
# == FEATUERS:
# * Display autotest results as local or remote Growl notifications.
# * Clean the terminal on every test cycle while maintaining scrollback.
#
# == SYNOPSIS:
# ~/.autotest
#   require 'autotest/blink1'
module Autotest::Blink1
  GEM_PATH = File.expand_path(File.join(File.dirname(__FILE__), '..', '..'))

  @ran_tests = false
  @ran_features = false

  @@one_notification_per_run = false

  ##
  # Whether to limit the number of notifications per run to one or not (default).
  def self.one_notification_per_run=(boolean)
    @@one_notification_per_run = boolean
  end


  ##
  # Display a message through Growl.
  def self.blink1(error_count, fail_count)
    #blink1 = File.join(GEM_PATH, 'blink1', 'blink1notify')
    blink1_tool = '/Users/evacuee/bin/blink1-tool'
    #case RbConfig::CONFIG['host_os']
    if File.exists? blink1_tool
      if error_count.to_i != 0 or fail_count.to_i != 0
        system "/Users/evacuee/bin/blink1-tool --rgb 0xff,0,00 --blink #{(error_count.to_i + fail_count.to_i)}"
        system "/Users/evacuee/bin/blink1-tool --rgb 0xff,0,00"
      else
        system "/Users/evacuee/bin/blink1-tool --rgb 0,255,0 --blink 3"
        system "/Users/evacuee/bin/blink1-tool --rgb 0,255,0"
      end
    else
      raise "blink1-tool not found"
    end
  end

  ##
  # Display the modified files.
  Autotest.add_hook :updated do |autotest, modified|
    @ran_tests = @ran_features = false
    false
  end

  ##
  # Parse the RSpec and Test::Unit results and send them to Growl.
  Autotest.add_hook :ran_command do |autotest|
    unless @@one_notification_per_run && @ran_tests
      result = Autotest::Result.new(autotest)
      if result.exists?
        case result.framework
        when 'test-unit'        
          if result.has?('test-error')
            blink1 result.get('test-error'), 0
          elsif result.has?('test-failed')
            blink1 0, result.get('test-failed')
          else
            blink1 0, 0
          end
        when 'rspec'
          if result.has?('example-failed')
            blink1 result.get('example-failed'), 0
          elsif result.has?('example-pending')
            blink1 result.get('example-pending'), 0
          else
            blink1 0, 0
          end
        end
      else
        #blink1 @label + 'Could not run tests.', '', 'error', 2, @@sticky_failure_notifications
        blink1 1, 0
      end
      @ran_tests = true
    end
    false
  end

  ##
  # Parse the Cucumber results and sent them to Growl.
  Autotest.add_hook :ran_features do |autotest|
    unless @@one_notification_per_run && @ran_features
      result = Autotest::Result.new(autotest)
      if result.exists?
        case result.framework
        when 'cucumber'
          explanation = []
          if result.has?('scenario-undefined') || result.has?('step-undefined')
            blink1 0, result['scenario-undefined'].to_i + result['step-undefined'].to_i
          elsif result.has?('scenario-failed') || result.has?('step-failed')
            blink1 result['scenario-failed'].to_i + result['step-failed'].to_i, 0
          elsif result.has?('scenario-pending') || result.has?('step-pending')
            blink1 result['scenario-pending'].to_i + result['step-pending'].to_i
          else
            blink1 0, 0
          end      
        end
      else
        blink1 1, 0
      end
      @ran_features = true
    end
    false
  end

end
