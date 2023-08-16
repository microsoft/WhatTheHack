namespace RockPaperScissorsBoom.Core.Game
{

    public enum Decision : short
    {
        Rock = 0b_10100_00001, // is 1 << 0, doesn't win vs 1 << 4 | 1 << 2 | self
        Paper = 0b_10001_00010, // is 1 << 1, doesn't win vs 1 << 4 |  self  | 1 << 1, 
        Scissors = 0b_10010_00100, // is 1 << 2, doesn't win vs 1 << 4 |  self  | 1 << 1, 
        Dynamite = 0b_00111_01000, // is 1 << 3, doesn't win vs  self  | 1 << 2 | 1 << 1 | 1 << 0
        WaterBalloon = 0b_01000_10000, // is 1 << 4, doesn't win vs  self  | 1 << 3
    }
}