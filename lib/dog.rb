require 'pry'
class Dog

  attr_accessor :name, :breed, :id

  def initialize(name:, breed:, id: nil)
    @name = name
    @breed = breed
    @id = id
  end

  def self.create_table
    DB[:conn].execute('CREATE TABLE dogs (id INTEGER PRIMARY KEY, name TEXT, breed TEXT)')
  end

  def self.drop_table
    DB[:conn].execute('DROP TABLE dogs')
  end

  def save
    if self.id
      self
      # dog = DB[:conn].execute('SELECT * FROM dogs')
    else
      DB[:conn].execute('INSERT INTO dogs(name, breed) VALUES (?, ?)', [self.name, self.breed])
      @id = DB[:conn].execute('SELECT last_insert_rowid() FROM dogs').flatten[0]
    end
    self #why this self is necessary
    # binding.pry
    # 0
  end



  def self.create(dog)
    new_dog = Dog.new(dog)
    new_dog.save
    new_dog
  # binding.pry
  end

  def self.find_by_id(id)
    dog = DB[:conn].execute('SELECT * FROM dogs WHERE id = ?', [id]).flatten
    result = Dog.new(id: dog[0], name: dog[1], breed: dog[2])
    result
    # binding.pry
  end

  def self.find_or_create_by(dog)

    # if dog[:id] == nil
    test = DB[:conn].execute('SELECT * FROM dogs WHERE name = ? AND breed = ?', dog[:name], dog[:breed])
    if test.empty?
      dog = Dog.create(dog)
    else
      # dog = Dog.new_from_db(test[0])
    end
    dog

    # binding.pry
    # 0

    # elsif DB[:conn].execute('SELECT * FROM dogs WHERE name = ?', dog[:name])
    #   Dog.find_by_id(dog[:id])
  end


  def self.new_from_db(row)
    Dog.new(id: row[0], name: row[1], breed: row[2])
  end




end
