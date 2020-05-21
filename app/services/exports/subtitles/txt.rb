module Exports
  module Subtitles
    class Txt < Base

      def initialize(lang: "en", num_char_per_line: 35, **args)
        super(**args, format: :txt)
        @num_char_per_line = num_char_per_line
        @lang = lang
      end
 
      def export_body
        # 1 To text
        text = get_text_from_world_list()
        # 2 Text segmentation
        text = text_segmentation(text)
        # 3 Line break between stentences
        text = add_line_break(text) 
        # 4 Fold char limit per line
        text = fold_words(text)
        # 5 Divide into two lines
        divide_into_two_lines(text)
      end

      def get_text_from_world_list()
        @subtitle.map { |cue| 
          cue["text"]
        }.join(' ')
      end

      def text_segmentation(text) 
        PragmaticSegmenter::Segmenter.new(text: text, language: @lang).segment.join("\n")
      end
 
      def add_line_break(text)
        text.gsub(/\n/, "\n\n")
      end

      def fold_words(text)
        line_arr = text.split("\n\n")
        fold_words_in_array = line_arr.map{ |line|
          fold_words_return_array(line.split(" "))
        }

        # flatten results
        folded_words_flatten = fold_words_in_array.map{ |line| line.join(" ") }

        # remove space after carriage return \n in lines
        result = folded_words_flatten.map{ |r| remove_space_after_carriage_return(r) }

        return result.join("\n\n")
      end


      # Folds array of words
      def fold_words_return_array(txt_array)
        counter = 0 
        txt_array.map.with_index { |word, index| 
          counter += word.length + 1
          # resetting counter when there is a 'paragraph' line break \n\n
          if (counter <= @num_char_per_line)
            # if not last word in list
            # cover edge case last element in array does not have a next element
            if txt_array[index+1]
              next_el_len = txt_array[index+1].length
              # check if adding next word would make the line go over the char limit @num_char_per_line
              if ((counter + next_el_len) < @num_char_per_line)
                word
              else
                # if it makes it go over, reset counter, return and add line break
                counter = 0
                "#{ word}\n"
              end 
            else
              # last word in the list
              word
            end
          else
            # if not greater then char @num_char_per_line
            counter = 0
            "#{ word }\n";
          end
        }
      end

      # Remove space after carriage return \n in lines
      def remove_space_after_carriage_return(text)
        text.gsub(/\n /, "\n");
      end
      
      # Divide into two lines
      def divide_into_two_lines(text)
        lines = text.split("\n")
        counter = 0

        result = lines.map { |l| 
          if (l == "") 
            l
          else
            if counter == 0
              counter += 1
              if (l.last[0] == ".")
                l + "\n\n"
              else
                l + "\n"
              end
            elsif counter == 1 
              counter = 0
              l + "\n\n"
            end
          end
        }

        # Remove space at beginnig of the line
        result = result.map{ |r| r.lstrip}
        # Remove empty lines from list to avoid unwanted space a beginning of line
        result = result.select{ |l| l.length > 0 };

        result = result.join("").strip
        
        return result;
      end

    end
  end
end