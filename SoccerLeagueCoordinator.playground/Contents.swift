/**
* Collect the entire pool of registered SKYFC players from the database
* TODO: Implement database call to get updated active players when I learn how to do that
*/
let players: [[String: String]] = [["name": "Joe Smith","height": "42","footballExperience": "true", "guardian": "Jim and Jan Smith"], ["name": "Jill Tanner", "height": "36","footballExperience": "true", "guardian": "Clara Tanner"],["name": "Bill Bon","height": "43","footballExperience": "true","guardian": "Sara and Jenny Bon"],["name": "Eva Gordon","height": "45","footballExperience": "false","guardian": "Wendy and Mike Gordon"],["name": "Matt Gill","height": "40","footballExperience": "false","guardian": "Charles and Sylvia Gill"],["name": "Kimmy Stein","height": "41","footballExperience": "false","guardian": "Bill and Hillary Stein"],["name": "Sammy Adams","height": "45","footballExperience": "false","guardian": "Jeff Adams"],["name": "Karl Saygan","height": "42","footballExperience": "true","guardian": "Heather Bledsoe"],["name": "Suzane Greenberg","height": "44","footballExperience": "true","guardian": "Henrietta Dumas"],["name": "Sal Dali","height": "41","footballExperience": "false","guardian": "Gala Dali"],["name": "Joe Kavalier","height": "39","footballExperience": "false","guardian": "Sam and Elaine Kavalier"],["name": "Ben Finkelstein","height": "44","footballExperience": "false","guardian": "Aaron and Jill Finkelstein"],["name": "Diego Soto","height": "41","footballExperience": "true","guardian": "Robin and Sarika Soto"],["name": "Chloe Alaska","height": "47","footballExperience": "false","guardian": "David and Jamie Alaska"],["name": "Arnold Willis","height": "43","footballExperience": "false","guardian": "Claire Willis"],["name": "Phillip Helm","height": "44","footballExperience": "true","guardian": "Thomas Helm and Eva Jones"],["name": "Les Clay","height": "42","footballExperience": "true","guardian": "Wynonna Brown"],["name": "Herschel Krustofski","height": "45","footballExperience": "true","guardian": "Hyman and Rachel Krustofski"]]

/** Declare and initialize experience-based arrays for future player sorting */
var experiencedSoccerPlayers: [[String: String]] = [],
  noviceSoccerPlayers: [[String: String]] = []

/** Declare and initialize team arrays with basic structure and information */
var teamRaptors: [String: Any] = ["roster": [], "mascot":"Raptors", "firstPracticeDate": "March 18", "firstPracticeTime": "1:00pm", "averageTeamHeight": 0, "totalPlayersWithExperience": 0],
  teamSharks: [String: Any] = ["roster": [], "mascot": "Sharks", "firstPracticeDate": "March 17", "firstPracticeTime": "3:00pm", "averageTeamHeight": 0, "totalPlayersWithExperience": 0],
  teamDragons: [String: Any] = ["roster": [], "mascot":"Dragons", "firstPracticeDate": "March 17", "firstPracticeTime": "1:00pm", "averageTeamHeight": 0, "totalPlayersWithExperience": 0]


/** 
* Function to sort all players into two pools based on previous football experience
* return {Void}
*/
func separatePlayersByExperience(pool: [[String: String]]) -> () {
  for player in pool {
    if (player["footballExperience"] != nil && player["footballExperience"]! == "true"   ) {
      experiencedSoccerPlayers.append(player)
    } else {
      noviceSoccerPlayers.append(player)
    }
  }
}

/**
* Function to take an array of players and organize the players by height based on the user's specified order
* params {pool: Array[String: Any]} - Unorganized array of player objects
* params {order: String} - A String to determine which way we want the array to sort in either Ascending or decending order
* return {Array[String: Any] - Organized array of player Dictionaries based on height }
*/
func organizePlayersByHeight(pool: [[String: String]], order: String) -> [[String: String]] {
  let result = pool.sorted {
  let playerHeight1 = Int($0["height"]!)
  let playerHeight2 = Int($1["height"]!)
    switch order {
      case "ASC":
        return  playerHeight1! < playerHeight2!
      default:
        return  playerHeight1! > playerHeight2!
    }
  }
  
  return result
}

