require "rails_helper"

module Exports
  module Subtitles

    RSpec.describe Docx do
      let(:json_data) { read_json_subs("subs") }
      describe "exporting to DOCX" do

        it "generates Tempfile" do
          expect(Docx.call(subtitle: json_data, video_title: "Title 1").instance_of?(Tempfile)).to eq true
        end

        it "generates Tempfile with extension .docx" do
          tempfile = Docx.call(subtitle: json_data, video_title: "Title 1")
          expect(File.extname(tempfile.path)).to eq ".docx"
        end
        
      end
    end

  end
end