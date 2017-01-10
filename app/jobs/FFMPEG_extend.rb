  module FFMPEG
    class EncodingOptions < Hash

      def convert_crf(value)
        ["-crf", value]
      end

      def convert_tune(value)
        ["-tune", value]
      end
    end
  end
