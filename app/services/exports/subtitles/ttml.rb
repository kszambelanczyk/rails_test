module Exports
  module Subtitles
    class Ttml < Base

      def initialize(**args)
        super(**args, format: :ttml)
      end
 
      def export_body
        @export_body ||= [header, cues_body, footer].join
      end
 
      def header
        '<?xml version="1.0" encoding="UTF-8"?>'\
        '<tt xmlns="http://www.w3.org/ns/ttml">'\
        '<head></head>'\
        '<body>'\
        '<div>'\
        "\r\n"
      end

      def footer
        "</div>\n</body>\n</tt>"
      end

      def cues_body
        @subtitle.map.with_index { |cue, index| 
          cue_body(cue, index)
        }.join
      end
 
      def cue_body(cue, index)
        str = '<p begin="%s" end="%s">%s</p>' % [format_seconds(cue["start"]), format_seconds(cue["end"]), escape_text(cue["text"]).gsub!(/\n/, '<br />')]
        str += "\r\n"
      end
 
    end
  end
end