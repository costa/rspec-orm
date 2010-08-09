describe Constinsts do

  class A
    include Constinsts

    attr_accessor :x, :y

    def initialize(x = 0, y = 0)
      @x, @y = x, y
    end
  end

  it "should effectively define a new constant instance given a new name" do
    A.Prs(3)
    A.Prs.should be_a A
    A.Prs.x.should == 3
    A.Prs.y.should == 0
  end

  it "should answer queries of the Klass.Konst? kind" do
    A.Tuv?.should == false
    A.Tuv.should be_a A
    A.Tuv?.should == true
  end
end
