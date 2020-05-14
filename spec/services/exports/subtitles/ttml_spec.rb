require "rails_helper"

module Exports
  module Subtitles

    RSpec.describe Ttml do
      let(:json_data) { read_json_subs("subs") }
      describe "exporting to TTML" do

        it "should return Tempfile" do
          expect(Ttml.call(subtitle: json_data, video_title: "Title 1").instance_of?(Tempfile)).to eq true
        end

        it "should return Tempfile with extension .ttml" do
          tempfile = Ttml.call(subtitle: json_data, video_title: "Title 1")
          expect(File.extname(tempfile.path)).to eq ".ttml"
        end

        it "should return file that contain characteristic markers" do
          tempfile = Ttml.call(subtitle: json_data, video_title: "Title 1")
          tempfile.rewind
          txt = tempfile.read
          expect(txt.match?(/\<\?xml version\=\"1.0\" encoding\=\"UTF-8\"\?\>/)).to eq true
          expect(txt.match?(/\<tt xmlns="http:\/\/www.w3.org\/ns\/ttml"\>/)).to eq true
        end

      end
    end

  end
end