require "rails_helper"

module Exports
  module Subtitles

    RSpec.describe Avid do
      let(:json_data) { read_json_subs("subs") }
      describe "exporting to Avid markers .txt" do

        it "generates Tempfile" do
          expect(Avid.call(subtitle: json_data, video_title: "Title 1").instance_of?(Tempfile)).to eq true
        end

        it "generates Tempfile with extension .txt" do
          tempfile = Avid.call(subtitle: json_data, video_title: "Title 1")
          expect(File.extname(tempfile.path)).to eq ".txt"
        end

        it "generates Tempfile where cue line is in appropiate format" do
          tempfile = Avid.call(subtitle: json_data, video_title: "Title 1")
          tempfile.rewind
          lines = tempfile.read.lines
          # removing UTF8_BOM_MAGIC_NUMBER
          lines[0][0] = "" 
          expect(lines[0].match?(/^\S+\t\d{2}:\d{2}:\d{2}:\d{2}\t\S+\t\S+\t/)).to eq true 
        end

      end
    end

  end
end