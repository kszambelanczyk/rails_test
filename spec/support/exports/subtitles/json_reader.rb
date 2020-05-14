module Exports
  module Subtitles
    module JsonReader
      def read_json_subs(filename)
        file_content = file_fixture("#{filename}.json").read
        JSON.parse(file_content)
      end
    end
  end
end