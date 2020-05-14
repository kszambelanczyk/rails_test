require "rails_helper"

module Exports
  module Subtitles

    RSpec.describe Itt do
      let(:json_data) { read_json_subs("subs") }
      describe "exporting to ITT" do

        it "should return Tempfile" do
          expect(Itt.call(subtitle: json_data, video_title: "Title 1").instance_of?(Tempfile)).to eq true
        end

        it "should return Tempfile with extension .ITT" do
          tempfile = Itt.call(subtitle: json_data, video_title: "Title 1")
          expect(File.extname(tempfile.path)).to eq ".ITT"
        end

        it "should return file that contain characteristic markers" do
          tempfile = Itt.call(subtitle: json_data, video_title: "Title 1")
          tempfile.rewind
          txt = tempfile.read
          expect(txt.match?(/\<\?xml version\=\"1.0\" encoding\=\"UTF-8\"\?\>/)).to eq true
        end

      end
    end

  end
end