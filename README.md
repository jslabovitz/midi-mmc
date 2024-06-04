# MIDI::MMC

This is a Ruby gem to facilitate controlling MIDI devices using the [MIDI Machine Control](https://en.wikipedia.org/wiki/MIDI_Machine_Control) protocol.


## Features

- Implements the common MMC commands, including transport (stop, play, record, etc.) and track arming.


## Limitations

- Does not handle any command responses, whether status (like timecode) or errors.
- Does not implement full MMC specification.


## Usage

```ruby
require 'midi-mmc'
require 'unimidi'

# set up
midi_output = UniMIDI::Output.gets
mmc = MIDI::MMC.new(output: midi_output)
mmc.reset

# record
mmc.goto_zero
mmc.arm_tracks(1)
# record something here
mmc.stop
mmc.arm_tracks(nil)

# play back
mmc.goto_zero
mmc.play
```


## Requirements

MIDI::MMC is designed to work with the [unimidi](http://github.com/arirusso/unimidi) gem, although any object passed in the `output` parameter to `MIDI::MMC.new` that responds to the `#puts` method can be used.


## References

- [Complete MIDI 1.0 Detailed Specification (1996, from archive.org)](https://archive.org/details/Complete_MIDI_1.0_Detailed_Specification_96-1-3)
- [MIDI Machine Control (Wikipedia)](https://en.wikipedia.org/wiki/MIDI_Machine_Control)