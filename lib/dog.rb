class Dog
  attr_accessor :name, :breed, :id

  def initialize(hash)
    @name = hash[:name]
    @breed = hash[:breed]
    @id = hash[:id]
  end

  def self.create_table
    sql = <<-SQL
    CREATE TABLE IF NOT EXISTS dogs(
      id INTEGER PRIMARY KEY,
      name TEXT,
      breed TEXT
    );
    SQL
    DB[:conn].execute(sql)
  end

  def self.drop_table
    sql = <<-SQL
    DROP TABLE IF EXISTS dogs;
    SQL
    DB[:conn].execute(sql)
  end

  def save

    sql = <<-SQL
    INSERT INTO dogs(name, breed) VALUES(?,?);
    SQL
    DB[:conn].execute(sql, self.name, self.breed)

    @id = DB[:conn].execute("SELECT * FROM dogs GROUP BY id HAVING MAX(id)").flatten[0]
    self
  end

  def self.create(hash)
    newDog = Dog.new(hash)
    newDog.save
    newDog

  end

  def self.new_from_db(row)
    #puts row
    hash = {:id => row[0], :name => row[1], :breed => row[2]}
    newDog = Dog.new(hash)

  end

  def self.find_by_id(id)
    row = DB[:conn].execute("SELECT * FROM dogs WHERE id = ?;", id)[0]
    hash = {:id => row[0], :name => row[1], :breed => row[2]}
    Dog.new(hash)

  end
  def self.find_or_create_by(hash)
    result = DB[:conn].execute("SELECT * FROM dogs WHERE name = ?, breed = ?;", hash[:name], hash[:breed])
    #hash[:id] = result[0][0]
  if result.nil?
      return Dog.new(hash)
    #else


  end
  def self.find_by_name
  end
  def update
  end



end
