module Exports
  module Subtitles
    class Itt < Base

      def initialize(lang: 'en-GB', fps: 25, **args)
        super(**args, format: :ITT)
        @lang = lang
        @fps = fps
      end
 
      def export_body
        @export_body ||= [header, cues_body, footer].join
      end
 
      def header
        %Q(
          <?xml version="1.0" encoding="UTF-8"?>
          <tt
            xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
            xmlns="http://www.w3.org/ns/ttml"
            xmlns:tt="http://www.w3.org/ns/ttml"
            xmlns:tts="http://www.w3.org/ns/ttml#styling"
            xmlns:ttp="http://www.w3.org/ns/ttml#parameter"
            xml:lang="#{ @lang }"
            ttp:timeBase="smpte"
            ttp:frameRate="#{ @fps }"
            ttp:frameRateMultiplier="#{ @fps === 25 ? '1 1' : '999 1000' }"
            ttp:dropMode="nonDrop"
          >
          <head>
            <styling>
              <style
                xml:id="normal"
                tts:fontFamily="sansSerif"
                tts:fontWeight="normal"
                tts:fontStyle="normal"
                tts:color="white"
                tts:fontSize="100%"
              />
            </styling>
            <layout>
              <region
                xml:id="bottom"
                tts:origin="0% 85%"
                tts:extent="100% 15%"
                tts:textAlign="center"
                tts:displayAlign="after"
              />
            </layout>
          </head>
          <body style="normal" region="bottom">
            <div begin="-01:00:00:00">
            ).strip
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
        str = '<p begin="%s" end="%s">%s</p>\n' % [tc_format(cue["start"] * @fps, @fps), tc_format(cue["end"] * @fps, @fps), escape_text(cue["text"]).gsub!(/\n/, '<br />') ]
        # str = '<p begin="${ tcFormat(parseFloat(v.start) * FPS, FPS) }" end="${ tcFormat(parseFloat(v.end) * FPS, FPS) }">${ escapeText(v.text).replace(/\n/g, '<br />') }</p>\n'

        # str = '<p begin="%s" end="%s">%s</p>' % [format_seconds(cue["start"]), format_seconds(cue["end"]), escape_text(cue["text"]).gsub!(/\n/, '<br />')]
        str += "\r\n"
      end
 
    end
  end
end