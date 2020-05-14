module Exports
  module Subtitles
    class Srt < Base

      def initialize(**args)
        super(**args, format: :srt)
      end

      def export_body
        @export_body = body
      end
 
      def body
        @subtitle.map.with_index { |cue, index| cue_body(cue, index) }.join
      end
 
      def cue_body(cue, index)
        [
          index + 1,
          cue_timecode(cue, ","),
          cue['text'].strip,
          "\r\n"
        ].join("\r\n")
      end

    end
    
  end
end