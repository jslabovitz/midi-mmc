$VERBOSE = false

require 'minitest/autorun'
require 'minitest/power_assert'

$LOAD_PATH.unshift File.expand_path('../lib', __FILE__)
require 'midi-mmc'

class MIDI::MMC::Test < Minitest::Test

  def test_simple
    mmc = MIDI::MMC.new
    steps = [
      [ proc { mmc.reset            }, 'F0 7F 7F 06 0D F7'                          ],
      [ proc { mmc.goto_zero        }, 'F0 7F 7F 06 44 06 01 00 00 00 00 00 F7'     ],
      [ proc { mmc.arm_tracks(1)    }, 'F0 7F 7F 06 40 06 4F 05 20 00 00 00 00 F7'  ],
      [ proc { mmc.stop             }, 'F0 7F 7F 06 01 F7'                          ],
      [ proc { mmc.arm_tracks(nil)  }, 'F0 7F 7F 06 40 06 4F 05 00 00 00 00 00 F7'  ],
      [ proc { mmc.goto_zero        }, 'F0 7F 7F 06 44 06 01 00 00 00 00 00 F7'     ],
      [ proc { mmc.play             }, 'F0 7F 7F 06 02 F7'                          ],
    ]
    steps.each do |step, expected_output|
      output = mmc.message_to_str(step.call)
      assert { output == expected_output }
    end
  end

end