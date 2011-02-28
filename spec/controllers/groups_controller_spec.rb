require 'spec_helper'

describe GroupsController do
  
  let(:group) { mock_model('Group').as_new_record.as_null_object }
  let(:discipline) { double('Discipline') }
  
  describe "GET new" do
    before do
      Group.stub(:new).and_return(group)
    end
    
    it "sets @group with a new group" do
      Group.should_receive(:new)
      get :new
      assigns[:group].should == group
    end
    
    context "when a discipline is received via params" do
      it "assigns the new group to the discipline" do
        group.should_receive('discipline=').with(discipline)
        get :new, :discipline => discipline
      end
    end
  end
  
  describe "POST create" do
    let(:group_params) do
      { 'name'       => "A Diurno",
        'lessons'    => {'monday' => ["08:00"]},
        'discipline' => discipline }
    end
    
    before do
      Group.stub(:new).and_return(group)
    end
    
    it "instantiates a new group with the provided params" do
      Group.should_receive(:new).with(group_params)
      post :create, :group => group_params
    end
    
    it "tries to save the group" do
      group.should_receive(:save)
      post :create
    end
    
    context "when the group is saved successfully" do
      before do
        group.stub(:save).and_return true
        post :create
      end
      
      it "sets a flash[:notice] message" do
        flash[:notice].should =~ /success/
      end
      
      it "redirects to the new group's page" do
        response.should redirect_to group
      end
      
    end
    context "when the group fails to save" do
      before do
        group.stub(:save).and_return false
        post :create
      end
      
      it "sets a flash[:error] message" do
        flash[:error].should =~ /error/
      end
      
      it "renders the 'new Group' form" do
        response.should render_template :new
      end
      
    end
  end
end