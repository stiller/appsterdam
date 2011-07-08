class Member < ActiveRecord::Base
  validates_presence_of :twitter_id
  validates_uniqueness_of :twitter_id
  
  def twitter_user_attributes=(attributes)
    self.attributes = {
      :twitter_id => attributes['id'],
      :name => attributes['name'],
      :username => attributes['screen_name'],
      :picture => attributes['profile_image_url'],
      :location => attributes['location'],
      :website => attributes['url'],
      :bio => attributes['description']
    }
  end
  
  def self.create_with_twitter_user_attributes(attributes)
    member = Member.new
    member.twitter_user_attributes = attributes
    member.save
    member
  end
  
  # Returns a randomized list of members
  def self.randomized(limit=20)
    # Because the ID's might be sparse we don't know how many records we will
    # get from a query. We keep trying with a random set of ID's until we've
    # matched the desired number or of we've tried for 20 times.
    tries = 20
    randomized = Set.new
    max_id = _max_id
    while(tries > 0 && randomized.length < limit)
      tries -= 1
      samples = (1..limit).map { rand(max_id) + 1 }
      randomized.merge all(:conditions => { :id => samples })
    end
    randomized.to_a
  end
end
