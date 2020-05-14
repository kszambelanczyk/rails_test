require "rails_helper"

module Exports
  module Subtitles

    RSpec.describe Premiere do
      let(:json_data) { read_json_subs("subs") }
      describe "exporting to Premiere TTML" do

        it "should return Tempfile" do
          expect(Premiere.call(subtitle: json_data, video_title: "Title 1").instance_of?(Tempfile)).to eq true
        end

        it "should return Tempfile with extension .xml" do
          tempfile = Premiere.call(subtitle: json_data, video_title: "Title 1")
          expect(File.extname(tempfile.path)).to eq ".xml"
        end

        it "should return file that contain characteristic markers" do
          tempfile = Premiere.call(subtitle: json_data, video_title: "Title 1")
          tempfile.rewind
          txt = tempfile.read
          expect(txt.match?(/\<\?xml version="1.0" encoding="UTF-8" standalone="no" \?\>/)).to eq true
          expect(txt.match?(/\<smpte\:information m608\:captionService="F1C1CC" m608\:channel="cc1"\/\>/)).to eq true
        end

      end
    end

  end
end