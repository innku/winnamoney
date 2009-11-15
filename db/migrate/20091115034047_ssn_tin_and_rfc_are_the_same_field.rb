class SsnTinAndRfcAreTheSameField < ActiveRecord::Migration
  def self.up
    change_table :orders do |t|
      t.remove :rfc
    end
  end

  def self.down
    change_table :orders do |t|
      t.string :rfc
    end
  end
end
