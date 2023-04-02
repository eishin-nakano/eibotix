require "csv"

CSV.foreach('db/csv/flashcard.csv', headers: true) do |row|
    Flashcard.create!(
      id: row['id'],
      english: row['english'],
      japanese: row['japanese']
    )
end