/** 
* Function to split a pool of players into the season's teams evening based on their array index
* params {pool: Array[String: Any]} - Organized array of player Dictionaries based on height
* return {Void}
* TODO: Improve function to accept a dynamic collection of teams
*/
func splitPlayersIntoTeams(pool: [[String: String]]) -> () {
  for (index, player) in pool.enumerated() {
    switch (index % 3) {
    case 0:
      if var raptorsRoster = teamRaptors["roster"] as? Array<Any> {
        raptorsRoster.append(player)
        teamRaptors["roster"] = raptorsRoster
        
        if player["footballExperience"]! == "true" {
          var totalExpPlayers: Int = teamRaptors["totalPlayersWithExperience"] as! Int
          totalExpPlayers += 1
          teamRaptors["totalPlayersWithExperience"] = totalExpPlayers
        }
      }
    case 1:
      if var sharksRoster =  teamSharks["roster"] as? Array<Any> {
        sharksRoster.append(player)
        teamSharks["roster"] = sharksRoster
        
        if player["footballExperience"]! == "true" {
          var totalExpPlayers: Int = teamSharks["totalPlayersWithExperience"] as! Int
          totalExpPlayers += 1
          teamSharks["totalPlayersWithExperience"] = totalExpPlayers
        }
      }
    case 2:
      if var dragonRoster =  teamDragons["roster"] as? Array<Any> {
        dragonRoster.append(player)
        teamDragons["roster"] = dragonRoster
        
        if player["footballExperience"]! == "true" {
          var totalExpPlayers: Int = teamDragons["totalPlayersWithExperience"] as! Int
          totalExpPlayers += 1
          teamDragons["totalPlayersWithExperience"] = totalExpPlayers
        }
      }
    default:
      break
    }
  }
}

/**
* Function to calculate a team's average height based on the player dictionary's "height" property
* params {team} - A filtered team roster after they have been organized
* return {Int} - The calculated average team height based on their team's current player count
*/
func calculateAverageTeamHeight(team: Array<[String: String]>) -> Int {
  var totalTeamHeight = 0
  
  for player in team {
    if let playerHeight = Int(player["height"]!) {
      totalTeamHeight += playerHeight
    }
  }
  
  return(totalTeamHeight / team.count)
}

/**
* Function to compare the average team heights to ensure they are evenly distributed with a variance no greater than 1.5 inches
* params {averageTeamHeights:Array<Int>} - An array of the average team heights
* return {Bool} - The result to ensure that the teams are evening sorted based on height
*/
func compareAverageTeamHeights(averageTeamHeights: Array<Int>) -> Bool {
  
  /** Sort the array on integers in ASC order */
  let result = averageTeamHeights.sorted()
  
  /** Determine the tallest team and the shortest team */
  let tallestTeam = Double(result[result.count - 1])
  let shortestTeam = Double(result[0])
  
  /** Compare that the difference between team heights is no greater than 1.5 inches */
  return (tallestTeam - shortestTeam <= 1.5)
}

/**
 *
 * params {}
 * return {}
 */
func compareTotalExpPlayers(expByTeam: Array<Int>) -> Bool {
  
  /** Sort the array on integers in ASC order */
  let result = expByTeam.sorted()
  
  /** Determine the tallest team and the shortest team */
  let mostExpTeam = Double(result[result.count - 1])
  let leastExpTeam = Double(result[0])
  
  /** Compare that the difference between team heights is no greater than 1.5 inches */
  return (mostExpTeam == leastExpTeam)
}

