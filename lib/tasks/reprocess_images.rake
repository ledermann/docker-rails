task reprocess_images: :environment do
  Clip.find_each do |clip|
    puts clip.id

    clip.update(image: clip.image[:original]) if clip.image_attacher.stored?
  end
end
