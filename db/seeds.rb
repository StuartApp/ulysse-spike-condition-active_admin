def store(name, category)
  { name: name, category: category, lat: rand(42_00000..45_00000), lng: rand(1_00000..5_00000)}
end

Store.create([
  store("Coca shop", "food"),
  store("Apple store", "tech"),
  store("Carrefour", "food"),
  { name: "not in range", category: "food", lat: -1, lng: -1 }
])
