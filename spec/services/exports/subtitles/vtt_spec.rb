require "rails_helper"

module Exports
  module Subtitles

    RSpec.describe Vtt do
      let(:json_data) { read_json_subs("subs") }
      describe "exporting to SRT" do

        it "should return Tempfile" do
          expect(Vtt.call(subtitle: json_data, video_title: "Title 1").instance_of?(Tempfile)).to eq true
        end

        it "should return Tempfile with extension .vtt" do
          tempfile = Vtt.call(subtitle: json_data, video_title: "Title 1")
          expect(File.extname(tempfile.path)).to eq ".vtt"
        end

        it "should return file with first line beginnig from 'WEBVTT'" do
          tempfile = Vtt.call(subtitle: json_data, video_title: "Title 1")
          tempfile.rewind
          lines = tempfile.read.lines
          # removing UTF8_BOM_MAGIC_NUMBER
          lines[0][0] = ''
          expect(lines[0].strip.match?(/^WEBVTT/)).to eq true 
        end

        it "should return file with timecode in appropiate format" do
          tempfile = Vtt.call(subtitle: json_data, video_title: "Title 1")
          tempfile.rewind
          txt = tempfile.read
          m1 = txt.match?(/\d{2}:\d{2}:\d{2}.\d{3} --> \d{2}:\d{2}:\d{2}.\d{3}\r\n/)
          m2 = txt.match?(/\d{2}:\d{2}.\d{3} --> \d{2}:\d{2}.\d{3}\r\n/)
          expect(m1 || m2).to eq true 
        end

      end
    end

  end
end