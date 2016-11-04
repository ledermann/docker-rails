module DockerRails
  class Application
    VERSION = '0.1.3'

    def full_version
      "#{VERSION}/#{build_time}"
    end

    def build_time
      @build_time ||= File.read('BUILD_TIME').lines.first.chomp rescue 'unknown'
    end
  end
end
