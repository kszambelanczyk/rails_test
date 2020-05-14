require "rails_helper"

module Exports
  module Subtitles

    RSpec.describe Srt do
      let(:json_data) { read_json_subs("subs") }
      describe "exporting to SRT" do

        it "should return Tempfile" do
          expect(Srt.call(subtitle: json_data, video_title: "Title 1").instance_of?(Tempfile)).to eq true
        end

        it "should return Tempfile with extension .srt" do
          tempfile = Srt.call(subtitle: json_data, video_title: "Title 1")
          expect(File.extname(tempfile.path)).to eq ".srt"
        end
        
        it "should return file in srt format" do
          tempfile = Srt.call(subtitle: json_data, video_title: "Title 1")
          tempfile.rewind
          lines = tempfile.read.lines
          # removing UTF8_BOM_MAGIC_NUMBER
          lines[0][0] = ''
          expect(lines[0].strip.match?(/^\d+$/)).to eq true 
          expect(lines[1].strip.match?(/^\d{2}:\d{2}:\d{2},\d{3} --> \d{2}:\d{2}:\d{2},\d{3}$/)).to eq true 
        end
      end
    end

  end
end