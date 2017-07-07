FactoryGirl.define do
  factory :note, class: Note do
    title "First"
    content "Something"
  end

  factory :tag, class: Tag do
    name "Comment"
  end

end