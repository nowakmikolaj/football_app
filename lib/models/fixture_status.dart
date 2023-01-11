// ignore_for_file: constant_identifier_names

enum FixtureStatus {
  CANC, // Match Cancelled
  AWD, // Technical Loss
  WO, // WalkOver
  AET, // Match Finished After Extra Time
  PEN, // Match Finished After Penalty
  FT, // Match Finished
  H1, // First Half, Kick Off
  HT, // Halftime
  H2, // Second Half, 2nd Half Started
  ET, // Extra Time
  BT, // Break Time
  P, // Penalty In Progress
  SUSP, // Match Suspended
  INT, // Match Interrupted
  LIVE, // In Progress
  NS, // Not Started
  PST, // Match Postponed
  ABD, // Match Abandoned
  TBD, // Time To Be Defined
}

const statusDictionary = <String, FixtureStatus>{
  'TBD': FixtureStatus.TBD,
  'NS': FixtureStatus.NS,
  '1H': FixtureStatus.H1,
  'HT': FixtureStatus.HT,
  '2H': FixtureStatus.H2,
  'ET': FixtureStatus.ET,
  'BT': FixtureStatus.BT,
  'P': FixtureStatus.P,
  'SUSP': FixtureStatus.SUSP,
  'INT': FixtureStatus.INT,
  'FT': FixtureStatus.FT,
  'AET': FixtureStatus.AET,
  'PEN': FixtureStatus.PEN,
  'PST': FixtureStatus.PST,
  'CANC': FixtureStatus.CANC,
  'ABD': FixtureStatus.ABD,
  'AWD': FixtureStatus.AWD,
  'WO': FixtureStatus.WO,
  'LIVE': FixtureStatus.LIVE,
};

const statusDescriptionDictionary = <String, String>{
  'TBD': "Time To Be Defined",
  'NS': "Not Started",
  '1H': "1st Half",
  'HT': "Halftime",
  '2H': "2nd Half",
  'ET': "Extra Time",
  'BT': "Break Time",
  'P': "Penalty In Progress",
  'SUSP': "Suspended",
  'INT': "Interrupted",
  'FT': "Finished",
  'AET': "After Extra Time",
  'PEN': "After Penalties",
  'PST': "Postponed",
  'CANC': "Cancelled",
  'ABD': "Abandoned",
  'AWD': "Technical Loss",
  'WO': "WalkOver",
  'LIVE': "LIVE",
};
