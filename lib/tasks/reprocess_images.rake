task reprocess_images: :environment do
  Clip.find_each do |clip|
    puts clip.id

    clip.update(image: clip.image) if clip.image_stored?
  end
end
