alias ToastMe.Profile
alias ToastMe.Repo
alias ToastMe.User

File.mkdir_p!("priv/static/uploads")
File.cp_r!("priv/seed-uploads", "priv/static/uploads")

user1 = Repo.insert!(%User{facebook_user_id: "fake-01", name: "Billy Joel"})
user2 = Repo.insert!(%User{facebook_user_id: "fake-02", name: "Musa Kearney"})
user3 = Repo.insert!(%User{facebook_user_id: "fake-03", name: "Caio Lin"})
user4 = Repo.insert!(%User{facebook_user_id: "fake-04", name: "Kiri Morrison"})
user5 = Repo.insert!(%User{facebook_user_id: "fake-05", name: "Kavan Ireland"})
user6 = Repo.insert!(%User{facebook_user_id: "fake-06", name: "Octavia Vu"})
user7 = Repo.insert!(%User{facebook_user_id: "fake-07", name: "Aliya Shannon"})
user8 = Repo.insert!(%User{facebook_user_id: "fake-08", name: "Kierran Paterson"})

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
