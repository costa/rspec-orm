
describe 'String#cut' do
  it "should cut a string into substrings, index-based" do
    "Hello, worlD".cut(1, -1).should == ['H','ello, worl','D']
  end
end
