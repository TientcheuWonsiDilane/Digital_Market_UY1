class AddUsernameToUsers < ActiveRecord::Migration[8.1]
  def up
    add_column :users, :username, :string

    # Ensure existing users have a username populated from their email prefix
    User.reset_column_information
    User.find_each do |user|
      base_username = user.email.split('@').first.gsub(/[^a-zA-Z0-9_]/, '')
      username = base_username
      counter = 1
      while User.exists?(username: username)
        username = "#{base_username}#{counter}"
        counter += 1
      end
      user.update_columns(username: username)
    end

    change_column_null :users, :username, false
    add_index :users, :username, unique: true
  end

  def down
    remove_index :users, :username
    remove_column :users, :username
  end
end
