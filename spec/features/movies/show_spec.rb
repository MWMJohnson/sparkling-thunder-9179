require "rails_helper"

RSpec.describe "the movies show" do

  before(:each) do
    @uni = Studio.create!(name: "Universal Studios", location: "Hollywood")
    @dis = Studio.create!(name: "Disney", location: "LA")
    
    @good = @uni.movies.create!(title: "Goodwill Hunting", creation_year: "1992", genre: "drama")
    @mib = @uni.movies.create!(title: "Men In Black", creation_year: "1997", genre: "animation")
    @toy = @dis.movies.create!(title: "Toy Story", creation_year: "1995", genre: "animation")

    @tom = Actor.create!(name: "Tom Hanks", age: 65)
    @matt = Actor.create!(name: "Matt Damon", age: 58)
    @will = Actor.create!(name: "Will Smith", age: 54)

    @good_matt = MoviesActor.create!(movie: @good, actor: @tom)
    @toy_tom = MoviesActor.create!(movie: @good, actor: @matt)
    @mib_will = MoviesActor.create!(movie: @mib, actor: @will)

    visit "/movies/#{@good.id}"
  end

  describe "the movies show page" do 
    it "lists the movies attributes" do
      expect(page).to have_content("Movie: #{@good.title}")
      expect(page).to have_content("Year: #{@good.creation_year}")
      expect(page).to have_content("Genre: #{@good.genre}")

      expect(page).to have_content("Actor: #{@matt.name}")
      expect(page).to have_content("Actor: #{@tom.name}")
      expect(page).to_not have_content("Actor: #{@will.name}")
      
      expect(@matt.name).to appear_before(@tom.name)
      expect(page).to have_content("Average actors age: #{@good.average_actor_age.round}")
    end
  end

  describe "the movies show form" do 
    it "it renders a form to add an actor " do
      expect(page).to have_content("Add an Actor")
      expect(find("form")).to have_content("ID")
      expect(page).to have_button("Submit")
    end

    it "it creates an actor " do
      expect(page).to_not have_content("Actor: #{@will.name}")

      fill_in "ID", with: "#{@will.id}"
      click_button "Submit"
      
      expect(page).to have_current_path("/movies/#{@good.id}")
      expect(page).to have_content("Actor: #{@will.name}")
      
      expect(@will.name).to appear_before(@matt.name)
      expect(@matt.name).to appear_before(@tom.name)

    end
  end
end