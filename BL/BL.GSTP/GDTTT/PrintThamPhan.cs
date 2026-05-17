using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace BL.GSTP.GDTTT
{
    public class PrintThamPhan
    {
        public string TENTHAMPHAN { get; set; }
        public string NOICHUYEN { get; set; }

        public override bool Equals(object obj)
        {
            var other = obj as PrintThamPhan;
            if (other == null)
                return false;

            return TENTHAMPHAN == other.TENTHAMPHAN &&
                   NOICHUYEN == other.NOICHUYEN;
        }

        public override int GetHashCode()
        {
            return (TENTHAMPHAN + NOICHUYEN).GetHashCode();
        }
    }
    

}