module MIDI

  class MMC

    attr_accessor :output
    attr_accessor :device_id

    DEVICE_ID_ALL = 0x7F

    TYPES = {
      command:        0x06,
      response:       0x07,
    }

    COMMANDS = {
      stop:           0x01,
      play:           0x02,
      deferred_play:  0x03,
      fast_forward:   0x04,
      rewind:         0x05,
      record_strobe:  0x06,
      record_exit:    0x07,
      record_pause:   0x08,
      pause:          0x09,
      eject:          0x0A,
      chase:          0x0B,
      reset:          0x0D,
      write:          0x40,
      goto:           0x44,
      shuttle:        0x47,
    }

    WRITE_MODES = {
      record_ready:   0x4F,
      sync_monitor:   0x52,
      input_monitor:  0x53,
      mute:           0x62,
    }

    def initialize(output:, device_id: nil)
      @output = output
      @device_id = device_id || DEVICE_ID_ALL
    end

    def stop
      send_command_message(:stop)
    end

    def play
      send_command_message(:play)
    end

    def deferred_play
      send_command_message(:deferred_play)
    end

    def fast_forward
      send_command_message(:fast_forward)
    end

    def rewind
      send_command_message(:rewind)
    end

    def record_strobe
      send_command_message(:record_strobe)
    end

    def record_exit
      send_command_message(:record_exit)
    end

    def record_pause
      send_command_message(:record_pause)
    end

    def pause
      send_command_message(:pause)
    end

    def eject
      send_command_message(:eject)
    end

    def chase
      send_command_message(:chase)
    end

    def reset
      send_command_message(:reset)
    end

    def write(tracks)
      tracks = case tracks
      when nil
        []
      when Numeric
        [tracks]
      when Range
        tracks.to_a
      when Array
        tracks
      else
        raise
      end
      bytes = track_bitmap_bytes(tracks)
      mode_id = WRITE_MODES[:record_ready] or raise
      track_bitmap = [bytes.length, *bytes]
      send_command_message(:write, track_bitmap.length, mode_id, *track_bitmap)
    end

    def goto(location)
      send_command_message(:goto, 0x06, 0x01, *location)
      sleep(1)
    end

    def goto_zero
      goto([0, 0, 0, 0, 0])
    end

    def shuffle
      send_command_message(:shuffle)
    end

    private

    def send_command_message(command, *elements)
      id = COMMANDS[command] or raise
      msg = [0xF0, 0x7F, @device_id, TYPES[:command], id, *elements, 0xF7]
      if @debug
        warn "%-15s >>> %s" % [command, msg.map { |b| '%02X' % b }.join(' ')]
      end
      output.write(msg.pack('C*'))
      msg
    end

    TRACK_BITMAP = {
       0 => [0, 0x20],
       1 => [0, 0x40],

       2 => [1, 0x01],
       3 => [1, 0x02],
       4 => [1, 0x04],
       5 => [1, 0x08],
       6 => [1, 0x10],
       7 => [1, 0x20],
       8 => [1, 0x40],

       9 => [2, 0x01],
      10 => [2, 0x02],
      11 => [2, 0x04],
      12 => [2, 0x08],
      13 => [2, 0x10],
      14 => [2, 0x20],
      15 => [2, 0x40],

      16 => [3, 0x01],
      17 => [3, 0x02],
      18 => [3, 0x04],
      19 => [3, 0x08],
      20 => [3, 0x10],
      21 => [3, 0x20],
      22 => [3, 0x40],

      23 => [4, 0x01],
    }

    def track_bitmap_bytes(tracks)
      bytes = [0, 0, 0, 0, 0]
      tracks.each do |track|
        spec = TRACK_BITMAP[track] or raise "Track out of range: #{track.inspect}"
        byte_idx, bits = *spec
        bytes[byte_idx] += bits
      end
      bytes
    end

  end

end