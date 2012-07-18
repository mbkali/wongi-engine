require 'spec_helper'

describe "ASSERT test" do

  before :each do
    @engine = Wongi::Engine.create
  end

  def engine
    @engine
  end

  def production
    @production
  end

  def test_rule &block
    @production = ( engine << rule( 'test-rule', &block ) )
  end

  it "should pass with a constant 'true'" do

    test_rule {
      forall {
        assert { |token|
          true
        }
      }
    }

    production.should have(1).tokens
    
  end

  it "should fail with a constant 'false'" do

    test_rule {
      forall {
        assert { |token|
          false
        }
      }
    }

    production.should have(0).tokens

  end

  it "should use the token with no arguments" do

    test_rule {
      forall {
        has :X, "is", :Y
        assert { |token|
          token[:X] == "resistance"
        }
      }
    }

    engine << ["resistance", "is", "futile"]

    production.should have(1).tokens
    production.tokens.first[:X].should == "resistance"

  end

  it "should use individual variables with arguments" do

    test_rule {
      forall {
        has :X, "is", :Y
        assert :X, :Y do |x, y|
          y == "futile"
        end
      }
    }

    engine << ["resistance", "is", "futile"]

    production.should have(1).tokens
    production.tokens.first[:X].should == "resistance"

  end

end
