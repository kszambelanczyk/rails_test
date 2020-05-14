require "rails_helper"

module Exports
  module Subtitles

    RSpec.describe Csv do
      let(:json_data) { read_json_subs("subs") }
      describe "exporting to CSV" do

        it "should return Tempfile" do
          expect(Csv.call(subtitle: json_data, video_title: "Title 1").instance_of?(Tempfile)).to eq true
        end

        it "should return Tempfile with extension .csv" do
          tempfile = Csv.call(subtitle: json_data, video_title: "Title 1")
          expect(File.extname(tempfile.path)).to eq ".csv"
        end

        it "should return file with the appropiate header" do
          tempfile = Csv.call(subtitle: json_data, video_title: "Title 1")
          tempfile.rewind
          lines = tempfile.read.lines
          # removing UTF8_BOM_MAGIC_NUMBER
          lines[0][0] = ''
          expect(lines[0].strip.match?(/^N,\s{1,}In,\s{1,}Out,\s{1,}Text/)).to eq true 
        end
        it "should return file where cue line is in appropiate format" do
          tempfile = Csv.call(subtitle: json_data, video_title: "Title 1")
          tempfile.rewind
          lines = tempfile.read.lines
          expect(lines[1].strip.match?(/^\d+,"\d+.\d+?","\d+.\d+?",".+?"$/)).to eq true 
        end

      end
    end

  end
end