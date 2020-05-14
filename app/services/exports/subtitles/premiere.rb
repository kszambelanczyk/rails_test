module Exports
  module Subtitles
    class Premiere < Base

      def initialize(**args)
        super(**args, format: :xml)
      end
 
      def export_body
        @export_body ||= [header, cues_body, footer].join
      end
 
      def header
        '<?xml version="1.0" encoding="UTF-8" standalone="no" ?>'\
        '<tt xmlns="http://www.w3.org/ns/ttml"'\
        'ttp:timeBase="media"'\
        'xmlns:m608="http://www.smpte-ra.org/schemas/2052-1/2010/smpte-tt#cea608"'\
        'xmlns:smpte="http://www.smpte-ra.org/schemas/2052-1/2010/smpte-tt"'\
        'xmlns:ttm="http://www.w3.org/ns/ttml#metadata">'\
        '<head>'\
        '<metadata>'\
        '<smpte:information m608:captionService="F1C1CC" m608:channel="cc1"/>'\
        '</metadata>'\
        '<styling></styling>'\
        '<layout></layout>'\
        '</head>'\
        '<body><div>'
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