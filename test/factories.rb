Factory.define :store, :class => Store do |s|
  s.sequence(:name) {|n| "tienda1#{n}" }
  s.language 'english'
  s.positioning 'left'
  s.status  'activated'
end
