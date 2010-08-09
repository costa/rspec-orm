describe '#recurse!' do
  it "should set block value recursively to arrays' elements and hashes' values" do
    ah = ['hi', {:k => 42} ]
    ah.recurse!{ |e| e*3 }.should == ah
    ah.should == ['hihihi', {:k => 126}]
  end
end
