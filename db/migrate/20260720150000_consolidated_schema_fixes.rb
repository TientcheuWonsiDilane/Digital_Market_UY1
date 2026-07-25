class ConsolidatedSchemaFixes < ActiveRecord::Migration[8.1]
  def up
    # Safely add store references - check existence first
    unless column_exists?(:items, :store_id)
      add_reference :items, :store, foreign_key: true
    end
    unless column_exists?(:products, :store_id)
      add_reference :products, :store, foreign_key: true
    end
  end

  def down
    if column_exists?(:items, :store_id)
      remove_reference :items, :store
    end
    if column_exists?(:products, :store_id)
      remove_reference :products, :store
    end
  end
end
