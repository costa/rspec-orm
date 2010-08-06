
*WARNING*: concept-quality code, that is, _anything_ may change!

Other than that, this is an attempt to make code like below work:

    require 'spec/rails/ar'
    
    describe BarController do
      context "having some items" do
        before do
          Drink.csv_send "
                  , volume(i) , price(f)
            Juice , 250       , 2.50
            Beer  , 473       , 5.50
            "    
          Food.Bun :weight => 20, :price => 2
        end
    
        it "should update the prices upon request" do
          post :price_change :category => 'food', :by => '+10%'
          response.should be_success
    
          Drink.constinsts.each_value { |d| d.should be_the_same }
          Food.Bun.should be_the_same_but :price => 2.20
        end
    
        after do
          # TODO resetting the database?
        end
    end

- which roughly does in already.

Note that you will need xgem from http://github.com/costa/xgem and
    export RUBYLIB="<a path to its ./lib>:$RUBYLIB"
until the gem is developed, packaged and distributed.
