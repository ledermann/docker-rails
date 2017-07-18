module DockerRails
  class Application
    def version
      '1.5.2b'
    end

    def build_time
      @build_time ||= begin
        File.read('BUILD_TIME').lines.first.chomp.to_datetime
      rescue
        Time.current
      end
    end
  end
end
