module Exports
  module Subtitles
    class Csv < Base

      def initialize(**args)
        super(**args, format: :csv)
      end
 
      def export_body
        @export_body ||= [header, cues_body].join
      end
 
      def header
        "N, In, Out, Text\r\n"
      end

      def cues_body
        @subtitle.map.with_index { |cue, index| 
          cue_body(cue, index)
        }.join
      end
 
      def cue_body(cue, index)
        line = "#{index + 1},"
        line += %Q(\"#{ cue["start"] }\",\"#{ cue["end"] }\",)
        line += %Q(\"#{ cue["text"].gsub!(/\n/, '\r\n') }\"\n)
      end
 
    end
  end
end