/** 
* Function to generate the form letters to players after they have been divided
* params {Dictionary} -
* returns {void} - No return value expected, just prints letters to the console
*/
func generateTeamLetters(team: [String: Any]) -> Array<String> {
  let teamPracticeDate: String = team["firstPracticeDate"] as! String
  let teamPracticeTime: String = team["firstPracticeTime"] as! String
  let teamMascot: String = team["mascot"] as! String
  let teamRoster: [[String: Any]] = team["roster"] as! Array<[String : Any]>
  
  var teamLetters = Array<String>()
  
  for player in teamRoster {
    teamLetters.append("Dear \(player["guardian"]!):\n\nThank you for registering your child for the 2017 SwiftKicks Youth Football Club(SKYFC).\nThis letter is to inform you that \(player["name"]!) has been recruited to play for the \(teamMascot.uppercased())!\n\nYour first practice will be held at the Apple playground football pitch on \(teamPracticeDate).\nPractice begins promptly at \(teamPracticeTime).\n\nBe sure your child comes prepared with the minimum required safety equipment, or else they will not be allowed to participate.\nPlease read the attached equipment sheet for reference.\n\nLooking forward to a great season!\n\nSincerely,\n\nDaniel Cicconi\nPresident | SwiftKicks Youth Football Club\n\nP.S. \(teamMascot.uppercased()) fan apparel is available for purchase at the SKYFC website. Hope to see you at the first game!\n\n\n---\n\n")
  }
  
  return teamLetters
}

/** Filter players by their previous soccer experience */
separatePlayersByExperience(pool: players)

/** Filter player pools by their height */
noviceSoccerPlayers = organizePlayersByHeight(pool: noviceSoccerPlayers, order: "ASC")
experiencedSoccerPlayers = organizePlayersByHeight(pool: experiencedSoccerPlayers, order: "DESC")

/** Split organized player pools into teams */
splitPlayersIntoTeams(pool: noviceSoccerPlayers)
splitPlayersIntoTeams(pool: experiencedSoccerPlayers)

/** Calculate average team height and print the result to the console */
teamRaptors["averageTeamHeight"] = calculateAverageTeamHeight(team: teamRaptors["roster"] as! Array<[String : String]>)
teamSharks["averageTeamHeight"] = calculateAverageTeamHeight(team: teamSharks["roster"] as! Array<[String : String]>)
teamDragons["averageTeamHeight"] = calculateAverageTeamHeight(team: teamDragons["roster"] as! Array<[String : String]>)

print("The Raptors average team height is \(teamRaptors["averageTeamHeight"]!).\n")
print("The Sharks average team height is \(teamSharks["averageTeamHeight"]!).\n")
print("The Dragons average team height is \(teamDragons["averageTeamHeight"]!).\n")
print("----\n\n")

/** 
* If the teams are separated into equal teams based on height, then generate the form letters to player guardians
* otherwise, print an error to the console
*/
let averageTeamHeights: Array<Int> = [teamRaptors["averageTeamHeight"] as! Int, teamSharks["averageTeamHeight"] as! Int, teamDragons["averageTeamHeight"] as! Int]

let totalExpPlayersPerTeam: Array<Int> = [teamRaptors["totalPlayersWithExperience"] as! Int, teamSharks["totalPlayersWithExperience"] as! Int, teamDragons["totalPlayersWithExperience"] as! Int]

if (compareAverageTeamHeights(averageTeamHeights: averageTeamHeights) && compareTotalExpPlayers(expByTeam: totalExpPlayersPerTeam)) {
  var letters = Array<String>()
  letters += generateTeamLetters(team: teamRaptors)
  letters += generateTeamLetters(team: teamSharks)
  letters += generateTeamLetters(team: teamDragons)
  
  for letter in letters { print(letter) }
  
} else {
  print("There was an error generating even teams this year! Please contact your developer to investigate")
  print("The Raptors average team height is \(teamRaptors["averageTeamHeight"]!).\n")
  print("The Sharks average team height is \(teamSharks["averageTeamHeight"]!).\n")
  print("The Dragons average team height is \(teamDragons["averageTeamHeight"]!).\n")
  print("----\n\n")
  print("The Raptors have \(teamRaptors["totalPlayersWithExperience"]!) players with previous experience.\n")
  print("The Sharks have \(teamSharks["totalPlayersWithExperience"]!) players with previous experience.\n")
  print("The Dragons have \(teamDragons["totalPlayersWithExperience"]!) players with previous experience.\n")
  print("----\n\n")
}