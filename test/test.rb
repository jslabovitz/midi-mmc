$VERBOSE = false

require 'minitest/autorun'
require 'minitest/power_assert'

$LOAD_PATH.unshift File.expand_path('../lib', __FILE__)
require 'midi-mmc'

class MIDI::MMC::Test < Minitest::Test

  def test_simple
    io = StringIO.new
    mmc = MIDI::MMC.new(output: io)
    mmc.play
    io.rewind
    output = io.read.unpack('C*')
    expected_output = [0xF0, 0x7F, 0x7F, 0x06, 0x02, 0xF7]
    assert { output == expected_output }
  end

end