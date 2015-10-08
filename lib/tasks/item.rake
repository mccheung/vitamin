namespace :item do
  desc "create item elasticsearch index"
  task create_index: :environment do
    Item.__elasticsearch__.create_index! force:true
  end

  desc "import all items into elasticsearch"
  task import_all: :environment do
    Item.import_all
  end

end
