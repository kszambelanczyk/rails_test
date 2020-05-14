module Exports
  module Subtitles
    class Vtt < Base

      def initialize(**args)
        super(**args, format: :vtt)
      end
 
      def export_body
        @export_body ||= [header, style, cues_body].join
      end
 
      def header
        "WEBVTT - Powered by Checksub\r\n\r\n"
      end
 
      def style
        "STYLE\r\n::cue { background: #6772e5; color: #fff; font-family: Lato; font-size: 14, text-align: center; }\r\n\r\n"
      end
 
      def cues_body
        @subtitle.map.with_index { |cue, index| cue_body(cue, index) }.join
      end
 
      def cue_body(cue, index)
        [
          index + 1,
          cue_timecode(cue, "."),
          cue['text'].strip,
          "\r\n"
        ].join("\r\n")
      end
 
    end
  end
end