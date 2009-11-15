10.times do
  Factory.create(:store)
  Store.last.activate!
end