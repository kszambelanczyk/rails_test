module Exports
  module Subtitles
    class Docx < Base

      def initialize(**args)
        super(**args, format: :docx)
        @with_bom = false
      end

      def export_body
        @export_body = body
      end
 
      def body
        result = @subtitle.map { |cue| 
          cue_body(cue) 
        }.join
        Htmltoword::Document.create(result)
      end
 
      def cue_body(cue)
        [
          %Q(<p>#{ cue["start"] }, #{ cue["end"] }</p>),
          %Q(<p>#{ cue["text"].strip }</p>),
          %Q(<p></p>)
        ].join()
      end

    end
    
  end
end