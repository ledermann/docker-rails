task reprocess_images: :environment do
  Clip.find_each do |clip|
    puts clip.id
    if clip.image_attacher.stored?
      clip.update(image: clip.image[:original])
    end
  end
end
