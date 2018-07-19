# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

User.create!(name: "Joe",
             email: "jwplatta@gmail.com",
             password: "password",
             password_confirmation: "password",
             admin: true,
           )

User.create!(name: "Matt",
            email: "meplatta@gmail.com",
            password: "password",
            password_confirmation: "password",
            admin: false,
          )

User.create!(name: "Ben",
             email: "bmplatta@gmail.com",
             password: "password",
             password_confirmation: "password",
             admin: false,
           )

User.create!(name: "Mark",
            email: "mark_gospel@gmail.com",
            password: "password",
            password_confirmation: "password",
            admin: false,
          )

User.create!(name: "Matthew",
             email: "matt_gospel@gmail.com",
             password: "password",
             password_confirmation: "password",
             admin: false,
           )

User.create!(name: "Luke",
            email: "luke_gospel@gmail.com",
            password: "password",
            password_confirmation: "password",
            admin: false,
          )

User.create!(name: "John",
             email: "john_gospel@gmail.com",
             password: "password",
             password_confirmation: "password",
             admin: false,
           )

User.create!(name: "Paul",
            email: "paul_letters@gmail.com",
            password: "password",
            password_confirmation: "password",
            admin: false,
          )

users = User.all

users.each do |user|
  user_id = user.id
  date_str = "2017-10-01"
  date = Date.parse(date_str)
  count = 0

  65.times do
    Transaction.create!(amount: 5.49,
                        description: "Tacos",
                        category: "RESTAURANT",
                        credit: false,
                        date: date,
                        user_id: user_id)
                        
    if count%8 == 0
      Transaction.create!(amount: 40.00,
                          description: "Trader Joe's",
                          category: "GROCERY",
                          date: date,
                          user_id: user_id)
    end

    if count%4 == 0
      Transaction.create!(amount: 19.99,
                          description: "Beer",
                          category: "ALCOHOL",
                          credit: false,
                          date: date,
                          user_id: user_id)
    end

    if count%7 == 0
      Transaction.create!(amount: 29.99,
                          description: "Mobil gas station",
                          category: "GAS",
                          credit: false,
                          date: date,
                          user_id: user_id)
    end

    count += 1
    date = date + 1

  end
end
