$LOAD_PATH.unshift(File.dirname(__FILE__))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
require 'autotest/blink1'
require 'rspec'
require 'rspec/autorun'

RSpec.configure do |config|
end

module Autotest::Blink1
  def self.blink1(title, message, icon, priority=0, stick="")
    icon
  end
end