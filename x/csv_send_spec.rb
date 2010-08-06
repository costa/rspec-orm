require 'xgem'

require 'x/to_t'

require 'csv_send'


describe CsvReceiver do

  it "should send a correct message per each csv line" do
    a = mock
    a.should_receive(:foo).with.and_return(1)
    a.should_receive(:bar).with('x').and_return(2)
    a.should_receive(:baz).with(:b => 'y', :c => 'z').and_return(['t', 'f'])
    a.should_receive(:flob).with('y', :d => 'z').and_return(nil)

    res = a.csv_send "
           ,   , a , b , c , d
      foo
      bar  , x ,
      baz  ,   ,   , y , z
      flob , y ,   ,   ,   , z
    "
    res.should == [1, 2, ['t', 'f'], nil]
  end

  it "should convert to basic types (integer, float, date, string)" do
    a = mock
    a.should_receive(:flob).with(2, DateTime.parse('11-11-2011 11:11'), :send,
                                 :b => -0.5, :d => 'x').and_return(nil)

    res = a.csv_send "
           , (i) , (t)              , (sym) , b(f) , c , d
      flob , 2   , 11-11-2011 11:11 , send , -0.5  ,   , x
    "
    res.should == [nil]
  end

  xit "should support explicit strings and nils"

  xit "should support EOL comments"

  it "should do nothing on empty input" do
    mock.csv_send ''
    mock.csv_send <<-EOF
    EOF
    mock.csv_send <<-EOF

       ,  , a, b, c, d

    EOF
  end
end
