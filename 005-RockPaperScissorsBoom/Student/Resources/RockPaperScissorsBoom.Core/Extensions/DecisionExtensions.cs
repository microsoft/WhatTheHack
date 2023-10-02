using RockPaperScissorsBoom.Core.Game;

namespace RockPaperScissorsBoom.Core.Extensions
{
    public static class DecisionExtensions
    {
        // selects id compoment of Decision enum
        const int ID_FLAG = 0b11111;

        /*  
            Uses the two 5 bit compents of the numeric values of the Decision enum to determine if d1 defeats d2
            left 5 bit component is a map of which values are defeated by the enum entry
            right 5 bit component is the id of the enum entry, by incrementing powers of 2            
         */
        public static bool IsWinnerAgainst(this ref Decision d1, ref Decision d2)
            => (((short)d1 & ID_FLAG) & ((short)d2 >> 5)) == 0;
    }
}