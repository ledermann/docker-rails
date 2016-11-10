desc "Create git tag with version"
task release: :environment do
  sh "git tag -m \"Version #{version}\" #{version_tag}"
end

def version
  DockerRails::Application.version
end

def version_tag
 "v#{version}"
end
