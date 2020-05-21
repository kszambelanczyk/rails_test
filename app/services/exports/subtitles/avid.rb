module Exports
  module Subtitles
    class Avid < Base

      def initialize(author: "Author", track: "V1", color: "white", **args)
        super(**args, format: :txt)
        @author = author
        @track = track
        @color = color
      end
 
      def export_body
        cues_body
      end
 
      def cues_body
        @subtitle.map { |cue| 
          cue_body(cue)
        }.join
      end
 
      def cue_body(cue)
        %Q(#{@author}\t#{formatted_timecode(cue["start"], ":", 2)}\t#{@track}\t#{@color}\t#{cue["text"].gsub(/\n/, "")}\r\n)
      end
 
    end
  end
end