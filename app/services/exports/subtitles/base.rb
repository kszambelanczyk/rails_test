module Exports
  module Subtitles

    class Base
      def self.call(**args, &block)
        new(**args, &block).call
      end

      def initialize(subtitle:, video_title:, format:, with_bom: true)
        @subtitle = subtitle
        @video_title = video_title
        @format = format
        @with_bom = with_bom
      end

      def call
        tempfile = Tempfile.new([@video_title, ".#{@format}"])
        tempfile.write UTF8_BOM_MAGIC_NUMBER if @with_bom
        tempfile.write export_body.force_encoding(Encoding::UTF_8)
        tempfile.rewind

        # # coping to local file for file inspection 
        # f = File.new("subs.#{@format}", "w")
        # f.write tempfile.read
        # f.close

        tempfile
      end

      private
      UTF8_BOM_MAGIC_NUMBER = "\uFEFF"
 
      def cue_timecode(cue, separator)
        [
          formatted_timecode(cue['start'], separator),
          formatted_timecode(cue['end'], separator)
        ].join(' --> ')
      end

      # Example: 2.16 => 00:00:02,160
      def formatted_timecode(time, separator, ms_len = 3 )
        decimal_seconds, = time.to_s.split(':').reverse
        decimal_seconds = decimal_seconds.to_f.round(ms_len).to_s
        seconds, milliseconds = decimal_seconds.split('.')
        [
          seconds_to_time(seconds.to_i),
          milliseconds << '0' * [ms_len - milliseconds.length, 0].max
          # formatted_milliseconds(milliseconds)
        ].join separator
      end
 
      # def formatted_milliseconds(milliseconds)
      #   milliseconds << '0' * [3 - milliseconds.length, 0].max
      # end
 
      def seconds_to_time(seconds)
        [seconds / 3600, seconds / 60 % 60, seconds % 60].map { |t| t.to_s.rjust(2, '0') }.join(':')
      end

      def escape_text(str)
        str.gsub!(/&/, "&amp;")
        str.gsub!(/</, "&lt;")
        str.gsub!(/>/, "&gt;")
        str
      end

      def format_seconds(seconds)
        t = Time.new(0,1,1,0,0,0) + seconds
        t.iso8601(3)[11..22]
      end

      def tc_format(frames, fps)
        Timecode.new(frames, fps).to_s.gsub!(/^00/,"01")
      end

    end
  end
end