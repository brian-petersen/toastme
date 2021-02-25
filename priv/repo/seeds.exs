alias ToastMe.Profile
alias ToastMe.Repo
alias ToastMe.User

File.mkdir_p!("priv/static/uploads")
File.cp_r!("priv/seed-uploads", "priv/static/uploads")

create_user = fn username ->
  %{username: username, password: "password", password_confirmation: "password"}
  |> User.changeset()
  |> Repo.insert!()
end

user1 = create_user.("user01")
user2 = create_user.("user02")
user3 = create_user.("user03")
user4 = create_user.("user04")
user5 = create_user.("user05")
user6 = create_user.("user06")
user7 = create_user.("user07")
user8 = create_user.("user08")
_user9 = create_user.("user09")
_user10 = create_user.("user10")

_profile1 =
  Repo.insert!(%Profile{
    user_id: user1.id,
    bio: "I love food, motorcycles, and women.",
    photos: ["party-cat.jpg", "cute-cat.jpg", "party-cat.jpg", "cute-cat.jpg", "party-cat.jpg"]
  })

_profile2 =
  Repo.insert!(%Profile{
    user_id: user2.id,
    bio: "Please go easy.",
    photos: ["party-cat.jpg"]
  })

_profile3 =
  Repo.insert!(%Profile{
    user_id: user3.id,
    bio: "Can't touch this.",
    photos: ["cute-cat.jpg"]
  })

_profile4 =
  Repo.insert!(%Profile{
    user_id: user4.id,
    bio: "The cake is a lie!",
    photos: ["cute-cat.jpg", "party-cat.jpg"]
  })

_profile5 =
  Repo.insert!(%Profile{
    user_id: user5.id,
    bio: "Jackie Chan is my hero!1!",
    photos: ["cute-cat.jpg", "party-cat.jpg"]
  })

_profile6 =
  Repo.insert!(%Profile{
    user_id: user6.id,
    bio: "Chuck Norris is better?!",
    photos: ["cute-cat.jpg", "party-cat.jpg"]
  })

_profile7 =
  Repo.insert!(%Profile{
    user_id: user7.id,
    bio: "Don't breathe on me.",
    photos: ["cute-cat.jpg", "party-cat.jpg"]
  })

_profile8 =
  Repo.insert!(%Profile{
    user_id: user8.id,
    bio: "You suck.",
    photos: ["cute-cat.jpg", "party-cat.jpg"]
  })
