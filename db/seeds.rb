# markcuban=User.create(username: "mcuban", email: "mcuban@nba.com", password: "sharktank")
# User.create(username: "sballmer", email: "sballmer@msn.com", password: "msftrules")
# User.create(username: "jbuss", email: "jbuss@lakers.com", password: "betterthanbro")
lukad=Player.create(firstname: "Luka", lastname: "Doncic", position: "Guard")
kevinknox=Player.create(firstname: "Kevin", lastname: "Knox", position: "Forward")
mrobinson=Player.create(firstname: "Mitchell", lastname: "Robinson", position: "Center")
markcuban=User.find_by(username: "mcuban")
lukad.user = markcuban
