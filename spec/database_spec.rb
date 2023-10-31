def run_script(commands, filename)
  raw_output = nil
  IO.popen("./db #{filename}", "r+") do |pipe|
    commands.each do |command|
      pipe.puts command
    end

    pipe.close_write

    raw_output = pipe.gets(nil)
  end
  raw_output.split("\n")
end


describe 'database' do
  it 'keeps data after closing connection' do
    result1 = run_script([
      "insert 1 user1 person1@example.com",
      ".exit",
    ], "test1.db")
    expect(result1).to match_array([
      "db > Executed.",
      "db > bye.",
    ])
    result2 = run_script([
      "select",
      ".exit",
    ], "test1.db")
    expect(result2).to match_array([
      "db > (1, user1, person1@example.com)",
      "Executed.",
      "db > bye.",
    ])
  end

  it 'prints error message when table is full' do
    script = (1..1401).map do |i|
      "insert #{1} user#{1} person#{1}@example.com"
    end
    script << ".exit"
    result = run_script(script, "test2.db")
    expect(result[-2]).to eq('db > Error: Table full.')
  end

  it 'allows inserting strings that are the maximam length' do
    long_username = "a"*32
    long_email = "a"*255
    script = [
      "insert 1 #{long_username} #{long_email}",
      "select",
      ".exit",
    ]
    result = run_script(script, "test3.db")
    expect(result).to match_array([
      "db > Executed.",
      "db > (1, #{long_username}, #{long_email})",
      "Executed.",
      "db > bye.",
    ])
  end

  it 'prints error message if strings are too long' do
    long_username = "a"*33
    long_email = "a"*256
    script = [
      "insert 1 #{long_username} #{long_email}",
      "select",
      ".exit",
    ]
    result = run_script(script, "test4.db")
    expect(result).to match_array([
      "db > String is too long.",
      "db > Executed.",
      "db > bye.",
    ])
  end

  it 'prints an error message if id is negative' do
    result = run_script([
      "insert -1 user1 person1@example.com",
      "select",
      ".exit",
    ], "test5.db")
    expect(result).to match_array([
      "db > ID must be positive.",
      "db > Executed.",
      "db > bye.",
    ])
  end

  after :all do
    Dir.glob("test*.db").each do |file| 
      File.delete(file)
    end
  end
end

