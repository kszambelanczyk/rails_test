require "rails_helper"

module Exports
  module Subtitles

    RSpec.describe Txt do
      let(:json_data) { read_json_subs("subs") }
      describe "exporting to TXT" do

        it "ganerates Tempfile" do
          expect(Txt.call(subtitle: json_data, video_title: "Title 1").instance_of?(Tempfile)).to eq true
        end

        it "generates Tempfile with extension .txt" do
          tempfile = Txt.call(subtitle: json_data, video_title: "Title 1")
          expect(File.extname(tempfile.path)).to eq ".txt"
        end
        
        it "generates Tempfile with first few chars matching data in json fixtures" do
          tempfile = Txt.call(subtitle: json_data, video_title: "Title 1")
          tempfile.rewind
          lines = tempfile.read.lines
          # removing UTF8_BOM_MAGIC_NUMBER
          lines[0][0] = ''
          expect(lines[0].match?(/^#{json_data[0]["text"][0..10]}/)).to eq true 
        end
        
      end
    end

  end
end